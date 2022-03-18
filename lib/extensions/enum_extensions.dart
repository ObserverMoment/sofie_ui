import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

//// String to enum parser ////
// https://stackoverflow.com/questions/27673781/enum-from-string
extension EnumParser on String {
  DifficultyLevel toDifficultyLevel() {
    return DifficultyLevel.values.firstWhere(
        (v) =>
            v.toString().toLowerCase() == 'DifficultyLevel.$this'.toLowerCase(),
        orElse: () => DifficultyLevel.artemisUnknown);
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

extension FeedPostTypeExtension on FeedPostType {
  bool get hasShareableContent => [
        FeedPostType.workout,
        FeedPostType.workoutPlan,
        FeedPostType.loggedWorkout,
      ].contains(this);
}

extension FitnessBenchmarkScoreTypeExtension on FitnessBenchmarkScoreType {
  String get display {
    switch (this) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
        return 'Fastest Time';
      case FitnessBenchmarkScoreType.longestdistance:
        return 'Longest Distance';
      case FitnessBenchmarkScoreType.maxload:
        return 'Max Load';
      case FitnessBenchmarkScoreType.timedmaxreps:
        return 'Max Reps';
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return 'Unbroken Reps';
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        return 'Hold For Time';

      default:
        throw Exception(
            'This is not a valid FitnessBenchmarkScoreType enum: $this');
    }
  }

  String get typeHeading {
    switch (this) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
        return 'Time Taken';
      case FitnessBenchmarkScoreType.longestdistance:
        return 'Distance';
      case FitnessBenchmarkScoreType.maxload:
        return 'Load';
      case FitnessBenchmarkScoreType.timedmaxreps:
        return 'Reps Completed';
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return 'Unbroken Reps';
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        return 'Time Held';

      default:
        throw Exception(
            'This is not a valid FitnessBenchmarkScoreType enum: $this');
    }
  }

  String? get scoreUnit {
    switch (this) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        return null; // Will display as time string
      case FitnessBenchmarkScoreType.longestdistance:
        return 'Metres';
      case FitnessBenchmarkScoreType.maxload:
        return 'KGs';
      case FitnessBenchmarkScoreType.timedmaxreps:
        return 'Reps';
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return 'Reps';

      default:
        throw Exception(
            'This is not a valid FitnessBenchmarkScoreType enum: $this');
    }
  }
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

extension UserDayLogRatingExtension on UserDayLogRating {
  Color get color {
    switch (this) {
      case UserDayLogRating.good:
        return Styles.primaryAccent;
      case UserDayLogRating.average:
        return CupertinoColors.activeOrange;
      case UserDayLogRating.bad:
        return Styles.errorRed;
      default:
        throw Exception(
            'UserDayLogRatingExtension: No color defined for $this');
    }
  }
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
