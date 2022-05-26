import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/components/user_profile_display.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
          if (data.userProfile == null) {
            return const ObjectNotFoundIndicator();
          }

          final profile = data.userProfile!;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarLargeTitle(profile.displayName),
              ),
              child: UserProfileDisplay(
                profile: profile,
              ));
        });
  }
}
