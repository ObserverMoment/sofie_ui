import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

//// String to enum parser ////
// https://stackoverflow.com/questions/27673781/enum-from-string
extension EnumParser on String {
  TimelinePostType toTimelinePostType() {
    return TimelinePostType.values.firstWhere(
        (e) =>
            e.toString().toLowerCase() ==
            'TimelinePostType.$this'.toLowerCase(), orElse: () {
      throw Exception('$this is not a valid TimelinePostType');
    });
  }

  DifficultyLevel toDifficultyLevel() {
    return DifficultyLevel.values.firstWhere(
        (v) =>
            v.toString().toLowerCase() == 'DifficultyLevel.$this'.toLowerCase(),
        orElse: () => DifficultyLevel.artemisUnknown);
  }
}

//// Enum type extensions ////
extension BenchmarkTypeExtension on BenchmarkType {
  String get apiValue => describeEnum(this).toUpperCase();

  String get display {
    switch (this) {
      case BenchmarkType.amrap:
        return 'AMRAP';
      case BenchmarkType.maxload:
        return 'Max Load';
      case BenchmarkType.unbrokenreps:
        return 'Reps Unbroken';
      case BenchmarkType.unbrokentime:
        return 'Time Unbroken';
      case BenchmarkType.fastesttime:
        return 'Fastest Time';
      default:
        throw Exception('This is not a valid BenchmarkType enum: $this');
    }
  }

  String get description {
    switch (this) {
      case BenchmarkType.amrap:
        return 'Complete as many reps as possible of a move or set of moves within a fixed amount of time. Score the numbetr of reps.';
      case BenchmarkType.maxload:
        return 'Properly complete a fixed number of reps or sets with the maximum load possible. Score the load.';
      case BenchmarkType.unbrokenreps:
        return 'Go unbroken for a long as possible whilst properly completing reps of a specified movement. Score the reps.';
      case BenchmarkType.unbrokentime:
        return 'Go unbroken for a long as possible whilst properly completing reps of a specified movement. Score the time.';
      case BenchmarkType.fastesttime:
        return 'Finish fixed reps or sets as fast as possible while still maintaining proper form. Score the time.';
      default:
        throw Exception('This is not a valid BenchmarkType enum: $this');
    }
  }
}

extension BodyweightUnitExtension on BodyweightUnit {
  String get apiValue => describeEnum(this).toUpperCase();
  String get display => describeEnum(this);
}

extension ContentAccessScopeExtension on ContentAccessScope {
  String get display => describeEnum(this).capitalize;
  String get apiValue => describeEnum(this).toUpperCase();
}

extension DifficultyLevelExtension on DifficultyLevel {
  String get display => describeEnum(this).capitalize;
  String get apiValue => describeEnum(this).toUpperCase();

  Color get displayColor {
    switch (this) {
      case DifficultyLevel.light:
        return Styles.difficultyLevelOne;
      case DifficultyLevel.challenging:
        return Styles.difficultyLevelTwo;
      case DifficultyLevel.intermediate:
        return Styles.difficultyLevelThree;
      case DifficultyLevel.advanced:
        return Styles.difficultyLevelFour;
      case DifficultyLevel.elite:
        return Styles.difficultyLevelFive;
      default:
        throw Exception('This is not a valid DifficultyLevel enum: $this');
    }
  }

  int get numericValue {
    switch (this) {
      case DifficultyLevel.light:
        return 1;
      case DifficultyLevel.challenging:
        return 2;
      case DifficultyLevel.intermediate:
        return 3;
      case DifficultyLevel.advanced:
        return 4;
      case DifficultyLevel.elite:
        return 5;
      default:
        throw Exception('This is not a valid DifficultyLevel enum: $this');
    }
  }

  static DifficultyLevel levelFromNumber(num value) {
    switch (value.round()) {
      case 1:
        return DifficultyLevel.light;
      case 2:
        return DifficultyLevel.challenging;
      case 3:
        return DifficultyLevel.intermediate;
      case 4:
        return DifficultyLevel.advanced;
      case 5:
        return DifficultyLevel.elite;
      default:
        throw Exception(
            'This is not a valid DifficultyLevel numeric value: $value');
    }
  }
}

extension DistanceUnitExtension on DistanceUnit {
  String get shortDisplay {
    switch (this) {
      case DistanceUnit.metres:
        return 'mtr';
      case DistanceUnit.kilometres:
        return 'km';
      case DistanceUnit.yards:
        return 'yd';
      case DistanceUnit.miles:
        return 'mi';
      default:
        throw Exception('This is not a valid DistanceUnit enum: $this');
    }
  }

  String get display => describeEnum(this).capitalize;
  String get apiValue => describeEnum(this).toUpperCase();
}

extension GenderExtension on Gender {
  String get display => describeEnum(this).capitalize;
  String get apiValue => describeEnum(this).toUpperCase();
}

extension LoadUnitExtension on LoadUnit {
  String get display {
    switch (this) {
      case LoadUnit.kg:
        return 'kg';
      case LoadUnit.lb:
        return 'lb';
      case LoadUnit.bodyweightpercent:
        return '% body';
      case LoadUnit.percentmax:
        return '% max';
      default:
        throw Exception('This is not a valid LoadUnit enum: $this');
    }
  }

  String get apiValue => describeEnum(this).toUpperCase();
}

extension TimelinePostTypeExtension on TimelinePostType {
  String get apiValue => describeEnum(this).toUpperCase();

  String get display {
    switch (this) {
      case TimelinePostType.announcement:
        return 'Announcement';
      case TimelinePostType.workout:
        return 'Workout';
      case TimelinePostType.workoutplan:
        return 'Workout Plan';
      default:
        throw Exception('This is not a valid TimelinePostType enum: $this');
    }
  }
}

extension TimeUnitExtension on TimeUnit {
  String get shortDisplay {
    switch (this) {
      case TimeUnit.hours:
        return 'hrs';
      case TimeUnit.minutes:
        return 'mins';
      case TimeUnit.seconds:
        return 'secs';
      default:
        throw Exception('This is not a valid TimeUnit enum: $this');
    }
  }

  String get display => describeEnum(this).capitalize;
  String get apiValue => describeEnum(this).toUpperCase();
}

extension UserProfileScopeExtension on UserProfileScope {
  String get apiValue => describeEnum(this).toUpperCase();
  String get display => describeEnum(this);
}

extension WorkoutMoveRepTypeExtension on WorkoutMoveRepType {
  String get display => describeEnum(this).capitalize;
  String get apiValue => describeEnum(this).toUpperCase();

  String get shortDisplay {
    switch (this) {
      case WorkoutMoveRepType.reps:
        return 'reps';
      case WorkoutMoveRepType.calories:
        return 'cals';
      case WorkoutMoveRepType.time:
        return 'time';
      case WorkoutMoveRepType.distance:
        return 'distance';
      default:
        throw Exception('This is not a valid WorkoutMoveRepType enum: $this');
    }
  }

  String get displaySingular {
    switch (this) {
      case WorkoutMoveRepType.reps:
        return 'rep';
      case WorkoutMoveRepType.calories:
        return 'cal';
      case WorkoutMoveRepType.time:
        return 'time';
      case WorkoutMoveRepType.distance:
        return 'distance';
      default:
        throw Exception('This is not a valid WorkoutMoveRepType enum: $this');
    }
  }
}
