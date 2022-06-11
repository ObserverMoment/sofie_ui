import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/club/club_details_info.dart';
import 'package:sofie_ui/components/club/club_details_people.dart';
import 'package:sofie_ui/components/club/club_details_timeline.dart';
import 'package:sofie_ui/components/club/club_details_workout_plans.dart';
import 'package:sofie_ui/components/club/club_details_workouts.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/utils.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubDetailsMembersPage extends StatefulWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  final AsyncCallback checkUserMemberStatus;
  const ClubDetailsMembersPage({
    Key? key,
    required this.club,
    required this.authedUserMemberType,
    required this.checkUserMemberStatus,
  }) : super(key: key);

  @override
  State<ClubDetailsMembersPage> createState() => _ClubDetailsMembersPageState();
}

class _ClubDetailsMembersPageState extends State<ClubDetailsMembersPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  final double _topNavBarHeight = 60;

  bool _enableFeedPolling = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _scrollProgress =
            (_scrollController.offset / (_maxHeaderSize - 200)).clamp(0.0, 1.0);
      });
    });
  }

  double get _topSafeArea => MediaQuery.of(context).padding.top;

  double get _maxHeaderSize => Utils.textNotNull(widget.club.coverImageUri)
      ? 500
      : 250 + _topNavBarHeight + _topSafeArea;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Header(
                club: widget.club,
                authedUserMemberType: widget.authedUserMemberType,
                maxHeaderSize: _maxHeaderSize,
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalLine(
                color: context.theme.cardBackground,
                verticalPadding: 0,
              ),
            ),
            SliverToBoxAdapter(
              child: ClubDetailsTimeline(
                club: widget.club,
                isOwnerOrAdmin:
                    ClubUtils.userIsOwnerOrAdmin(widget.authedUserMemberType),
                enableFeedPolling: _enableFeedPolling,
              ),
            ),
          ],
        ),
        AnimatedNavBar(
          scrollProgress: _scrollProgress,
          club: widget.club,
          authedUserMemberType: widget.authedUserMemberType,
          cancelFeedPolling: () => setState(() => _enableFeedPolling = false),
          checkUserMemberStatus: widget.checkUserMemberStatus,
          navBarHeight: _topNavBarHeight,
          topSafeArea: _topSafeArea,
        ),
      ],
    );
  }
}

class AnimatedNavBar extends StatelessWidget {
  final double scrollProgress;
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  final AsyncCallback checkUserMemberStatus;
  final VoidCallback cancelFeedPolling;
  final double navBarHeight;
  final double topSafeArea;
  const AnimatedNavBar(
      {Key? key,
      required this.scrollProgress,
      required this.club,
      required this.authedUserMemberType,
      required this.cancelFeedPolling,
      required this.checkUserMemberStatus,
      required this.navBarHeight,
      required this.topSafeArea})
      : super(key: key);

  Future<void> _shareClub(ClubSummary club) async {
    await SharingAndLinking.shareLink(
        'club/${club.id}', 'Check out this club!');
  }

  Future<void> _createNewPost(BuildContext context) async {
    await context.navigateTo(ClubFeedPostCreatorRoute(
        clubId: club.id,
        onSuccess: () => context.showToast(
            message: 'Post created. It will display shortly.')));
  }

  void _confirmDeleteClub(BuildContext context, ClubSummary club) {
    context.showConfirmDeleteDialog(
        message:
            'Warning: This cannot be undone and will result in the deletion of all data, chat and timeline history from this club!',
        itemName: club.name,
        itemType: 'Club',
        onConfirm: () async {
          cancelFeedPolling();
          try {
            await GraphQLStore.store
                .delete<DeleteClub$Mutation, DeleteClubArguments>(
              mutation: DeleteClubMutation(
                  variables: DeleteClubArguments(id: club.id)),
              objectId: club.id,
              typename: kClubSummaryTypeName,
              processResult: (data) {
                // Remove ClubSummary from userClubs query.
                GraphQLStore.store
                    .deleteNormalizedObject(resolveDataId(club.toJson())!);

                // Remove all refs to it from queries.
                GraphQLStore.store
                    .removeAllQueryRefsToId(resolveDataId(club.toJson())!);

                // Rebroadcast all queries that may be affected.
                GraphQLStore.store.broadcastQueriesByIds([
                  GQLOpNames.userClubs,
                ]);
              },
            );
            context.pop();
          } catch (e) {
            printLog(e.toString());
            context.showToast(
                message: 'Sorry, there was a problem deleting this club!',
                toastType: ToastType.destructive);
          }
        });
  }

