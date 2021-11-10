import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/move_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/workout_plan_filters_bloc.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/uploadcare.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(kSettingsHiveBoxName);
  await Hive.openBox(GraphQLStore.boxName);

  /// Once we have ensured that clean up and garbage collection is working well.
  /// TODO: Remove this before pushing anything to production.
  await Hive.box(GraphQLStore.boxName).clear();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: material.Colors.transparent,
    // Default to light initially - this needs to be updated to dark if the user selects light theme.
    statusBarIconBrightness: Brightness.light,
  ));

  // Global services that have no deps.
  GetIt.I.registerSingleton<UploadcareService>(UploadcareService());
  GetIt.I.registerSingleton<Logger>(Logger());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const AuthRouter()));
}

class AuthRouter extends StatefulWidget {
  const AuthRouter({Key? key}) : super(key: key);
  @override
  _AuthRouterState createState() => _AuthRouterState();
}

class _AuthRouterState extends State<AuthRouter> {
  final _authBloc = AuthBloc();
  final _appRouter = AppRouter();
  late Brightness _userDeviceBrightness;

  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton<AuthBloc>(_authBloc);

    _userDeviceBrightness =
        SchedulerBinding.instance?.window.platformBrightness ?? Brightness.dark;
  }

  @override
  void dispose() {
    GetIt.I.unregister<AuthBloc>(
      instance: _authBloc,
      disposingFunction: (bloc) => bloc.dispose(),
    );
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthState>(
        valueListenable: GetIt.I<AuthBloc>().authState,
        builder: (context, authState, _) {
          final _authedUser = GetIt.I<AuthBloc>().authedUser;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeBloc>(
                  create: (_) =>
                      ThemeBloc(deviceBrightness: _userDeviceBrightness)),
              Provider<GraphQLStore>(
                create: (_) => GraphQLStore(),
                dispose: (context, store) => store.dispose(),
              ),
              ChangeNotifierProvider<MoveFiltersBloc>(
                  create: (_) => MoveFiltersBloc()),
              ChangeNotifierProvider<WorkoutFiltersBloc>(
                  create: (_) => WorkoutFiltersBloc()),
              ChangeNotifierProvider<WorkoutPlanFiltersBloc>(
                  create: (_) => WorkoutPlanFiltersBloc()),
            ],
            builder: (context, child) => material.Theme(
              data: material.ThemeData(
                  scaffoldBackgroundColor: context.theme.background),
              child: _Unfocus(
                  child: CupertinoApp.router(
                routeInformationParser:
                    _appRouter.defaultRouteParser(includePrefixMatches: true),
                routerDelegate: AutoRouterDelegate.declarative(
                  _appRouter,
                  routes: (_) => [
                    // if the user is logged in, they may proceed to the main App
                    if (authState == AuthState.authed && _authedUser != null)
                      const AuthedRouter()
                    // if they are not logged in, bring them to the Login page
                    else if (authState == AuthState.validating ||
                        authState == AuthState.unknown)
                      const GlobalLoadingRoute()
                    else
                      const UnauthedLandingRoute(),
                  ],
                ),
                debugShowCheckedModeBanner: false,
                theme: context.theme.cupertinoThemeData,
                localizationsDelegates: const [
                  material.DefaultMaterialLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('en', 'GB'),
                ],
              )),
            ),
          );
        });
  }
}

/// Blank placeholder page.
class GlobalLoadingPage extends StatelessWidget {
  const GlobalLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(child: SizedBox.expand());
  }
}

/// A widget that unfocus everything when tapped.
///
/// This implements the "Unfocus when tapping in empty space" behavior for the
/// entire application.
class _Unfocus extends StatelessWidget {
  const _Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
