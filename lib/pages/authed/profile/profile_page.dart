import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/profile/user_profile_display.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> updateUserFields(
      BuildContext context, String id, String key, dynamic value) async {
    final variables =
        UpdateUserArguments(data: UpdateUserInput.fromJson({key: value}));

    await context.graphQLStore.mutate(
      mutation: UpdateUserMutation(variables: variables),
      customVariablesMap: {
        'data': {key: value}
      },
      broadcastQueryIds: [AuthedUserQuery().operationName],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    final query = UserPublicProfileByIdQuery(
        variables: UserPublicProfileByIdArguments(userId: authedUserId));

    return QueryObserver<UserPublicProfileById$Query,
            UserPublicProfileByIdArguments>(
        key: Key('ProfilePage - ${query.operationName}'),
        query: query,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final profile = data.userPublicProfileById;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavBarLargeTitle(profile.displayName),
                  ],
                ),
                withoutLeading: true,
                trailing: NavBarTrailingRow(children: [
                  TertiaryButton(
                      prefixIconData: CupertinoIcons.pencil,
                      text: 'Edit',
                      onPressed: () =>
                          context.navigateTo(const EditProfileRoute())),
                  CupertinoButton(
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(
                        CupertinoIcons.gear,
                      ),
                      onPressed: () =>
                          context.navigateTo(const SettingsRoute()))
                ]),
              ),
              child: UserProfileDisplay(
                profile: profile,
              ));
        });
  }
}
