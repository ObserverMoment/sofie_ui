/// For Artemis package - custom scalar conversions for types.
/// DateTime
DateTime fromGraphQLDateTimeToDartDateTime(int date) =>
    DateTime.fromMillisecondsSinceEpoch(date);

int fromDartDateTimeToGraphQLDateTime(DateTime date) =>
    date.millisecondsSinceEpoch;

DateTime? fromGraphQLDateTimeNullableToDartDateTimeNullable(int? date) =>
    date != null ? DateTime.fromMillisecondsSinceEpoch(date) : null;

int? fromDartDateTimeNullableToGraphQLDateTimeNullable(DateTime? date) =>
    date?.millisecondsSinceEpoch;

/// JSON
Map fromGraphQLJsonToDartMap(dynamic data) {
  return Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
}

dynamic fromDartMapToGraphQLJson(Map data) => data;

Map? fromGraphQLJsonNullableToDartMapNullable(dynamic data) {
  return data != null
      ? Map<String, dynamic>.from(data as Map<dynamic, dynamic>)
      : null;
}

dynamic fromDartMapNullableToGraphQLJsonNullable(Map? data) =>
    data;
