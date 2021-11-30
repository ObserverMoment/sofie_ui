import 'package:artemis/artemis.dart';
import 'package:get_it/get_it.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:normalize/normalize.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/services/store/links/auth_link.dart';
import 'package:sofie_ui/services/store/links/gql_links.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class GraphQLStore {
  static const String boxName = 'graphql-cache';
  late HttpLink _httpLink;
  late AuthLink _authLink;
  late Link _link;
  late Box _box;

  final _refKey = '\$ref';
  final _queryRootKey = 'Query';

  /// See [normalize -> Policies -> TypePolicy]
  /// These objects will NOT be normalized as root objects and will instead sit inside their parent as raw json data.
  /// Generate the policy object from the list of excluded typenames at [kExcludeFromNormalization]
  final Map<String, TypePolicy> _typePolicies = kExcludeFromNormalization
      .fold<Map<String, TypePolicy>>({}, (policyObj, typename) {
    policyObj[typename] = TypePolicy(keyFields: {});
    return policyObj;
  });

  GraphQLStore() {
    _httpLink = HttpLink(
      EnvironmentConfig.graphqlEndpoint,
    );

    _authLink = AuthLink(
        getToken: () async =>
            'Bearer ${await GetIt.I<AuthBloc>().getIdToken()}');

    _link = _authLink.concat(_httpLink);

    /// This must already have been opened (in main.dart probably).
    _box = Hive.box(boxName);

    /// Run a clean up of the data on init.
    gc();
  }

  Map<String, ObservableQuery> observableQueries = <String, ObservableQuery>{};

  List<ObservableQuery<TData, TVars>>
      _getQueriesbyId<TData, TVars extends json.JsonSerializable>(String id) =>
          observableQueries.values.fold(
              [],
              (observableQueries, next) =>
                  next.id == id || next.query.operationName == id
                      ? [
                          ...observableQueries,
                          next as ObservableQuery<TData, TVars>
                        ]
                      : observableQueries);

  /// [T] is query type. [U] is variables / args type.
  ObservableQuery<TData, TVars>
      registerObserver<TData, TVars extends json.JsonSerializable>(
          GraphQLQuery<TData, TVars> query,
          {bool parameterizeQuery = false}) {
    if (query.operationName == null) {
      throw Exception(
          '[query.operationName] cannot be null when registering an observable query.');
    } else {
      final String id = query.variables == null
          ? query.operationName!
          : parameterizeQuery

              /// If we want to split instances of the query data when the variables change then we set [parameterizeQuery] to true.
              /// [workoutById({"id":736373-837737-39383})]
              /// Each time we query a new workoutById (i.e. the [id] variable changes) a new key under the [Query] root will be created. Each workout will be stored and accessible separately.
              ? getParameterizedQueryId(query)

              /// For non parametized queries, all instances of the same query should be saved under a single key - regardless of variable changes. Mainly for list type queries which we want to just overwrite with new data when it comes in.
              /// We need to set all vars to in the varsMap to null like this
              /// [userLoggedWorkouts({"first":null})]
              : getNulledVarsQueryId(query);

      if (!observableQueries.containsKey(id)) {
        /// No stream with this id exists - create a new stream.
        observableQueries[id] = ObservableQuery<TData, TVars>(
            id: id,
            subject: BehaviorSubject<GraphQLResponse>(),
            query: query,
            parameterize: parameterizeQuery);
      } else {
        // A stream with this id already has one or more listeners.
        // Increment the observer count.
        observableQueries[id]!.observers++;
        // Overwrite the old query with the most recent one.
        // This allows for queries which have variables, but which are not being parameterized by them, to get new data and broadcast to a single query.
        observableQueries[id]!.query = query;
      }

      return observableQueries[id]! as ObservableQuery<TData, TVars>;
    }
  }

  void unregisterObserver(String id) {
    if (!observableQueries.containsKey(id)) {
      throw QueryNotFoundException(id);
    } else {
      if (observableQueries[id]!.observers == 1) {
        // There was only one observer. Close the stream.
        observableQueries[id]!.dispose();
        // Remove it from the map.
        observableQueries.remove(id);
      } else {
        // Reduce the number of active listeners by one.
        observableQueries[id]!.observers--;
      }
    }
  }

  /// Called by a [QueryObserver] when the widget mounts.
  Future<void> fetchInitialQuery(
      {required String id,
      required QueryFetchPolicy fetchPolicy,
      bool garbageCollectAfterFetch = false}) async {
    if (!observableQueries.containsKey(id)) {
      throw QueryNotFoundException(id);
    } else {
      switch (fetchPolicy) {
        case QueryFetchPolicy.storeAndNetwork:
          _queryStore(id);
          await _queryNetwork(id);
          break;
        case QueryFetchPolicy.storeFirst:
          final success = _queryStore(id);
          if (!success) {
            await _queryNetwork(id);
          }
          break;
        case QueryFetchPolicy.storeOnly:
          _queryStore(id);
          break;
        case QueryFetchPolicy.networkOnly:
          await _queryNetwork(id);
          break;
        default:
          throw Exception('$fetchPolicy is not valid.');
      }

      if (garbageCollectAfterFetch) {
        gc();
      }
    }
  }

  /// Fetches data requested by a graphql query selection set from the normalized store.
  /// Broadcasts data to the associated stream if query is successful.
  bool _queryStore(String id) {
    final observableQuery = observableQueries[id];
    if (observableQuery == null) {
      printLog(
          '_queryStore: QueryNotFoundOrNotInitialized: There is no ObservableQuery with id: $id');
      return false;
    } else {
      try {
        // Does a key exist in the store?
        if (!_hasQueryDataInStore(observableQuery.id)) {
          printLog(
              '_queryStore: No key in data store for ${observableQuery.id}');
          return false;
        }

        final GraphQLQuery query = observableQuery.query;

        // Denormalize the data
        final data = denormalizeOperation(
            variables: observableQuery.parameterize
                ? query.variables?.toJson() ?? const {}
                : const {},
            typePolicies: _typePolicies,
            document: query.document,
            returnPartialData: true,
            read: (dataId) => readNormalized(dataId));

        if (data == null) {
          printLog('_queryStore: Data returned null for ${observableQuery.id}');
          return false;
        }

        // Add to the stream to broadcastQueriesByIds to all listeners.
        observableQuery.subject.add(GraphQLResponse(data: query.parse(data)));
        return true;
      } catch (e) {
        printLog(e.toString());
        return false;
      }
    }
  }

  /// Get data from the network, normalize it, add it to the store, broadcastQueriesByIds to the observable query.
  Future<bool> _queryNetwork(String id) async {
    final observableQuery = observableQueries[id];
    if (observableQuery == null) {
      printLog(
          '_queryNetwork: QueryNotFoundOrNotInitialized: There is no ObservableQuery with id: $id');
      return false;
    } else {
      final GraphQLQuery query = observableQuery.query;

      final response = await execute(query);

      if (response.errors != null && response.errors!.isNotEmpty) {
        // Broadcast the error. Do not update the store.
        observableQuery.subject
            .add(GraphQLResponse(data: response.data, errors: response.errors));
        return false;
      } else {
        try {
          /// Important! [normalizeOperation.variables] is by default in alphabetical order.
          /// i.e. [userPublicProfiles({"cursor":null,"take":null})]
          /// vs [userPublicProfiles({"take":null,"cursor":null})]
          /// These will be different keys as far as the store is concerned.
          normalizeOperation(
              data: response.data ?? {},
              document: query.document,
              variables: observableQuery.parameterize
                  ? query.getVariablesMap()
                  : const {},
              typePolicies: _typePolicies,
              read: readNormalized,
              write: mergeWriteNormalized);

          // Broadcast the updated data.
          broadcastQueriesByIds([id]);
          return true;
        } catch (e) {
          printLog(e.toString());
          return false;
        }
      }
    }
  }

  void broadcastQueriesByIds(List<String> ids) {
    for (final id in ids) {
      final observableQueries = _getQueriesbyId(id);
      for (final q in observableQueries) {
        _queryStore(q.id);
      }
    }
  }

  /////////////////////////////////////
  ////// Request executions ///////////
  /////////////////////////////////////
  /// Standard execution that returns unparsed graphql response.
  /// Can parse with [query.parse(data)] if needed.
  /// If you want to pass an incomplete input object as the variables. i.e. just one field needs to be updated. Pass this Map as [variables]. Otherwise the full input object will be sent as a map, null values included.
  Future<Response> execute(GraphQLQuery query,
      {Map<String, dynamic>? customVariablesMap}) async {
    final request = Request(
      operation: Operation(
        document: query.document,
        operationName: query.operationName,
      ),
      variables: customVariablesMap ?? query.getVariablesMap(),
    );

    final response = await _link.request(request).first;
    return response;
  }

  //////////////////////////////////////////
  ////// Store Update Operations ///////////
  //////////////////////////////////////////
  Future<OperationResult<TData>>
      create<TData, TVars extends json.JsonSerializable>({
    required GraphQLQuery<TData, TVars> mutation,
    List<String> addRefToQueries = const [],
    void Function(TData resultData)? processResult,
  }) async {
    final response = await execute(mutation);

    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      /// Check for a top level field alias - these are needed sometimes due to the way Artemis generates return types for operations.
      final alias = extractRootFieldAliasFromOperation(mutation);
      final data = response.data![alias ?? mutation.operationName];

      /// Handle cases where returned data is a list of created objects.
      if (data is List) {
        for (final e in data) {
          normalizeToStore(
            data: e,
            write: mergeWriteNormalized,
            read: readNormalized,
          );
          addRefToQueryData(data: e, queryIds: addRefToQueries);
        }
      } else {
        normalizeToStore(
            data: data, write: mergeWriteNormalized, read: readNormalized);
        addRefToQueryData(data: data, queryIds: addRefToQueries);
      }

      processResult?.call(result.data!);
    }

    return result;
  }

  /// Network query which writes to store and optionally re-broadcasts specified queries. Returns the query result or null if fail.
  /// Update the store with returned (after normalizing) data, then broadcastQueriesByIds (broadcastQueriesByIds is really a store read follwed by a broadcastQueriesByIds) to specified ids.
  Future<OperationResult<TData>?>
      query<TData, TVars extends json.JsonSerializable>({
    required GraphQLQuery<TData, TVars> query,
    // bool writeToStore = true,
    List<String> broadcastQueryIds = const [],
  }) async {
    final response = await execute(query);

    final result = OperationResult<TData>(
        data: query.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      /// Check for a top level field alias - these are needed sometimes due to the way Artemis generates return types for operations.
      final alias = extractRootFieldAliasFromOperation(query);
      final data = response.data![alias ?? query.operationName];

      /// Important! [normalizeOperation.variables] is by default in alphabetical order.
      /// i.e. [userPublicProfiles({"cursor":null,"take":null})]
      /// vs [userPublicProfiles({"take":null,"cursor":null})]
      /// These will be different keys as far as the store is concerned.
      normalizeOperation(
          data: data,
          document: query.document,
          variables: query.getVariablesMap(),
          typePolicies: _typePolicies,
          read: readNormalized,
          write: mergeWriteNormalized);

      if (broadcastQueryIds.isNotEmpty) {
        broadcastQueriesByIds(broadcastQueryIds);
      }
    }

    return result;
  }

  /// Network mutation with optional optimism.
  /// Wrap execute function - add cache writing and broadcastQueriesByIdsing.
  /// Update the store with returned (after normalizing) data, then broadcastQueriesByIds (broadcastQueriesByIds is really a store read follwed by a broadcastQueriesByIds) to specified ids.
  Future<OperationResult<TData>>
      mutate<TData, TVars extends json.JsonSerializable>({
    required GraphQLQuery<TData, TVars> mutation,
    List<String> broadcastQueryIds = const [],

    /// If you want to add / remove ref to / from queries the you have to provide [id] and [__typename] in the optimistic data and these fields must also be returned by the api in the result object.
    List<String> addRefToQueries = const [],
    List<String> removeRefFromQueries = const [],

    /// Remove a whole query key from the store.
    /// Useful when deleting single objects that have query root data in the store.
    /// i.e. [workoutById(id: 123)].
    List<String> clearQueryDataAtKeys = const [],

    /// [customVariablesMap] - if you do not want to pass all the fields of the object to the API. If you pass null fields then those fields will be set null in the DB.
    Map<String, dynamic>? customVariablesMap,
    void Function(TData resultData)? processResult,
  }) async {
    final response =
        await execute(mutation, customVariablesMap: customVariablesMap);

    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      /// Check for a top level field alias - these are needed sometimes due to the way Artemis generates return types for operations.
      final alias = extractRootFieldAliasFromOperation(mutation);
      final data = response.data![alias ?? mutation.operationName];

      /// Handle cases where returned data is a list of objects.
      /// E.g CreateBodyTransformPhotosMutation returns [List<BodyTransformPhoto>]
      /// Note: Optimistic data cannot be a list...currently.
      if (data is List) {
        for (final e in data) {
          normalizeToStore(
              data: e, write: mergeWriteNormalized, read: readNormalized);
          if (addRefToQueries.isNotEmpty) {
            addRefToQueryData(data: e, queryIds: addRefToQueries);
          }
          if (removeRefFromQueries.isNotEmpty) {
            removeRefFromQueryData(data: e, queryIds: removeRefFromQueries);
          }
        }
      } else {
        normalizeToStore(
            data: data, write: mergeWriteNormalized, read: readNormalized);
        if (addRefToQueries.isNotEmpty) {
          addRefToQueryData(data: data, queryIds: addRefToQueries);
        }
        if (removeRefFromQueries.isNotEmpty) {
          removeRefFromQueryData(data: data, queryIds: removeRefFromQueries);
        }
      }

      processResult?.call(result.data!);

      /// Handled the same way whether return value is a list or not - it just deletes the data at the specified keys.
      /// Use this to handle side effects where deleting data is necessary. E.g when a user leaves a club we need to delete all data relating to the club from the store.
      if (clearQueryDataAtKeys.isNotEmpty) {
        _clearQueryDataAtKeys(clearQueryDataAtKeys);
      }

      broadcastQueriesByIds(broadcastQueryIds);
    }

    return result;
  }

  /// Delete ops should always return the ID of the deleted item.
  /// [objectId] as standard - [type:id]
  /// Runs [deleteNormalizedObject()] so (currently) should only be used to delete objects that are being normalized. If the object is not a top level $ref in a query but rather a ref nested inside of another object within queries - you can set [removeAllRefsToId] to true. This may be expensive as it searches the entire store for refs to this ID and removes them so use sparingly.
  Future<OperationResult<TData>> delete<TData,
          TVars extends json.JsonSerializable>(
      {required GraphQLQuery<TData, TVars> mutation,
      required String objectId,
      required String typename,

      /// Useful if you have deleted an object that has parent(s) which may still be referencing it.
      bool removeAllRefsToId = false,
      List<String> removeRefFromQueries = const [],
      void Function(TData resultData)? processResult,

      /// Remove a whole query key from the store.
      /// Useful when deleting single objects that have query root data in the store.
      /// i.e. [workoutById(id: 123)].
      List<String> clearQueryDataAtKeys = const [],
      List<String> broadcastQueryIds = const []}) async {
    final response = await execute(mutation);

    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors &&
        response.data?[mutation.operationName] == objectId) {
      final id = '$typename:$objectId';
      await deleteNormalizedObject(id);

      if (removeAllRefsToId) {
        removeAllQueryRefsToId(id);
      }

      if (removeRefFromQueries.isNotEmpty) {
        removeRefFromQueryData(
            data: {'id': objectId, '__typename': typename},
            queryIds: removeRefFromQueries);
      }

      if (clearQueryDataAtKeys.isNotEmpty) {
        _clearQueryDataAtKeys(clearQueryDataAtKeys);
      }

      processResult?.call(result.data!);

      broadcastQueriesByIds(broadcastQueryIds);
    }

    return result;
  }

  /// Similar to [delete] but will delete a list of objects from store.
  /// Must all be the same [typename].
  Future<OperationResult<TData>> deleteMultiple<TData,
          TVars extends json.JsonSerializable>(
      {required GraphQLQuery<TData, TVars> mutation,
      required List<String> objectIds,
      required String typename,
      void Function(TData resultData)? processResult,

      // useful if you have deleted an object that has parent(s) which may still be referencing it.
      bool removeAllRefsToIds = false,
      List<String> removeRefsFromQueries = const [],
      List<String> clearQueryDataAtKeys = const [],
      List<String> broadcastQueryIds = const []}) async {
    final response = await execute(mutation);

    /// [result][data][operationName] should always be a list of deleted IDs being returned from the API.
    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      for (final id in response.data?[mutation.operationName] as List) {
        final objectStoreId = '$typename:$id';
        await deleteNormalizedObject(objectStoreId);

        if (removeAllRefsToIds) {
          removeAllQueryRefsToId(id);
        }

        if (removeRefsFromQueries.isNotEmpty) {
          removeRefFromQueryData(
              data: {'id': id, '__typename': typename},
              queryIds: removeRefsFromQueries);
        }
      }

      if (clearQueryDataAtKeys.isNotEmpty) {
        /// Remove a whole query key from the store.
        /// Useful when deleting single objects that have query root data in the store.
        /// i.e. [workoutById(id: 123)].
        _clearQueryDataAtKeys(clearQueryDataAtKeys);
      }

      processResult?.call(result.data!);

      broadcastQueriesByIds(broadcastQueryIds);
    }

    return result;
  }

  /////// Network only operations /////////////////////
  /////// No data saved to client side store //////////
  /////// Light wrappers around [execute] function ////
  Future<OperationResult<TData>>
      networkOnlyOperation<TData, TVars extends json.JsonSerializable>(
          {required GraphQLQuery<TData, TVars> operation,
          Map<String, dynamic>? customVariablesMap}) async {
    final response =
        await execute(operation, customVariablesMap: customVariablesMap);

    final result = OperationResult<TData>(
        data: operation.parse(response.data ?? {}), errors: response.errors);

    return result;
  }

  /// Client side (Store) write.
  /// Will merge / overwrite with previous data, or creating it if not present.
  bool writeDataToStore(
      {required Map<String, dynamic> data,
      List<String> broadcastQueryIds = const [],

      /// Only queries whose data is a list of refs can accept refs like this.
      List<String> addRefToQueries = const []}) {
    try {
      normalizeToStore(
          data: data, write: mergeWriteNormalized, read: readNormalized);

      if (addRefToQueries.isNotEmpty) {
        addRefToQueryData(data: data, queryIds: addRefToQueries);
      }

      broadcastQueriesByIds(broadcastQueryIds);
      return true;
    } catch (e) {
      printLog(e.toString());
      return false;
    }
  }

  /// Add a ref obj to all specified query ids.
  /// Does not write a normalized object to the store.
  bool addRefToQueryData(
      {required Map<String, dynamic> data, required List<String> queryIds}) {
    final objectId = resolveDataId(data);
    if (objectId == null) {
      printLog(
          'Warning: Could not resolveDataId in [data]. If you want to add a ref to queries then you need to provide [id] and [__typename] in the data.');
      return false;
    }
    final allQueries = _box.get(_queryRootKey);

    for (final queryId in queryIds) {
      final prevList = allQueries[queryId];

      if (prevList != null && prevList is! List) {
        throw AssertionError(
            'There is data under [$_queryRootKey][$queryId], but it is not a list. You cannot add a ref to a non list object.');
      }

      final newRef = {_refKey: objectId};

      final updatedList = [if (prevList != null) ...prevList as List, newRef];

      // Rewrite to box.
      _box.put(_queryRootKey, {...allQueries, queryId: updatedList});

      broadcastQueriesByIds([queryId]);
    }
    return true;
  }

  /// Remove a ref obj from all specified query ids.
  /// [objectId] must be in the format [type:id] as a string.
  /// If [_box.get(_queryRootKey)] is null then this key will be created.
  /// Runs broadcast once the ref has been removed.
  bool removeRefFromQueryData(
      {required Map<String, dynamic> data, required List<String> queryIds}) {
    final objectId = resolveDataId(data);
    if (objectId == null) {
      printLog(
          'Warning: Could not resolveDataId in [data]. If you want to remove a ref from queries then you need to provide [id] and [__typename] in the data.');
      return false;
    }
    final allQueries = _box.get(_queryRootKey);

    for (final queryId in queryIds) {
      final prevList = allQueries[queryId];

      if (prevList != null && prevList is! List) {
        throw AssertionError(
            'There is data under [$_queryRootKey][$queryId], but it is not a list. You cannot remove a ref from a non list object.');
      }

      final updatedList = prevList != null
          ? (prevList as List).where((e) => e[_refKey] != objectId).toList()
          : [];

      // Rewrite to box.
      _box.put(_queryRootKey, {...allQueries, queryId: updatedList});

      broadcastQueriesByIds([queryId]);
    }
    return true;
  }

  /////////////////////////////////////
  ///// Hive box reads and writes /////
  /////////////////////////////////////
  /// Merges / overwrites [value] with existing data at [key].
  Future<void> mergeWriteNormalized(String key, dynamic value) async {
    if (value is Map<String, Object>) {
      final existing = _box.get(key);
      _box.put(
        key,
        existing != null ? deeplyMergeLeft([existing, value]) : value,
      );
    } else {
      _box.put(key, value);
    }
  }

  /// Retrieves data from a key and then recursively retrieves all of its children.
  /// Children can be scalar or [$ref] objects and plain json Map is returned.
  Map<String, dynamic> readDenomalized(String key) {
    return readFromStoreDenormalized(key, _box);
  }

  /// Retrieves the raw normalized data.
  /// Normalized children will be [$ref] objects. Not plain json maps.
  Map<String, dynamic> readNormalized(String key) {
    return Map<String, dynamic>.from(_box.get(key) ?? {});
  }

  Future<void> deleteNormalizedObject(String key) async {
    await _box.delete(key);
  }

  /// Within the root query key - does data for this query exist.
  bool _hasQueryDataInStore(String queryKey) {
    return _box.get(_queryRootKey, defaultValue: {})[queryKey] != null;
  }

  void _clearQueryDataAtKeys(List<String> queryKeys) {
    final queriesData = Map<String, dynamic>.from(_box.get(_queryRootKey));
    for (final key in queryKeys) {
      queriesData.remove(key);
    }
    _box.put(_queryRootKey, queriesData);
  }

  /// [id] should be [type:id] as standard.
  /// Will remove all objects in the store's queries which = {_refKey: key}
  void removeAllQueryRefsToId(String id) {
    for (final rootKey in _box.keys) {
      final data = _box.get(rootKey);
      _box.put(rootKey, recursiveRemoveRefsToId(data: data, id: id));
    }
  }

  /// Removes all entities that cannot be reached from the Query root key.
  Set<String> gc() {
    final reachable = reachableIdsFromDataId(
      dataId: _queryRootKey,
      read: (dataId) => readNormalized(dataId),
    );

    final keysToRemove = _box.keys
        .where(
          (key) => key != _queryRootKey && !reachable.contains(key),
        )
        .map((k) => k.toString())
        .toSet();
    _box.deleteAll(keysToRemove);

    return keysToRemove;
  }

  Future<void> clear() async {
    await _box.clear();
  }

  Future<void> dispose() async {
    observableQueries.forEach((k, v) {
      v.dispose();
    });
    _httpLink.dispose();
    await _box.clear();
  }
}

