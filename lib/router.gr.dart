// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i53;
import 'package:flutter/cupertino.dart' as _i61;
import 'package:flutter/material.dart' as _i60;

import 'components/creators/body_tracking/body_tracking_entry_creator.dart'
    as _i35;
import 'components/creators/club_creator/club_creator.dart' as _i36;
import 'components/creators/collection_creator.dart' as _i37;
import 'components/creators/custom_move_creator/custom_move_creator.dart'
    as _i38;
import 'components/creators/gym_profile_creator.dart' as _i39;
import 'components/creators/logged_workout_creator/logged_workout_creator.dart'
    as _i46;
import 'components/creators/personal_best_creator/personal_best_creator.dart'
    as _i41;
import 'components/creators/post_creator/club_post_creator.dart' as _i43;
import 'components/creators/post_creator/post_creator.dart' as _i42;
import 'components/creators/progress_journal_creator/progress_journal_creator.dart'
    as _i40;
import 'components/creators/scheduled_workout_creator.dart' as _i44;
import 'components/creators/workout_creator/workout_creator.dart' as _i45;
import 'components/creators/workout_plan_creator/workout_plan_creator.dart'
    as _i47;
import 'components/creators/workout_plan_review_creator.dart' as _i48;
import 'components/do_workout/do_workout_wrapper_page.dart' as _i11;
import 'components/social/chat/chats_overview_page.dart' as _i6;
import 'components/social/chat/club_members_chat_page.dart' as _i8;
import 'components/social/chat/one_to_one_chat_page.dart' as _i7;
import 'components/timers/timers_page.dart' as _i13;
import 'components/workout/workout_finders/public/public_workout_finder_page.dart'
    as _i23;
import 'components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart'
    as _i24;
import 'generated/api/graphql_api.dart' as _i62;
import 'main.dart' as _i2;
import 'pages/authed/authed_routes_wrapper_page.dart' as _i3;
import 'pages/authed/details_pages/club_details/club_details_page.dart' as _i27;
import 'pages/authed/details_pages/collection_details_page.dart' as _i10;
import 'pages/authed/details_pages/logged_workout_details_page.dart' as _i28;
import 'pages/authed/details_pages/personal_best_details_page.dart' as _i29;
import 'pages/authed/details_pages/progress_journal_details_page.dart' as _i31;
import 'pages/authed/details_pages/user_public_profile_details_page.dart'
    as _i30;
import 'pages/authed/details_pages/workout_details_page.dart' as _i32;
import 'pages/authed/details_pages/workout_plan_details_page.dart' as _i33;
import 'pages/authed/details_pages/workout_plan_enrolment_details_page.dart'
    as _i34;
import 'pages/authed/discover/discover_clubs_page.dart' as _i26;
import 'pages/authed/discover/discover_page.dart' as _i50;
import 'pages/authed/discover/discover_people_page.dart' as _i25;
import 'pages/authed/home/home_page.dart' as _i52;
import 'pages/authed/home/your_clubs.dart' as _i14;
import 'pages/authed/home/your_collections.dart' as _i15;
import 'pages/authed/home/your_gym_profiles.dart' as _i16;
import 'pages/authed/home/your_moves_library.dart' as _i17;
import 'pages/authed/home/your_plans/your_plans.dart' as _i18;
import 'pages/authed/home/your_schedule.dart' as _i20;
import 'pages/authed/home/your_throwdowns.dart' as _i21;
import 'pages/authed/home/your_workouts/your_workouts.dart' as _i22;
import 'pages/authed/landing_pages/club_invite_landing_page.dart' as _i9;
import 'pages/authed/main_tabs_page.dart' as _i4;
import 'pages/authed/page_not_found.dart' as _i49;
import 'pages/authed/profile/archive_page.dart' as _i5;
import 'pages/authed/profile/profile_page.dart' as _i54;
import 'pages/authed/profile/settings.dart' as _i12;
import 'pages/authed/progress/body_tracking_page.dart' as _i58;
import 'pages/authed/progress/journals_page.dart' as _i57;
import 'pages/authed/progress/logged_workouts_page.dart' as _i59;
import 'pages/authed/progress/personal_bests_page.dart' as _i56;
import 'pages/authed/progress/progress_page.dart' as _i55;
import 'pages/authed/social/social_page.dart' as _i51;
import 'pages/authed/social/your_posts_page.dart' as _i19;
import 'pages/unauthed/unauthed_landing.dart' as _i1;

