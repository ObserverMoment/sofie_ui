import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_goals.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_meta.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_participants.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_reviews.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_workout_schedule.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutPlanDetailsPage extends StatefulWidget {
  final String id;
  const WorkoutPlanDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _WorkoutPlanDetailsPageState createState() => _WorkoutPlanDetailsPageState();
}

class _WorkoutPlanDetailsPageState extends State<WorkoutPlanDetailsPage> {
  /// 0 = Schedule List. 1 = Goals HeatMap / Calendar. 2 = Participants. 3 = reviews.
  int _activeTabIndex = 0;

  void _handleTabChange(int index) {
    setState(() => _activeTabIndex = index);
  }

  /// I.e. enrol the user in the plan.
  Future<void> _createWorkoutPlanEnrolment() async {
    final variables =
        CreateWorkoutPlanEnrolmentArguments(workoutPlanId: widget.id);

    final result = await context.graphQLStore.mutate<
            CreateWorkoutPlanEnrolment$Mutation,
            CreateWorkoutPlanEnrolmentArguments>(
        mutation: CreateWorkoutPlanEnrolmentMutation(variables: variables),
        addRefToQueries: [WorkoutPlanEnrolmentsQuery().operationName]);

    await checkOperationResult(context, result,
        onSuccess: () =>
            context.showToast(message: 'Plan joined. Congratulations!'),
        onFail: () => context.showErrorAlert(
            'Something went wrong, there was an issue joining the plan'));
  }

  Future<void> _shareWorkoutPlan(WorkoutPlan workoutPlan) async {
    await SharingAndLinking.shareLink(
        'workout-plan/${workoutPlan.id}', 'Check out this workout plan!');
  }

  Future<void> _archiveWorkoutPlan(WorkoutPlan workoutPlan) async {
    await context.showConfirmDeleteDialog(
        verb: 'Archive',
        itemType: 'Plan',
        message:
            'It will be moved to your archive where it can be retrieved if needed.',
        onConfirm: () async {
          final result = await context.graphQLStore.mutate<
              ArchiveWorkoutPlanById$Mutation, ArchiveWorkoutPlanByIdArguments>(
            mutation: ArchiveWorkoutPlanByIdMutation(
              variables: ArchiveWorkoutPlanByIdArguments(id: workoutPlan.id),
            ),
            processResult: (data) {
              // Remove WorkoutPlanSummary from store.
              context.graphQLStore.deleteNormalizedObject(
                  resolveDataId(workoutPlan.summary.toJson())!);

              // Remove all refs to it from queries.
              context.graphQLStore.removeAllQueryRefsToId(
                  resolveDataId(workoutPlan.summary.toJson())!);

              // Rebroadcast all queries that may be affected.
              context.graphQLStore.broadcastQueriesByIds([
                GQLOpNames.userWorkoutPlansQuery,
                GQLOpNames.userCollectionsQuery,
                GQLOpNames.userClubsQuery,
              ]);

              // Update WorkoutPlan and workoutPlanById query
              context.graphQLStore.writeDataToStore(data: {
                ...workoutPlan.summary.toJson(),
                'archived': true
              }, broadcastQueryIds: [
                GQLVarParamKeys.workoutPlanByIdQuery(widget.id)
              ]);
            },
            addRefToQueries: [GQLOpNames.userArchivedWorkoutPlansQuery],
          );

          await checkOperationResult(context, result,
              onSuccess: () =>
                  context.showToast(message: 'Workout plan archived'),
              onFail: () => context.showErrorAlert(
                  'Something went wrong, the workout plan was not archived correctly'));
        });
  }

