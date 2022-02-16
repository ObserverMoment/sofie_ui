import 'package:hive_flutter/hive_flutter.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/services/data_utils.dart';

/// Retrieves data from Hive settings box if exists.
/// Or inits defaults.
class UserWorkoutSettingsBloc {
  late UserWorkoutSettings _workoutSettings;

  UserWorkoutSettingsBloc() {
    // Open Hive box and check if there are workout settings saved.
    // Initialise them from Hive box.
    final workoutSettingsFromDevice =
        Hive.box(kSettingsHiveBoxName).get(kSettingsHiveBoxWorkoutSettingsKey);

    /// Convert from [_InternalLinkedHashMap<dynamic, dynamic>] to [Map<String, dynamic>]
    final json = workoutSettingsFromDevice == null
        ? null
        : DataUtils.convertToJsonMap(workoutSettingsFromDevice as Map);

    _workoutSettings = json != null
        ? UserWorkoutSettings.fromJson(json)
        : UserWorkoutSettings();
  }

  UserWorkoutSettings get settings => _workoutSettings;

  void updateSettings(Map<String, dynamic> data) {
    _updateAndSaveSettings(
        UserWorkoutSettings.fromJson({..._workoutSettings.json, ...data}));
  }

  Future<void> _updateAndSaveSettings(
      UserWorkoutSettings workoutSettings) async {
    await Hive.box(kSettingsHiveBoxName)
        .put(kSettingsHiveBoxWorkoutSettingsKey, workoutSettings.json);
    _workoutSettings = workoutSettings;
  }
}

class UserWorkoutSettings {
  bool activeWakelockSetting = true;
  int countdownToStartSeconds = 3;
  // For Lifting and Custom Sessions only.
  // Will display each time a user marks a move as completed.
  bool enableAutoRestTimer = false;
  int autoRestTimerSeconds = 60;

  UserWorkoutSettings();

  UserWorkoutSettings.fromJson(Map<String, dynamic> json)
      : activeWakelockSetting = json['activeWakelockSetting'] != null
            ? (json['activeWakelockSetting'] as bool)
            : true,
        countdownToStartSeconds = json['countdownToStartSeconds'] != null
            ? (json['countdownToStartSeconds'] as int)
            : 3,
        autoRestTimerSeconds = json['autoRestTimerSeconds'] != null
            ? (json['autoRestTimerSeconds'] as int)
            : 60,
        enableAutoRestTimer = json['enableAutoRestTimer'] != null
            ? (json['enableAutoRestTimer'] as bool)
            : false;

  Map<String, dynamic> get json => <String, dynamic>{
        'activeWakelockSetting': activeWakelockSetting,
        'countdownToStartSeconds': countdownToStartSeconds,
        'autoRestTimerSeconds': autoRestTimerSeconds,
        'enableAutoRestTimer': enableAutoRestTimer,
      };
}
