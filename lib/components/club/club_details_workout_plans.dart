import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
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

class ClubDetailsWorkoutPlans extends StatefulWidget {
  final Club club;
  final List<WorkoutPlanSummary> workoutPlans;
  final bool isOwnerOrAdmin;
  const ClubDetailsWorkoutPlans(
      {Key? key,
      required this.workoutPlans,
      required this.isOwnerOrAdmin,
      required this.club})
      : super(key: key);

  @override
  State<ClubDetailsWorkoutPlans> createState() =>
      _ClubDetailsWorkoutPlansState();
}

class _ClubDetailsWorkoutPlansState extends State<ClubDetailsWorkoutPlans> {
  bool _loading = false;

  void _handleWorkoutPlanTap(WorkoutPlanSummary workoutPlan) {
    if (widget.isOwnerOrAdmin) {
      openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                  name: workoutPlan.name,
                  subtitle: 'Workout Plan',
                  imageUri: workoutPlan.coverImageUri),
              items: [
                BottomSheetMenuItem(
                    text: 'View',
                    icon: const Icon(CupertinoIcons.arrow_right),
                    onPressed: () =>
                        _navigateToWorkoutPlanDetails(workoutPlan)),
                BottomSheetMenuItem(
                    text: 'Remove',
                    isDestructive: true,
                    icon: const Icon(CupertinoIcons.delete_simple,
                        color: Styles.errorRed),
                    onPressed: () =>
                        _confirmRemoveWorkoutPlanFromClub(workoutPlan)),
              ]));
    } else {
      _navigateToWorkoutPlanDetails(workoutPlan);
    }
  }

  void _navigateToWorkoutPlanDetails(WorkoutPlanSummary workoutPlan) {
    context.navigateTo(WorkoutPlanDetailsRoute(id: workoutPlan.id));
  }

  void _openWorkoutPlanFinder() {
    context.navigateTo(YourPlansRoute(
        showCreateButton: true,
        showJoined: false,
        showSaved: false,
        pageTitle: 'Select Plan',
        selectPlan: (w) => _addWorkoutPlanToClub(w)));
  }

  Future<void> _addWorkoutPlanToClub(WorkoutPlanSummary workoutPlan) async {
    setState(() {
      _loading = true;
    });

    final variables = AddWorkoutPlanToClubArguments(
        clubId: widget.club.id, workoutPlanId: workoutPlan.id);

    final result = await context.graphQLStore
        .mutate<AddWorkoutPlanToClub$Mutation, AddWorkoutPlanToClubArguments>(
            mutation: AddWorkoutPlanToClubMutation(variables: variables),
            broadcastQueryIds: [GQLVarParamKeys.clubByIdQuery(widget.club.id)]);

    setState(() {
      _loading = false;
    });

    await checkOperationResult(context, result,
        onSuccess: () => context.showToast(message: 'Plan added.'),
        onFail: () => context.showToast(
            message: 'Sorry there was a problem.',
            toastType: ToastType.destructive));
  }

  void _confirmRemoveWorkoutPlanFromClub(WorkoutPlanSummary workoutPlan) {
    context.showConfirmDeleteDialog(
        verb: 'Remove',
        itemType: 'Plan',
        itemName: workoutPlan.name,
        message:
            'Club members will no longer have access to this plan via your club.',
        onConfirm: () => _removeWorkoutPlanFromClub(workoutPlan));
  }

  Future<void> _removeWorkoutPlanFromClub(
      WorkoutPlanSummary workoutPlan) async {
    setState(() {
      _loading = true;
    });

    final variables = RemoveWorkoutPlanFromClubArguments(
        clubId: widget.club.id, workoutPlanId: workoutPlan.id);

    final result = await context.graphQLStore.mutate<
            RemoveWorkoutPlanFromClub$Mutation,
            RemoveWorkoutPlanFromClubArguments>(
        mutation: RemoveWorkoutPlanFromClubMutation(variables: variables),
        broadcastQueryIds: [GQLVarParamKeys.clubByIdQuery(widget.club.id)]);

    setState(() {
      _loading = false;
    });

    await checkOperationResult(context, result,
        onSuccess: () => context.showToast(message: 'Plan removed.'),
        onFail: () => context.showToast(
            message: 'Sorry there was a problem.',
            toastType: ToastType.destructive));
  }

  Widget get _placeholder => const SizedBox(
        height: 100,
        child: Center(
          child: MyText(
            'No workoutPlans',
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
        widget.workoutPlans.isEmpty
            ? _placeholder
            : ImplicitlyAnimatedList<WorkoutPlanSummary>(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    top: 8, bottom: kAssumedFloatingButtonHeight),
                items: widget.workoutPlans,
                itemBuilder: (context, animation, workoutPlan, index) =>
                    SizeFadeTransition(
                      animation: animation,
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      child: GestureDetector(
                          onTap: () => _handleWorkoutPlanTap(workoutPlan),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: WorkoutPlanCard(workoutPlan),
                          )),
                    ),
                areItemsTheSame: (a, b) => a == b),
        if (widget.isOwnerOrAdmin)
          Positioned(
              bottom: 12,
              child: FloatingIconButton(
                text: 'Add Plan',
                onPressed: _openWorkoutPlanFinder,
                loading: _loading,
                iconData: CupertinoIcons.add,
              ))
      ],
    );
  }
}
