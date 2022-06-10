import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubDetailsWorkoutPlans extends StatefulWidget {
  final String clubId;
  final bool isOwnerOrAdmin;
  const ClubDetailsWorkoutPlans(
      {Key? key, required this.isOwnerOrAdmin, required this.clubId})
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
                    icon: CupertinoIcons.arrow_right,
                    onPressed: () =>
                        _navigateToWorkoutPlanDetails(workoutPlan)),
                BottomSheetMenuItem(
                    text: 'Remove',
                    isDestructive: true,
                    icon: CupertinoIcons.delete_simple,
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
    context.navigateTo(TrainingPlansRoute(
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
        clubId: widget.clubId, workoutPlanId: workoutPlan.id);

    final result = await GraphQLStore.store.mutate<
            AddWorkoutPlanToClub$Mutation, AddWorkoutPlanToClubArguments>(
        mutation: AddWorkoutPlanToClubMutation(variables: variables),
        refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
        broadcastQueryIds: [GQLVarParamKeys.clubWorkoutPlans(widget.clubId)]);

    setState(() {
      _loading = false;
    });

    checkOperationResult(result,
        onSuccess: () => context.showToast(message: 'Plan Added'),
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
        clubId: widget.clubId, workoutPlanId: workoutPlan.id);

    final result = await GraphQLStore.store.mutate<
            RemoveWorkoutPlanFromClub$Mutation,
            RemoveWorkoutPlanFromClubArguments>(
        mutation: RemoveWorkoutPlanFromClubMutation(variables: variables),
        refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
        broadcastQueryIds: [GQLVarParamKeys.clubWorkoutPlans(widget.clubId)]);

    setState(() {
      _loading = false;
    });

    checkOperationResult(result,
        onSuccess: () => context.showToast(message: 'Plan Removed'),
        onFail: () => context.showToast(
            message: 'Sorry there was a problem.',
            toastType: ToastType.destructive));
  }

  @override
  Widget build(BuildContext context) {
    final query = ClubWorkoutPlansQuery(
        variables: ClubWorkoutPlansArguments(clubId: widget.clubId));

    return QueryObserver<ClubWorkoutPlans$Query, ClubWorkoutPlansArguments>(
        key: Key('ClubDetailsWorkoutPlans - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final workoutPlans = data.clubWorkoutPlans.workoutPlans;

          return MyPageScaffold(
              child: NestedScrollView(
            headerSliverBuilder: (c, i) =>
                [const MySliverNavbar(title: 'Plans')],
            body: widget.isOwnerOrAdmin
                ? FABPage(
                    rowButtonsAlignment: MainAxisAlignment.end,
                    rowButtons: [
                      FloatingButton(
                        text: 'Add Plan',
                        onTap: _openWorkoutPlanFinder,
                        loading: _loading,
                        icon: CupertinoIcons.add,
                      )
                    ],
                    child: _ClubWorkoutPlansList(
                      handleWorkoutPlanTap: _handleWorkoutPlanTap,
                      workoutPlans: workoutPlans,
                    ))
                : _ClubWorkoutPlansList(
                    handleWorkoutPlanTap: _handleWorkoutPlanTap,
                    workoutPlans: workoutPlans,
                  ),
          ));
        });
  }
}

class _ClubWorkoutPlansList extends StatelessWidget {
  final List<WorkoutPlanSummary> workoutPlans;
  final void Function(WorkoutPlanSummary plan) handleWorkoutPlanTap;
  const _ClubWorkoutPlansList(
      {Key? key,
      required this.workoutPlans,
      required this.handleWorkoutPlanTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return workoutPlans.isEmpty
        ? const ContentEmptyPlaceholder(message: 'No Plans', actions: [])
        : ImplicitlyAnimatedList<WorkoutPlanSummary>(
            padding: const EdgeInsets.only(
                top: 8, bottom: kAssumedFloatingButtonHeight),
            shrinkWrap: true,
            items: workoutPlans,
            itemBuilder: (context, animation, workoutPlan, index) =>
                SizeFadeTransition(
                  animation: animation,
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  child: GestureDetector(
                      onTap: () => handleWorkoutPlanTap(workoutPlan),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: WorkoutPlanCard(workoutPlan),
                      )),
                ),
            areItemsTheSame: (a, b) => a == b);
  }
}
