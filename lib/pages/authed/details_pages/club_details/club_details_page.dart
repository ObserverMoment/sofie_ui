import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_members_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_non_members_page.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class ClubDetailsPage extends StatefulWidget {
  final String id;
  const ClubDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _ClubDetailsPageState createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  bool _stopPollingFeed = false;
  UserClubMemberStatus? _authedUserMemberType;

  Future<void> _checkUserMemberStatus() async {
    final result = await context.graphQLStore.networkOnlyOperation(
        operation: CheckUserClubMemberStatusQuery(
            variables: CheckUserClubMemberStatusArguments(clubId: widget.id)));

    checkOperationResult(context, result, onFail: () {
      setState(() {
        _authedUserMemberType = UserClubMemberStatus.none;
      });
      context.showToast(
          message: 'Sorry, there was a problem checking your membership.');
    }, onSuccess: () {
      setState(() {
        _authedUserMemberType = result.data!.checkUserClubMemberStatus;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUserMemberStatus();
  }

  Future<void> _createNewPost() async {
    await context.navigateTo(ClubPostCreatorRoute(
        clubId: widget.id,
        onSuccess: (_) => context.showToast(
            message: 'Post created. It will display shortly.')));
  }

  Future<void> _shareClub(ClubSummary club) async {
    await SharingAndLinking.shareLink(
        'club/${club.id}', 'Check out this club!');
  }

  Future<void> _addUserToPublicClub(ClubSummary club) async {
    if (club.contentAccessScope == ContentAccessScope.public) {
      context.showToast(
        message: 'Joining Club! Just a second...',
      );

      final variables = UserJoinPublicClubArguments(clubId: club.id);

      final result = await context.graphQLStore.networkOnlyOperation<
              UserJoinPublicClub$Mutation, UserJoinPublicClubArguments>(
          operation: UserJoinPublicClubMutation(variables: variables));

      checkOperationResult(context, result, onSuccess: () async {
        /// Update / re-run the userClubs query to get and broadcast updated list.
        await context.graphQLStore
            .query<UserClubs$Query, json.JsonSerializable>(
                query: UserClubsQuery(),
                broadcastQueryIds: [GQLOpNames.userClubs]);

        await _checkUserMemberStatus();

        context.showToast(
          message: 'Nice One! Welcome to ${club.name}!',
        );
      }, onFail: () {
        context.showToast(
            message: 'Sorry, there was a problem joining the club.',
            toastType: ToastType.destructive);
      });
    } else {
      context.showToast(
          message: 'Sorry, this Club is Private.',
          toastType: ToastType.destructive);
    }
  }

  void _confirmDeleteClub(ClubSummary club) {
    context.showConfirmDeleteDialog(
        message:
            'Warning: This cannot be undone and will result in the deletion of all data, chat and timeline history from this club!',
        itemName: club.name,
        itemType: 'Club',
        onConfirm: () async {
          setState(() {
            _stopPollingFeed = true;
          });
          try {
            await context.graphQLStore
                .delete<DeleteClub$Mutation, DeleteClubArguments>(
              mutation: DeleteClubMutation(
                  variables: DeleteClubArguments(id: widget.id)),
              objectId: widget.id,
              typename: kClubSummaryTypeName,
              removeAllRefsToId: true,
              processResult: (data) {
                // Remove ClubSummary from userClubs query.
                context.graphQLStore
                    .deleteNormalizedObject(resolveDataId(club.toJson())!);

                // Remove all refs to it from queries.
                context.graphQLStore
                    .removeAllQueryRefsToId(resolveDataId(club.toJson())!);

                // Rebroadcast all queries that may be affected.
                context.graphQLStore.broadcastQueriesByIds([
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

  void _confirmLeaveClub(String clubId) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    context.showConfirmDialog(
        title: 'Leave this Club?',
        message:
            'Are you sure you want to leave this club? You will no longer have access to club chat, feeds or content.',
        onConfirm: () async {
          setState(() {
            _stopPollingFeed = true;
          });
          try {
            final result = await context.graphQLStore.mutate<
                RemoveUserFromClub$Mutation, RemoveUserFromClubArguments>(
              mutation: RemoveUserFromClubMutation(
                  variables: RemoveUserFromClubArguments(
                      userToRemoveId: authedUserId, clubId: clubId)),
            );

            checkOperationResult(context, result,
                onSuccess: () async {
                  /// Update / re-run the userClubs query to get and broadcast updated list minus the club they just left.
                  await context.graphQLStore
                      .query<UserClubs$Query, json.JsonSerializable>(
                          query: UserClubsQuery(),
                          broadcastQueryIds: [GQLOpNames.userClubs]);

                  await _checkUserMemberStatus();

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

  bool get _userIsMember => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
        UserClubMemberStatus.member
      ].contains(_authedUserMemberType);

  bool get _userIsOwnerOrAdmin => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(_authedUserMemberType);

  bool get _userIsOwner => _authedUserMemberType == UserClubMemberStatus.owner;

  Widget get _checkingMembershipPlaceholder => MyPageScaffold(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            LoadingSpinningLines(),
            SizedBox(height: 10),
            MyText('CHECKING MEMBERSHIP')
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    final clubSummaryQuery =
        ClubSummaryQuery(variables: ClubSummaryArguments(id: widget.id));

    return _authedUserMemberType == null
        ? FadeInUp(child: _checkingMembershipPlaceholder)
        : QueryObserver<ClubSummary$Query, ClubSummaryArguments>(
            key: Key(
                'ClubDetailsPage - ${clubSummaryQuery.operationName}-${widget.id}'),
            query: clubSummaryQuery,
            parameterizeQuery: true,
            builder: (clubData) {
              final club = clubData.clubSummary;

              return CupertinoPageScaffold(
                  navigationBar: MyNavBar(
                    middle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NavBarTitle(club.name),
                        MyText(
                          club.owner.displayName.toUpperCase(),
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
                                  name: club.name,
                                  subtitle: 'Club',
                                  imageUri: club.coverImageUri,
                                ),
                                items: [
                                  if (_userIsOwnerOrAdmin)
                                    BottomSheetMenuItem(
                                        text: 'New Post',
                                        icon: const Icon(CupertinoIcons.add),
                                        onPressed: _createNewPost),
                                  if (_userIsOwnerOrAdmin)
                                    BottomSheetMenuItem(
                                        text: 'Edit Club Info',
                                        icon: const Icon(CupertinoIcons.pencil),
                                        onPressed: () => context.navigateTo(
                                            ClubCreatorRoute(
                                                clubSummary: club))),
                                  if (!_userIsMember &&
                                      club.contentAccessScope ==
                                          ContentAccessScope.public)
                                    BottomSheetMenuItem(
                                        text: 'Join Club',
                                        icon: const Icon(CupertinoIcons.add),
                                        onPressed: () =>
                                            _addUserToPublicClub(club)),
                                  if (club.contentAccessScope ==
                                      ContentAccessScope.public)
                                    BottomSheetMenuItem(
                                        text: 'Share',
                                        icon: const Icon(
                                            CupertinoIcons.paperplane),
                                        onPressed: () => _shareClub(club)),
                                  if (!_userIsMember && !_userIsOwner)
                                    BottomSheetMenuItem(
                                        text: 'Leave Club',
                                        isDestructive: true,
                                        icon: const Icon(
                                          CupertinoIcons.square_arrow_right,
                                          color: Styles.errorRed,
                                        ),
                                        onPressed: () =>
                                            _confirmLeaveClub(club.id)),
                                  if (_userIsOwner)
                                    BottomSheetMenuItem(
                                        text: 'Shut Down Club',
                                        icon: const Icon(
                                          CupertinoIcons
                                              .exclamationmark_triangle,
                                          color: Styles.errorRed,
                                        ),
                                        isDestructive: true,
                                        onPressed: () =>
                                            _confirmDeleteClub(club)),
                                ]))),
                  ),
                  child: _userIsMember
                      ? FadeInUp(
                          child: ClubDetailsMembersPage(
                            club: club,
                            authedUserMemberType: _authedUserMemberType!,
                            stopPollingFeed: _stopPollingFeed,
                          ),
                        )
                      : ClubDetailsNonMembersPage(
                          club: club,
                          joinClub: () => _addUserToPublicClub(club),
                        ));
            });
  }
}
