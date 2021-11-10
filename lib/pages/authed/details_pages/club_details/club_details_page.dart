import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
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

class ClubDetailsPage extends StatefulWidget {
  final String id;
  const ClubDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _ClubDetailsPageState createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  bool _stopPollingFeed = false;

  Future<void> _createNewPost() async {
    await context.navigateTo(ClubPostCreatorRoute(
        clubId: widget.id,
        onSuccess: (_) => context.showToast(
            message: 'Post created. It will display shortly.')));
  }

  Future<void> _shareClub(Club club) async {
    await SharingAndLinking.shareLink(
        'club/${club.id}', 'Check out this club!');
  }

  Future<void> _addUserToPublicClub(Club club) async {
    if (club.contentAccessScope == ContentAccessScope.public) {
      context.showToast(
        message: 'Joining Club! Just a second...',
      );

      final variables = UserJoinPublicClubArguments(clubId: club.id);

      final result = await context.graphQLStore.networkOnlyOperation<
              UserJoinPublicClub$Mutation, UserJoinPublicClubArguments>(
          operation: UserJoinPublicClubMutation(variables: variables));

      await checkOperationResult(context, result, onSuccess: () async {
        await context.graphQLStore.query<ClubById$Query, ClubByIdArguments>(
            query: ClubByIdQuery(variables: ClubByIdArguments(id: widget.id)),
            broadcastQueryIds: [GQLVarParamKeys.clubByIdQuery(widget.id)]);

        /// Manually add the ref to the Club to [userClubs] query.
        /// Necessary as the return type from [userClubs] is a ClubSummary (so the ID will need to be be ClubSummary:12345 - not Club:12345) whereas return type from the above mutation is a Club.
        context.graphQLStore.addRefToQueryData(data: {
          'id': result.data!.userJoinPublicClub,
          '__typename': 'ClubSummary'
        }, queryIds: [
          GQLOpNames.userClubsQuery
        ]);

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

  void _confirmDeleteClub(String clubName) {
    context.showConfirmDeleteDialog(
        message:
            'Warning: This cannot be undone and will result in the deletion of all data, chat and timeline history from this club!',
        itemName: clubName,
        itemType: 'Club',
        onConfirm: () async {
          setState(() {
            _stopPollingFeed = true;
          });
          try {
            await context.graphQLStore
                .delete<DeleteClubById$Mutation, DeleteClubByIdArguments>(
                    mutation: DeleteClubByIdMutation(
                        variables: DeleteClubByIdArguments(id: widget.id)),
                    objectId: widget.id,
                    typename: kClubTypeName,
                    removeAllRefsToId: true,
                    clearQueryDataAtKeys: [
                  GQLVarParamKeys.clubByIdQuery(widget.id),
                ],
                    removeRefFromQueries: [
                  GQLOpNames.userClubsQuery
                ]);
            context.pop();
          } catch (e) {
            printLog(e.toString());
            context.showToast(
                message: 'Sorry, there was a problem deleting this club!',
                toastType: ToastType.destructive);
          }
        });
  }

  void _confirmLeaveClub(String authedUserId, String clubId) {
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
              clearQueryDataAtKeys: [GQLVarParamKeys.clubByIdQuery(clubId)],
            );

            await checkOperationResult(context, result,
                onSuccess: () {
                  /// Manually remove the ref to the Club from [userClubs] query.
                  /// Necessary as the return type from [userClubs] is a ClubSummary (so the ID will be ClubSummary:12345 - not Club:12345) whereas return type from the above mutation is a Club.
                  context.graphQLStore.removeRefFromQueryData(
                      data: {'id': clubId, '__typename': 'ClubSummary'},
                      queryIds: [GQLOpNames.userClubsQuery]);

                  context.pop();
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

  @override
  Widget build(BuildContext context) {
    final query = ClubByIdQuery(variables: ClubByIdArguments(id: widget.id));
    return QueryObserver<ClubById$Query, ClubByIdArguments>(
        key: Key('ClubDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        loadingIndicator: const ShimmerDetailsPage(title: 'Getting Ready'),
        builder: (data) {
          final club = data.clubById;

          /// Club data fields which are above the users access level will be returned as null.
          /// E.g. Workouts, Plans etc will be null if the user is not a member.
          /// We will also show a different UI - one which shows a summary and allows the user to join if the club is public.

          final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
          final userIsOwner = authedUserId == club.owner.id;
          final userIsAdmin = club.admins.any((a) => a.id == authedUserId);
          final isOwnerOrAdmin = userIsOwner || userIsAdmin;

          final userIsMember = userIsOwner ||
              userIsAdmin ||
              club.members.any((m) => m.id == authedUserId);

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
              trailing: NavBarTrailingRow(
                children: [
                  if (userIsMember)
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context
                            .navigateTo(ClubMembersChatRoute(clubId: club.id)),
                        child: const Icon(CupertinoIcons.chat_bubble_2)),
                  CupertinoButton(
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
                                if (!userIsMember &&
                                    club.contentAccessScope ==
                                        ContentAccessScope.public)
                                  BottomSheetMenuItem(
                                      text: 'Join',
                                      icon: const Icon(CupertinoIcons.add),
                                      onPressed: () =>
                                          _addUserToPublicClub(club)),
                                if (club.contentAccessScope ==
                                    ContentAccessScope.public)
                                  BottomSheetMenuItem(
                                      text: 'Share',
                                      icon:
                                          const Icon(CupertinoIcons.paperplane),
                                      onPressed: () => _shareClub(club)),
                                if (isOwnerOrAdmin)
                                  BottomSheetMenuItem(
                                      text: 'Manage',
                                      icon: const Icon(CupertinoIcons.pencil),
                                      onPressed: () => context.navigateTo(
                                          ClubCreatorRoute(club: club))),
                                if (isOwnerOrAdmin)
                                  BottomSheetMenuItem(
                                      text: 'New Post',
                                      icon: const Icon(CupertinoIcons.add),
                                      onPressed: _createNewPost),
                                if (userIsMember && !userIsOwner)
                                  BottomSheetMenuItem(
                                      text: 'Leave Club',
                                      isDestructive: true,
                                      icon: const Icon(
                                        CupertinoIcons.square_arrow_right,
                                        color: Styles.errorRed,
                                      ),
                                      onPressed: () => _confirmLeaveClub(
                                          authedUserId, club.id)),
                                if (userIsOwner)
                                  BottomSheetMenuItem(
                                      text: 'Shut Down Club',
                                      icon: const Icon(
                                        CupertinoIcons.exclamationmark_triangle,
                                        color: Styles.errorRed,
                                      ),
                                      isDestructive: true,
                                      onPressed: () =>
                                          _confirmDeleteClub(club.name)),
                              ])))
                ],
              ),
            ),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  if (Utils.textNotNull(club.coverImageUri))
                    SizedBox(
                      height: 180,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedUploadcareImage(club.coverImageUri!,
                              fit: BoxFit.cover),
                        ],
                      ),
                    ),
                ]))
              ],
              body: userIsMember
                  ? FadeInUp(
                      child: ClubDetailsMembersPage(
                        club: club,
                        isOwnerOrAdmin: isOwnerOrAdmin,
                        stopPollingFeed: _stopPollingFeed,
                      ),
                    )
                  : ClubDetailsNonMembersPage(
                      club: club,
                      joinClub: () => _addUserToPublicClub(club),
                      members: [...club.admins, ...club.members]),
            ),
          );
        });
  }
}
