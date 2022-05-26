import 'dart:convert';

import 'package:artemis/artemis.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:hive/hive.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';

const kStoreReferenceKey = '\$ref';

bool checkOperationResult<T>(OperationResult<T> result,
    {VoidCallback? onSuccess, VoidCallback? onFail}) {
  if (result.hasErrors || result.data == null) {
    result.errors?.forEach((e) async {
      printLog(e.toString());
      await Sentry.captureException(
        e,
      );
    });
    if (onFail != null) {
      onFail();
    }
    return false;
  } else {
    if (onSuccess != null) {
      onSuccess();
    }
    return true;
  }
}

/// Accepts hierarchical data and write it to a normalized key value store [Hive] box.
/// All objects must have two fields, [__typename] and [id] to generate a unique id.
/// Objects without these fields, or that are in [kExcludeFromNormalization], will not be normalized and will be accessible from their parents.
void normalizeToStore(
    {String? queryKey,
    required Map<String, dynamic> data,
    required void Function(String key, Object? data) write,
    required Map<String, dynamic> Function(String key) read,
    String referenceKey = kStoreReferenceKey}) {
  final Map<String, dynamic> normalizedResult = {};

  try {
    if (queryKey != null) {
      /// { userWorkouts: [obj, obj, obj] }.
      normalizedResult['Query'] = {
        queryKey:
            normalizeObject(normalized: normalizedResult, data: data[queryKey])
      };
    } else {
      normalizeObject(normalized: normalizedResult, data: data);
    }

    /// Write each key in the normalized map to the store. Overwriting previous data.
    for (final entry in normalizedResult.entries) {
      write(entry.key, {
        ...read(entry.key),
        ...entry.value,
      });
    }
  } catch (e) {
    printLog(e.toString());
    printLog('normalizeToStore falied - no data written.');
  }
}

/// Recursively traverses the object.
Object? normalizeObject(
    {required Object? data,
    required Map<String, dynamic> normalized,
    String referenceKey = kStoreReferenceKey}) {
  if (data is Map<String, dynamic>) {
    final dataId = resolveDataId(data);
    if (dataId == null) {
      /// Do not normalize and return un-normalized raw data.
      return data;
    } else {
      final normalizedData =
          data.entries.fold<Map<String, dynamic>>({}, (obj, entry) {
        obj[entry.key] =
            normalizeObject(normalized: normalized, data: entry.value);
        return obj;
      });

      normalized[dataId] = normalizedData;
      return {referenceKey: resolveDataId(data)};
    }
  } else if (data is List) {
    return data
        .map((obj) => normalizeObject(normalized: normalized, data: obj))
        .toList();
  } else {
    /// If data is scalar or null then return it to be written.
    return data;
  }
}

/// Read a key from the store and recursively denormalize all the $refs.
Map<String, dynamic> readFromStoreDenormalized(String key, Box box) {
  final normalized = Map<String, dynamic>.from(box.get(key) as Map? ?? {});
  return Map<String, dynamic>.from(
      denormalizeObject(data: normalized, box: box) as Map<String, dynamic>);
}

/// Recursive function which will denormalize a normalized object in [box].
Object? denormalizeObject({required Object? data, required Box box}) {
  if (data is Map<String, dynamic>) {
    return data.entries.fold<Map<String, dynamic>>({}, (acum, e) {
      if (e.key == kStoreReferenceKey) {
        final refData = Map<String, dynamic>.from(box.get(e.value) as Map);
        return Map<String, dynamic>.from(
            denormalizeObject(data: refData, box: box) as Map<String, dynamic>);
      } else {
        acum[e.key] = denormalizeObject(data: e.value, box: box);
        return acum;
      }
    });
  } else if (data is List) {
    return data.map((obj) => denormalizeObject(data: obj, box: box)).toList();
  } else {
    return data;
  }
}

String? resolveDataId(Map<String, dynamic> data) {
  if (data['__typename'] == null) {
    /// Cannot normalize an object without a data["__typename"] field as this is required to resolve the unique id.
    return null;
  } else if (data['id'] == null) {
    /// Cannot normalize an object without a data["id"] field as this is required to resolve the unique id.
    return null;
  } else if (kExcludeFromNormalization.contains(data['__typename'])) {
    /// We do not want to normalize these objects - they are always children and should be considered only in relation to their parent.
    /// i.e. There should be no entry under [WorkoutMove:id]. This is never accessed directly and should be deleted if its parents [set, section, workout] are deleted.
    return null;
  } else {
    return '${data["__typename"]}:${data["id"]}';
  }
}