class AppRouter extends _i53.RootStackRouter {
  AppRouter([_i60.GlobalKey<_i60.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i53.PageFactory> pagesMap = {
    UnauthedLandingRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i1.UnauthedLandingPage(),
          fullscreenDialog: true);
    },
    GlobalLoadingRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i2.GlobalLoadingPage(),
          fullscreenDialog: true);
    },
    AuthedRouter.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i3.AuthedRoutesWrapperPage(),
          fullscreenDialog: true);
    },
    MainTabsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.MainTabsPage());
    },
    ArchiveRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i5.ArchivePage());
    },
    ChatsOverviewRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i6.ChatsOverviewPage());
    },
    OneToOneChatRoute.name: (routeData) {
      final args = routeData.argsAs<OneToOneChatRouteArgs>();
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i7.OneToOneChatPage(
              key: args.key, otherUserId: args.otherUserId));
    },
    ClubMembersChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClubMembersChatRouteArgs>();
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i8.ClubMembersChatPage(key: args.key, clubId: args.clubId));
    },
    ClubInviteLandingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubInviteLandingRouteArgs>(
          orElse: () =>
              ClubInviteLandingRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i9.ClubInviteLandingPage(key: args.key, id: args.id));
    },
    CollectionDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CollectionDetailsRouteArgs>(
          orElse: () =>
              CollectionDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i10.CollectionDetailsPage(key: args.key, id: args.id));
    },
    DoWorkoutWrapperRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DoWorkoutWrapperRouteArgs>(
          orElse: () =>
              DoWorkoutWrapperRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i11.DoWorkoutWrapperPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout));
    },
    SettingsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i12.SettingsPage());
    },
    TimersRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i13.TimersPage());
    },
    YourClubsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i14.YourClubsPage());
    },
    YourCollectionsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i15.YourCollectionsPage());
    },
    YourGymProfilesRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i16.YourGymProfilesPage());
    },
    YourMovesLibraryRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i17.YourMovesLibraryPage());
    },
    YourPlansRoute.name: (routeData) {
      final args = routeData.argsAs<YourPlansRouteArgs>(
          orElse: () => const YourPlansRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i18.YourPlansPage(
              key: args.key,
              selectPlan: args.selectPlan,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showJoined: args.showJoined,
              showSaved: args.showSaved));
    },
    YourPostsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i19.YourPostsPage());
    },
    YourScheduleRoute.name: (routeData) {
      final args = routeData.argsAs<YourScheduleRouteArgs>(
          orElse: () => const YourScheduleRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i20.YourSchedulePage(
              key: args.key, openAtDate: args.openAtDate));
    },
    YourThrowdownsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i21.YourThrowdownsPage());
    },
    YourWorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<YourWorkoutsRouteArgs>(
          orElse: () => const YourWorkoutsRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i22.YourWorkoutsPage(
              key: args.key,
              selectWorkout: args.selectWorkout,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showSaved: args.showSaved));
    },
    PublicWorkoutFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutFinderRouteArgs>(
          orElse: () => const PublicWorkoutFinderRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i23.PublicWorkoutFinderPage(
              key: args.key, selectWorkout: args.selectWorkout));
    },
    PublicWorkoutPlanFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutPlanFinderRouteArgs>(
          orElse: () => const PublicWorkoutPlanFinderRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i24.PublicWorkoutPlanFinderPage(
              key: args.key, selectWorkoutPlan: args.selectWorkoutPlan));
    },
    DiscoverPeopleRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i25.DiscoverPeoplePage());
    },
    DiscoverClubsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i26.DiscoverClubsPage());
    },
    ClubDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubDetailsRouteArgs>(
          orElse: () => ClubDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i27.ClubDetailsPage(key: args.key, id: args.id));
    },
    LoggedWorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoggedWorkoutDetailsRouteArgs>(
          orElse: () =>
              LoggedWorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i28.LoggedWorkoutDetailsPage(key: args.key, id: args.id));
    },
    PersonalBestDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PersonalBestDetailsRouteArgs>(
          orElse: () =>
              PersonalBestDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i29.PersonalBestDetailsPage(key: args.key, id: args.id));
    },
    UserPublicProfileDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicProfileDetailsRouteArgs>(
          orElse: () => UserPublicProfileDetailsRouteArgs(
              userId: pathParams.getString('userId')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i30.UserPublicProfileDetailsPage(
              key: args.key, userId: args.userId));
    },
    ProgressJournalDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProgressJournalDetailsRouteArgs>(
          orElse: () =>
              ProgressJournalDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i31.ProgressJournalDetailsPage(key: args.key, id: args.id));
    },
    WorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutDetailsRouteArgs>(
          orElse: () =>
              WorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i32.WorkoutDetailsPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout));
    },
    WorkoutPlanDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanDetailsRouteArgs>(
          orElse: () =>
              WorkoutPlanDetailsRouteArgs(id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i33.WorkoutPlanDetailsPage(key: args.key, id: args.id));
    },
    WorkoutPlanEnrolmentDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanEnrolmentDetailsRouteArgs>(
          orElse: () => WorkoutPlanEnrolmentDetailsRouteArgs(
              id: pathParams.getString('id')));
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child:
              _i34.WorkoutPlanEnrolmentDetailsPage(key: args.key, id: args.id));
    },
    BodyTrackingEntryCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<BodyTrackingEntryCreatorRouteArgs>(
          orElse: () => const BodyTrackingEntryCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i35.BodyTrackingEntryCreatorPage(
              key: args.key, bodyTrackingEntry: args.bodyTrackingEntry));
    },
    ClubCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubCreatorRouteArgs>(
          orElse: () => const ClubCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i36.ClubCreatorPage(key: args.key, club: args.club));
    },
    CollectionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionCreatorRouteArgs>(
          orElse: () => const CollectionCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i37.CollectionCreatorPage(
              key: args.key,
              collection: args.collection,
              onComplete: args.onComplete));
    },
    CustomMoveCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CustomMoveCreatorRouteArgs>(
          orElse: () => const CustomMoveCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i38.CustomMoveCreatorPage(key: args.key, move: args.move));
    },
    GymProfileCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfileCreatorRouteArgs>(
          orElse: () => const GymProfileCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i39.GymProfileCreatorPage(
              key: args.key, gymProfile: args.gymProfile));
    },
    ProgressJournalCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ProgressJournalCreatorRouteArgs>(
          orElse: () => const ProgressJournalCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i40.ProgressJournalCreatorPage(
              key: args.key, progressJournal: args.progressJournal));
    },
    PersonalBestCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalBestCreatorRouteArgs>(
          orElse: () => const PersonalBestCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i41.PersonalBestCreatorPage(
              key: args.key, userBenchmark: args.userBenchmark));
    },
    PostCreatorRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i42.PostCreatorPage());
    },
    ClubPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubPostCreatorRouteArgs>();
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i43.ClubPostCreatorPage(
              key: args.key, clubId: args.clubId, onSuccess: args.onSuccess));
    },
    ScheduledWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduledWorkoutCreatorRouteArgs>(
          orElse: () => const ScheduledWorkoutCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i44.ScheduledWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workout: args.workout,
              scheduleOn: args.scheduleOn,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutCreatorRouteArgs>(
          orElse: () => const WorkoutCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i45.WorkoutCreatorPage(key: args.key, workout: args.workout));
    },
    LoggedWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutCreatorRouteArgs>();
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i46.LoggedWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workoutId: args.workoutId));
    },
    WorkoutPlanCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanCreatorRouteArgs>(
          orElse: () => const WorkoutPlanCreatorRouteArgs());
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i47.WorkoutPlanCreatorPage(
              key: args.key, workoutPlan: args.workoutPlan));
    },
    WorkoutPlanReviewCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanReviewCreatorRouteArgs>();
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i48.WorkoutPlanReviewCreatorPage(
              key: args.key,
              workoutPlanReview: args.workoutPlanReview,
              parentWorkoutPlanId: args.parentWorkoutPlanId,
              parentWorkoutPlanEnrolmentId: args.parentWorkoutPlanEnrolmentId));
    },
    RouteNotFoundRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i49.PageNotFoundPage());
    },
    DiscoverRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i50.DiscoverPage());
    },
    SocialRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i51.SocialPage());
    },
    HomeRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i52.HomePage());
    },
    ProgressStack.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i53.EmptyRouterPage());
    },
    ProfileRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i54.ProfilePage());
    },
    ProgressRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i55.ProgressPage());
    },
    PersonalBestsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i56.PersonalBestsPage());
    },
    JournalsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i57.JournalsPage());
    },
    BodyTrackingRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i58.BodyTrackingPage());
    },
    LoggedWorkoutsRoute.name: (routeData) {
      return _i53.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i59.LoggedWorkoutsPage());
    }
  };

  @override
  List<_i53.RouteConfig> get routes => [
        _i53.RouteConfig(UnauthedLandingRoute.name, path: '/auth'),
        _i53.RouteConfig(GlobalLoadingRoute.name, path: '/loading'),
        _i53.RouteConfig(AuthedRouter.name, path: '/', children: [
          _i53.RouteConfig(MainTabsRoute.name,
              path: '',
              parent: AuthedRouter.name,
              children: [
                _i53.RouteConfig(DiscoverRoute.name,
                    path: '', parent: MainTabsRoute.name),
                _i53.RouteConfig(SocialRoute.name,
                    path: 'social', parent: MainTabsRoute.name),
                _i53.RouteConfig(HomeRoute.name,
                    path: 'studio', parent: MainTabsRoute.name),
                _i53.RouteConfig(ProgressStack.name,
                    path: 'progress',
                    parent: MainTabsRoute.name,
                    children: [
                      _i53.RouteConfig(ProgressRoute.name,
                          path: '', parent: ProgressStack.name),
                      _i53.RouteConfig(PersonalBestsRoute.name,
                          path: 'personal-bests', parent: ProgressStack.name),
                      _i53.RouteConfig(JournalsRoute.name,
                          path: 'journals', parent: ProgressStack.name),
                      _i53.RouteConfig(BodyTrackingRoute.name,
                          path: 'body-tracking', parent: ProgressStack.name),
                      _i53.RouteConfig(LoggedWorkoutsRoute.name,
                          path: 'workout-logs', parent: ProgressStack.name)
                    ]),
                _i53.RouteConfig(ProfileRoute.name,
                    path: 'profile', parent: MainTabsRoute.name)
              ]),
          _i53.RouteConfig(ArchiveRoute.name,
              path: 'archive', parent: AuthedRouter.name),
          _i53.RouteConfig(ChatsOverviewRoute.name,
              path: 'chats', parent: AuthedRouter.name),
          _i53.RouteConfig(OneToOneChatRoute.name,
              path: 'chat', parent: AuthedRouter.name),
          _i53.RouteConfig(ClubMembersChatRoute.name,
              path: 'club-chat', parent: AuthedRouter.name),
          _i53.RouteConfig(ClubInviteLandingRoute.name,
              path: 'club-invite/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(CollectionDetailsRoute.name,
              path: 'collection/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(DoWorkoutWrapperRoute.name,
              path: 'do-workout/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: AuthedRouter.name),
          _i53.RouteConfig(TimersRoute.name,
              path: 'timers', parent: AuthedRouter.name),
          _i53.RouteConfig(YourClubsRoute.name,
              path: 'your-clubs', parent: AuthedRouter.name),
          _i53.RouteConfig(YourCollectionsRoute.name,
              path: 'your-collections', parent: AuthedRouter.name),
          _i53.RouteConfig(YourGymProfilesRoute.name,
              path: 'your-gym-profiles', parent: AuthedRouter.name),
          _i53.RouteConfig(YourMovesLibraryRoute.name,
              path: 'your-moves', parent: AuthedRouter.name),
          _i53.RouteConfig(YourPlansRoute.name,
              path: 'your-plans', parent: AuthedRouter.name),
          _i53.RouteConfig(YourPostsRoute.name,
              path: 'your-posts', parent: AuthedRouter.name),
          _i53.RouteConfig(YourScheduleRoute.name,
              path: 'your-schedule', parent: AuthedRouter.name),
          _i53.RouteConfig(YourThrowdownsRoute.name,
              path: 'your-throwdowns', parent: AuthedRouter.name),
          _i53.RouteConfig(YourWorkoutsRoute.name,
              path: 'your-workouts', parent: AuthedRouter.name),
          _i53.RouteConfig(PublicWorkoutFinderRoute.name,
              path: 'public-workouts', parent: AuthedRouter.name),
          _i53.RouteConfig(PublicWorkoutPlanFinderRoute.name,
              path: 'public-plans', parent: AuthedRouter.name),
          _i53.RouteConfig(DiscoverPeopleRoute.name,
              path: 'discover-people', parent: AuthedRouter.name),
          _i53.RouteConfig(DiscoverClubsRoute.name,
              path: 'discover-clubs', parent: AuthedRouter.name),
          _i53.RouteConfig(ClubDetailsRoute.name,
              path: 'club/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(LoggedWorkoutDetailsRoute.name,
              path: 'logged-workout/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(PersonalBestDetailsRoute.name,
              path: 'personal-best/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(UserPublicProfileDetailsRoute.name,
              path: 'profile/:userId', parent: AuthedRouter.name),
          _i53.RouteConfig(ProgressJournalDetailsRoute.name,
              path: 'progress-journal/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(WorkoutDetailsRoute.name,
              path: 'workout/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(WorkoutPlanDetailsRoute.name,
              path: 'workout-plan/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(WorkoutPlanEnrolmentDetailsRoute.name,
              path: 'workout-plan-progress/:id', parent: AuthedRouter.name),
          _i53.RouteConfig(BodyTrackingEntryCreatorRoute.name,
              path: 'create/body-tracking', parent: AuthedRouter.name),
          _i53.RouteConfig(ClubCreatorRoute.name,
              path: 'create/club', parent: AuthedRouter.name),
          _i53.RouteConfig(CollectionCreatorRoute.name,
              path: 'create/collection', parent: AuthedRouter.name),
          _i53.RouteConfig(CustomMoveCreatorRoute.name,
              path: 'create/custom-move', parent: AuthedRouter.name),
          _i53.RouteConfig(GymProfileCreatorRoute.name,
              path: 'create/gym-profile', parent: AuthedRouter.name),
          _i53.RouteConfig(ProgressJournalCreatorRoute.name,
              path: 'create/journal', parent: AuthedRouter.name),
          _i53.RouteConfig(PersonalBestCreatorRoute.name,
              path: 'create/personal-best', parent: AuthedRouter.name),
          _i53.RouteConfig(PostCreatorRoute.name,
              path: 'create/post', parent: AuthedRouter.name),
          _i53.RouteConfig(ClubPostCreatorRoute.name,
              path: 'create/club-post', parent: AuthedRouter.name),
          _i53.RouteConfig(ScheduledWorkoutCreatorRoute.name,
              path: 'create/scheduled-workout', parent: AuthedRouter.name),
          _i53.RouteConfig(WorkoutCreatorRoute.name,
              path: 'create/workout', parent: AuthedRouter.name),
          _i53.RouteConfig(LoggedWorkoutCreatorRoute.name,
              path: 'create/workout-log', parent: AuthedRouter.name),
          _i53.RouteConfig(WorkoutPlanCreatorRoute.name,
              path: 'create/workout-plan', parent: AuthedRouter.name),
          _i53.RouteConfig(WorkoutPlanReviewCreatorRoute.name,
              path: 'create/workout-plan-review', parent: AuthedRouter.name),
          _i53.RouteConfig(RouteNotFoundRoute.name,
              path: '404', parent: AuthedRouter.name),
          _i53.RouteConfig('*#redirect',
              path: '*',
              parent: AuthedRouter.name,
              redirectTo: '404',
              fullMatch: true)
        ])
      ];
}

