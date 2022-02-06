import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class CoreDataRepo {
  static List<BodyArea> bodyAreas = [];
  static List<Equipment> equipment = [];
  static List<MoveType> moveTypes = [];
  static List<WorkoutGoal> workoutGoals = [];
  static List<WorkoutSectionType> workoutSectionTypes = [];
  static List<Move> standardMoves = [];

  static Future<void> initCoreData(BuildContext context) async {
    final result = await context.graphQLStore
        .networkOnlyOperation(operation: CoreDataQuery());

    checkOperationResult(context, result,
        onFail: () => throw Exception('Could not load core app data!'),
        onSuccess: () {
          final coreData = result.data!.coreData;
          bodyAreas = coreData.bodyAreas;
          equipment = coreData.equipment;
          moveTypes = coreData.moveTypes;
          workoutGoals = coreData.workoutGoals;
          workoutSectionTypes = coreData.workoutSectionTypes;
          standardMoves = coreData.standardMoves;
        });
  }
}
