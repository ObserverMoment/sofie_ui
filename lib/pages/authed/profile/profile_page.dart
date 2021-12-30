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
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final String _routeName;
  late String _authedUserId;

  void _updateProfileData() {
    context.graphQLStore
        .refetchQueriesByIds([GQLVarParamKeys.userProfile(_authedUserId)]);
  }

  @override
  void initState() {
    super.initState();
    _authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    _routeName = context.routeData.name;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Due to the complexity of the data on this page we do not want to have to run updates whenever some piece of data is updated by the user elsewhere in the app.
    /// Eg when the update a personal best score, or when they update one of their clubs.
    /// So we listen to the AutoRouter and check for when we are landing back on this page.
    context.router.root.removeListener(_didPopOrSwitchToThisRoute);
    context.router.root.addListener(_didPopOrSwitchToThisRoute);
  }

  void _didPopOrSwitchToThisRoute() {
    /// We need to run two checks.
    /// 1. is the AuthedRouter [router] currently showing the [MainTabsRoute].
    /// 2. Is the active tab route [tabsRouter] the same as [_routeName]
    if (context.router.currentChild?.name == MainTabsRoute.name &&
        _routeName == context.tabsRouter.current.name) {
      _updateProfileData();
    }
  }

  @override
  void dispose() {
    context.router.root.removeListener(_didPopOrSwitchToThisRoute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = UserProfileQuery(
        variables: UserProfileArguments(userId: _authedUserId));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key('ProfilePage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final profile = data.userProfile;

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