/// generated route for [_i1.UnauthedLandingPage]
class UnauthedLandingRoute extends _i53.PageRouteInfo<void> {
  const UnauthedLandingRoute() : super(name, path: '/auth');

  static const String name = 'UnauthedLandingRoute';
}

/// generated route for [_i2.GlobalLoadingPage]
class GlobalLoadingRoute extends _i53.PageRouteInfo<void> {
  const GlobalLoadingRoute() : super(name, path: '/loading');

  static const String name = 'GlobalLoadingRoute';
}

/// generated route for [_i3.AuthedRoutesWrapperPage]
class AuthedRouter extends _i53.PageRouteInfo<void> {
  const AuthedRouter({List<_i53.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'AuthedRouter';
}

/// generated route for [_i4.MainTabsPage]
class MainTabsRoute extends _i53.PageRouteInfo<void> {
  const MainTabsRoute({List<_i53.PageRouteInfo>? children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'MainTabsRoute';
}

/// generated route for [_i5.ArchivePage]
class ArchiveRoute extends _i53.PageRouteInfo<void> {
  const ArchiveRoute() : super(name, path: 'archive');

  static const String name = 'ArchiveRoute';
}

/// generated route for [_i6.ChatsOverviewPage]
class ChatsOverviewRoute extends _i53.PageRouteInfo<void> {
  const ChatsOverviewRoute() : super(name, path: 'chats');

  static const String name = 'ChatsOverviewRoute';
}

/// generated route for [_i7.OneToOneChatPage]
class OneToOneChatRoute extends _i53.PageRouteInfo<OneToOneChatRouteArgs> {
  OneToOneChatRoute({_i61.Key? key, required String otherUserId})
      : super(name,
            path: 'chat',
            args: OneToOneChatRouteArgs(key: key, otherUserId: otherUserId));

  static const String name = 'OneToOneChatRoute';
}

class OneToOneChatRouteArgs {
  const OneToOneChatRouteArgs({this.key, required this.otherUserId});

  final _i61.Key? key;

  final String otherUserId;

  @override
  String toString() {
    return 'OneToOneChatRouteArgs{key: $key, otherUserId: $otherUserId}';
  }
}

/// generated route for [_i8.ClubMembersChatPage]
class ClubMembersChatRoute
    extends _i53.PageRouteInfo<ClubMembersChatRouteArgs> {
  ClubMembersChatRoute({_i61.Key? key, required String clubId})
      : super(name,
            path: 'club-chat',
            args: ClubMembersChatRouteArgs(key: key, clubId: clubId));

  static const String name = 'ClubMembersChatRoute';
}

class ClubMembersChatRouteArgs {
  const ClubMembersChatRouteArgs({this.key, required this.clubId});

  final _i61.Key? key;

  final String clubId;

  @override
  String toString() {
    return 'ClubMembersChatRouteArgs{key: $key, clubId: $clubId}';
  }
}

/// generated route for [_i9.ClubInviteLandingPage]
class ClubInviteLandingRoute
    extends _i53.PageRouteInfo<ClubInviteLandingRouteArgs> {
  ClubInviteLandingRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'club-invite/:id',
            args: ClubInviteLandingRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubInviteLandingRoute';
}

class ClubInviteLandingRouteArgs {
  const ClubInviteLandingRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubInviteLandingRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i10.CollectionDetailsPage]
class CollectionDetailsRoute
    extends _i53.PageRouteInfo<CollectionDetailsRouteArgs> {
  CollectionDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'collection/:id',
            args: CollectionDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'CollectionDetailsRoute';
}

class CollectionDetailsRouteArgs {
  const CollectionDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'CollectionDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i11.DoWorkoutWrapperPage]
class DoWorkoutWrapperRoute
    extends _i53.PageRouteInfo<DoWorkoutWrapperRouteArgs> {
  DoWorkoutWrapperRoute(
      {_i61.Key? key,
      required String id,
      _i62.ScheduledWorkout? scheduledWorkout})
      : super(name,
            path: 'do-workout/:id',
            args: DoWorkoutWrapperRouteArgs(
                key: key, id: id, scheduledWorkout: scheduledWorkout),
            rawPathParams: {'id': id});

  static const String name = 'DoWorkoutWrapperRoute';
}

class DoWorkoutWrapperRouteArgs {
  const DoWorkoutWrapperRouteArgs(
      {this.key, required this.id, this.scheduledWorkout});

  final _i61.Key? key;

  final String id;

  final _i62.ScheduledWorkout? scheduledWorkout;

  @override
  String toString() {
    return 'DoWorkoutWrapperRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout}';
  }
}

/// generated route for [_i12.SettingsPage]
class SettingsRoute extends _i53.PageRouteInfo<void> {
  const SettingsRoute() : super(name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for [_i13.TimersPage]
class TimersRoute extends _i53.PageRouteInfo<void> {
  const TimersRoute() : super(name, path: 'timers');

  static const String name = 'TimersRoute';
}

/// generated route for [_i14.YourClubsPage]
class YourClubsRoute extends _i53.PageRouteInfo<void> {
  const YourClubsRoute() : super(name, path: 'your-clubs');

  static const String name = 'YourClubsRoute';
}

/// generated route for [_i15.YourCollectionsPage]
class YourCollectionsRoute extends _i53.PageRouteInfo<void> {
  const YourCollectionsRoute() : super(name, path: 'your-collections');

  static const String name = 'YourCollectionsRoute';
}

/// generated route for [_i16.YourGymProfilesPage]
class YourGymProfilesRoute extends _i53.PageRouteInfo<void> {
  const YourGymProfilesRoute() : super(name, path: 'your-gym-profiles');

  static const String name = 'YourGymProfilesRoute';
}

/// generated route for [_i17.YourMovesLibraryPage]
class YourMovesLibraryRoute extends _i53.PageRouteInfo<void> {
  const YourMovesLibraryRoute() : super(name, path: 'your-moves');

  static const String name = 'YourMovesLibraryRoute';
}

/// generated route for [_i18.YourPlansPage]
class YourPlansRoute extends _i53.PageRouteInfo<YourPlansRouteArgs> {
  YourPlansRoute(
      {_i61.Key? key,
      void Function(_i62.WorkoutPlanSummary)? selectPlan,
      bool showCreateButton = false,
      bool showDiscoverButton = false,
      String pageTitle = 'Plans',
      bool showJoined = true,
      bool showSaved = true})
      : super(name,
            path: 'your-plans',
            args: YourPlansRouteArgs(
                key: key,
                selectPlan: selectPlan,
                showCreateButton: showCreateButton,
                showDiscoverButton: showDiscoverButton,
                pageTitle: pageTitle,
                showJoined: showJoined,
                showSaved: showSaved));

  static const String name = 'YourPlansRoute';
}

class YourPlansRouteArgs {
  const YourPlansRouteArgs(
      {this.key,
      this.selectPlan,
      this.showCreateButton = false,
      this.showDiscoverButton = false,
      this.pageTitle = 'Plans',
      this.showJoined = true,
      this.showSaved = true});

  final _i61.Key? key;

  final void Function(_i62.WorkoutPlanSummary)? selectPlan;

  final bool showCreateButton;

  final bool showDiscoverButton;

  final String pageTitle;

  final bool showJoined;

  final bool showSaved;

  @override
  String toString() {
    return 'YourPlansRouteArgs{key: $key, selectPlan: $selectPlan, showCreateButton: $showCreateButton, showDiscoverButton: $showDiscoverButton, pageTitle: $pageTitle, showJoined: $showJoined, showSaved: $showSaved}';
  }
}

/// generated route for [_i19.YourPostsPage]
class YourPostsRoute extends _i53.PageRouteInfo<void> {
  const YourPostsRoute() : super(name, path: 'your-posts');

  static const String name = 'YourPostsRoute';
}

/// generated route for [_i20.YourSchedulePage]
class YourScheduleRoute extends _i53.PageRouteInfo<YourScheduleRouteArgs> {
  YourScheduleRoute({_i61.Key? key, DateTime? openAtDate})
      : super(name,
            path: 'your-schedule',
            args: YourScheduleRouteArgs(key: key, openAtDate: openAtDate));

  static const String name = 'YourScheduleRoute';
}

class YourScheduleRouteArgs {
  const YourScheduleRouteArgs({this.key, this.openAtDate});

  final _i61.Key? key;

  final DateTime? openAtDate;

  @override
  String toString() {
    return 'YourScheduleRouteArgs{key: $key, openAtDate: $openAtDate}';
  }
}

/// generated route for [_i21.YourThrowdownsPage]
class YourThrowdownsRoute extends _i53.PageRouteInfo<void> {
  const YourThrowdownsRoute() : super(name, path: 'your-throwdowns');

  static const String name = 'YourThrowdownsRoute';
}

/// generated route for [_i22.YourWorkoutsPage]
class YourWorkoutsRoute extends _i53.PageRouteInfo<YourWorkoutsRouteArgs> {
  YourWorkoutsRoute(
      {_i61.Key? key,
      void Function(_i62.WorkoutSummary)? selectWorkout,
      bool showCreateButton = false,
      bool showDiscoverButton = false,
      String pageTitle = 'Your Workouts',
      bool showSaved = true})
      : super(name,
            path: 'your-workouts',
            args: YourWorkoutsRouteArgs(
                key: key,
                selectWorkout: selectWorkout,
                showCreateButton: showCreateButton,
                showDiscoverButton: showDiscoverButton,
                pageTitle: pageTitle,
                showSaved: showSaved));

  static const String name = 'YourWorkoutsRoute';
}

class YourWorkoutsRouteArgs {
  const YourWorkoutsRouteArgs(
      {this.key,
      this.selectWorkout,
      this.showCreateButton = false,
      this.showDiscoverButton = false,
      this.pageTitle = 'Your Workouts',
      this.showSaved = true});

  final _i61.Key? key;

  final void Function(_i62.WorkoutSummary)? selectWorkout;

  final bool showCreateButton;

  final bool showDiscoverButton;

  final String pageTitle;

  final bool showSaved;

  @override
  String toString() {
    return 'YourWorkoutsRouteArgs{key: $key, selectWorkout: $selectWorkout, showCreateButton: $showCreateButton, showDiscoverButton: $showDiscoverButton, pageTitle: $pageTitle, showSaved: $showSaved}';
  }
}

/// generated route for [_i23.PublicWorkoutFinderPage]
class PublicWorkoutFinderRoute
    extends _i53.PageRouteInfo<PublicWorkoutFinderRouteArgs> {
  PublicWorkoutFinderRoute(
      {_i61.Key? key, void Function(_i62.WorkoutSummary)? selectWorkout})
      : super(name,
            path: 'public-workouts',
            args: PublicWorkoutFinderRouteArgs(
                key: key, selectWorkout: selectWorkout));

  static const String name = 'PublicWorkoutFinderRoute';
}

class PublicWorkoutFinderRouteArgs {
  const PublicWorkoutFinderRouteArgs({this.key, this.selectWorkout});

  final _i61.Key? key;

  final void Function(_i62.WorkoutSummary)? selectWorkout;

  @override
  String toString() {
    return 'PublicWorkoutFinderRouteArgs{key: $key, selectWorkout: $selectWorkout}';
  }
}

/// generated route for [_i24.PublicWorkoutPlanFinderPage]
class PublicWorkoutPlanFinderRoute
    extends _i53.PageRouteInfo<PublicWorkoutPlanFinderRouteArgs> {
  PublicWorkoutPlanFinderRoute(
      {_i61.Key? key,
      void Function(_i62.WorkoutPlanSummary)? selectWorkoutPlan})
      : super(name,
            path: 'public-plans',
            args: PublicWorkoutPlanFinderRouteArgs(
                key: key, selectWorkoutPlan: selectWorkoutPlan));

  static const String name = 'PublicWorkoutPlanFinderRoute';
}

class PublicWorkoutPlanFinderRouteArgs {
  const PublicWorkoutPlanFinderRouteArgs({this.key, this.selectWorkoutPlan});

  final _i61.Key? key;

  final void Function(_i62.WorkoutPlanSummary)? selectWorkoutPlan;

  @override
  String toString() {
    return 'PublicWorkoutPlanFinderRouteArgs{key: $key, selectWorkoutPlan: $selectWorkoutPlan}';
  }
}

/// generated route for [_i25.DiscoverPeoplePage]
class DiscoverPeopleRoute extends _i53.PageRouteInfo<void> {
  const DiscoverPeopleRoute() : super(name, path: 'discover-people');

  static const String name = 'DiscoverPeopleRoute';
}

/// generated route for [_i26.DiscoverClubsPage]
class DiscoverClubsRoute extends _i53.PageRouteInfo<void> {
  const DiscoverClubsRoute() : super(name, path: 'discover-clubs');

  static const String name = 'DiscoverClubsRoute';
}

/// generated route for [_i27.ClubDetailsPage]
class ClubDetailsRoute extends _i53.PageRouteInfo<ClubDetailsRouteArgs> {
  ClubDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'club/:id',
            args: ClubDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubDetailsRoute';
}

class ClubDetailsRouteArgs {
  const ClubDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i28.LoggedWorkoutDetailsPage]
class LoggedWorkoutDetailsRoute
    extends _i53.PageRouteInfo<LoggedWorkoutDetailsRouteArgs> {
  LoggedWorkoutDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'logged-workout/:id',
            args: LoggedWorkoutDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'LoggedWorkoutDetailsRoute';
}

class LoggedWorkoutDetailsRouteArgs {
  const LoggedWorkoutDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'LoggedWorkoutDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i29.PersonalBestDetailsPage]
class PersonalBestDetailsRoute
    extends _i53.PageRouteInfo<PersonalBestDetailsRouteArgs> {
  PersonalBestDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'personal-best/:id',
            args: PersonalBestDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'PersonalBestDetailsRoute';
}

class PersonalBestDetailsRouteArgs {
  const PersonalBestDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'PersonalBestDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i30.UserPublicProfileDetailsPage]
class UserPublicProfileDetailsRoute
    extends _i53.PageRouteInfo<UserPublicProfileDetailsRouteArgs> {
  UserPublicProfileDetailsRoute({_i61.Key? key, required String userId})
      : super(name,
            path: 'profile/:userId',
            args: UserPublicProfileDetailsRouteArgs(key: key, userId: userId),
            rawPathParams: {'userId': userId});

  static const String name = 'UserPublicProfileDetailsRoute';
}

class UserPublicProfileDetailsRouteArgs {
  const UserPublicProfileDetailsRouteArgs({this.key, required this.userId});

  final _i61.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserPublicProfileDetailsRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for [_i31.ProgressJournalDetailsPage]
class ProgressJournalDetailsRoute
    extends _i53.PageRouteInfo<ProgressJournalDetailsRouteArgs> {
  ProgressJournalDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'progress-journal/:id',
            args: ProgressJournalDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ProgressJournalDetailsRoute';
}

class ProgressJournalDetailsRouteArgs {
  const ProgressJournalDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'ProgressJournalDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i32.WorkoutDetailsPage]
class WorkoutDetailsRoute extends _i53.PageRouteInfo<WorkoutDetailsRouteArgs> {
  WorkoutDetailsRoute(
      {_i61.Key? key,
      required String id,
      _i62.ScheduledWorkout? scheduledWorkout})
      : super(name,
            path: 'workout/:id',
            args: WorkoutDetailsRouteArgs(
                key: key, id: id, scheduledWorkout: scheduledWorkout),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutDetailsRoute';
}

class WorkoutDetailsRouteArgs {
  const WorkoutDetailsRouteArgs(
      {this.key, required this.id, this.scheduledWorkout});

  final _i61.Key? key;

  final String id;

  final _i62.ScheduledWorkout? scheduledWorkout;

  @override
  String toString() {
    return 'WorkoutDetailsRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout}';
  }
}

/// generated route for [_i33.WorkoutPlanDetailsPage]
class WorkoutPlanDetailsRoute
    extends _i53.PageRouteInfo<WorkoutPlanDetailsRouteArgs> {
  WorkoutPlanDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'workout-plan/:id',
            args: WorkoutPlanDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutPlanDetailsRoute';
}

class WorkoutPlanDetailsRouteArgs {
  const WorkoutPlanDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'WorkoutPlanDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i34.WorkoutPlanEnrolmentDetailsPage]
class WorkoutPlanEnrolmentDetailsRoute
    extends _i53.PageRouteInfo<WorkoutPlanEnrolmentDetailsRouteArgs> {
  WorkoutPlanEnrolmentDetailsRoute({_i61.Key? key, required String id})
      : super(name,
            path: 'workout-plan-progress/:id',
            args: WorkoutPlanEnrolmentDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutPlanEnrolmentDetailsRoute';
}

class WorkoutPlanEnrolmentDetailsRouteArgs {
  const WorkoutPlanEnrolmentDetailsRouteArgs({this.key, required this.id});

  final _i61.Key? key;

  final String id;

  @override
  String toString() {
    return 'WorkoutPlanEnrolmentDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i35.BodyTrackingEntryCreatorPage]
class BodyTrackingEntryCreatorRoute
    extends _i53.PageRouteInfo<BodyTrackingEntryCreatorRouteArgs> {
  BodyTrackingEntryCreatorRoute(
      {_i61.Key? key, _i62.BodyTrackingEntry? bodyTrackingEntry})
      : super(name,
            path: 'create/body-tracking',
            args: BodyTrackingEntryCreatorRouteArgs(
                key: key, bodyTrackingEntry: bodyTrackingEntry));

  static const String name = 'BodyTrackingEntryCreatorRoute';
}

class BodyTrackingEntryCreatorRouteArgs {
  const BodyTrackingEntryCreatorRouteArgs({this.key, this.bodyTrackingEntry});

  final _i61.Key? key;

  final _i62.BodyTrackingEntry? bodyTrackingEntry;

  @override
  String toString() {
    return 'BodyTrackingEntryCreatorRouteArgs{key: $key, bodyTrackingEntry: $bodyTrackingEntry}';
  }
}

/// generated route for [_i36.ClubCreatorPage]
class ClubCreatorRoute extends _i53.PageRouteInfo<ClubCreatorRouteArgs> {
  ClubCreatorRoute({_i61.Key? key, _i62.Club? club})
      : super(name,
            path: 'create/club',
            args: ClubCreatorRouteArgs(key: key, club: club));

  static const String name = 'ClubCreatorRoute';
}

class ClubCreatorRouteArgs {
  const ClubCreatorRouteArgs({this.key, this.club});

  final _i61.Key? key;

  final _i62.Club? club;

  @override
  String toString() {
    return 'ClubCreatorRouteArgs{key: $key, club: $club}';
  }
}

/// generated route for [_i37.CollectionCreatorPage]
class CollectionCreatorRoute
    extends _i53.PageRouteInfo<CollectionCreatorRouteArgs> {
  CollectionCreatorRoute(
      {_i61.Key? key,
      _i62.Collection? collection,
      void Function(_i62.Collection)? onComplete})
      : super(name,
            path: 'create/collection',
            args: CollectionCreatorRouteArgs(
                key: key, collection: collection, onComplete: onComplete));

  static const String name = 'CollectionCreatorRoute';
}

class CollectionCreatorRouteArgs {
  const CollectionCreatorRouteArgs(
      {this.key, this.collection, this.onComplete});

  final _i61.Key? key;

  final _i62.Collection? collection;

  final void Function(_i62.Collection)? onComplete;

  @override
  String toString() {
    return 'CollectionCreatorRouteArgs{key: $key, collection: $collection, onComplete: $onComplete}';
  }
}

/// generated route for [_i38.CustomMoveCreatorPage]
class CustomMoveCreatorRoute
    extends _i53.PageRouteInfo<CustomMoveCreatorRouteArgs> {
  CustomMoveCreatorRoute({_i61.Key? key, _i62.Move? move})
      : super(name,
            path: 'create/custom-move',
            args: CustomMoveCreatorRouteArgs(key: key, move: move));

  static const String name = 'CustomMoveCreatorRoute';
}

class CustomMoveCreatorRouteArgs {
  const CustomMoveCreatorRouteArgs({this.key, this.move});

  final _i61.Key? key;

  final _i62.Move? move;

  @override
  String toString() {
    return 'CustomMoveCreatorRouteArgs{key: $key, move: $move}';
  }
}

/// generated route for [_i39.GymProfileCreatorPage]
class GymProfileCreatorRoute
    extends _i53.PageRouteInfo<GymProfileCreatorRouteArgs> {
  GymProfileCreatorRoute({_i61.Key? key, _i62.GymProfile? gymProfile})
      : super(name,
            path: 'create/gym-profile',
            args: GymProfileCreatorRouteArgs(key: key, gymProfile: gymProfile));

  static const String name = 'GymProfileCreatorRoute';
}

class GymProfileCreatorRouteArgs {
  const GymProfileCreatorRouteArgs({this.key, this.gymProfile});

  final _i61.Key? key;

  final _i62.GymProfile? gymProfile;

  @override
  String toString() {
    return 'GymProfileCreatorRouteArgs{key: $key, gymProfile: $gymProfile}';
  }
}

/// generated route for [_i40.ProgressJournalCreatorPage]
class ProgressJournalCreatorRoute
    extends _i53.PageRouteInfo<ProgressJournalCreatorRouteArgs> {
  ProgressJournalCreatorRoute(
      {_i61.Key? key, _i62.ProgressJournal? progressJournal})
      : super(name,
            path: 'create/journal',
            args: ProgressJournalCreatorRouteArgs(
                key: key, progressJournal: progressJournal));

  static const String name = 'ProgressJournalCreatorRoute';
}

class ProgressJournalCreatorRouteArgs {
  const ProgressJournalCreatorRouteArgs({this.key, this.progressJournal});

  final _i61.Key? key;

  final _i62.ProgressJournal? progressJournal;

  @override
  String toString() {
    return 'ProgressJournalCreatorRouteArgs{key: $key, progressJournal: $progressJournal}';
  }
}

/// generated route for [_i41.PersonalBestCreatorPage]
class PersonalBestCreatorRoute
    extends _i53.PageRouteInfo<PersonalBestCreatorRouteArgs> {
  PersonalBestCreatorRoute({_i61.Key? key, _i62.UserBenchmark? userBenchmark})
      : super(name,
            path: 'create/personal-best',
            args: PersonalBestCreatorRouteArgs(
                key: key, userBenchmark: userBenchmark));

  static const String name = 'PersonalBestCreatorRoute';
}

class PersonalBestCreatorRouteArgs {
  const PersonalBestCreatorRouteArgs({this.key, this.userBenchmark});

  final _i61.Key? key;

  final _i62.UserBenchmark? userBenchmark;

  @override
  String toString() {
    return 'PersonalBestCreatorRouteArgs{key: $key, userBenchmark: $userBenchmark}';
  }
}

/// generated route for [_i42.PostCreatorPage]
class PostCreatorRoute extends _i53.PageRouteInfo<void> {
  const PostCreatorRoute() : super(name, path: 'create/post');

  static const String name = 'PostCreatorRoute';
}

/// generated route for [_i43.ClubPostCreatorPage]
class ClubPostCreatorRoute
    extends _i53.PageRouteInfo<ClubPostCreatorRouteArgs> {
  ClubPostCreatorRoute(
      {_i61.Key? key,
      required String clubId,
      void Function(_i62.TimelinePostFullData)? onSuccess})
      : super(name,
            path: 'create/club-post',
            args: ClubPostCreatorRouteArgs(
                key: key, clubId: clubId, onSuccess: onSuccess));

  static const String name = 'ClubPostCreatorRoute';
}

class ClubPostCreatorRouteArgs {
  const ClubPostCreatorRouteArgs(
      {this.key, required this.clubId, this.onSuccess});

  final _i61.Key? key;

  final String clubId;

  final void Function(_i62.TimelinePostFullData)? onSuccess;

  @override
  String toString() {
    return 'ClubPostCreatorRouteArgs{key: $key, clubId: $clubId, onSuccess: $onSuccess}';
  }
}

/// generated route for [_i44.ScheduledWorkoutCreatorPage]
class ScheduledWorkoutCreatorRoute
    extends _i53.PageRouteInfo<ScheduledWorkoutCreatorRouteArgs> {
  ScheduledWorkoutCreatorRoute(
      {_i61.Key? key,
      _i62.ScheduledWorkout? scheduledWorkout,
      _i62.WorkoutSummary? workout,
      DateTime? scheduleOn,
      String? workoutPlanEnrolmentId})
      : super(name,
            path: 'create/scheduled-workout',
            args: ScheduledWorkoutCreatorRouteArgs(
                key: key,
                scheduledWorkout: scheduledWorkout,
                workout: workout,
                scheduleOn: scheduleOn,
                workoutPlanEnrolmentId: workoutPlanEnrolmentId));

  static const String name = 'ScheduledWorkoutCreatorRoute';
}

class ScheduledWorkoutCreatorRouteArgs {
  const ScheduledWorkoutCreatorRouteArgs(
      {this.key,
      this.scheduledWorkout,
      this.workout,
      this.scheduleOn,
      this.workoutPlanEnrolmentId});

  final _i61.Key? key;

  final _i62.ScheduledWorkout? scheduledWorkout;

  final _i62.WorkoutSummary? workout;

  final DateTime? scheduleOn;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'ScheduledWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workout: $workout, scheduleOn: $scheduleOn, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for [_i45.WorkoutCreatorPage]
class WorkoutCreatorRoute extends _i53.PageRouteInfo<WorkoutCreatorRouteArgs> {
  WorkoutCreatorRoute({_i61.Key? key, _i62.Workout? workout})
      : super(name,
            path: 'create/workout',
            args: WorkoutCreatorRouteArgs(key: key, workout: workout));

  static const String name = 'WorkoutCreatorRoute';
}

class WorkoutCreatorRouteArgs {
  const WorkoutCreatorRouteArgs({this.key, this.workout});

  final _i61.Key? key;

  final _i62.Workout? workout;

  @override
  String toString() {
    return 'WorkoutCreatorRouteArgs{key: $key, workout: $workout}';
  }
}

/// generated route for [_i46.LoggedWorkoutCreatorPage]
class LoggedWorkoutCreatorRoute
    extends _i53.PageRouteInfo<LoggedWorkoutCreatorRouteArgs> {
  LoggedWorkoutCreatorRoute(
      {_i61.Key? key,
      _i62.ScheduledWorkout? scheduledWorkout,
      required String workoutId})
      : super(name,
            path: 'create/workout-log',
            args: LoggedWorkoutCreatorRouteArgs(
                key: key,
                scheduledWorkout: scheduledWorkout,
                workoutId: workoutId));

  static const String name = 'LoggedWorkoutCreatorRoute';
}

class LoggedWorkoutCreatorRouteArgs {
  const LoggedWorkoutCreatorRouteArgs(
      {this.key, this.scheduledWorkout, required this.workoutId});

  final _i61.Key? key;

  final _i62.ScheduledWorkout? scheduledWorkout;

  final String workoutId;

  @override
  String toString() {
    return 'LoggedWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workoutId: $workoutId}';
  }
}

/// generated route for [_i47.WorkoutPlanCreatorPage]
class WorkoutPlanCreatorRoute
    extends _i53.PageRouteInfo<WorkoutPlanCreatorRouteArgs> {
  WorkoutPlanCreatorRoute({_i61.Key? key, _i62.WorkoutPlan? workoutPlan})
      : super(name,
            path: 'create/workout-plan',
            args: WorkoutPlanCreatorRouteArgs(
                key: key, workoutPlan: workoutPlan));

  static const String name = 'WorkoutPlanCreatorRoute';
}

class WorkoutPlanCreatorRouteArgs {
  const WorkoutPlanCreatorRouteArgs({this.key, this.workoutPlan});

  final _i61.Key? key;

  final _i62.WorkoutPlan? workoutPlan;

  @override
  String toString() {
    return 'WorkoutPlanCreatorRouteArgs{key: $key, workoutPlan: $workoutPlan}';
  }
}

/// generated route for [_i48.WorkoutPlanReviewCreatorPage]
class WorkoutPlanReviewCreatorRoute
    extends _i53.PageRouteInfo<WorkoutPlanReviewCreatorRouteArgs> {
  WorkoutPlanReviewCreatorRoute(
      {_i61.Key? key,
      _i62.WorkoutPlanReview? workoutPlanReview,
      required String parentWorkoutPlanId,
      required String parentWorkoutPlanEnrolmentId})
      : super(name,
            path: 'create/workout-plan-review',
            args: WorkoutPlanReviewCreatorRouteArgs(
                key: key,
                workoutPlanReview: workoutPlanReview,
                parentWorkoutPlanId: parentWorkoutPlanId,
                parentWorkoutPlanEnrolmentId: parentWorkoutPlanEnrolmentId));

  static const String name = 'WorkoutPlanReviewCreatorRoute';
}

class WorkoutPlanReviewCreatorRouteArgs {
  const WorkoutPlanReviewCreatorRouteArgs(
      {this.key,
      this.workoutPlanReview,
      required this.parentWorkoutPlanId,
      required this.parentWorkoutPlanEnrolmentId});

  final _i61.Key? key;

  final _i62.WorkoutPlanReview? workoutPlanReview;

  final String parentWorkoutPlanId;

  final String parentWorkoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutPlanReviewCreatorRouteArgs{key: $key, workoutPlanReview: $workoutPlanReview, parentWorkoutPlanId: $parentWorkoutPlanId, parentWorkoutPlanEnrolmentId: $parentWorkoutPlanEnrolmentId}';
  }
}

/// generated route for [_i49.PageNotFoundPage]
class RouteNotFoundRoute extends _i53.PageRouteInfo<void> {
  const RouteNotFoundRoute() : super(name, path: '404');

  static const String name = 'RouteNotFoundRoute';
}

/// generated route for [_i50.DiscoverPage]
class DiscoverRoute extends _i53.PageRouteInfo<void> {
  const DiscoverRoute() : super(name, path: '');

  static const String name = 'DiscoverRoute';
}

/// generated route for [_i51.SocialPage]
class SocialRoute extends _i53.PageRouteInfo<void> {
  const SocialRoute() : super(name, path: 'social');

  static const String name = 'SocialRoute';
}

/// generated route for [_i52.HomePage]
class HomeRoute extends _i53.PageRouteInfo<void> {
  const HomeRoute() : super(name, path: 'studio');

  static const String name = 'HomeRoute';
}

/// generated route for [_i53.EmptyRouterPage]
class ProgressStack extends _i53.PageRouteInfo<void> {
  const ProgressStack({List<_i53.PageRouteInfo>? children})
      : super(name, path: 'progress', initialChildren: children);

  static const String name = 'ProgressStack';
}

/// generated route for [_i54.ProfilePage]
class ProfileRoute extends _i53.PageRouteInfo<void> {
  const ProfileRoute() : super(name, path: 'profile');

  static const String name = 'ProfileRoute';
}

/// generated route for [_i55.ProgressPage]
class ProgressRoute extends _i53.PageRouteInfo<void> {
  const ProgressRoute() : super(name, path: '');

  static const String name = 'ProgressRoute';
}

/// generated route for [_i56.PersonalBestsPage]
class PersonalBestsRoute extends _i53.PageRouteInfo<void> {
  const PersonalBestsRoute() : super(name, path: 'personal-bests');

  static const String name = 'PersonalBestsRoute';
}

/// generated route for [_i57.JournalsPage]
class JournalsRoute extends _i53.PageRouteInfo<void> {
  const JournalsRoute() : super(name, path: 'journals');

  static const String name = 'JournalsRoute';
}

/// generated route for [_i58.BodyTrackingPage]
class BodyTrackingRoute extends _i53.PageRouteInfo<void> {
  const BodyTrackingRoute() : super(name, path: 'body-tracking');

  static const String name = 'BodyTrackingRoute';
}

/// generated route for [_i59.LoggedWorkoutsPage]
class LoggedWorkoutsRoute extends _i53.PageRouteInfo<void> {
  const LoggedWorkoutsRoute() : super(name, path: 'workout-logs');

  static const String name = 'LoggedWorkoutsRoute';
}