  Future<void> _unarchiveWorkoutPlan(WorkoutPlan workoutPlan) async {
    await context.showConfirmDialog(
        title: 'Unarchive this workout plan?',
        message: 'It will be moved back into your plans.',
        verb: 'Unarchive',
        onConfirm: () async {
          final result = await context.graphQLStore.mutate<
              UnarchiveWorkoutPlanById$Mutation,
              UnarchiveWorkoutPlanByIdArguments>(
            mutation: UnarchiveWorkoutPlanByIdMutation(
                variables:
                    UnarchiveWorkoutPlanByIdArguments(id: workoutPlan.id)),
            processResult: (data) {
              // This operation returns a full WorkoutPlan object.
              // Add a WorkoutPlanSummary to store and to userWorkoutPlansQuery
              context.graphQLStore.writeDataToStore(
                data: data.unarchiveWorkoutPlanById.summary.toJson(),
                addRefToQueries: [GQLOpNames.userWorkoutPlansQuery],
              );

              final archivedWorkoutPlan = {
                '__typename': kArchivedWorkoutPlanTypename,
                'id': workoutPlan.id
              };

              // Remove ArchivedWorkoutPlan from store and ref from userArchivedWorkoutPlansQuery.
              context.graphQLStore
                  .deleteNormalizedObject(resolveDataId(archivedWorkoutPlan)!);

              context.graphQLStore.removeRefFromQueryData(
                  data: archivedWorkoutPlan,
                  queryIds: [GQLOpNames.userArchivedWorkoutPlansQuery]);
            },
            broadcastQueryIds: [
              GQLVarParamKeys.workoutPlanByIdQuery(widget.id),
            ],
          );

          await checkOperationResult(context, result,
              onSuccess: () =>
                  context.showToast(message: 'Workout plan unarchived'),
              onFail: () => context.showErrorAlert(
                  'Something went wrong, the workout plan was not unarchived correctly'));
        });
  }

