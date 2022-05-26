import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/body_areas/body_area_selectors.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/logged_workout_creator_with_sections.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/logged_workout/logged_workout_section_moves_list.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';

/// Very simlar to the LoggedWorkoutCreator.
/// Shares most of its components and logic is handled by [LoggedWorkoutCreatorBloc].
class LoggedWorkoutDetailsPage extends StatelessWidget {
  final String id;
  const LoggedWorkoutDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  Future<void> _shareLoggedWorkout() async {
    await SharingAndLinking.shareLink(
        'logged-workout/$id', 'Check out my workout log!');
  }

  Future<void> _deleteLoggedWorkout(BuildContext context) async {
    await context.showConfirmDeleteDialog(
        itemType: 'Log',
        message: 'This cannot be undone.',
        onConfirm: () async {
          final result = await GraphQLStore.store
              .delete<DeleteLoggedWorkoutById$Mutation, json.JsonSerializable>(
            typename: kLoggedWorkoutTypename,
            objectId: id,
            mutation: DeleteLoggedWorkoutByIdMutation(
              variables: DeleteLoggedWorkoutByIdArguments(id: id),
            ),
            clearQueryDataAtKeys: [
              getParameterizedQueryId(LoggedWorkoutByIdQuery(
                  variables: LoggedWorkoutByIdArguments(id: id)))
            ],
            removeRefFromQueries: [GQLOpNames.userLoggedWorkouts],
          );

          if (result.hasErrors) {
            context.showErrorAlert(
                'Something went wrong, the log was not deleted correctly');
          } else {
            context.pop(); // The screen.
          }
        });
  }

  /// Saves all changes to the global graphql store once the user is done with this spage.
  void _handleSaveAndClose(BuildContext context) {
    context.read<LoggedWorkoutCreatorBloc>().writeAllChangesToStore();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final query =
        LoggedWorkoutByIdQuery(variables: LoggedWorkoutByIdArguments(id: id));

    return QueryObserver<LoggedWorkoutById$Query, LoggedWorkoutByIdArguments>(
        key: Key('LoggedWorkoutDetailsPage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        fetchPolicy: QueryFetchPolicy.networkOnly,
        builder: (data) {
          if (data.loggedWorkoutById == null) {
            return const ObjectNotFoundIndicator(
              notFoundItemName: 'the required log data',
            );
          }
          final loggedWorkout = data.loggedWorkoutById!;

          final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
          final bool isOwner = loggedWorkout.user?.id == authedUserId;

          if (!isOwner) {
            return _LoggedWorkoutReadOnly(
              loggedWorkout: loggedWorkout,
            );
          }

          return ChangeNotifierProvider(
            create: (context) => LoggedWorkoutCreatorBloc(
              context: context,
              prevLoggedWorkout: loggedWorkout,
            ),
            builder: (context, child) {
              return MyPageScaffold(
                  navigationBar: MyNavBar(
                    customLeading: NavBarBackButtonStandalone(
                      onPressed: () => _handleSaveAndClose(context),
                    ),
                    middle: NavBarTitle(loggedWorkout.name),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.ellipsis),
                        onPressed: () => openBottomSheetMenu(
                            context: context,
                            child: BottomSheetMenu(
                                header: BottomSheetMenuHeader(
                                  name: loggedWorkout.name,
                                  subtitle: 'Logged Workout',
                                ),
                                items: [
                                  if (Utils.textNotNull(
                                      loggedWorkout.workoutId))
                                    BottomSheetMenuItem(
                                        text: 'View workout',
                                        icon: CupertinoIcons.info,
                                        onPressed: () => context.navigateTo(
                                            WorkoutDetailsRoute(
                                                id: loggedWorkout.workoutId!))),
                                  BottomSheetMenuItem(
                                      text: 'Share',
                                      icon: CupertinoIcons.paperplane,
                                      onPressed: _shareLoggedWorkout),
                                  BottomSheetMenuItem(
                                      text: 'Delete',
                                      icon: CupertinoIcons.delete_simple,
                                      isDestructive: true,
                                      onPressed: () =>
                                          _deleteLoggedWorkout(context)),
                                ]))),
                  ),
                  child: const LoggedWorkoutCreatorWithSections());
            },
          );
        });
  }
}

