import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/club/invites/club_invite_token_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ClubDetailsInvitesManager extends StatelessWidget {
  final String clubId;
  const ClubDetailsInvitesManager({Key? key, required this.clubId})
      : super(key: key);

  Widget _buildTokenRowButton(IconData iconData, VoidCallback onPressed) =>
      CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          onPressed: onPressed,
          child: Icon(iconData, size: 20));

  void _confirmDeleteToken(BuildContext context, ClubInviteToken token) {
    context.showConfirmDeleteDialog(
        itemType: 'Invite Link',
        message: 'This cannot be un-done and the link will become inactive.',
        onConfirm: () => _deleteClubInviteToken(context, token));
  }

  Future<void> _deleteClubInviteToken(
      BuildContext context, ClubInviteToken token) async {
    final variables = DeleteClubInviteTokenArguments(
        data: DeleteClubInviteTokenInput(clubId: clubId, tokenId: token.id));

    final result = await context.graphQLStore
        .mutate<DeleteClubInviteToken$Mutation, DeleteClubInviteTokenArguments>(
      mutation: DeleteClubInviteTokenMutation(variables: variables),
      broadcastQueryIds: [GQLVarParamKeys.clubInviteTokens(clubId)],
    );

    checkOperationResult(context, result,
        onFail: () => context.showErrorAlert(
            'Sorry there was a problem deleting this invite link.'));
  }

  @override
  Widget build(BuildContext context) {
    final query = ClubInviteTokensQuery(
        variables: ClubInviteTokensArguments(clubId: clubId));

    return QueryObserver<ClubInviteTokens$Query, ClubInviteTokensArguments>(
        key: Key('ClubDetailsInvitesManager - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final sortedInviteTokens = data.clubInviteTokens.tokens
              .sortedBy<DateTime>((t) => t.createdAt)
              .reversed
              .toList();

          return MyPageScaffold(
            child: NestedScrollView(
                headerSliverBuilder: (c, i) =>
                    [const MySliverNavbar(title: 'Invites Manager')],
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.mail,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                MyHeaderText(
                                  'Invite Links (${sortedInviteTokens.length})',
                                  size: FONTSIZE.four,
                                )
                              ],
                            ),
                            TertiaryButton(
                                prefixIconData: CupertinoIcons.add,
                                text: 'Invite Link',
                                onPressed: () => context.push(
                                        child: ClubInviteTokenCreator(
                                      clubId: clubId,
                                    )))
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: sortedInviteTokens.isEmpty
                              ? const Center(child: MyText('No invite links'))
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortedInviteTokens.length,
                                  itemBuilder: (c, i) {
                                    final token = sortedInviteTokens[i];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: context.theme.primary
                                                  .withOpacity(0.2))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  token.name,
                                                  lineHeight: 1.3,
                                                ),
                                                MyText(
                                                  token.inviteLimit == 0
                                                      ? '${token.joinedUserIds.length} of unlimited used'
                                                      : '${token.joinedUserIds.length} of ${token.inviteLimit} used',
                                                  color: token.inviteLimit !=
                                                              0 &&
                                                          token.joinedUserIds
                                                                  .length >=
                                                              token.inviteLimit
                                                      ? Styles.errorRed
                                                      : Styles.primaryAccent,
                                                  lineHeight: 1.3,
                                                ),
                                                MyText(
                                                  'Created ${token.createdAt.minimalDateString}',
                                                  size: FONTSIZE.one,
                                                  subtext: true,
                                                  lineHeight: 1.4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              _buildTokenRowButton(
                                                  CupertinoIcons.paperplane,
                                                  () => SharingAndLinking
                                                      .shareClubInviteLink(
                                                          token.id)),
                                              _buildTokenRowButton(
                                                  CupertinoIcons.pencil,
                                                  () => context.push(
                                                          child:
                                                              ClubInviteTokenCreator(
                                                        token: token,
                                                        clubId: clubId,
                                                      ))),
                                              _buildTokenRowButton(
                                                CupertinoIcons.trash,
                                                () => _confirmDeleteToken(
                                                    context, token),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                    ],
                  ),
                )),
          );
        });
  }
}
