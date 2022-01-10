import 'package:sofie_ui/components/data_vis/waffle_chart.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:supercharged/supercharged.dart';
import 'package:collection/collection.dart';

class DataUtils {
  static List<WaffleChartInput> waffleChartInputsFromGoals(
      List<WorkoutGoal> goals) {
    final data = goals.fold<Map<WorkoutGoal, int>>({}, (acum, next) {
      if (acum[next] != null) {
        acum[next] = acum[next]! + 1;
      } else {
        acum[next] = 1;
      }
      return acum;
    });

    return data.entries
        .map((e) => WaffleChartInput(
            fraction: e.value / goals.length,
            color: HexColor.fromHex(e.key.hexColor),
            name: e.key.name))
        .toList();
  }

  /// Also sorts non bodyweight options alphabetically.
  static List<Equipment> sortEquipmentsWithBodyWeightFirst(
      List<Equipment> equipments) {
    final sortedEquipments = equipments.sortedBy<String>((e) => e.name);
    final bodyweight = sortedEquipments
        .firstWhereOrNull((e) => e.id == kBodyweightEquipmentId);
    return bodyweight == null
        ? sortedEquipments
        : [
            bodyweight,
            ...sortedEquipments.where((e) => e.id != kBodyweightEquipmentId),
          ];
  }

  /// Use this to split the user inputted load amount in two when displaying info on what equipmengt is needed. Eg. Dumbbells and Kettlebells.
  static double getLoadPerEquipmentUnit(Equipment e, double loadAmount) {
    final isDumbbells = e.id == kDumbbellsEquipmentId;
    final isKettleBells = e.id == kKettlebellsEquipmentId;
    final individualLoadAmount =
        isDumbbells || isKettleBells ? (loadAmount / 2) : loadAmount;
    return individualLoadAmount;
  }

  /// Receives any list of bodyAreaMove scores and returns a new list.
  /// Where each body area is represented only once and the score associated with it is calculated as a percentage of the whole list.
  static List<BodyAreaMoveScore> percentageBodyAreaMoveScores(
      List<BodyAreaMoveScore> bodyAreaMoveScores) {
    final totalPoints = bodyAreaMoveScores.sumByDouble((bams) => bams.score);
    final grouped = bodyAreaMoveScores.groupBy((bams) => bams.bodyArea);
    final summed = grouped.keys.map((bodyArea) {
      return grouped[bodyArea]!.fold(
          BodyAreaMoveScore()
            ..bodyArea = bodyArea
            ..score = 0, (BodyAreaMoveScore acum, next) {
        acum.score += next.score as int;
        return acum;
      });
    });
    return summed.map((bams) {
      bams.score = (bams.score ~/ totalPoints) * 100;
      return bams;
    }).toList();
  }

  /// Used when creating or doing a workout.
  static Duration calculateTimedSectionDuration(WorkoutSection workoutSection) {
    switch (workoutSection.workoutSectionType.name) {
      case kHIITCircuitName:
      case kEMOMName:
      case kTabataName:
        return Duration(
            seconds: workoutSection.rounds *
                workoutSection.workoutSets.sumBy((s) => s.duration));
      default:
        throw Exception(
            'DataUtils.calculateTimedSectionDuration: ${workoutSection.workoutSectionType.name} is not a timed workout type - so a duration cannot be calculated.');
    }
  }

  static int workoutMoveTimeRepsInSeconds(WorkoutMove workoutMove) {
    switch (workoutMove.timeUnit) {
      case TimeUnit.hours:
        return workoutMove.reps.round() * 3600;
      case TimeUnit.minutes:
        return workoutMove.reps.round() * 60;
      case TimeUnit.seconds:
        return workoutMove.reps.round();
      default:
        throw Exception(
            'DataUtils.workoutMoveTimeRepsInSeconds: ${workoutMove.timeUnit} is not a time unit that we can process.');
    }
  }

  /// Time and distance moves: a workoutMove counts as one 'rep'.
  /// E.g. 10mtr row would be 1 rep. 10 seconds hang hold would be one rep.
  /// One 'round' of the section.
  static int totalRepsInSection(WorkoutSection section) {
    return section.workoutSets.fold(0, (sectionAcum, nextSet) {
      return sectionAcum + totalRepsInSet(nextSet);
    });
  }

  static int totalRepsInSet(WorkoutSet workoutSet) {
    return workoutSet.workoutMoves.fold(0, (setAcum, nextMove) {
      if ([
        WorkoutMoveRepType.time,
        WorkoutMoveRepType.distance,
        WorkoutMoveRepType.artemisUnknown
      ].contains(nextMove.repType)) {
        return setAcum + 1;
      } else {
        return setAcum + nextMove.reps.round();
      }
    });
  }

  static List<BodyArea> bodyAreasInWorkoutSection(WorkoutSection section) {
    final List<BodyArea> bodyAreas = [];
    for (final s in section.workoutSets) {
      for (final m in s.workoutMoves) {
        bodyAreas.addAll(
            m.move.bodyAreaMoveScores.map((bams) => bams.bodyArea).toList());
      }
    }
    return bodyAreas;
  }

  /// Recursively cast a nested map of any [Map<K,V>]
  /// Initially to convert from [_InternalLinkedHashMap<dynamic, dynamic>] to [Map<String, dynamic>]
  /// When retrieving nested data from Hive.
  static Map<String, dynamic> convertToJsonMap(Map original) {
    return original.entries.fold<Map<String, dynamic>>({}, (map, next) {
      if (next.value is Map) {
        map[next.key.toString()] = convertToJsonMap(next.value as Map);
      } else if (next.value is List) {
        map[next.key.toString()] = (next.value as List)
            .map((o) => o is Map ? convertToJsonMap(o) : o)
            .toList();
      } else {
        map[next.key.toString()] = next.value;
      }

      return map;
    });
  }

  static String buildBenchmarkEntryScoreText(BenchmarkType benchmarkType,
      LoadUnit loadUnit, UserBenchmarkEntry entry) {
    switch (benchmarkType) {
      case BenchmarkType.maxload:
        return '${entry.score.stringMyDouble()}${loadUnit.display}';
      case BenchmarkType.fastesttime:
      case BenchmarkType.unbrokentime:
        return Duration(seconds: entry.score.round()).compactDisplay;
      case BenchmarkType.amrap:
      case BenchmarkType.unbrokenreps:
        return '${entry.score.stringMyDouble()} reps';
      default:
        return entry.score.stringMyDouble();
    }
  }

  /// 0 = true / yes
  /// 1 = false / no
  /// 2 = null / don't care
  static int nullableBoolToInt({bool? value}) {
    return value == null
        ? 2
        : value
            ? 0
            : 1;
  }

  static bool? intToNullableBool(int i) {
    return i == 0
        ? true
        : i == 1
            ? false
            : null;
  }
}
