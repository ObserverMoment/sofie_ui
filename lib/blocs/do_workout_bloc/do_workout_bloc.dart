import 'package:collection/collection.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/amrap_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/fortime_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/lifting_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/timed_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/components/media/audio/audio_player_controller.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/audio_session_manager.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class DoWorkoutBloc extends ChangeNotifier {
  /// Before any pre-start adjustments.
  final Workout originalWorkout;

  /// When present these will be passed on to log creation function.
  /// [scheduledWorkout] so that we can add the log to the scheduled workout to mark it as done.
  /// [workoutPlanDayWorkoutId] and [workoutPlanEnrolmentId] so that we can create a [CompletedWorkoutPlanDayWorkout] to mark it as done in the plan.
  final ScheduledWorkout? scheduledWorkout;
  final String? workoutPlanDayWorkoutId;
  final String? workoutPlanEnrolmentId;

  /// After any pre-start adjustments. Use this during.
  late Workout activeWorkout;

  /// Updated when user triggers playSection(int index).
  /// i.e. the section that they are doing.
  int? _activeSection;

  /// List of timers - one for each workoutSection.
  /// Sorted by sortPosition. Index [0] == sortPosition of [0] etc.
  late List<StopWatchTimer> _stopWatchTimers;

  /// [AudioPlayer]s for any sections which have [classAudioUri]. Null if no audio.
  /// One for each section. Sorted by sortPosition. Index [0] == sortPosition of [0] etc.
  List<AudioPlayer?> _audioPlayers = [];

  /// [VideoPlayerController]s for any sections which have [classVideoUri]. Null if no video.
  /// One for each section. Sorted by sortPosition. Index [0] == sortPosition of [0] etc.
  List<VideoPlayerController?> _videoControllers = [];

  /// List of _controllers - one for each workoutSection.
  /// Sorted by sortPosition. Index [0] == sortPosition of [0] etc.
  /// Each section type has a sub controller that extends [WorkoutSectionController]
  /// Need to ensure that one only at a time is playing.
  late List<WorkoutSectionController> _controllers;

  /// Init flags.
  bool audioInitSuccess = false;
  bool videoInitSuccess = false;

  /// User settings ////
  /// Wakelock settings.
  /// Revert to this once the workout session is finished.
  bool? _initialWakelockSetting;
  bool activeWakelockSetting = true;

  int countdownToStartSeconds = 3;

  AudioSession? _session;

  /// Sound effects.
  AudioPlayer beepOnePlayer = AudioPlayer();
  AudioPlayer beepTwoPlayer = AudioPlayer();
  AudioPlayer toneCompletePlayer = AudioPlayer();

  String get _beepOneAsset => 'assets/audio/do_workout/chime_bell_note.mp3';
  String get _beepTwoAsset => 'assets/audio/do_workout/chime_chirp.mp3';
  String get _toneCompleteAsset =>
      'assets/audio/do_workout/chime_clickbell_octave_lo.mp3';

  DoWorkoutBloc(
      {required this.originalWorkout,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId}) {
    activeWorkout = originalWorkout.copyAndSortAllChildren;

    final workoutSections = activeWorkout.workoutSections;

    /// One per section.
    _stopWatchTimers = workoutSections.map((_) => StopWatchTimer()).toList();

    /// One per section.
    _controllers = workoutSections
        .map((wSection) => _mapSectionTypeToControllerType(wSection))
        .toList();

    _initVideoControllers().then((_) => _initAudioPlayers()
        .then((_) => _setupAudioSession().then((_) => _initWakelock())));
  }

  /// Constructor async helper ///
  Future<void> _initVideoControllers() async {
    _videoControllers =
        await Future.wait(activeWorkout.workoutSections.map((section) async {
      if (Utils.textNotNull(section.classVideoUri)) {
        try {
          final controller = await VideoSetupManager.initializeVideoPlayer(
              uri: section.classVideoUri!, autoLoop: true, mixWithOthers: true);

          return controller;
        } catch (e) {
          printLog(e.toString());
          throw Exception('Unable to get data for this video.');
        }
      } else {
        return null;
      }
    }).toList());

    videoInitSuccess = true;
    notifyListeners();
  }

  /// Constructor async helper ///
  Future<void> _initAudioPlayers() async {
    /// Init any classAudio players required.
    _audioPlayers =
        await Future.wait(activeWorkout.workoutSections.map((section) async {
      if (Utils.textNotNull(section.classAudioUri)) {
        final player = await AudioPlayerController.init(
            audioUrl: UploadcareService.getFileUrl(section.classAudioUri!)!,
            player: AudioPlayer());

        return player;
      } else {
        return null;
      }
    }).toList());

    /// Init FX players.
    await beepOnePlayer.setAsset(_beepOneAsset);
    await beepTwoPlayer.setAsset(_beepTwoAsset);
    await toneCompletePlayer.setAsset(_toneCompleteAsset);
    notifyListeners();
  }

  Future<void> _setupAudioSession() async {
    /// TODO: need to handle the section audio with different settings.
    /// Section.classAudio should pause other sources.
    /// And internal FX should duck Section.classAudio.
    _session = await AudioSessionManager.setupAudioSession();

    audioInitSuccess = true;
    notifyListeners();
  }

  /// Constructor async helper ///
  Future<void> _initWakelock() async {
    // Save the original setting so we can revert to it on dispose.
    _initialWakelockSetting = await Wakelock.enabled;

    // set wakelock to true, which is the default.
    await Wakelock.enable();

    notifyListeners();
  }

  //// Generate _controllers for all sections in the workout using this mapping ////
  WorkoutSectionController _mapSectionTypeToControllerType(
      WorkoutSection workoutSection) {
    final typeName = workoutSection.workoutSectionType.name;
    switch (typeName) {
      case kEMOMName:
      case kHIITCircuitName:
      case kTabataName:
        return TimedSectionController(
            workoutSection: workoutSection,
            playBeepOne: playBeepOne,
            playBeepTwo: playBeepTwo,
            stopWatchTimer: _stopWatchTimers[workoutSection.sortPosition],
            onCompleteSection: () =>
                _onSectionComplete(workoutSection.sortPosition));
      case kAMRAPName:
        return AMRAPSectionController(
          workoutSection: workoutSection,
          stopWatchTimer: _stopWatchTimers[workoutSection.sortPosition],
          playBeepOne: playBeepOne,
          onCompleteSection: () =>
              _onSectionComplete(workoutSection.sortPosition),
        );
      case kForTimeName:
        return ForTimeSectionController(
          workoutSection: workoutSection,
          stopWatchTimer: _stopWatchTimers[workoutSection.sortPosition],
          onCompleteSection: () =>
              _onSectionComplete(workoutSection.sortPosition),
        );
      case kCustomSessionName:
      case kLiftingName:
        return LiftingSectionController(
          workoutSection: workoutSection,
          stopWatchTimer: _stopWatchTimers[workoutSection.sortPosition],
          onCompleteSection: () =>
              _onSectionComplete(workoutSection.sortPosition),
        );
      default:
        throw Exception(
            'No mapping exists for workout section type $typeName.');
    }
  }

  void _onSectionComplete(int index) {
    pauseSection(index);
    playToneComplete();
    notifyListeners();
  }

  AudioPlayer? getAudioPlayerForSection(int index) =>
      index > _audioPlayers.length - 1 ? null : _audioPlayers[index];

  VideoPlayerController? getVideoControllerForSection(int index) =>
      index > _videoControllers.length - 1 ? null : _videoControllers[index];

  StopWatchTimer getStopWatchTimerForSection(int index) =>
      _stopWatchTimers[index];

  WorkoutSectionController getControllerForSection(int index) =>
      _controllers[index];

  Stream<WorkoutSectionProgressState> getProgressStreamForSection(int index) =>
      _controllers[index].progressStream;

  WorkoutSectionProgressState getProgressStateForSection(int index) =>
      _controllers[index].state;

  bool get allSectionsComplete => _controllers.every((c) => c.sectionComplete);

  /// Used to get the 'Now" and Next" set displays.
  /// For now set use offset of 0.
  /// For next set use offset of 1.
  List<WorkoutSet?> getNowAndNextSetsForSection(int sectionIndex, int qty) {
    final controller = getControllerForSection(sectionIndex);
    return controller.getNowAndNextSets(qty);
  }

  //// User Inputs Start ////
  Future<void> toggleWakelock(bool enable) async {
    await Wakelock.toggle(enable: enable);
    activeWakelockSetting = enable;
    notifyListeners();
  }

  Future<void> adjustCountdownToStartSeconds(int seconds) async {
    countdownToStartSeconds = seconds;
    notifyListeners();
  }

  Future<void> playSection(int index) async {
    if (!getControllerForSection(index).sectionComplete) {
      _activeSection = index;
      getControllerForSection(index).sectionHasStarted = true;
      getStopWatchTimerForSection(index).onExecute.add(StopWatchExecute.start);
      await getVideoControllerForSection(index)?.play();
      getAudioPlayerForSection(index)?.play();
      notifyListeners();
    }
  }

  Future<void> pauseSection(int index) async {
    getStopWatchTimerForSection(index).onExecute.add(StopWatchExecute.stop);
    await getAudioPlayerForSection(index)?.pause();
    await getVideoControllerForSection(index)?.pause();
    notifyListeners();
  }

  Future<void> resetSection(int index) async {
    /// Whenever resetting / re-initializing make sure we are using the activeWorkout objects.
    /// This is the object that the user can modify so we need to ensure that controller data is kept in sync with this.
    getControllerForSection(index)
        .initialize(activeWorkout.workoutSections[index]);

    await getAudioPlayerForSection(index)?.stop();
    await getAudioPlayerForSection(index)?.seek(Duration.zero);

    await getVideoControllerForSection(index)?.pause();
    await getVideoControllerForSection(index)?.seekTo(Duration.zero);

    notifyListeners();
  }

  Future<void> resetWorkout() async {
    /// Whenever resetting / re-initializing make sure we are using the activeWorkout objects.
    /// This is the object that the user can modify so we need to ensure that controller data is kept in sync with this.
    _controllers
        .mapIndexed((i, c) => c.initialize(activeWorkout.workoutSections[i]));

    for (final p in _audioPlayers) {
      await p?.stop();
      await p?.seek(Duration.zero);
    }

    for (final v in _videoControllers) {
      await v?.pause();
      await v?.seekTo(Duration.zero);
    }
  }

  /// Used for workouts where the user is stepping through sets as they complete them.
  /// [AMRAP] / [ForTime]
  void markCurrentWorkoutSetAsComplete(int sectionIndex) {
    _controllers[sectionIndex].markCurrentWorkoutSetAsComplete();
  }

  ///// Sound FX Methods ////
  Future<void> playBeepOne() async {
    await beepOnePlayer.seek(Duration.zero);
    beepOnePlayer.play();
  }

  /// New round starts
  Future<void> playBeepTwo() async {
    await beepTwoPlayer.seek(Duration.zero);
    await beepTwoPlayer.play();

    deactivateAudioSession();
  }

  /// Section completed.
  Future<void> playToneComplete() async {
    await toneCompletePlayer.seek(Duration.zero);
    await toneCompletePlayer.play();

    deactivateAudioSession();
  }

  /// Clear FX audio_players and stop ducking audio sources from other apps.
  /// It is useful is user is playing music in the background via other app.
  Future<void> deactivateAudioSession() async {
    /// This should only happen if no classAudio / videoAudio is active for the currently active section. We assume that the user does not want to prioritize background audio when in app audio is present. However, they should be able to set this.
    /// TODO: Testing of the different combinations of media playing / muted etc here is required.
    bool activeClassVideo = _activeSection != null &&
        getVideoControllerForSection(_activeSection!) != null &&
        getVideoControllerForSection(_activeSection!)!.value.volume != 0;

    bool activeClassAudio = _activeSection != null &&
        getAudioPlayerForSection(_activeSection!) != null &&
        getAudioPlayerForSection(_activeSection!)!.volume != 0;

    if (!activeClassVideo && !activeClassAudio) {
      await beepOnePlayer.stop();
      await beepTwoPlayer.stop();
      await toneCompletePlayer.stop();

      Future.delayed(const Duration(seconds: 1), () {
        _session!.setActive(false);
      });
    }
  }

  //////////////////////////////////////////////////////////////////
  /// Modify WorkoutSection, WorkoutSet and WorkoutMove methods ////
  /// Modify sets and moves before starting the workout ////////////
  /// or (if Free Session) during the workout //////////////////////
  //////////////////////////////////////////////////////////////////

  /// TODO: Quite heavy handed to reset / re-init the controller after each change the user makes. Revisit this for a better solution.

  /// IMPORTANT: [updateWorkoutSectionRounds] will re-initialize section controller progress.
  /// No check for [isCustomSession] as FreeSession should never have rounds.
  Future<void> updateWorkoutSectionRounds(int sectionIndex, int rounds) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    section.rounds = rounds;
    activeWorkout.workoutSections[sectionIndex] = section;

    /// Re-init the controller.
    await resetSection(sectionIndex);

    notifyListeners();
  }

  /// For AMRAPs.
  /// IMPORTANT: [updateWorkoutSectionTimecap] will re-initialize section controller progress.
  /// No check for [isCustomSession] as FreeSession should never have rounds.
  Future<void> updateWorkoutSectionTimecap(
      int sectionIndex, int seconds) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    section.timecap = seconds;
    activeWorkout.workoutSections[sectionIndex] = section;

    /// Re-init the controller.
    await resetSection(sectionIndex);

    notifyListeners();
  }

  /// Allows the user to add a single move set (i.e) not a SuperSet to the end of the section.
  /// Primarily for use in a Free Session so the user can extend their workout / add extra moves easily whilst they are in progress. But also available via the [DoWorkoutSectionModifications] screen.
  /// Always making a copy of the section as this is what the provider.select listener is checking.
  /// IMPORTANT: [addWorkoutMoveToSection] and [addWorkoutSetToSection] will re-initialize section controller progress unless it is a FreeSession or a Lifting Session.
  Future<void> addWorkoutSetToSection(
      int sectionIndex, WorkoutSet workoutSet) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    section.workoutSets.add(workoutSet);

    activeWorkout.workoutSections[sectionIndex] = section;

    if (!section.isCustomSession && !section.isLifting) {
      /// Re-init the controller.
      await resetSection(sectionIndex);
    }

    notifyListeners();
  }

  Future<void> addWorkoutMoveToSection(
      int sectionIndex, WorkoutMove workoutMove) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    final newWorkoutSet = WorkoutSet()
      ..id = const Uuid().v1()
      ..sortPosition = section.workoutSets.length
      ..duration = 60
      ..workoutMoves = [workoutMove];

    section.workoutSets.add(newWorkoutSet);

    activeWorkout.workoutSections[sectionIndex] = section;

    if (!section.isCustomSession && !section.isLifting) {
      /// Re-init the controller.
      await resetSection(sectionIndex);
    }

    notifyListeners();
  }

  /// IMPORTANT: [removeWorkoutSetFromSection] will re-initialize section controller progress.
  Future<void> removeWorkoutSetFromSection(
      int sectionIndex, int setIndex) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    section.workoutSets.removeAt(setIndex);

    section.workoutSets.forEachIndexed((i, wSet) {
      wSet.sortPosition = i;
    });

    activeWorkout.workoutSections[sectionIndex] = section;

    /// Re-init the controller.
    await resetSection(sectionIndex);

    notifyListeners();
  }

  /// IMPORTANT: [updateWorkoutSetDuration] will re-initialize section controller progress unless it is a FreeSession.
  /// No check for [isCustomSession] as FreeSession should never have sets with duration (for timed types only).
  Future<void> updateWorkoutSetDuration(
      int sectionIndex, int setIndex, int seconds) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    section.workoutSets[setIndex].duration = seconds;

    activeWorkout.workoutSections[sectionIndex] = section;

    /// Re-init the controller.
    await resetSection(sectionIndex);

    notifyListeners();
  }

  /// IMPORTANT: [updateWorkoutMove] will re-initialize section controller unless it is a Custom or Lifting section.
  Future<void> updateWorkoutMove(
      int sectionIndex, int setIndex, WorkoutMove workoutMove) async {
    final section = WorkoutSection.fromJson(
        activeWorkout.workoutSections[sectionIndex].toJson());

    section.workoutSets[setIndex].workoutMoves = section
        .workoutSets[setIndex].workoutMoves
        .map((wm) => wm.id == workoutMove.id ? workoutMove : wm)
        .toList();

    activeWorkout.workoutSections[sectionIndex] = section;

    if (!section.isCustomSession && !section.isLifting) {
      /// Re-init the controller.
      await resetSection(sectionIndex);
    }

    notifyListeners();
  }

  /// Modify Section, Set and Move methods END////
  ////////////////////////////////////////////////

  CreateLoggedWorkoutInput generateLogInputData() {
    CreateLoggedWorkoutInput loggedWorkoutInput = CreateLoggedWorkoutInput(
      completedOn: DateTime.now(),
      scheduledWorkout: scheduledWorkout != null
          ? ConnectRelationInput(id: scheduledWorkout!.id)
          : null,
      gymProfile: scheduledWorkout?.gymProfile != null
          ? ConnectRelationInput(id: scheduledWorkout!.gymProfile!.id)
          : null,
      name: activeWorkout.name,
      workout: ConnectRelationInput(id: activeWorkout.id),
      workoutPlanDayWorkout: workoutPlanDayWorkoutId != null
          ? ConnectRelationInput(id: workoutPlanDayWorkoutId!)
          : null,
      workoutPlanEnrolment: workoutPlanEnrolmentId != null
          ? ConnectRelationInput(id: workoutPlanEnrolmentId!)
          : null,
      workoutGoals: activeWorkout.workoutGoals
          .map((g) => ConnectRelationInput(id: g.id))
          .toList(),
      loggedWorkoutSections: generateLoggedSectionsInput(),
    );

    return loggedWorkoutInput;
  }

  List<CreateLoggedWorkoutSectionInLoggedWorkoutInput>
      generateLoggedSectionsInput() {
    return activeWorkout.workoutSections
        .sortedBy<num>((wSection) => wSection.sortPosition)
        .map((wSection) => getControllerForSection(wSection.sortPosition))
        .where((controller) => controller.sectionHasStarted)
        .mapIndexed((i, controller) {
      /// Use [i] to assign the new sort position within the log. This is needed because the user does not have to complete all the workout sections.

      final timeTakenSeconds = controller.stopWatchTimer.secondTime.value;

      if (controller.workoutSection.isLifting ||
          controller.workoutSection.isCustomSession) {
        /// For Lifting and Custom sessions the user can modify moves while they are working out. Modifying moves when working out does not reset the controller (as is teh case when the user is modifying moves on other workout types BEFORE they start) - so the [workoutSection] being referenced in the controller will not be getting updated. Only the [activeWorkout] is getting updated - so we must use that to generate the log section inputs.
        final activeWorkoutSection = activeWorkout.workoutSections.firstWhere(
            (wSection) =>
                wSection.sortPosition ==
                controller.workoutSection.sortPosition);

        /// Converts completed sets and reps lists to proper input objects and adds to [controller.state.loggedSection]
        (controller as LiftingSectionController)
            .updateLoggedSectionInput(activeWorkoutSection);
      }

      final loggedSectionInput = controller.state.loggedSection;
      loggedSectionInput.sortPosition = i;
      loggedSectionInput.repScore = calculateRepScore(controller);
      loggedSectionInput.timeTakenSeconds = timeTakenSeconds;

      return loggedSectionInput;
    }).toList();
  }

  int? calculateRepScore(WorkoutSectionController controller) {
    final workoutSection = controller.workoutSection;
    final loggedSectionInput = controller.state.loggedSection;

    int? repScore;

    if (workoutSection.isAMRAP) {
      repScore = (controller as AMRAPSectionController).repsCompleted;
    } else if (workoutSection.isForTime) {
      repScore = (controller as ForTimeSectionController).repsCompleted;
    } else if (workoutSection.isLifting) {
      repScore = DataUtils.totalRepsInLoggedSectionInput(loggedSectionInput);
    }

    return repScore;
  }

  /// User Inputs End ////
  ////////////////////////

  @override
  Future<void> dispose() async {
    super.dispose();
    await beepOnePlayer.dispose();
    await beepTwoPlayer.dispose();
    await toneCompletePlayer.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final v in _videoControllers) {
      v?.dispose();
    }
    for (final t in _stopWatchTimers) {
      await t.dispose();
    }
    for (final p in _audioPlayers) {
      await p?.dispose();
    }
    if (_initialWakelockSetting != null) {
      await Wakelock.toggle(enable: _initialWakelockSetting!);
    }
  }
}
