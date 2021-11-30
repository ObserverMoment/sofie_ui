import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Class which provides easy getters for the gql operation names in cases where there are variables being requires by the generated types.
/// Useful for managing store state - store mutations and QueryObserver updates.
/// Variables / args are ignored - just the operation name is returned.
class GQLOpNames {
  /// By Id. This will (NEEDS testing!) trigger all byId queries of this type. i.e. all of the [progressJournalById] queries or all of the [workoutByIdQueries].
  static String get progressJournalByIdQuery =>
      ProgressJournalByIdQuery(variables: ProgressJournalByIdArguments(id: ''))
          .operationName;

  /// TODO: Does this key trigger all workoutById queries?
  static String get workoutByIdQuery =>
      WorkoutByIdQuery(variables: WorkoutByIdArguments(id: '')).operationName;

  /// TODO: Does this key trigger all userBenchmarkByIdQuery queries?
  static String get userBenchmarkByIdQuery =>
      UserBenchmarkByIdQuery(variables: UserBenchmarkByIdArguments(id: ''))
          .operationName;

  /// List type queries where variables are not used.
  static String get bodyTrackingEntries =>
      BodyTrackingEntriesQuery().operationName;

  static String get userProgressJournalsQuery =>
      UserProgressJournalsQuery().operationName;

  static String get workoutPlanEnrolmentsQuery =>
      WorkoutPlanEnrolmentsQuery().operationName;

  /// List type queries where variables are not used.
  /// Note: In the API UserBenchmarksQuery can take vars - they are optional and not currently being used.
  static String get userBenchmarksQuery => UserBenchmarksQuery().operationName;

  static String get userClubsQuery => UserClubsQuery().operationName;
  static String get userCollectionsQuery =>
      UserCollectionsQuery().operationName;

  static String get userCustomMovesQuery =>
      UserCustomMovesQuery().operationName;

  static String get userWorkoutsQuery => UserWorkoutsQuery().operationName;

  static String get userWorkoutPlansQuery =>
      UserWorkoutPlansQuery().operationName;

  static String get userScheduledWorkoutsQuery =>
      UserScheduledWorkoutsQuery().operationName;

  //// Archive Related ////
  static String get userArchivedWorkoutsQuery =>
      UserArchivedWorkoutsQuery().operationName;

  static String get userArchivedWorkoutPlansQuery =>
      UserArchivedWorkoutPlansQuery().operationName;

  static String get userArchivedCustomMovesQuery =>
      UserArchivedCustomMovesQuery().operationName;
}

/// Observable queries whose operations can accept variables, but whose keys are being stored with the variables nulled.
/// /// For example [workoutById({"id": null})]
class GQLNullVarsKeys {
  static String get userLoggedWorkoutsQuery => getNulledVarsQueryId(
      UserLoggedWorkoutsQuery(variables: UserLoggedWorkoutsArguments()));
}

/// Observable queries whose operations accept variables and whose keys are being generated based on the variables being passed.
/// /// For example [workoutById({"id": 1234})]
class GQLVarParamKeys {
  static String clubByIdQuery(String id) => getParameterizedQueryId(
      ClubByIdQuery(variables: ClubByIdArguments(id: id)));

  static String progressJournalByIdQuery(String id) =>
      getParameterizedQueryId(ProgressJournalByIdQuery(
          variables: ProgressJournalByIdArguments(id: id)));

  static String userBenchmarkByIdQuery(String id) => getParameterizedQueryId(
      UserBenchmarkByIdQuery(variables: UserBenchmarkByIdArguments(id: id)));

  static String userCollectionByIdQuery(String id) => getParameterizedQueryId(
      UserCollectionByIdQuery(variables: UserCollectionByIdArguments(id: id)));

  static String workoutByIdQuery(String id) => getParameterizedQueryId(
      WorkoutByIdQuery(variables: WorkoutByIdArguments(id: id)));

  static String workoutPlanByIdQuery(String id) => getParameterizedQueryId(
      WorkoutPlanByIdQuery(variables: WorkoutPlanByIdArguments(id: id)));

  static String workoutPlanEnrolmentByIdQuery(String id) =>
      getParameterizedQueryId(WorkoutPlanEnrolmentByIdQuery(
          variables: WorkoutPlanEnrolmentByIdArguments(id: id)));
}