  void _confirmLeaveClub(BuildContext context, String clubId) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    context.showConfirmDialog(
        title: 'Leave this Club?',
        message:
            'Are you sure you want to leave this club? You will no longer have access to club chat, feeds or content.',
        onConfirm: () async {
          cancelFeedPolling();
          try {
            final result = await GraphQLStore.store.mutate<
                RemoveUserFromClub$Mutation, RemoveUserFromClubArguments>(
              mutation: RemoveUserFromClubMutation(
                  variables: RemoveUserFromClubArguments(
                      userToRemoveId: authedUserId, clubId: clubId)),
            );

            checkOperationResult(result,
                onSuccess: () async {
                  /// Update / re-run the userClubs query to get and broadcast updated list minus the club they just left.
                  await GraphQLStore.store
                      .query<UserClubs$Query, json.JsonSerializable>(
                          query: UserClubsQuery(),
                          broadcastQueryIds: [GQLOpNames.userClubs]);

                  await checkUserMemberStatus();

                  context.showToast(
                    message: 'You have now left this Club.',
                  );
                },
                onFail: () => throw Exception('Sorry, there was a problem.'));
          } catch (e) {
            printLog(e.toString());
            context.showToast(
                message: 'Sorry, there was a problem leaving this club!',
                toastType: ToastType.destructive);
          }
        });
  }

  bool get _userIsOwnerOrAdmin =>
      ClubUtils.userIsOwnerOrAdmin(authedUserMemberType);
  bool get _userIsOwner => ClubUtils.userIsOwner(authedUserMemberType);
  bool get _userIsMember => ClubUtils.userIsMember(authedUserMemberType);

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        context.theme.background.withOpacity((1 - scrollProgress) * 0.4);

    return SizedBox(
      height: navBarHeight + topSafeArea,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
              opacity: scrollProgress,
              child: Container(
                  color: context.theme.cupertinoThemeData.barBackgroundColor,
                  height: navBarHeight + topSafeArea)),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: topSafeArea, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: context.pop,
                  padding: EdgeInsets.zero,
                  child: CircularBox(
                      color: backgroundColor,
                      child: const Icon(
                        CupertinoIcons.arrow_left,
                      )),
                ),
                Opacity(
                    opacity: scrollProgress,
                    child: MyHeaderText(
                      club.name,
                    )),
                CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: CircularBox(
                        color: backgroundColor,
                        child: const Icon(CupertinoIcons.ellipsis)),
                    onPressed: () => openBottomSheetMenu(
                        context: context,
                        child: BottomSheetMenu(
                            header: BottomSheetMenuHeader(
                              name: club.name,
                              subtitle: 'Club',
                              imageUri: club.coverImageUri,
                            ),
                            items: [
                              if (_userIsOwnerOrAdmin)
                                BottomSheetMenuItem(
                                    text: 'New Post',
                                    icon: CupertinoIcons.add,
                                    onPressed: () => _createNewPost(context)),
                              if (_userIsOwnerOrAdmin)
                                BottomSheetMenuItem(
                                    text: 'Edit Club Info',
                                    icon: CupertinoIcons.pencil,
                                    onPressed: () => context.navigateTo(
                                        ClubCreatorRoute(clubSummary: club))),
                              if (club.contentAccessScope ==
                                  ContentAccessScope.public)
                                BottomSheetMenuItem(
                                    text: 'Share',
                                    icon: CupertinoIcons.paperplane,
                                    onPressed: () => _shareClub(club)),
                              if (_userIsMember && !_userIsOwner)
                                BottomSheetMenuItem(
                                    text: 'Leave Club',
                                    isDestructive: true,
                                    icon: CupertinoIcons.square_arrow_right,
                                    onPressed: () =>
                                        _confirmLeaveClub(context, club.id)),
                              if (_userIsOwner)
                                BottomSheetMenuItem(
                                    text: 'Shut Down Club',
                                    icon:
                                        CupertinoIcons.exclamationmark_triangle,
                                    isDestructive: true,
                                    onPressed: () =>
                                        _confirmDeleteClub(context, club)),
                            ]))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  final double maxHeaderSize;
  const Header({
    Key? key,
    required this.club,
    required this.authedUserMemberType,
    required this.maxHeaderSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradientBasisColor = context.theme.background;

    return SizedBox(
      height: maxHeaderSize,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          if (Utils.textNotNull(club.coverImageUri))
            SizedBox(
              height: maxHeaderSize,
              child: SizedUploadcareImage(
                club.coverImageUri!,
                fit: BoxFit.none,
                displaySize: Size.square(maxHeaderSize),
              ),
            ),
          if (Utils.textNotNull(club.coverImageUri))
            Container(
              height: maxHeaderSize,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    gradientBasisColor.withOpacity(0),
                    gradientBasisColor.withOpacity(0.7),
                    gradientBasisColor.withOpacity(0.9),
                    gradientBasisColor,
                  ],
                      stops: const [
                    0.4,
                    0.6,
                    0.9,
                    1.0,
                  ])),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyHeaderText(club.name, size: FONTSIZE.six),
                const SizedBox(height: 8),
                if (Utils.textNotNull(club.description))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ReadMoreTextBlock(
                      title: club.name,
                      text: club.description!,
                      trimLines: 2,
                    ),
                  ),
                _ClubSectionButtons(
                  club: club,
                  authedUserMemberType: authedUserMemberType,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubSectionButtons extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  const _ClubSectionButtons(
      {Key? key, required this.club, required this.authedUserMemberType})
      : super(key: key);

  double get _iconSize => 26.0;

  @override
  Widget build(BuildContext context) {
    final userIsOwnerOrAdmin = [
      UserClubMemberStatus.owner,
      UserClubMemberStatus.admin,
    ].contains(authedUserMemberType);

    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 24,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 24,
        children: [
          if (userIsOwnerOrAdmin || club.memberCount > 0)
            _ClubSectionButton(
              label: 'People',
              icon: Icon(
                CupertinoIcons.person_2_fill,
                size: _iconSize,
              ),
              count: club.memberCount,
              onTap: () => context.push(
                  child: ClubDetailsPeople(
                authedUserMemberType: authedUserMemberType,
                clubId: club.id,
              )),
            ),
          if (userIsOwnerOrAdmin || club.workoutCount > 0)
            _ClubSectionButton(
              label: 'Workouts',
              icon: SvgPicture.asset('assets/graphics/dumbbell.svg',
                  height: _iconSize,
                  fit: BoxFit.fitHeight,
                  color: context.theme.primary),
              count: club.workoutCount,
              onTap: () => context.push(
                  child: ClubDetailsWorkouts(
                isOwnerOrAdmin: userIsOwnerOrAdmin,
                clubId: club.id,
              )),
            ),
          if (userIsOwnerOrAdmin || club.planCount > 0)
            _ClubSectionButton(
                label: 'Plans',
                icon: Icon(CupertinoIcons.calendar, size: _iconSize),
                count: club.planCount,
                onTap: () => context.push(
                        child: ClubDetailsWorkoutPlans(
                      isOwnerOrAdmin: userIsOwnerOrAdmin,
                      clubId: club.id,
                    ))),
          if (userIsOwnerOrAdmin || 0 > 0)
            _ClubSectionButton(
              label: 'Throwdowns',
              icon: SvgPicture.asset('assets/graphics/medal.svg',
                  height: _iconSize,
                  fit: BoxFit.fitHeight,
                  color: context.theme.primary),
              count: 0,
              onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
            ),
          if (userIsOwnerOrAdmin || 0 > 0)
            _ClubSectionButton(
              label: 'Coaching',
              icon: Icon(
                CupertinoIcons.chart_bar_fill,
                size: _iconSize,
              ),
              count: 0,
              onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
            ),
          if (userIsOwnerOrAdmin || 0 > 0)
            _ClubSectionButton(
              label: 'Gear',
              icon: Icon(
                CupertinoIcons.shopping_cart,
                size: _iconSize,
              ),
              count: 0,
              onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
            ),
          _ClubSectionButton(
            label: 'Chat',
            icon: Icon(
              CupertinoIcons.chat_bubble_text_fill,
              size: _iconSize + 3,
            ),
            onTap: () =>
                context.navigateTo(ClubMembersChatRoute(clubId: club.id)),
          ),
          _ClubSectionButton(
              label: 'Club Info',
              icon: Icon(
                CupertinoIcons.info_circle_fill,
                size: _iconSize + 3,
              ),
              onTap: () => context.push(
                      child: ClubDetailsInfo(
                    club: club,
                  ))),
        ],
      ),
    );
  }
}

class _ClubSectionButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final int? count;
  final VoidCallback onTap;
  const _ClubSectionButton(
      {Key? key,
      required this.label,
      required this.icon,
      this.count,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                if (count != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: MyText(
                      count.toString(),
                      size: FONTSIZE.six,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            MyText(label, maxLines: 2, size: FONTSIZE.one),
          ],
        ),
      ),
    );
  }
}
