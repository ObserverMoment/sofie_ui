import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubUtils {
  static Future<UserClubMemberStatus?> checkAuthedUserMemberStatus(
      BuildContext context, String clubId, VoidCallback onFail) async {
    final result = await GraphQLStore.store.networkOnlyOperation(
        operation: CheckUserClubMemberStatusQuery(
            variables: CheckUserClubMemberStatusArguments(clubId: clubId)));

    final success = checkOperationResult(result);

    if (success) {
      return result.data!.checkUserClubMemberStatus;
    } else {
      onFail();
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
