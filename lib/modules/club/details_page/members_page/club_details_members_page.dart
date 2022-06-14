import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';

import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/club/details_page/members_page/club_details_header.dart';
import 'package:sofie_ui/modules/club/details_page/utils.dart';
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
                child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children:
                  List.generate(50, (index) => const Card(child: MyText('Hi'))),
            )),
          ],
        ),
        AnimateOnScrollNavBar(
          scrollProgress: _scrollProgress,
          club: widget.club,
          authedUserMemberType: widget.authedUserMemberType,
          checkUserMemberStatus: widget.checkUserMemberStatus,
          navBarHeight: _topNavBarHeight,
          topSafeArea: _topSafeArea,
        ),
      ],
    );
  }
}

class AnimateOnScrollNavBar extends StatelessWidget {
  final double scrollProgress;
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  final AsyncCallback checkUserMemberStatus;
  final double navBarHeight;
  final double topSafeArea;
  const AnimateOnScrollNavBar(
      {Key? key,
      required this.scrollProgress,
      required this.club,
      required this.authedUserMemberType,
      required this.checkUserMemberStatus,
      required this.navBarHeight,
      required this.topSafeArea})
      : super(key: key);

  Future<void> _shareClub(ClubSummary club) async {
    await SharingAndLinking.shareLink(
        'club/${club.id}', 'Check out this club!');
  }

  void _confirmDeleteClub(BuildContext context, ClubSummary club) {
    context.showConfirmDeleteDialog(
        message:
            'Warning: This cannot be undone and will result in the deletion of all data, chat and timeline history from this club!',
        itemName: club.name,
        itemType: 'Club',
        onConfirm: () async {
          try {
            await GraphQLStore.store
                .delete<DeleteClub$Mutation, DeleteClubArguments>(
              mutation: DeleteClubMutation(
                  variables: DeleteClubArguments(id: club.id)),
              objectId: club.id,
              typename: kClubSummaryTypeName,
              onSuccess: context.pop,
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
          try {
            await GraphQLStore.store.mutate<RemoveUserFromClub$Mutation,
                RemoveUserFromClubArguments>(
              mutation: RemoveUserFromClubMutation(
                  variables: RemoveUserFromClubArguments(
                      userToRemoveId: authedUserId, clubId: clubId)),
              processResult: (result) async {
                await GraphQLStore.store
                    .query<UserClubs$Query, json.JsonSerializable>(
                        query: UserClubsQuery(),
                        broadcastQueryIds: [GQLOpNames.userClubs]);

                checkUserMemberStatus()
                    .then((_) => {
                          context.showToast(
                            message: 'You have now left this Club.',
                          )
                        })
                    .onError((error, stackTrace) => {
                          context.showToast(
                              message:
                                  'Sorry, there was a problem leaving this club!',
                              toastType: ToastType.destructive)
                        });
              },
            );
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