/// Traverses the data object and removes any ref objects that match the id provided.
/// Returns a cleaned version of the data.
Object? recursiveRemoveRefsToId(
    {required Object? data,
    required String id,
    String referenceKey = kStoreReferenceKey}) {
  if (data is Map) {
    return data.entries.fold<Map<String, dynamic>>({}, (obj, entry) {
      if (entry.key == kStoreReferenceKey && entry.value == id) {
        /// This is an entry we want to delete. Ignore
        return obj;
      } else {
        obj[entry.key as String] =
            recursiveRemoveRefsToId(data: entry.value, id: id);
        return obj;
      }
    });
  } else if (data is List) {
    return data
        .map((e) {
          if (e is Map &&
              e.entries.length == 1 &&
              e[kStoreReferenceKey] == id) {
            return null;
          } else {
            return recursiveRemoveRefsToId(data: e, id: id);
          }
        })
        .where((e) => e != null)
        .toList();
  } else {
    /// Nulls and scalars return.
    return data;
  }
}

Map<String, dynamic>? recursivelyAddAll(
  Map<String, dynamic>? target,
  Map<String, dynamic>? source,
) {
  final tgt = Map<String, dynamic>.from(target ?? {});

  source!.forEach((String key, dynamic value) {
    if (tgt.containsKey(key) &&
        tgt[key] is Map<String, dynamic> &&
        value != null &&
        value is Map<String, dynamic>) {
      tgt[key] = recursivelyAddAll(
        tgt[key] as Map<String, dynamic>,
        value,
      );
    } else {
      // Lists and nulls overwrite target as if they were normal scalars
      tgt[key] = value;
    }
  });
  return target;
}

/// Deeply merges `maps` into a new map, merging nested maps recursively.
///
/// Paths in the rightmost maps override those in the earlier ones, so:
/// ```
/// print(deeplyMergeLeft([
///   {'keyA': 'a1'},
///   {'keyA': 'a2', 'keyB': 'b2'},
///   {'keyB': 'b3'}
/// ]));
/// // { keyA: a2, keyB: b3 }
/// ```
///
/// Conflicting [List]s are overwritten like scalars
Map<String, dynamic>? deeplyMergeLeft(
  Iterable<Map<String, dynamic>?> maps,
) {
  // prepend an empty literal for functional immutability
  return <Map<String, dynamic>?>[{}, ...maps].reduce(recursivelyAddAll);
}

/// Returns a set of all IDs reachable from the given data ID.
/// Includes the given [dataId] itself.
/// usually [dataId] will be ['Query']
Set<String> reachableIdsFromDataId({
  required String dataId,
  required Map<String, dynamic> Function(String dataId) read,
  String referenceKey = '\$ref',
}) =>
    _idsInObject(read(dataId), read, referenceKey, {})..add(dataId);

/// Recursively finds reachable IDs in [object]
Set<String> _idsInObject(
  Object object,
  Map<String, dynamic> Function(String dataId) read,
  String referenceKey,
  Set<String> visited,
) {
  if (object is Map) {
    if (object.containsKey(referenceKey)) {
      if (visited.contains(object[referenceKey])) return {};
      return {object[referenceKey]}..addAll(
          _idsInObject(
            read(object[referenceKey]),
            read,
            referenceKey,
            visited..add(object[referenceKey]),
          ),
        );
    }

    return object.values.fold(
      {},
      (ids, element) => ids
        ..addAll(
          _idsInObject(
            /// Had to add [?? {}] to the original function by [normalize] because it is possible for element to be null and this was throwing. Not sure why this was not an issue in the original library - possibly due to more strict partial data rules when writing fragments.
            element as Object? ?? {},
            read,
            referenceKey,
            visited,
          ),
        ),
    );
  } else if (object is List) {
    return object.fold(
      {},
      (ids, element) => ids
        ..addAll(
          _idsInObject(
            element as Object,
            read,
            referenceKey,
            visited,
          ),
        ),
    );
  }
  return {};
}

/// TODO: Needs some further research and testing.
/// Returns null if no alias found.
String? extractRootFieldAliasFromOperation(GraphQLQuery operation) {
  final OperationDefinitionNode operationDefinitionNode = operation
          .document.definitions
          .firstWhere((node) => node is OperationDefinitionNode)
      as OperationDefinitionNode;

  return (operationDefinitionNode.selectionSet.selections[0] as FieldNode)
      .alias
      ?.value;
}

/// For example [workoutById({"id": id})]
/// Same as the [normalize] package does this.
String getParameterizedQueryId(GraphQLQuery query) {
  return '${query.operationName}(${jsonEncode(query.getVariablesMap())})';
}

/// For example [workoutById({"id": null})]
/// Same as the [normalize] package does this.
String getNulledVarsQueryId(GraphQLQuery query) {
  return '${query.operationName}(${jsonEncode(nullifyVars(query.getVariablesMap()))})';
}

Map<String, dynamic> nullifyVars(Map<String, dynamic> vars) {
  return vars.keys.fold<Map<String, dynamic>>({}, (nulledVars, next) {
    nulledVars[next] = null;
    return nulledVars;
  });
}
