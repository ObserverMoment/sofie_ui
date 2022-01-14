import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_members_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_non_members_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/utils.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class ClubDetailsPage extends StatefulWidget {
  final String id;
  const ClubDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _ClubDetailsPageState createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  UserClubMemberStatus? _authedUserMemberType;

  Future<void> _checkUserMemberStatus() async {
    final status =
        await ClubUtils.checkAuthedUserMemberStatus(context, widget.id);

    setState(() {
      _authedUserMemberType = status ?? UserClubMemberStatus.none;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUserMemberStatus();
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

  bool get _userIsMember => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
        UserClubMemberStatus.member
      ].contains(_authedUserMemberType);

  Widget get _checkingMembershipPlaceholder => MyPageScaffold(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CupertinoActivityIndicator(
              radius: 12,
            ),
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
                  child: _userIsMember
                      ? FadeInUp(
                          child: ClubDetailsMembersPage(
                            club: club,
                            authedUserMemberType: _authedUserMemberType!,
                            checkUserMemberStatus: _checkUserMemberStatus,
                          ),
                        )
                      : ClubDetailsNonMembersPage(
                          club: club,
                          joinClub: () => _addUserToPublicClub(club),
                        ));
            });
  }
}
