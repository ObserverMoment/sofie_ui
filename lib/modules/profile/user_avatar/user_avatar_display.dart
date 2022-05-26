import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class UserAvatarDisplay extends StatelessWidget {
  final double size;
  final bool withBorder;
  const UserAvatarDisplay({Key? key, this.size = 100, this.withBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserProfileQuery(
        variables:
            UserProfileArguments(userId: GetIt.I<AuthBloc>().authedUser!.id));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key('ProfilePage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          return UserAvatar(
            avatarUri: data.userProfile?.avatarUri,
            size: size,
            border: withBorder,
            borderWidth: 2,
          );
        });
  }
}
