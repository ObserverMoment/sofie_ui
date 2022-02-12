import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ClubUtils {
  static Future<UserClubMemberStatus?> checkAuthedUserMemberStatus(
      BuildContext context, String clubId) async {
    final result = await context.graphQLStore.networkOnlyOperation(
        operation: CheckUserClubMemberStatusQuery(
            variables: CheckUserClubMemberStatusArguments(clubId: clubId)));

    final success = checkOperationResult(context, result);

    if (success) {
      return result.data!.checkUserClubMemberStatus;
    } else {
      context.showToast(
          message: 'Sorry, there was a problem checking your membership.');
      return null;
    }
  }

  static bool userIsMember(UserClubMemberStatus clubMemberStatus) => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
        UserClubMemberStatus.member
      ].contains(clubMemberStatus);

  static bool userIsOwnerOrAdmin(UserClubMemberStatus clubMemberStatus) => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(clubMemberStatus);

  static bool userIsOwner(UserClubMemberStatus clubMemberStatus) =>
      clubMemberStatus == UserClubMemberStatus.owner;
}