/// For viewing - displayed when the viewing user is not the owning user.
class _LoggedWorkoutReadOnly extends StatelessWidget {
  final LoggedWorkout loggedWorkout;
  const _LoggedWorkoutReadOnly({Key? key, required this.loggedWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: NestedScrollView(
      headerSliverBuilder: (c, i) => [
        MySliverNavbar(title: loggedWorkout.user?.displayName ?? 'Log'),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0),
          child: MyHeaderText(loggedWorkout.name),
        ))
      ],
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _InfoWithHeading(
            content: MyText(loggedWorkout.completedOn.dateAndTime),
            header: 'Completd On',
          ),
          if (loggedWorkout.gymProfile != null)
            _InfoWithHeading(
              content: MyText(loggedWorkout.gymProfile!.name),
              header: 'Completd At',
            ),
          if (Utils.textNotNull(loggedWorkout.note))
            _InfoWithHeading(
              content: ReadMoreTextBlock(
                text: loggedWorkout.note!,
                trimLines: 4,
                title: 'Note',
              ),
              header: 'Note',
            ),
          if (loggedWorkout.workoutGoals.isNotEmpty)
            _InfoWithHeading(
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: loggedWorkout.workoutGoals
                    .map((g) => Tag(tag: g.name))
                    .toList(),
              ),
              header: 'Goals Targeted',
            ),
          const SizedBox(height: 8),
          ContentBox(
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (c, i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _LoggedWorkoutSectionDisplay(
                          loggedWorkoutSection:
                              loggedWorkout.loggedWorkoutSections[i],
                        ),
                      ),
                  separatorBuilder: (c, i) => const HorizontalLine(
                        verticalPadding: 0,
                      ),
                  itemCount: loggedWorkout.loggedWorkoutSections.length))
        ],
      ),
    ));
  }
}

class _InfoWithHeading extends StatelessWidget {
  final String header;
  final Widget content;
  const _InfoWithHeading(
      {Key? key, required this.header, required this.content})
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

class _LoggedWorkoutSectionDisplay extends StatelessWidget {
  final LoggedWorkoutSection loggedWorkoutSection;
  const _LoggedWorkoutSectionDisplay(
      {Key? key, required this.loggedWorkoutSection})
      : super(key: key);

  Widget _buildNavigatorButton(
          BuildContext context, Widget pageChild, Widget buttonChild) =>
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => context.push(
          child: pageChild,
        ),
        child: buttonChild,
      );

  @override
  Widget build(BuildContext context) {
    final sectionType = loggedWorkoutSection.workoutSectionType;
    final bodyAreas = loggedWorkoutSection.uniqueBodyAreas;
    final moveTypes = loggedWorkoutSection.uniqueMoveTypes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    loggedWorkoutSection.workoutSectionType.name.toUpperCase(),
                  ),
                  if (Utils.textNotNull(loggedWorkoutSection.name))
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: MyHeaderText(
                        loggedWorkoutSection.name!,
                        size: FONTSIZE.two,
                        weight: FontWeight.normal,
                        color: Styles.primaryAccent,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  _buildNavigatorButton(
                      context,
                      LoggedWorkoutSectionMovesList(
                          loggedWorkoutSection: loggedWorkoutSection),
                      const Icon(CupertinoIcons.list_number)),
                  _buildNavigatorButton(
                      context,
                      MyPageScaffold(
                          navigationBar: const MyNavBar(
                            middle: NavBarLargeTitle('Body Areas Targeted'),
                          ),
                          child: BodyAreaSelectorFrontBackPaged(
                            bodyGraphicHeight:
                                MediaQuery.of(context).size.height * 0.55,
                            handleTapBodyArea: (_) =>
                                {}, // Noop as this is read only,
                            selectedBodyAreas: bodyAreas,
                          )),
                      SvgPicture.asset(
                        'assets/body_areas/body_button.svg',
                        width: 30,
                        alignment: Alignment.topCenter,
                        color: context.theme.primary.withOpacity(0.7),
                      )),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DurationTag(
                  fontSize: FONTSIZE.four,
                  iconSize: 16,
                  duration:
                      Duration(seconds: loggedWorkoutSection.timeTakenSeconds),
                ),
                if (sectionType.isScored || sectionType.isLifting)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ContentBox(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: MyText(
                        '${loggedWorkoutSection.repScore ?? " - "} reps',
                        size: FONTSIZE.four,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moveTypes
                .map((mType) => Tag(
                      tag: mType.name,
                      fontSize: FONTSIZE.one,
                      color: context.theme.background,
                      textColor: context.theme.primary,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
