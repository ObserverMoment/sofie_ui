import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class CoreDataRepo {
  static List<BodyArea> bodyAreas = [];
  static List<Equipment> equipment = [];
  static List<MoveType> moveTypes = [];
  static List<ProgressWidget> progressWidgets = [];
  static List<FitnessBenchmarkCategory> fitnessBenchmarkCategories = [];
  /// TODO: Deprecated.
  static List<WorkoutGoal> workoutGoals = [];
  static List<WorkoutSectionType> workoutSectionTypes = [];

  static Future<void> initCoreData(BuildContext context) async {
    final result = await GraphQLStore.store
        .networkOnlyOperation(operation: CoreDataQuery());

    checkOperationResult(result,
        onFail: () => throw Exception('Could not load core app data!'),
        onSuccess: () {
          final coreData = result.data!.coreData;
          bodyAreas = coreData.bodyAreas;
          equipment = coreData.equipment;
          moveTypes = coreData.moveTypes;
          progressWidgets = coreData.progressWidgets;
          fitnessBenchmarkCategories = coreData.fitnessBenchmarkCategories;
          workoutSectionTypes = coreData.workoutSectionTypes;
          workoutGoals = coreData.workoutGoals;
        });
  }
}
