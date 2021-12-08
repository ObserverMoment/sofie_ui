import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ClubDetailsWorkouts extends StatefulWidget {
  final Club club;
  final List<WorkoutSummary> workouts;
  final bool isOwnerOrAdmin;
  const ClubDetailsWorkouts(
      {Key? key,
      required this.workouts,
      required this.isOwnerOrAdmin,
      required this.club})
      : super(key: key);

  @override
  State<ClubDetailsWorkouts> createState() => _ClubDetailsWorkoutsState();
}

class _ClubDetailsWorkoutsState extends State<ClubDetailsWorkouts> {
  bool _loading = false;

  void _handleWorkoutTap(WorkoutSummary workout) {
    if (widget.isOwnerOrAdmin) {
      openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                  name: workout.name,
                  subtitle: 'Workout',
                  imageUri: workout.coverImageUri),
              items: [
                BottomSheetMenuItem(
                    text: 'View',
                    icon: const Icon(CupertinoIcons.arrow_right),
                    onPressed: () => _navigateToWorkoutDetails(workout)),
                BottomSheetMenuItem(
                    text: 'Remove',
                    isDestructive: true,
                    icon: const Icon(CupertinoIcons.delete_simple,
                        color: Styles.errorRed),
                    onPressed: () =>
                        _confirmRemoveWorkoutFromClub(context, workout)),
              ]));
    } else {
      _navigateToWorkoutDetails(workout);
    }
  }

  void _navigateToWorkoutDetails(WorkoutSummary workout) {
    context.navigateTo(WorkoutDetailsRoute(id: workout.id));
  }

  void _openWorkoutFinder() {
    context.navigateTo(YourWorkoutsRoute(
        pageTitle: 'Select Workout',
        showSaved: false,
        showCreateButton: true,
        selectWorkout: (w) => _addWorkoutToClub(context, w)));
  }

  Future<void> _addWorkoutToClub(
      BuildContext context, WorkoutSummary workout) async {
    setState(() {
      _loading = true;
    });

    final variables = AddWorkoutToClubArguments(
        clubId: widget.club.id, workoutId: workout.id);

    final result = await context.graphQLStore
        .mutate<AddWorkoutToClub$Mutation, AddWorkoutToClubArguments>(
            mutation: AddWorkoutToClubMutation(variables: variables),
            broadcastQueryIds: [GQLVarParamKeys.clubByIdQuery(widget.club.id)]);

    setState(() {
      _loading = false;
    });

    checkOperationResult(context, result,
        onSuccess: () => context.showToast(message: 'Workout added.'),
        onFail: () => context.showToast(
            message: 'Sorry there was a problem.',
            toastType: ToastType.destructive));
  }

  void _confirmRemoveWorkoutFromClub(
      BuildContext context, WorkoutSummary workout) {
    context.showConfirmDeleteDialog(
        verb: 'Remove',
        itemType: 'Workout',
        itemName: workout.name,
        message:
            'Club members will no longer have access to this workout via your club.',
        onConfirm: () => _removeWorkoutFromClub(context, workout));
  }

  Future<void> _removeWorkoutFromClub(
      BuildContext context, WorkoutSummary workout) async {
    setState(() {
      _loading = true;
    });

    final variables = RemoveWorkoutFromClubArguments(
        clubId: widget.club.id, workoutId: workout.id);

    final result = await context.graphQLStore
        .mutate<RemoveWorkoutFromClub$Mutation, RemoveWorkoutFromClubArguments>(
            mutation: RemoveWorkoutFromClubMutation(variables: variables),
            broadcastQueryIds: [GQLVarParamKeys.clubByIdQuery(widget.club.id)]);

    setState(() {
      _loading = false;
    });

    checkOperationResult(context, result,
        onSuccess: () => context.showToast(message: 'Workout removed.'),
        onFail: () => context.showToast(
            message: 'Sorry there was a problem.',
            toastType: ToastType.destructive));
  }

  Widget get _placeholder => const SizedBox(
        height: 100,
        child: Center(
          child: MyText(
            'No workouts',
            subtext: true,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: [
        widget.workouts.isEmpty
            ? _placeholder
            : ImplicitlyAnimatedList<WorkoutSummary>(
                padding: const EdgeInsets.only(
                    top: 8, bottom: kAssumedFloatingButtonHeight),
                shrinkWrap: true,
                items: widget.workouts,
                itemBuilder: (context, animation, workout, index) =>
                    SizeFadeTransition(
                      animation: animation,
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      child: GestureDetector(
                          onTap: () => _handleWorkoutTap(workout),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: WorkoutCard(workout),
                          )),
                    ),
                areItemsTheSame: (a, b) => a == b),
        if (widget.isOwnerOrAdmin)
          Positioned(
              bottom: 12,
              child: FloatingIconButton(
                text: 'Add Workout',
                onPressed: _openWorkoutFinder,
                loading: _loading,
                iconData: CupertinoIcons.add,
              ))
      ],
    );
  }
}
