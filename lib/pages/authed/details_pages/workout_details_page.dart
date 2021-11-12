import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_like_heart.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/collections/collection_manager.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/workout/workout_details_workout_section.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutDetailsPage extends StatefulWidget {
  final String id;
  const WorkoutDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _WorkoutDetailsPageState createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  Future<void> _copyWorkout(String id) async {
    await context.showConfirmDialog(
        title: 'Make a copy of this Workout?',
        verb: 'Make Copy',
        message: 'Note: Media will not be copied across.',
        onConfirm: () async {
          final result = await context.graphQLStore.create<
                  DuplicateWorkoutById$Mutation, DuplicateWorkoutByIdArguments>(
              mutation: DuplicateWorkoutByIdMutation(
                  variables: DuplicateWorkoutByIdArguments(id: id)),
              addRefToQueries: [GQLOpNames.userWorkoutsQuery]);

          await checkOperationResult(context, result,
              onSuccess: () => context.showToast(
                  message: 'Copy created. View in Your Workouts'),
              onFail: () => context.showErrorAlert(
                  'Something went wrong, the workout was not duplicated correctly'));
        });
  }

  Future<void> _openScheduleWorkout(Workout workout) async {
    final result = await context.pushRoute(ScheduledWorkoutCreatorRoute(
      workout: workout,
    ));
    if (result is ToastRequest) {
      context.showToast(message: result.message, toastType: result.type);
    }
  }

  Future<void> _shareWorkout(Workout workout) async {
    await SharingAndLinking.shareLink(
        'workout/${workout.id}', 'Check out this workout!');
  }

  Future<void> _archiveWorkout(String id) async {
    await context.showConfirmDeleteDialog(
        verb: 'Archive',
        itemType: 'Workout',
        message:
            'It will be moved to your archive where it can be retrieved if needed.',
        onConfirm: () async {
          final result = await context.graphQLStore
              .mutate<ArchiveWorkoutById$Mutation, ArchiveWorkoutByIdArguments>(
                  mutation: ArchiveWorkoutByIdMutation(
                      variables: ArchiveWorkoutByIdArguments(id: id)),
                  removeRefFromQueries: [
                GQLOpNames.userWorkoutsQuery
              ],
                  addRefToQueries: [
                GQLOpNames.userArchivedWorkoutsQuery
              ],
                  broadcastQueryIds: [
                GQLVarParamKeys.workoutByIdQuery(widget.id),
              ]);

          await checkOperationResult(context, result,
              onSuccess: () => context.showToast(message: 'Workout archived'),
              onFail: () => context.showErrorAlert(
                  'Something went wrong, the workout was not archived correctly'));
        });
  }

  Future<void> _unarchiveWorkout(String id) async {
    await context.showConfirmDialog(
        title: 'Unarchive this workout?',
        verb: 'Unarchive',
        message: 'It will be moved back into your workouts.',
        onConfirm: () async {
          final result = await context.graphQLStore.mutate<
              UnarchiveWorkoutById$Mutation, UnarchiveWorkoutByIdArguments>(
            mutation: UnarchiveWorkoutByIdMutation(
              variables: UnarchiveWorkoutByIdArguments(id: id),
            ),
            addRefToQueries: [GQLOpNames.userWorkoutsQuery],
            removeRefFromQueries: [GQLOpNames.userArchivedWorkoutsQuery],
            broadcastQueryIds: [
              GQLVarParamKeys.workoutByIdQuery(widget.id),
            ],
          );

          await checkOperationResult(context, result,
              onSuccess: () => context.showToast(message: 'Workout unarchived'),
              onFail: () => context.showErrorAlert(
                  'Something went wrong, the workout was not unarchived correctly'));
        });
  }

  Widget _buildMetaInfoRow(Workout workout, {bool centerAlign = false}) =>
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: centerAlign
              ? MainAxisAlignment.center
              : workout.archived || workout.lengthMinutes != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
          children: [
            if (workout.archived)
              const FadeIn(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    CupertinoIcons.archivebox_fill,
                    color: Styles.errorRed,
                  ),
                ),
              ),
            if (workout.lengthMinutes != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DurationTag(
                  fontSize: FONTSIZE.three,
                  iconSize: 15,
                  duration: Duration(minutes: workout.lengthMinutes!),
                ),
              ),
            DifficultyLevelTag(
              backgroundColor: context.theme.background.withOpacity(0.85),
              difficultyLevel: workout.difficultyLevel,
              fontSize: FONTSIZE.two,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final query =
        WorkoutByIdQuery(variables: WorkoutByIdArguments(id: widget.id));

    return QueryObserver<WorkoutById$Query, WorkoutByIdArguments>(
        key: Key('WorkoutDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        loadingIndicator: const ShimmerDetailsPage(title: 'Getting Ready'),
        builder: (workoutData) {
          return QueryObserver<UserCollections$Query, json.JsonSerializable>(
              key: Key(
                  'WorkoutDetailsPage - ${UserCollectionsQuery().operationName}'),
              query: UserCollectionsQuery(),
              fetchPolicy: QueryFetchPolicy.storeFirst,
              loadingIndicator:
                  const ShimmerDetailsPage(title: 'Getting Ready'),
              builder: (collectionsData) {
                final Workout workout = workoutData.workoutById;

                final List<Collection> collections = collectionsData
                    .userCollections
                    .where((collection) => collection.workouts
                        .map((w) => w.id)
                        .contains(workout.id))
                    .toList();

                final List<WorkoutSection> sortedWorkoutSections = workout
                    .workoutSections
                    .sortedBy<num>((ws) => ws.sortPosition);

                final allEquipments = workout.allEquipment;

                final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
                final bool isOwner = workout.user.id == authedUserId;

                return CupertinoPageScaffold(
                    navigationBar: MyNavBar(
                      middle: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NavBarTitle(workout.name),
                          MyText(
                            workout.user.displayName.toUpperCase(),
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
                                  name: workout.name,
                                  subtitle: 'Workout',
                                  imageUri: workout.coverImageUri,
                                ),
                                items: [
                                  if (!isOwner &&
                                      workout.user.userProfileScope ==
                                          UserProfileScope.public)
                                    BottomSheetMenuItem(
                                        text: 'View creator',
                                        icon: const Icon(
                                            CupertinoIcons.profile_circled),
                                        onPressed: () => context.navigateTo(
                                            UserPublicProfileDetailsRoute(
                                                userId: workout.user.id))),
                                  BottomSheetMenuItem(
                                      text: 'Log it',
                                      icon: const Icon(
                                          CupertinoIcons.text_badge_checkmark),
                                      onPressed: () => context.navigateTo(
                                          LoggedWorkoutCreatorRoute(
                                              workout: workout))),
                                  if (isOwner ||
                                      workout.contentAccessScope ==
                                          ContentAccessScope.public)
                                    BottomSheetMenuItem(
                                        text: 'Share',
                                        icon: const Icon(
                                            CupertinoIcons.paperplane),
                                        onPressed: () =>
                                            _shareWorkout(workout)),
                                  if (isOwner)
                                    BottomSheetMenuItem(
                                        text: 'Edit',
                                        icon: const Icon(CupertinoIcons.pencil),
                                        onPressed: () => context.navigateTo(
                                            WorkoutCreatorRoute(
                                                workout: workout))),
                                  if (isOwner)
                                    BottomSheetMenuItem(
                                        text: 'Copy',
                                        icon: const Icon(CupertinoIcons
                                            .plus_rectangle_on_rectangle),
                                        onPressed: () =>
                                            _copyWorkout(workout.id)),
                                  if (isOwner)
                                    BottomSheetMenuItem(
                                        text: 'Export',
                                        icon: const Icon(
                                            CupertinoIcons.download_circle),
                                        onPressed: () =>
                                            context.showAlertDialog(
                                                title: 'Coming soon!')),
                                  if (isOwner)
                                    BottomSheetMenuItem(
                                        text: workout.archived
                                            ? 'Unarchive'
                                            : 'Archive',
                                        icon: Icon(
                                          CupertinoIcons.archivebox,
                                          color: workout.archived
                                              ? null
                                              : Styles.errorRed,
                                        ),
                                        isDestructive: !workout.archived,
                                        onPressed: () => workout.archived
                                            ? _unarchiveWorkout(workout.id)
                                            : _archiveWorkout(workout.id)),
                                ])),
                      ),
                    ),
                    child: StackAndFloatingButton(
                        onPressed: () => context
                            .navigateTo(DoWorkoutWrapperRoute(id: widget.id)),
                        pageHasBottomNavBar: false,
                        buttonText: 'Do It',
                        buttonIconData: CupertinoIcons.arrow_right_square,
                        buttonInternalPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 80),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            if (Utils.textNotNull(workout.coverImageUri))
                              SizedBox(
                                height: 210,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    SizedUploadcareImage(workout.coverImageUri!,
                                        fit: BoxFit.cover),
                                    _buildMetaInfoRow(workout),
                                  ],
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _ActionIconButton(
                                      icon: const Icon(
                                          CupertinoIcons.calendar_badge_plus),
                                      label: 'Schedule',
                                      onPressed: () =>
                                          _openScheduleWorkout(workout),
                                    ),
                                    _ActionIconButton(
                                        icon: const Icon(CupertinoIcons
                                            .text_badge_checkmark),
                                        label: 'Log It',
                                        onPressed: () => context.navigateTo(
                                            LoggedWorkoutCreatorRoute(
                                                workout: workout))),
                                    if (Utils.textNotNull(
                                        workout.introVideoUri))
                                      _ActionIconButton(
                                          icon: const Icon(CupertinoIcons.tv),
                                          label: 'Video',
                                          onPressed: () => VideoSetupManager
                                              .openFullScreenVideoPlayer(
                                                  context: context,
                                                  videoUri:
                                                      workout.introVideoUri!,
                                                  videoThumbUri: workout
                                                      .introVideoThumbUri!,
                                                  autoPlay: true,
                                                  autoLoop: true)),
                                    if (Utils.textNotNull(
                                        workout.introAudioUri))
                                      _ActionIconButton(
                                          icon: const Icon(
                                              CupertinoIcons.headphones),
                                          label: 'Audio',
                                          onPressed: () => AudioPlayerController
                                              .openAudioPlayer(
                                                  context: context,
                                                  audioUri:
                                                      workout.introAudioUri!,
                                                  pageTitle: 'Intro Audio',
                                                  audioTitle: workout.name,
                                                  autoPlay: true)),

                                    /// The heart is appearing smaller than other items for some reason - so manually making it larger and removing gap underneath between text.
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => CollectionManager
                                          .addOrRemoveObjectFromCollection(
                                              context, workout,
                                              alreadyInCollections:
                                                  collections),
                                      child: Column(
                                        children: [
                                          AnimatedLikeHeart(
                                              active: collections.isNotEmpty,
                                              size: 26),
                                          const MyText(
                                            'SAVE',
                                            size: FONTSIZE.one,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            const HorizontalLine(verticalPadding: 0),
                            if (!Utils.textNotNull(workout.coverImageUri))
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: context.theme.primary
                                                  .withOpacity(0.2)))),
                                  child: _buildMetaInfoRow(workout,
                                      centerAlign: true)),
                            if (Utils.textNotNull(workout.description))
                              _InfoSection(
                                content: ReadMoreTextBlock(
                                    text: workout.description!,
                                    title: workout.name),
                                header: 'Description',
                                icon: CupertinoIcons.doc_text,
                              ),
                            if (workout.workoutGoals.isNotEmpty)
                              _InfoSection(
                                content: CommaSeparatedList(
                                    workout.workoutGoals
                                        .map((g) => g.name)
                                        .toList(),
                                    fontSize: FONTSIZE.three),
                                header: 'Goals',
                                icon: CupertinoIcons.scope,
                              ),
                            if (workout.workoutTags.isNotEmpty)
                              _InfoSection(
                                content: CommaSeparatedList(
                                    workout.workoutTags
                                        .map((t) => t.tag)
                                        .toList(),
                                    fontSize: FONTSIZE.three),
                                header: 'Tags',
                                icon: CupertinoIcons.tag,
                              ),
                            _InfoSection(
                              content: allEquipments.isEmpty
                                  ? const MyText(
                                      'No equipment required',
                                      subtext: true,
                                    )
                                  : CommaSeparatedList(
                                      allEquipments.map((e) => e.name).toList(),
                                      fontSize: FONTSIZE.three),
                              header: 'Equipment',
                              icon: CupertinoIcons.cube,
                            ),
                            const SizedBox(height: 16),
                            ...sortedWorkoutSections
                                .map((ws) => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 6,
                                          right: 6,
                                          bottom: 16),
                                      child: WorkoutDetailsWorkoutSection(ws),
                                    ))
                                .toList(),
                            const SizedBox(height: 70)
                          ],
                        )));
              });
        });
  }
}

class _ActionIconButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  const _ActionIconButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 2),
          MyText(
            label.toUpperCase(),
            size: FONTSIZE.one,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String header;
  final IconData icon;
  final Widget content;
  const _InfoSection(
      {Key? key,
      required this.header,
      required this.icon,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: context.theme.primary.withOpacity(0.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyHeaderText(
                  header,
                  weight: FontWeight.normal,
                  size: FONTSIZE.two,
                ),
                const SizedBox(width: 4),
                Icon(icon, size: 12),
              ],
            ),
          ),
          const SizedBox(height: 12),
          content
        ],
      ),
    );
  }
}