import 'package:artemis/artemis.dart';
import 'package:get_it/get_it.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_link/gql_link.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:rxdart/rxdart.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/services/store/links/auth_link.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class GraphQLStore {
  static const String boxName = 'graphql-cache';
  late HttpLink _httpLink;
  late AuthLink _authLink;
  late Link _link;
  late Box _box;

  static const refKey = '\$ref';
  static const queryRootKey = 'query';
  static const dataRootKey = 'data';

  GraphQLStore() {
    _httpLink = HttpLink(
      EnvironmentConfig.graphqlEndpoint,
    );

    _authLink = AuthLink(
        getToken: () async =>
            'Bearer ${await GetIt.I<AuthBloc>().getIdToken()}');

    _link = _authLink.concat(_httpLink);

    /// This must already have been opened (in main.dart...probably).
    _box = Hive.box(boxName);

    /// Run a clean up of the data on init.
    gc();
  }

  /// Must first register instance with GetIt for this to work.
  /// Should only ever be one instance per runtime of GraphQLStore.
  static GraphQLStore get store => GetIt.I<GraphQLStore>();

  Map<String, ObservableQuery> observableQueries = <String, ObservableQuery>{};

  List<ObservableQuery<TData, TVars>>
      _getQueriesbyId<TData, TVars extends json.JsonSerializable>(String id) =>
          observableQueries.values
              .where((oq) => oq.id == id || oq.query.operationName == id)
              .toList() as List<ObservableQuery<TData, TVars>>;

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
  Future<void> fetchInitialQuery<TData>(
      {required String id,
      required QueryFetchPolicy fetchPolicy,
      bool garbageCollectAfterFetch = false}) async {
    if (!observableQueries.containsKey(id)) {
      throw QueryNotFoundException(id);
    } else {
      switch (fetchPolicy) {
        case QueryFetchPolicy.storeAndNetwork:
          _queryStore<TData>(id);
          await _queryNetwork<TData>(id);
          break;
        case QueryFetchPolicy.storeFirst:
          final success = _queryStore<TData>(id);
          if (!success) {
            await _queryNetwork<TData>(id);
          }
          break;
        case QueryFetchPolicy.storeOnly:
          _queryStore<TData>(id);
          break;
        case QueryFetchPolicy.networkOnly:
          await _queryNetwork<TData>(id);
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
  bool _queryStore<TData>(String id) {
    final observableQuery = observableQueries[id];
    if (observableQuery == null) {
      printLog(
          '_queryStore: QueryNotFoundOrNotInitialized: There is no ObservableQuery with id: $id');
      return false;
    } else {
      try {
        // Does a key exist in the store?
        if (!hasQueryDataInStore(observableQuery.id)) {
          printLog(
              '_queryStore: No key in data store for ${observableQuery.id}');
          return false;
        }

        final queryData = readQueryData(observableQuery.id);

        if (queryData == null) {
          printLog('_queryStore: Data returned null for ${observableQuery.id}');
          return false;
        }

        final aliasOrName =
            extractRootFieldAliasFromOperation(observableQuery.query) ??
                observableQuery.query.operationName ??
                id;

        final TData data =
            observableQuery.query.parse({aliasOrName: queryData});

        // Add to the stream to broadcastQueriesByIds to all listeners.
        observableQuery.subject.add(GraphQLResponse<TData>(data: data));
        return true;
      } catch (e) {
        printLog(e.toString());
        return false;
      }
    }
  }

  /// Get data from the network, normalize it, add it to the store, broadcastQueriesByIds to the observable query.
  Future<bool> _queryNetwork<TData>(String id) async {
    final observableQuery = observableQueries[id];
    if (observableQuery == null) {
      printLog(
          '_queryNetwork: QueryNotFoundOrNotInitialized: There is no ObservableQuery with id: $id');
      return false;
    } else {
      try {
        await query(query: observableQuery.query, broadcastQueryIds: [id]);
        return true;
      } catch (e) {
        printLog(e.toString());
        return false;
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

  Future<void> refetchQueriesByIds(List<String> ids) async {
    for (final id in ids) {
      final observableQueries = _getQueriesbyId(id);
      for (final q in observableQueries) {
        await _queryNetwork(q.id);
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

  /// Network query which writes to store and optionally re-broadcasts specified queries. Returns the query result or null if fail.
  /// Update the store with returned (after normalizing) data, then broadcastQueriesByIds (broadcastQueriesByIds is really a store read follwed by a broadcastQueriesByIds) to specified ids.
  Future<OperationResult<TData>?>
      query<TData, TVars extends json.JsonSerializable>({
    required GraphQLQuery<TData, TVars> query,
    bool parameterizeQuery = true,
    List<String> broadcastQueryIds = const [],
  }) async {
    final response = await execute(query);

    final hasErrors = response.errors != null && response.errors!.isNotEmpty;

    if (hasErrors) {
      printLog('There was an error...${query.operationName}');
      response.errors?.forEach((e) {
        printLog(e.toString());
      });
    }

    if (!hasErrors && response.data != null) {
      /// Get the correct query ID for writing data to the store on the response is received.
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

      /// Check for a top level field alias to ensure we look under the correct key for the response.
      final alias = extractRootFieldAliasFromOperation(query);
      final data = response.data![alias ?? query.operationName ?? id];

      normalizeToStore(
        queryKey: id,
        data: data,
        write: mergeWriteNormalized,
        read: readNormalized,
      );

      if (broadcastQueryIds.isNotEmpty) {
        broadcastQueriesByIds(broadcastQueryIds);
      }
    }

    final result = OperationResult<TData>(
        data: query.parse(response.data ?? {}), errors: response.errors);

    return result;
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

    final hasErrors = response.errors != null && response.errors!.isNotEmpty;

    if (hasErrors) {
      printLog('There was an error...${mutation.operationName}');
      response.errors?.forEach((e) {
        printLog(e.toString());
      });
    }

    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      /// Check for a top level field alias to ensure we look under the correct key for the response.
      final alias = extractRootFieldAliasFromOperation(mutation);
      final data = response.data![alias ?? mutation.operationName];

      /// Handle cases where returned data is a list of objects.
      /// E.g CreateBodyTransformPhotosMutation returns [List<BodyTransformPhoto>]
      /// Note: Optimistic data cannot be a list...currently.
      if (data is List) {
        for (final e in data) {
          normalizeToStore(
              data: e, write: mergeWriteNormalized, read: readNormalized);
          addRefToQueryData(data: e, queryIds: addRefToQueries);
        }
      } else {
        normalizeToStore(
            data: data, write: mergeWriteNormalized, read: readNormalized);
        addRefToQueryData(data: data, queryIds: addRefToQueries);
      }

      processResult?.call(result.data as TData);
    }

    return result;
  }

  /// Network mutation with optional optimism.
  /// Wrap execute function - add cache writing and broadcastQueriesByIdsing.
  /// Update the store with returned (after normalizing) data, then broadcastQueriesByIds (broadcastQueriesByIds is really a store read follwed by a broadcastQueriesByIds) to specified ids.
  Future<OperationResult<TData>>
      mutate<TData, TVars extends json.JsonSerializable>({
    required GraphQLQuery<TData, TVars> mutation,
    Map<String, dynamic>? optimisticData,

    /// Query IDs passed here will be refetched from the network. Data will be added to store and then the query broadcast.
    List<String> refetchQueryIds = const [],

    /// Broascast from the store - no network request made.
    List<String> broadcastQueryIds = const [],

    /// [customVariablesMap] - if you do not want to pass all the fields of the object to the API. If you pass null fields / omit some fields to the typed inputs then those fields will be set null in the DB.
    Map<String, dynamic>? customVariablesMap,
    void Function(TData resultData)? processResult,
  }) async {
    if (optimisticData != null) {
      writeDataToStore(
        data: optimisticData,
        broadcastQueryIds: broadcastQueryIds,
      );
    }

    final response =
        await execute(mutation, customVariablesMap: customVariablesMap);

    final hasErrors = response.errors != null && response.errors!.isNotEmpty;

    if (hasErrors) {
      printLog('There was an error...${mutation.operationName}');
      response.errors?.forEach((e) {
        printLog(e.toString());
      });

      /// TODO: Handle optimistic data rollback.
    }

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
        }
      } else {
        normalizeToStore(
            data: data, write: mergeWriteNormalized, read: readNormalized);
      }

      processResult?.call(result.data as TData);

      broadcastQueriesByIds(broadcastQueryIds);
      refetchQueriesByIds(refetchQueryIds);
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
      void Function(TData resultData)? processResult,

      /// Remove a whole query key from the store.
      /// Useful when deleting single objects that have query root data in the store.
      /// i.e. [workoutById(id: 123)].
      List<String> clearQueryDataAtKeys = const [],
      List<String> broadcastQueryIds = const []}) async {
    final response = await execute(mutation);

    final hasErrors = response.errors != null && response.errors!.isNotEmpty;

    if (hasErrors) {
      printLog('There was an error...${mutation.operationName}');
      response.errors?.forEach((e) {
        printLog(e.toString());
      });
    }

    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      final id = '$typename:$objectId';
      await deleteNormalizedObject(id);

      removeAllQueryRefsToId(id);

      if (clearQueryDataAtKeys.isNotEmpty) {
        clearQueryData(clearQueryDataAtKeys);
      }

      processResult?.call(result.data as TData);

      broadcastQueriesByIds(broadcastQueryIds);
    }

    return result;
  }

  /// Similar to [delete] but will delete a list of objects from store.
  /// Must all be the same [typename].
  Future<OperationResult<TData>>
      deleteMultiple<TData, TVars extends json.JsonSerializable>(
          {required GraphQLQuery<TData, TVars> mutation,
          required List<String> objectIds,
          required String typename,
          List<String> clearQueryDataAtKeys = const [],
          void Function(TData resultData)? processResult,
          List<String> broadcastQueryIds = const []}) async {
    final response = await execute(mutation);

    final hasErrors = response.errors != null && response.errors!.isNotEmpty;

    if (hasErrors) {
      response.errors?.forEach((e) {
        printLog(e.toString());
      });
    }

    /// [result][data][operationName] should always be a list of deleted IDs being returned from the API.
    final result = OperationResult<TData>(
        data: mutation.parse(response.data ?? {}), errors: response.errors);

    if (!result.hasErrors && result.data != null) {
      for (final id in response.data?[mutation.operationName] as List) {
        final objectStoreId = '$typename:$id';
        await deleteNormalizedObject(objectStoreId);

        removeAllQueryRefsToId(id);
      }

      if (clearQueryDataAtKeys.isNotEmpty) {
        /// Remove a whole query key from the store.
        /// Useful when deleting single objects that have query root data in the store.
        /// i.e. [workoutById(id: 123)].
        clearQueryData(clearQueryDataAtKeys);
      }

      processResult?.call(result.data as TData);

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

    final hasErrors = response.errors != null && response.errors!.isNotEmpty;

    if (hasErrors) {
      response.errors?.forEach((e) {
        printLog(e.toString());
      });
    }

    final result = OperationResult<TData>(
        data: operation.parse(response.data ?? {}), errors: response.errors);

    return result;
  }

  /////////////////////////////////////
  ///// Hive box reads and writes /////
  /////////////////////////////////////
  /// Client side (Store) reads.
  Object? readQueryData(String queryId) {
    final allQueries = _box.get(queryRootKey);

    final queryObject = allQueries[queryId];

    return denormalizeObject(data: queryObject, box: _box);
  }

  /// Retrieves the raw normalized data.
  /// Normalized children will be [$ref] objects. Not plain json maps.
  Map<String, dynamic> readNormalized(String key) {
    return Map<String, dynamic>.from(_box.get(key) ?? {});
  }

  /// Retrieves data from a key and then recursively retrieves all of its children.
  /// Children can be scalar or [$ref] objects where plain json Map is returned.
  Map<String, dynamic> readDenomalized(String key) {
    return readFromStoreDenormalized(key: key, box: _box);
  }

  /// Client side (Store) write.
  /// Writes query response data and / or straight JSON data to the store.
  /// For query data the object will be { [queryId]: [Map] or []}
  bool writeDataToStore(
      {String? queryId,
      required Map<String, dynamic> data,
      List<String> broadcastQueryIds = const [],

      /// Only queries whose data is a [list] of refs can accept refs like this. Do not use for queries where data is a single Map.
      List<String> addRefToQueries = const []}) {
    try {
      normalizeToStore(
          queryKey: queryId,
          data: data,
          write: mergeWriteNormalized,
          read: readNormalized);

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

  Future<void> deleteNormalizedObject(String key) async {
    await _box.delete(key);
  }

  ////////////////////////////
  //// Handle Ref Updates ////
  ////////////////////////////
  /// Add a $ref obj to all specified query ids. Query data must be a [List]
  /// Does not write a normalized object to the store.
  bool addRefToQueryData(
      {required Map<String, dynamic> data, required List<String> queryIds}) {
    final objectId = resolveDataId(data);
    if (objectId == null) {
      printLog(
          'Warning: Could not resolveDataId in [data]. If you want to add a ref to queries then you need to provide [id] and [__typename] in the data.');
      return false;
    }
    final allQueries = _box.get(queryRootKey);

    for (final queryId in queryIds) {
      final prevList = allQueries[queryId];

      if (prevList != null && prevList is! List) {
        throw AssertionError(
            'There is data under [$queryRootKey][$queryId], but it is not a list. You cannot add a ref to a non list object.');
      }

      final newRef = {refKey: objectId};

      final updatedList = [if (prevList != null) ...prevList as List, newRef];

      // Rewrite to box.
      _box.put(queryRootKey, {...allQueries, queryId: updatedList});

      broadcastQueriesByIds([queryId]);
    }
    return true;
  }

  ///  Remove a ref obj from all specified query ids (where those ID's data is in [List] format).
  /// [objectId] must be in the format [type:id] as a string.
  /// If [_box.get(queryRootKey)] is null then this key will be created.
  /// Runs broadcast once the ref has been removed.
  bool removeRefFromQueryData(
      {required Map<String, dynamic> data, required List<String> queryIds}) {
    final objectId = resolveDataId(data);
    if (objectId == null) {
      printLog(
          'Warning: Could not resolveDataId in [data]. If you want to remove a ref from queries then you need to provide [id] and [__typename] in the data.');
      return false;
    }
    final allQueries = _box.get(queryRootKey);

    for (final queryId in queryIds) {
      final prevList = allQueries[queryId];

      if (prevList != null && prevList is! List) {
        throw AssertionError(
            'There is data under [$queryRootKey][$queryId], but it is not a list. You cannot remove a ref from a non list object.');
      }

      final updatedList = prevList != null
          ? (prevList as List).where((e) => e[refKey] != objectId).toList()
          : [];

      // Rewrite to box.
      _box.put(queryRootKey, {...allQueries, queryId: updatedList});

      broadcastQueriesByIds([queryId]);
    }
    return true;
  }

  /// Within the root query key - does data for this query exist.
  bool hasQueryDataInStore(String queryKey) {
    return _box.get(queryRootKey, defaultValue: {})[queryKey] != null;
  }

  void clearQueryData(List<String> queryKeys) {
    final queriesData = Map<String, dynamic>.from(_box.get(queryRootKey));
    for (final key in queryKeys) {
      queriesData.remove(key);
    }
    _box.put(queryRootKey, queriesData);
  }

  /// [id] should be [type:id] as standard.
  /// Will remove all objects in the store which = {refKey: key}
  void removeAllQueryRefsToId(String id) {
    for (final rootKey in _box.keys) {
      final data = _box.get(rootKey);
      _box.put(rootKey, recursiveRemoveRefsToId(data: data, id: id));
    }
  }

  /// Removes all entities that cannot be reached from the Query root key.
  Set<String> gc() {
    final reachable = reachableIdsFromDataId(
      dataId: queryRootKey,
      read: (dataId) => readNormalized(dataId),
    );

    final keysToRemove = _box.keys
        .where(
          (key) => key != queryRootKey && !reachable.contains(key),
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

/// A single stream of data relating to a single executable [GraphQLQuery].
/// Allows a widget / component to watch this stream and re-build when new data is broadcast to it.
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
