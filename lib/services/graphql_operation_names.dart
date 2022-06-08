import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Class which provides easy getters for the gql operation names in cases where there are variables being requires by the generated types.
/// Useful for managing store state - store mutations and QueryObserver updates.
/// Variables / args are ignored - just the operation name is returned.
class GQLOpNames {
  /// List type queries where variables are not used.
  static String get announcementUpdates =>
      AnnouncementUpdatesQuery().operationName;
  static String get welcomeTodoItems => WelcomeTodoItemsQuery().operationName;

  static String get bodyTrackingEntries =>
      BodyTrackingEntriesQuery().operationName;

  static String get userGoals => UserGoalsQuery().operationName;

  static String get userDayLogMoods => UserDayLogMoodsQuery().operationName;
  static String get userMeditationLogs =>
      UserMeditationLogsQuery().operationName;
  static String get userEatWellLogs => UserEatWellLogsQuery().operationName;
  static String get userSleepWellLogs => UserSleepWellLogsQuery().operationName;

  /// Exercise Score Trackers ////
  static String get userExerciseLoadTrackers =>
      UserExerciseLoadTrackersQuery().operationName;

  /// Benchmarks and Scores ////
  static String get userFitnessBenchmarks =>
      UserFitnessBenchmarksQuery().operationName;

  static String get workoutPlanEnrolments =>
      WorkoutPlanEnrolmentsQuery().operationName;

  static String get userClubs => UserClubsQuery().operationName;
  static String get userCollections => UserCollectionsQuery().operationName;

  static String get customMoves => CustomMovesQuery().operationName;

  static String get userLoggedWorkouts =>
      UserLoggedWorkoutsQuery().operationName;

  /// TODO: Does this key trigger all workoutById queries?
  static String get workoutById =>
      WorkoutByIdQuery(variables: WorkoutByIdArguments(id: '')).operationName;

  static String get userWorkouts => UserWorkoutsQuery().operationName;
  static String get userWorkoutTags => UserWorkoutTagsQuery().operationName;

  static String get userWorkoutPlans => UserWorkoutPlansQuery().operationName;

  static String get userScheduledWorkouts =>
      UserScheduledWorkoutsQuery().operationName;

  //// Workout Session Related ////
  static String get userResistanceSessions =>
      UserResistanceSessionsQuery().operationName;

  //// Archive Related ////
  static String get userArchivedWorkouts =>
      UserArchivedWorkoutsQuery().operationName;

  static String get userArchivedWorkoutPlans =>
      UserArchivedWorkoutPlansQuery().operationName;

  static String get userArchivedCustomMoves =>
      UserArchivedCustomMovesQuery().operationName;
}

/// Observable queries whose operations accept variables and whose keys are being generated based on the variables being passed.
/// /// For example [workoutById({"id": 1234})]
class GQLVarParamKeys {
  static String clubSummary(String id) => getParameterizedQueryId(
      ClubSummaryQuery(variables: ClubSummaryArguments(id: id)));

  static String clubInviteTokens(String id) => getParameterizedQueryId(
      ClubInviteTokensQuery(variables: ClubInviteTokensArguments(clubId: id)));

  static String clubMembers(String id) => getParameterizedQueryId(
      ClubMembersQuery(variables: ClubMembersArguments(clubId: id)));

  static String clubWorkouts(String id) => getParameterizedQueryId(
      ClubWorkoutsQuery(variables: ClubWorkoutsArguments(clubId: id)));

  static String clubWorkoutPlans(String id) => getParameterizedQueryId(
      ClubWorkoutPlansQuery(variables: ClubWorkoutPlansArguments(clubId: id)));

  static String userCollectionById(String id) => getParameterizedQueryId(
      UserCollectionByIdQuery(variables: UserCollectionByIdArguments(id: id)));

  static String userProfile(String id) => getParameterizedQueryId(
      UserProfileQuery(variables: UserProfileArguments(userId: id)));

  static String resistanceSessionById(String id) =>
      getParameterizedQueryId(ResistanceSessionByIdQuery(
          variables: ResistanceSessionByIdArguments(id: id)));

  static String workoutById(String id) => getParameterizedQueryId(
      WorkoutByIdQuery(variables: WorkoutByIdArguments(id: id)));

  static String workoutPlanById(String id) => getParameterizedQueryId(
      WorkoutPlanByIdQuery(variables: WorkoutPlanByIdArguments(id: id)));

  static String workoutPlanEnrolmentById(String id) =>
      getParameterizedQueryId(WorkoutPlanEnrolmentByIdQuery(
          variables: WorkoutPlanEnrolmentByIdArguments(id: id)));
}
