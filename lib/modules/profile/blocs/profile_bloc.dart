import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ProfileBloc {
  static Future<void> updateUserFields(
      String id, Map<String, dynamic> data, VoidCallback onFail) async {
    final graphQLStore = GraphQLStore.store;
    final variables =
        UpdateUserProfileArguments(data: UpdateUserProfileInput.fromJson(data));

    final result = await graphQLStore.networkOnlyOperation(
        operation: UpdateUserProfileMutation(variables: variables),
        customVariablesMap: {'data': data});

    checkOperationResult(result, onFail: onFail, onSuccess: () {
      /// Write new user data to UserProfile object.
      final prev = graphQLStore.readDenomalized('$kUserProfileTypename:$id');

      var updated = <String, dynamic>{
        ...prev,
      };

      for (final key in data.keys) {
        updated[key] = result.data!.updateUserProfile.toJson()[key];
      }

      graphQLStore.writeDataToStore(
          data: updated, broadcastQueryIds: [GQLVarParamKeys.userProfile(id)]);
    });
  }
}