/// A single stream of data relating toa single executable [GraphQLQuery].
/// Allows a widget to watch this stream and re-build when new data is broadcast to it.
class ObservableQuery<TData, TVars extends json.JsonSerializable> {
  final BehaviorSubject<GraphQLResponse> subject;
  late GraphQLQuery<TData, TVars> query;

  /// If true then data is saved under a key ([id]) which includes the parameters of the query (if they exist).
  /// Example:
  /// [workoutById({"id":null})] when false
  /// [workoutById({"id": Workout:9262436-7399290})] when true
  /// Defaults to false.
  final bool parameterize;
  final String id;

  /// The last result passed into the stream. Useful for initialising stream data in the instance where a [QueryObserver] is listening to an already running stream.
  final GraphQLResponse? latest;

  /// Tracks how many [QueryObserver]s are listening to the stream.
  int observers = 1;

  ObservableQuery(
      {required this.id,
      required this.subject,
      required this.query,
      this.latest,
      this.parameterize = false});

  void dispose() {
    subject.close();
  }
}

class OperationResult<TData> {
  final TData? data;
  final List<Object>? errors;
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  OperationResult({this.data, this.errors});
}

class QueryNotFoundException implements Exception {
  final String id;
  const QueryNotFoundException(this.id);
  @override
  String toString() =>
      'QueryNotFoundException: There is no ObservableQuery with this id: $id';
}

/// [QueryFetchPolicy] determines where the client may return a result from.
enum QueryFetchPolicy {
  /// Return result from cache. Only fetch from network if cached result is not available.
  storeFirst,

  /// Return result from cache first (if it exists), then return network result once it's available.
  storeAndNetwork,

  /// Return result from cache if available, fail otherwise.
  storeOnly,

  /// Return result from network, fail if network call doesn't succeed, save to cache.
  networkOnly,
}
