// import 'package:flutter/cupertino.dart';
// import 'package:get_it/get_it.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/modules/workouts/creator/resistance/resistance_session_bloc.dart';
// import 'package:sofie_ui/services/graphql_operation_names.dart';
// import 'package:sofie_ui/services/store/graphql_store.dart';
// import 'package:sofie_ui/services/store/store_utils.dart';

// class WorkoutSessionBloc {
//   /// The main data that gets edited on the client by the user.
//   late String workoutSessionId;

//   final GraphQLStore _store = GetIt.I<GraphQLStore>();

//   WorkoutSessionBloc(WorkoutSession initial) {
//     workoutSessionId = initial.id;
//   }

//   void _writeToStore(Map<String, dynamic> data) {
//     _store.writeDataToStore(data: data, broadcastQueryIds: [
//       GQLVarParamKeys.workoutSessionById(workoutSessionId),
//       GQLOpNames.userWorkoutSessions,
//     ]);
//   }

//   void updateWorkoutSession(
//       {required WorkoutSession workoutSession,
//       required Map<String, dynamic> data}) async {
//     final updated =
//         WorkoutSession.fromJson({...workoutSession.toJson(), ...data});

//     final result = await _store.mutate(
//         optimisticData: updated.toJson(),
//         broadcastQueryIds: [
//           GQLVarParamKeys.workoutSessionById(workoutSessionId),
//           GQLOpNames.userWorkoutSessions,
//         ],
//         mutation: UpdateWorkoutSessionMutation(
//             variables: UpdateWorkoutSessionArguments(
//                 data: UpdateWorkoutSessionInput.fromJson(updated.toJson()))));

//     checkOperationResult(result, onFail: () {
//       /// Revert to backup and rebroadcast.
//       _writeToStore(workoutSession.toJson());
//     });
//   }

//   /////// Resistance Session ////////
//   Future<void> createResistanceSession(
//       {required WorkoutSession workoutSession,
//       required Function(ResistanceSession created) onSuccess,
//       required VoidCallback onFail}) async {
//     final created = await ResistanceSessionBloc.createResistanceSession(
//         workoutSessionId: workoutSessionId);

//     if (created != null) {
//       WorkoutSession updated = WorkoutSession.fromJson(workoutSession.toJson());
//       updated.childrenOrder.add(created.id);
//       updated.resistanceSessions.add(created);

//       _writeToStore(updated.toJson());
//       onSuccess(created);
//     } else {
//       onFail();
//     }
//   }

//   Future<void> duplicateResistanceSession(
//       {required WorkoutSession workoutSession,
//       required ResistanceSession resistanceSession,
//       required Function(ResistanceSession created) onSuccess,
//       required VoidCallback onFail}) async {
//     final duplicated = await ResistanceSessionBloc.duplicateResistanceSession(
//         resistanceSession: resistanceSession);

//     if (duplicated != null) {
//       WorkoutSession updated = WorkoutSession.fromJson(workoutSession.toJson());

//       /// Add new ID just after the duplicated session.
//       final i = updated.childrenOrder.indexOf(resistanceSession.id);
//       updated.childrenOrder.insert(i + 1, duplicated.id);

//       updated.resistanceSessions.add(duplicated);

//       _writeToStore(updated.toJson());
//     } else {
//       onFail();
//     }
//   }

//   Future<void> deleteResistanceSession(
//       {required WorkoutSession workoutSession,
//       required ResistanceSession resistanceSession,
//       required VoidCallback onFail}) async {
//     final deletedId = await ResistanceSessionBloc.deleteResistanceSession(
//         resistanceSession: resistanceSession);

//     if (deletedId == resistanceSession.id) {
//       WorkoutSession updated = WorkoutSession.fromJson(workoutSession.toJson());

//       updated.childrenOrder.remove(deletedId);
//       updated.resistanceSessions.removeWhere((s) => s.id == deletedId);

//       _writeToStore(updated.toJson());
//     } else {
//       onFail();
//     }
//   }
// }
