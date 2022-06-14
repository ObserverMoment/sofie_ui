import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/layout/fab_page/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/layout/fab_page/floating_text_button.dart';
import 'package:sofie_ui/components/my_tab_bar_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubDetailsWorkouts extends StatelessWidget {
  final String clubId;
  final bool isOwnerOrAdmin;
  const ClubDetailsWorkouts(
      {Key? key, required this.clubId, required this.isOwnerOrAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Workouts'),
      ),
      child: FABPage(
        rowButtons: [
          FloatingTextButton(
            text: 'Add Workout',
            onTap: () => print('open select type modal'),
            icon: CupertinoIcons.add,
          )
        ],
        child: MyText(
          'Same functionality as ClubResistanceWorkouts - but will retrieve all workouts of all types - allow passing filter by type',
          maxLines: 8,
        ),
      ),
    );
  }
}


//// DEPRECATED /////
// class ClubDetailsWorkouts extends StatefulWidget {
//   final String clubId;
//   final bool isOwnerOrAdmin;
//   const ClubDetailsWorkouts(
//       {Key? key, required this.isOwnerOrAdmin, required this.clubId})
//       : super(key: key);

//   @override
//   State<ClubDetailsWorkouts> createState() => _ClubDetailsWorkoutsState();
// }

// class _ClubDetailsWorkoutsState extends State<ClubDetailsWorkouts> {
//   bool _loading = false;

//   void _handleWorkoutTap(WorkoutSummary workout) {
//     if (widget.isOwnerOrAdmin) {
//       openBottomSheetMenu(
//           context: context,
//           child: BottomSheetMenu(
//               header: BottomSheetMenuHeader(
//                   name: workout.name,
//                   subtitle: 'Workout',
//                   imageUri: workout.coverImageUri),
//               items: [
//                 BottomSheetMenuItem(
//                     text: 'View',
//                     icon: CupertinoIcons.arrow_right,
//                     onPressed: () => _navigateToWorkoutDetails(workout)),
//                 BottomSheetMenuItem(
//                     text: 'Remove',
//                     isDestructive: true,
//                     icon: CupertinoIcons.delete_simple,
//                     onPressed: () =>
//                         _confirmRemoveWorkoutFromClub(context, workout)),
//               ]));
//     } else {
//       _navigateToWorkoutDetails(workout);
//     }
//   }

//   void _navigateToWorkoutDetails(WorkoutSummary workout) {
//     // context.navigateTo(WorkoutDetailsRoute(id: workout.id));
//   }

//   void _openWorkoutFinder() {
//     // context.navigateTo(WorkoutsRoute(
//     //     pageTitle: 'Select Workout',
//     //     showSaved: false,
//     //     selectWorkout: (w) => _addWorkoutToClub(context, w)));
//   }

//   Future<void> _addWorkoutToClub(
//       BuildContext context, WorkoutSummary workout) async {
//     setState(() {
//       _loading = true;
//     });

//     final variables =
//         AddWorkoutToClubArguments(clubId: widget.clubId, workoutId: workout.id);

//     final result = await GraphQLStore.store
//         .mutate<AddWorkoutToClub$Mutation, AddWorkoutToClubArguments>(
//             mutation: AddWorkoutToClubMutation(variables: variables),
//             refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
//             broadcastQueryIds: [GQLVarParamKeys.clubWorkouts(widget.clubId)]);

//     setState(() {
//       _loading = false;
//     });

//     checkOperationResult(result,
//         onSuccess: () => context.showToast(message: 'Workout Added'),
//         onFail: () => context.showToast(
//             message: 'Sorry there was a problem',
//             toastType: ToastType.destructive));
//   }

//   void _confirmRemoveWorkoutFromClub(
//       BuildContext context, WorkoutSummary workout) {
//     context.showConfirmDeleteDialog(
//         verb: 'Remove',
//         itemType: 'Workout',
//         itemName: workout.name,
//         message:
//             'Club members will no longer have access to this workout via your club',
//         onConfirm: () => _removeWorkoutFromClub(context, workout));
//   }

//   Future<void> _removeWorkoutFromClub(
//       BuildContext context, WorkoutSummary workout) async {
//     setState(() {
//       _loading = true;
//     });

//     final variables = RemoveWorkoutFromClubArguments(
//         clubId: widget.clubId, workoutId: workout.id);

//     final result = await GraphQLStore.store
//         .mutate<RemoveWorkoutFromClub$Mutation, RemoveWorkoutFromClubArguments>(
//             mutation: RemoveWorkoutFromClubMutation(variables: variables),
//             refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
//             broadcastQueryIds: [GQLVarParamKeys.clubWorkouts(widget.clubId)]);

//     setState(() {
//       _loading = false;
//     });

//     checkOperationResult(result,
//         onSuccess: () => context.showToast(message: 'Workout Removed'),
//         onFail: () => context.showToast(
//             message: 'Sorry there was a problem',
//             toastType: ToastType.destructive));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final query = ClubWorkoutsQuery(
//         variables: ClubWorkoutsArguments(clubId: widget.clubId));

//     return QueryObserver<ClubWorkouts$Query, ClubWorkoutsArguments>(
//         key: Key('ClubDetailsWorkouts - ${query.operationName}'),
//         query: query,
//         parameterizeQuery: true,
//         builder: (data) {
//           final workouts = data.clubWorkouts.workouts;

//           return MyPageScaffold(
//               child: NestedScrollView(
//             headerSliverBuilder: (c, i) =>
//                 [const MySliverNavbar(title: 'Workouts')],
//             body: widget.isOwnerOrAdmin
//                 ? FABPage(
//                     rowButtonsAlignment: MainAxisAlignment.end,
//                     rowButtons: [
//                       FloatingTextButton(
//                         text: 'Add Workout',
//                         onTap: _openWorkoutFinder,
//                         loading: _loading,
//                         icon: CupertinoIcons.add,
//                       )
//                     ],
//                     child: _ClubWorkoutsList(
//                       handleWorkoutTap: _handleWorkoutTap,
//                       workouts: workouts,
//                     ))
//                 : _ClubWorkoutsList(
//                     handleWorkoutTap: _handleWorkoutTap,
//                     workouts: workouts,
//                   ),
//           ));
//         });
//   }
// }

// class _ClubWorkoutsList extends StatelessWidget {
//   final List<WorkoutSummary> workouts;
//   final void Function(WorkoutSummary workout) handleWorkoutTap;
//   const _ClubWorkoutsList(
//       {Key? key, required this.workouts, required this.handleWorkoutTap})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return workouts.isEmpty
//         ? const ContentEmptyPlaceholder(message: 'No Workouts', actions: [])
//         : ImplicitlyAnimatedList<WorkoutSummary>(
//             padding: const EdgeInsets.only(
//                 top: 8, bottom: kAssumedFloatingButtonHeight),
//             shrinkWrap: true,
//             items: workouts,
//             itemBuilder: (context, animation, workout, index) =>
//                 SizeFadeTransition(
//                   animation: animation,
//                   sizeFraction: 0.7,
//                   curve: Curves.easeInOut,
//                   child: GestureDetector(
//                       onTap: () => handleWorkoutTap(workout),
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 12.0),
//                         child: WorkoutCard(workout),
//                       )),
//                 ),
//             areItemsTheSame: (a, b) => a == b);
//   }
// }