  Widget _buildContent({
    required WorkoutPlan workoutPlan,
    required List<Equipment> allEquipment,
    required List<Collection> collections,
    required bool hasEnrolled,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: MyTabBarNav(
                  titles: const [
                    'Info',
                    'Workouts',
                    'Goals',
                    'Reviews',
                    'People'
                  ],
                  handleTabChange: _handleTabChange,
                  activeTabIndex: _activeTabIndex),
            ),
            Expanded(
              child: IndexedStack(
                index: _activeTabIndex,
                children: [
                  WorkoutPlanMeta(
                    workoutPlan: workoutPlan,
                    allEquipment: allEquipment,
                    collections: collections,
                    hasEnrolled: hasEnrolled,
                  ),
                  WorkoutPlanWorkoutSchedule(workoutPlan: workoutPlan),
                  WorkoutPlanGoals(workoutPlan: workoutPlan),
                  WorkoutPlanReviews(reviews: workoutPlan.workoutPlanReviews),
                  WorkoutPlanParticipants(
                      userSummaries: workoutPlan.workoutPlanEnrolments
                          .map((e) => e.user)
                          .toList())
                ],
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final query = WorkoutPlanByIdQuery(
        variables: WorkoutPlanByIdArguments(id: widget.id));

    return QueryObserver<WorkoutPlanById$Query, WorkoutPlanByIdArguments>(
        key: Key('YourWorkoutPlansPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        loadingIndicator: const ShimmerDetailsPage(title: 'Getting Ready'),
        builder: (workoutPlanData) {
          return QueryObserver<UserCollections$Query, json.JsonSerializable>(
              key: Key(
                  'WorkoutPlanDetailsPage - ${UserCollectionsQuery().operationName}'),
              query: UserCollectionsQuery(),
              fetchPolicy: QueryFetchPolicy.storeFirst,
              loadingIndicator:
                  const ShimmerDetailsPage(title: 'Getting Ready'),
              builder: (collectionsData) {
                final workoutPlan = workoutPlanData.workoutPlanById;
                final enrolments = workoutPlan.workoutPlanEnrolments;

                final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
                final bool isOwner = workoutPlan.user.id == authedUserId;

                /// Is the user already enrolled in this plan?
                final enrolmentInPlan = enrolments
                    .firstWhereOrNull((e) => e.user.id == authedUserId);

                final List<Collection> collections = collectionsData
                    .userCollections
                    .where((collection) =>
                        collection.workoutPlans.contains(workoutPlan))
                    .toList();

                final List<Equipment> allEquipment = workoutPlan.allEquipment;

                return CupertinoPageScaffold(
                    navigationBar: MyNavBar(
                      middle: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NavBarTitle(workoutPlan.name),
                          MyText(
                            workoutPlan.user.displayName.toUpperCase(),
                            size: FONTSIZE.one,
                            subtext: true,
                          ),
                        ],
                      ),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.ellipsis),
                        onPressed: () => openBottomSheetMenu(
                            context: context,
                            child: BottomSheetMenu(
                                header: BottomSheetMenuHeader(
                                  name: workoutPlan.name,
                                  subtitle: 'Workout Plan',
                                  imageUri: workoutPlan.coverImageUri,
                                ),
                                items: [
                                  if (!isOwner &&
                                      workoutPlan.user.userProfileScope ==
                                          UserProfileScope.public)
                                    BottomSheetMenuItem(
                                        text: 'View creator',
                                        icon: const Icon(
                                            CupertinoIcons.profile_circled),
                                        onPressed: () => context.navigateTo(
                                            UserPublicProfileDetailsRoute(
                                                userId: workoutPlan.user.id))),
                                  if (isOwner ||
                                      workoutPlan.contentAccessScope ==
                                          ContentAccessScope.public)
                                    BottomSheetMenuItem(
                                        text: 'Share',
                                        icon: const Icon(
                                            CupertinoIcons.paperplane),
                                        onPressed: () =>
                                            _shareWorkoutPlan(workoutPlan)),
                                  if (isOwner)
                                    BottomSheetMenuItem(
                                        text: 'Edit',
                                        icon: const Icon(CupertinoIcons.pencil),
                                        onPressed: () => context.navigateTo(
                                            WorkoutPlanCreatorRoute(
                                                workoutPlan: workoutPlan))),
                                  BottomSheetMenuItem(
                                      text: 'Export',
                                      icon: const Icon(
                                          CupertinoIcons.download_circle),
                                      onPressed: () => context.showAlertDialog(
                                          title: 'Coming Soon!')),
                                  if (isOwner)
                                    BottomSheetMenuItem(
                                        text: workoutPlan.archived
                                            ? 'Unarchive'
                                            : 'Archive',
                                        icon: Icon(
                                          CupertinoIcons.archivebox,
                                          color: workoutPlan.archived
                                              ? null
                                              : Styles.errorRed,
                                        ),
                                        isDestructive: !workoutPlan.archived,
                                        onPressed: () => workoutPlan.archived
                                            ? _unarchiveWorkoutPlan(workoutPlan)
                                            : _archiveWorkoutPlan(workoutPlan)),
                                ])),
                      ),
                    ),
                    child: StackAndFloatingButton(
                      pageHasBottomNavBar: false,
                      onPressed: enrolmentInPlan != null
                          ? () => context.navigateTo(
                              WorkoutPlanEnrolmentDetailsRoute(
                                  id: enrolmentInPlan.id))
                          : _createWorkoutPlanEnrolment,
                      buttonIconData: enrolmentInPlan != null
                          ? CupertinoIcons.chart_bar_square
                          : CupertinoIcons.plus,
                      buttonText: enrolmentInPlan != null
                          ? 'View Progress'
                          : 'Join Plan',
                      buttonInternalPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 36),
                      child: Utils.textNotNull(workoutPlan.coverImageUri)
                          ? NestedScrollView(
                              headerSliverBuilder:
                                  (context, innerBoxIsScrolled) => <Widget>[
                                        SliverList(
                                            delegate: SliverChildListDelegate([
                                          SizedBox(
                                            height: 210,
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                SizedUploadcareImage(
                                                    workoutPlan.coverImageUri!,
                                                    fit: BoxFit.cover),
                                              ],
                                            ),
                                          )
                                        ]))
                                      ],
                              body: _buildContent(
                                workoutPlan: workoutPlan,
                                allEquipment: allEquipment,
                                collections: collections,
                                hasEnrolled: enrolmentInPlan != null,
                              ))
                          : _buildContent(
                              workoutPlan: workoutPlan,
                              allEquipment: allEquipment,
                              collections: collections,
                              hasEnrolled: enrolmentInPlan != null,
                            ),
                    ));
              });
        });
  }
}
