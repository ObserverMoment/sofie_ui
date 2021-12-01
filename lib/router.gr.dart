// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i42;
import 'package:flutter/cupertino.dart' as _i66;
import 'package:flutter/material.dart' as _i65;

import 'components/creators/body_tracking/body_tracking_entry_creator.dart'
    as _i27;
import 'components/creators/club_creator/club_creator.dart' as _i28;
import 'components/creators/collection_creator.dart' as _i29;
import 'components/creators/custom_move_creator/custom_move_creator.dart'
    as _i30;
import 'components/creators/gym_profile_creator.dart' as _i31;
import 'components/creators/logged_workout_creator/logged_workout_creator.dart'
    as _i38;
import 'components/creators/personal_best_creator/personal_best_creator.dart'
    as _i33;
import 'components/creators/post_creator/club_post_creator.dart' as _i35;
import 'components/creators/post_creator/post_creator.dart' as _i34;
import 'components/creators/progress_journal_creator/progress_journal_creator.dart'
    as _i32;
import 'components/creators/scheduled_workout_creator.dart' as _i36;
import 'components/creators/workout_creator/workout_creator.dart' as _i37;
import 'components/creators/workout_plan_creator/workout_plan_creator.dart'
    as _i39;
import 'components/creators/workout_plan_review_creator.dart' as _i40;
import 'components/do_workout/do_workout_wrapper_page.dart' as _i11;
import 'components/social/chat/chats_overview_page.dart' as _i6;
import 'components/social/chat/club_members_chat_page.dart' as _i8;
import 'components/social/chat/one_to_one_chat_page.dart' as _i7;
import 'components/timers/timers_page.dart' as _i13;
import 'components/workout/workout_finders/private/private_workout_finder_page.dart'
    as _i16;
import 'components/workout/workout_finders/public/public_workout_finder_page.dart'
    as _i15;
import 'components/workout_plan/workout_plan_finder/private/private_workout_plan_finder.dart'
    as _i18;
import 'components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart'
    as _i17;
import 'generated/api/graphql_api.dart' as _i67;
import 'main.dart' as _i2;
import 'pages/authed/authed_routes_wrapper_page.dart' as _i3;
import 'pages/authed/details_pages/club_details/club_details_page.dart' as _i19;
import 'pages/authed/details_pages/collection_details_page.dart' as _i10;
import 'pages/authed/details_pages/logged_workout_details_page.dart' as _i20;
import 'pages/authed/details_pages/personal_best_details_page.dart' as _i21;
import 'pages/authed/details_pages/progress_journal_details_page.dart' as _i23;
import 'pages/authed/details_pages/user_public_profile_details_page.dart'
    as _i22;
import 'pages/authed/details_pages/workout_details_page.dart' as _i24;
import 'pages/authed/details_pages/workout_plan_details_page.dart' as _i25;
import 'pages/authed/details_pages/workout_plan_enrolment_details_page.dart'
    as _i26;
import 'pages/authed/discover/discover_champions_page.dart' as _i49;
import 'pages/authed/discover/discover_clubs_page.dart' as _i47;
import 'pages/authed/discover/discover_community_page.dart' as _i48;
import 'pages/authed/discover/discover_page.dart' as _i45;
import 'pages/authed/discover/discover_people_page.dart' as _i46;
import 'pages/authed/home/home_page.dart' as _i50;
import 'pages/authed/home/your_awards.dart' as _i51;
import 'pages/authed/home/your_clubs.dart' as _i52;
import 'pages/authed/home/your_collections.dart' as _i53;
import 'pages/authed/home/your_gym_profiles.dart' as _i54;
import 'pages/authed/home/your_moves_library.dart' as _i55;
import 'pages/authed/home/your_plans/your_plans.dart' as _i56;
import 'pages/authed/home/your_schedule.dart' as _i57;
import 'pages/authed/home/your_throwdowns.dart' as _i58;
import 'pages/authed/home/your_workouts/your_workouts.dart' as _i59;
import 'pages/authed/landing_pages/club_invite_landing_page.dart' as _i9;
import 'pages/authed/main_tabs_page.dart' as _i4;
import 'pages/authed/page_not_found.dart' as _i41;
import 'pages/authed/profile/archive_page.dart' as _i5;
import 'pages/authed/profile/profile_page.dart' as _i44;
import 'pages/authed/profile/settings.dart' as _i12;
import 'pages/authed/progress/body_tracking_page.dart' as _i63;
import 'pages/authed/progress/journals_page.dart' as _i62;
import 'pages/authed/progress/logged_workouts_page.dart' as _i64;
import 'pages/authed/progress/personal_bests_page.dart' as _i61;
import 'pages/authed/progress/progress_page.dart' as _i60;
import 'pages/authed/social/social_page.dart' as _i43;
import 'pages/authed/social/your_posts_page.dart' as _i14;
import 'pages/unauthed/unauthed_landing.dart' as _i1;

class AppRouter extends _i42.RootStackRouter {
  AppRouter([_i65.GlobalKey<_i65.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i42.PageFactory> pagesMap = {
    UnauthedLandingRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i1.UnauthedLandingPage(),
          fullscreenDialog: true);
    },
    GlobalLoadingRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i2.GlobalLoadingPage(),
          fullscreenDialog: true);
    },
    AuthedRouter.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i3.AuthedRoutesWrapperPage(),
          fullscreenDialog: true);
    },
    MainTabsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.MainTabsPage());
    },
    ArchiveRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i5.ArchivePage());
    },
    ChatsOverviewRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i6.ChatsOverviewPage());
    },
    OneToOneChatRoute.name: (routeData) {
      final args = routeData.argsAs<OneToOneChatRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i7.OneToOneChatPage(
              key: args.key, otherUserId: args.otherUserId));
    },
    ClubMembersChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClubMembersChatRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i8.ClubMembersChatPage(key: args.key, clubId: args.clubId));
    },
    ClubInviteLandingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubInviteLandingRouteArgs>(
          orElse: () =>
              ClubInviteLandingRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i9.ClubInviteLandingPage(key: args.key, id: args.id));
    },
    CollectionDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CollectionDetailsRouteArgs>(
          orElse: () =>
              CollectionDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i10.CollectionDetailsPage(key: args.key, id: args.id));
    },
    DoWorkoutWrapperRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DoWorkoutWrapperRouteArgs>(
          orElse: () =>
              DoWorkoutWrapperRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i11.DoWorkoutWrapperPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout));
    },
    SettingsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i12.SettingsPage());
    },
    TimersRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i13.TimersPage());
    },
    YourPostsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i14.YourPostsPage());
    },
    PublicWorkoutFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutFinderRouteArgs>(
          orElse: () => const PublicWorkoutFinderRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i15.PublicWorkoutFinderPage(
              key: args.key, selectWorkout: args.selectWorkout));
    },
    PrivateWorkoutFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PrivateWorkoutFinderRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i16.PrivateWorkoutFinderPage(
              key: args.key, selectWorkout: args.selectWorkout));
    },
    PublicWorkoutPlanFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutPlanFinderRouteArgs>(
          orElse: () => const PublicWorkoutPlanFinderRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i17.PublicWorkoutPlanFinderPage(
              key: args.key, selectWorkoutPlan: args.selectWorkoutPlan));
    },
    PrivateWorkoutPlanFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PrivateWorkoutPlanFinderRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i18.PrivateWorkoutPlanFinderPage(
              key: args.key, selectWorkoutPlan: args.selectWorkoutPlan));
    },
    ClubDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubDetailsRouteArgs>(
          orElse: () => ClubDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i19.ClubDetailsPage(key: args.key, id: args.id));
    },
    LoggedWorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoggedWorkoutDetailsRouteArgs>(
          orElse: () =>
              LoggedWorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i20.LoggedWorkoutDetailsPage(key: args.key, id: args.id));
    },
    PersonalBestDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PersonalBestDetailsRouteArgs>(
          orElse: () =>
              PersonalBestDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i21.PersonalBestDetailsPage(key: args.key, id: args.id));
    },
    UserPublicProfileDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicProfileDetailsRouteArgs>(
          orElse: () => UserPublicProfileDetailsRouteArgs(
              userId: pathParams.getString('userId')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i22.UserPublicProfileDetailsPage(
              key: args.key, userId: args.userId));
    },
    ProgressJournalDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProgressJournalDetailsRouteArgs>(
          orElse: () =>
              ProgressJournalDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i23.ProgressJournalDetailsPage(key: args.key, id: args.id));
    },
    WorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutDetailsRouteArgs>(
          orElse: () =>
              WorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i24.WorkoutDetailsPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout));
    },
    WorkoutPlanDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanDetailsRouteArgs>(
          orElse: () =>
              WorkoutPlanDetailsRouteArgs(id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i25.WorkoutPlanDetailsPage(key: args.key, id: args.id));
    },
    WorkoutPlanEnrolmentDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanEnrolmentDetailsRouteArgs>(
          orElse: () => WorkoutPlanEnrolmentDetailsRouteArgs(
              id: pathParams.getString('id')));
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child:
              _i26.WorkoutPlanEnrolmentDetailsPage(key: args.key, id: args.id));
    },
    BodyTrackingEntryCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<BodyTrackingEntryCreatorRouteArgs>(
          orElse: () => const BodyTrackingEntryCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i27.BodyTrackingEntryCreatorPage(
              key: args.key, bodyTrackingEntry: args.bodyTrackingEntry));
    },
    ClubCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubCreatorRouteArgs>(
          orElse: () => const ClubCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i28.ClubCreatorPage(key: args.key, club: args.club));
    },
    CollectionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionCreatorRouteArgs>(
          orElse: () => const CollectionCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i29.CollectionCreatorPage(
              key: args.key,
              collection: args.collection,
              onComplete: args.onComplete));
    },
    CustomMoveCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CustomMoveCreatorRouteArgs>(
          orElse: () => const CustomMoveCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i30.CustomMoveCreatorPage(key: args.key, move: args.move));
    },
    GymProfileCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfileCreatorRouteArgs>(
          orElse: () => const GymProfileCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i31.GymProfileCreatorPage(
              key: args.key, gymProfile: args.gymProfile));
    },
    ProgressJournalCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ProgressJournalCreatorRouteArgs>(
          orElse: () => const ProgressJournalCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i32.ProgressJournalCreatorPage(
              key: args.key, progressJournal: args.progressJournal));
    },
    PersonalBestCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalBestCreatorRouteArgs>(
          orElse: () => const PersonalBestCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i33.PersonalBestCreatorPage(
              key: args.key, userBenchmark: args.userBenchmark));
    },
    PostCreatorRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i34.PostCreatorPage());
    },
    ClubPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubPostCreatorRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i35.ClubPostCreatorPage(
              key: args.key, clubId: args.clubId, onSuccess: args.onSuccess));
    },
    ScheduledWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduledWorkoutCreatorRouteArgs>(
          orElse: () => const ScheduledWorkoutCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i36.ScheduledWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workout: args.workout,
              scheduleOn: args.scheduleOn,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutCreatorRouteArgs>(
          orElse: () => const WorkoutCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i37.WorkoutCreatorPage(key: args.key, workout: args.workout));
    },
    LoggedWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutCreatorRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i38.LoggedWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workoutId: args.workoutId));
    },
    WorkoutPlanCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanCreatorRouteArgs>(
          orElse: () => const WorkoutPlanCreatorRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i39.WorkoutPlanCreatorPage(
              key: args.key, workoutPlan: args.workoutPlan));
    },
    WorkoutPlanReviewCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanReviewCreatorRouteArgs>();
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i40.WorkoutPlanReviewCreatorPage(
              key: args.key,
              workoutPlanReview: args.workoutPlanReview,
              parentWorkoutPlanId: args.parentWorkoutPlanId,
              parentWorkoutPlanEnrolmentId: args.parentWorkoutPlanEnrolmentId));
    },
    RouteNotFoundRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i41.PageNotFoundPage());
    },
    DiscoverStack.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i42.EmptyRouterPage());
    },
    SocialRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i43.SocialPage());
    },
    HomeStack.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i42.EmptyRouterPage());
    },
    ProgressStack.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i42.EmptyRouterPage());
    },
    ProfileRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i44.ProfilePage());
    },
    DiscoverRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i45.DiscoverPage());
    },
    DiscoverPeopleRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i46.DiscoverPeoplePage());
    },
    DiscoverClubsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i47.DiscoverClubsPage());
    },
    DiscoverCommunityRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i48.DiscoverCommunityPage());
    },
    DiscoverChampionsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i49.DiscoverChampionsPage());
    },
    HomeRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i50.HomePage());
    },
    YourAwardsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i51.YourAwardsPage());
    },
    YourClubsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i52.YourClubsPage());
    },
    YourCollectionsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i53.YourCollectionsPage());
    },
    YourGymProfilesRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i54.YourGymProfilesPage());
    },
    YourMovesLibraryRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i55.YourMovesLibraryPage());
    },
    YourPlansRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i56.YourPlansPage());
    },
    YourScheduleRoute.name: (routeData) {
      final args = routeData.argsAs<YourScheduleRouteArgs>(
          orElse: () => const YourScheduleRouteArgs());
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i57.YourSchedulePage(
              key: args.key, openAtDate: args.openAtDate));
    },
    YourThrowdownsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i58.YourThrowdownsPage());
    },
    YourWorkoutsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i59.YourWorkoutsPage());
    },
    ProgressRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i60.ProgressPage());
    },
    PersonalBestsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i61.PersonalBestsPage());
    },
    JournalsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i62.JournalsPage());
    },
    BodyTrackingRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i63.BodyTrackingPage());
    },
    LoggedWorkoutsRoute.name: (routeData) {
      return _i42.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i64.LoggedWorkoutsPage());
    }
  };

  @override
  List<_i42.RouteConfig> get routes => [
        _i42.RouteConfig(UnauthedLandingRoute.name, path: '/auth'),
        _i42.RouteConfig(GlobalLoadingRoute.name, path: '/loading'),
        _i42.RouteConfig(AuthedRouter.name, path: '/', children: [
          _i42.RouteConfig(MainTabsRoute.name,
              path: '',
              parent: AuthedRouter.name,
              children: [
                _i42.RouteConfig(DiscoverStack.name,
                    path: '',
                    parent: MainTabsRoute.name,
                    children: [
                      _i42.RouteConfig(DiscoverRoute.name,
                          path: '', parent: DiscoverStack.name),
                      _i42.RouteConfig(DiscoverPeopleRoute.name,
                          path: 'discover-people', parent: DiscoverStack.name),
                      _i42.RouteConfig(DiscoverClubsRoute.name,
                          path: 'discover-clubs', parent: DiscoverStack.name),
                      _i42.RouteConfig(DiscoverCommunityRoute.name,
                          path: 'community', parent: DiscoverStack.name),
                      _i42.RouteConfig(DiscoverChampionsRoute.name,
                          path: 'champions', parent: DiscoverStack.name)
                    ]),
                _i42.RouteConfig(SocialRoute.name,
                    path: 'social', parent: MainTabsRoute.name),
                _i42.RouteConfig(HomeStack.name,
                    path: 'studio',
                    parent: MainTabsRoute.name,
                    children: [
                      _i42.RouteConfig(HomeRoute.name,
                          path: '', parent: HomeStack.name),
                      _i42.RouteConfig(YourAwardsRoute.name,
                          path: 'your-awards', parent: HomeStack.name),
                      _i42.RouteConfig(YourClubsRoute.name,
                          path: 'your-clubs', parent: HomeStack.name),
                      _i42.RouteConfig(YourCollectionsRoute.name,
                          path: 'your-collections', parent: HomeStack.name),
                      _i42.RouteConfig(YourGymProfilesRoute.name,
                          path: 'your-gym-profiles', parent: HomeStack.name),
                      _i42.RouteConfig(YourMovesLibraryRoute.name,
                          path: 'your-moves', parent: HomeStack.name),
                      _i42.RouteConfig(YourPlansRoute.name,
                          path: 'your-plans', parent: HomeStack.name),
                      _i42.RouteConfig(YourScheduleRoute.name,
                          path: 'your-schedule', parent: HomeStack.name),
                      _i42.RouteConfig(YourThrowdownsRoute.name,
                          path: 'your-throwdowns', parent: HomeStack.name),
                      _i42.RouteConfig(YourWorkoutsRoute.name,
                          path: 'your-workouts', parent: HomeStack.name)
                    ]),
                _i42.RouteConfig(ProgressStack.name,
                    path: 'progress',
                    parent: MainTabsRoute.name,
                    children: [
                      _i42.RouteConfig(ProgressRoute.name,
                          path: '', parent: ProgressStack.name),
                      _i42.RouteConfig(PersonalBestsRoute.name,
                          path: 'personal-bests', parent: ProgressStack.name),
                      _i42.RouteConfig(JournalsRoute.name,
                          path: 'journals', parent: ProgressStack.name),
                      _i42.RouteConfig(BodyTrackingRoute.name,
                          path: 'body-tracking', parent: ProgressStack.name),
                      _i42.RouteConfig(LoggedWorkoutsRoute.name,
                          path: 'workout-logs', parent: ProgressStack.name)
                    ]),
                _i42.RouteConfig(ProfileRoute.name,
                    path: 'profile', parent: MainTabsRoute.name)
              ]),
          _i42.RouteConfig(ArchiveRoute.name,
              path: 'archive', parent: AuthedRouter.name),
          _i42.RouteConfig(ChatsOverviewRoute.name,
              path: 'chats', parent: AuthedRouter.name),
          _i42.RouteConfig(OneToOneChatRoute.name,
              path: 'chat', parent: AuthedRouter.name),
          _i42.RouteConfig(ClubMembersChatRoute.name,
              path: 'club-chat', parent: AuthedRouter.name),
          _i42.RouteConfig(ClubInviteLandingRoute.name,
              path: 'club-invite/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(CollectionDetailsRoute.name,
              path: 'collection/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(DoWorkoutWrapperRoute.name,
              path: 'do-workout/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: AuthedRouter.name),
          _i42.RouteConfig(TimersRoute.name,
              path: 'timers', parent: AuthedRouter.name),
          _i42.RouteConfig(YourPostsRoute.name,
              path: 'your-posts', parent: AuthedRouter.name),
          _i42.RouteConfig(PublicWorkoutFinderRoute.name,
              path: 'community-workouts', parent: AuthedRouter.name),
          _i42.RouteConfig(PrivateWorkoutFinderRoute.name,
              path: 'personal-workouts', parent: AuthedRouter.name),
          _i42.RouteConfig(PublicWorkoutPlanFinderRoute.name,
              path: 'community-plans', parent: AuthedRouter.name),
          _i42.RouteConfig(PrivateWorkoutPlanFinderRoute.name,
              path: 'personal-plans', parent: AuthedRouter.name),
          _i42.RouteConfig(ClubDetailsRoute.name,
              path: 'club/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(LoggedWorkoutDetailsRoute.name,
              path: 'logged-workout/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(PersonalBestDetailsRoute.name,
              path: 'personal-best/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(UserPublicProfileDetailsRoute.name,
              path: 'profile/:userId', parent: AuthedRouter.name),
          _i42.RouteConfig(ProgressJournalDetailsRoute.name,
              path: 'progress-journal/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(WorkoutDetailsRoute.name,
              path: 'workout/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(WorkoutPlanDetailsRoute.name,
              path: 'workout-plan/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(WorkoutPlanEnrolmentDetailsRoute.name,
              path: 'workout-plan-progress/:id', parent: AuthedRouter.name),
          _i42.RouteConfig(BodyTrackingEntryCreatorRoute.name,
              path: 'create/body-tracking', parent: AuthedRouter.name),
          _i42.RouteConfig(ClubCreatorRoute.name,
              path: 'create/club', parent: AuthedRouter.name),
          _i42.RouteConfig(CollectionCreatorRoute.name,
              path: 'create/collection', parent: AuthedRouter.name),
          _i42.RouteConfig(CustomMoveCreatorRoute.name,
              path: 'create/custom-move', parent: AuthedRouter.name),
          _i42.RouteConfig(GymProfileCreatorRoute.name,
              path: 'create/gym-profile', parent: AuthedRouter.name),
          _i42.RouteConfig(ProgressJournalCreatorRoute.name,
              path: 'create/journal', parent: AuthedRouter.name),
          _i42.RouteConfig(PersonalBestCreatorRoute.name,
              path: 'create/personal-best', parent: AuthedRouter.name),
          _i42.RouteConfig(PostCreatorRoute.name,
              path: 'create/post', parent: AuthedRouter.name),
          _i42.RouteConfig(ClubPostCreatorRoute.name,
              path: 'create/club-post', parent: AuthedRouter.name),
          _i42.RouteConfig(ScheduledWorkoutCreatorRoute.name,
              path: 'create/scheduled-workout', parent: AuthedRouter.name),
          _i42.RouteConfig(WorkoutCreatorRoute.name,
              path: 'create/workout', parent: AuthedRouter.name),
          _i42.RouteConfig(LoggedWorkoutCreatorRoute.name,
              path: 'create/workout-log', parent: AuthedRouter.name),
          _i42.RouteConfig(WorkoutPlanCreatorRoute.name,
              path: 'create/workout-plan', parent: AuthedRouter.name),
          _i42.RouteConfig(WorkoutPlanReviewCreatorRoute.name,
              path: 'create/workout-plan-review', parent: AuthedRouter.name),
          _i42.RouteConfig(RouteNotFoundRoute.name,
              path: '404', parent: AuthedRouter.name),
          _i42.RouteConfig('*#redirect',
              path: '*',
              parent: AuthedRouter.name,
              redirectTo: '404',
              fullMatch: true)
        ])
      ];
}

/// generated route for [_i1.UnauthedLandingPage]
class UnauthedLandingRoute extends _i42.PageRouteInfo<void> {
  const UnauthedLandingRoute() : super(name, path: '/auth');

  static const String name = 'UnauthedLandingRoute';
}

/// generated route for [_i2.GlobalLoadingPage]
class GlobalLoadingRoute extends _i42.PageRouteInfo<void> {
  const GlobalLoadingRoute() : super(name, path: '/loading');

  static const String name = 'GlobalLoadingRoute';
}

/// generated route for [_i3.AuthedRoutesWrapperPage]
class AuthedRouter extends _i42.PageRouteInfo<void> {
  const AuthedRouter({List<_i42.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'AuthedRouter';
}

/// generated route for [_i4.MainTabsPage]
class MainTabsRoute extends _i42.PageRouteInfo<void> {
  const MainTabsRoute({List<_i42.PageRouteInfo>? children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'MainTabsRoute';
}

/// generated route for [_i5.ArchivePage]
class ArchiveRoute extends _i42.PageRouteInfo<void> {
  const ArchiveRoute() : super(name, path: 'archive');

  static const String name = 'ArchiveRoute';
}

/// generated route for [_i6.ChatsOverviewPage]
class ChatsOverviewRoute extends _i42.PageRouteInfo<void> {
  const ChatsOverviewRoute() : super(name, path: 'chats');

  static const String name = 'ChatsOverviewRoute';
}

/// generated route for [_i7.OneToOneChatPage]
class OneToOneChatRoute extends _i42.PageRouteInfo<OneToOneChatRouteArgs> {
  OneToOneChatRoute({_i66.Key? key, required String otherUserId})
      : super(name,
            path: 'chat',
            args: OneToOneChatRouteArgs(key: key, otherUserId: otherUserId));

  static const String name = 'OneToOneChatRoute';
}

class OneToOneChatRouteArgs {
  const OneToOneChatRouteArgs({this.key, required this.otherUserId});

  final _i66.Key? key;

  final String otherUserId;

  @override
  String toString() {
    return 'OneToOneChatRouteArgs{key: $key, otherUserId: $otherUserId}';
  }
}

/// generated route for [_i8.ClubMembersChatPage]
class ClubMembersChatRoute
    extends _i42.PageRouteInfo<ClubMembersChatRouteArgs> {
  ClubMembersChatRoute({_i66.Key? key, required String clubId})
      : super(name,
            path: 'club-chat',
            args: ClubMembersChatRouteArgs(key: key, clubId: clubId));

  static const String name = 'ClubMembersChatRoute';
}

class ClubMembersChatRouteArgs {
  const ClubMembersChatRouteArgs({this.key, required this.clubId});

  final _i66.Key? key;

  final String clubId;

  @override
  String toString() {
    return 'ClubMembersChatRouteArgs{key: $key, clubId: $clubId}';
  }
}

/// generated route for [_i9.ClubInviteLandingPage]
class ClubInviteLandingRoute
    extends _i42.PageRouteInfo<ClubInviteLandingRouteArgs> {
  ClubInviteLandingRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'club-invite/:id',
            args: ClubInviteLandingRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubInviteLandingRoute';
}

class ClubInviteLandingRouteArgs {
  const ClubInviteLandingRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubInviteLandingRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i10.CollectionDetailsPage]
class CollectionDetailsRoute
    extends _i42.PageRouteInfo<CollectionDetailsRouteArgs> {
  CollectionDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'collection/:id',
            args: CollectionDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'CollectionDetailsRoute';
}

class CollectionDetailsRouteArgs {
  const CollectionDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'CollectionDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i11.DoWorkoutWrapperPage]
class DoWorkoutWrapperRoute
    extends _i42.PageRouteInfo<DoWorkoutWrapperRouteArgs> {
  DoWorkoutWrapperRoute(
      {_i66.Key? key,
      required String id,
      _i67.ScheduledWorkout? scheduledWorkout})
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

  final _i66.Key? key;

  final String id;

  final _i67.ScheduledWorkout? scheduledWorkout;

  @override
  String toString() {
    return 'DoWorkoutWrapperRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout}';
  }
}

/// generated route for [_i12.SettingsPage]
class SettingsRoute extends _i42.PageRouteInfo<void> {
  const SettingsRoute() : super(name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for [_i13.TimersPage]
class TimersRoute extends _i42.PageRouteInfo<void> {
  const TimersRoute() : super(name, path: 'timers');

  static const String name = 'TimersRoute';
}

/// generated route for [_i14.YourPostsPage]
class YourPostsRoute extends _i42.PageRouteInfo<void> {
  const YourPostsRoute() : super(name, path: 'your-posts');

  static const String name = 'YourPostsRoute';
}

/// generated route for [_i15.PublicWorkoutFinderPage]
class PublicWorkoutFinderRoute
    extends _i42.PageRouteInfo<PublicWorkoutFinderRouteArgs> {
  PublicWorkoutFinderRoute(
      {_i66.Key? key, void Function(_i67.WorkoutSummary)? selectWorkout})
      : super(name,
            path: 'community-workouts',
            args: PublicWorkoutFinderRouteArgs(
                key: key, selectWorkout: selectWorkout));

  static const String name = 'PublicWorkoutFinderRoute';
}

class PublicWorkoutFinderRouteArgs {
  const PublicWorkoutFinderRouteArgs({this.key, this.selectWorkout});

  final _i66.Key? key;

  final void Function(_i67.WorkoutSummary)? selectWorkout;

  @override
  String toString() {
    return 'PublicWorkoutFinderRouteArgs{key: $key, selectWorkout: $selectWorkout}';
  }
}

/// generated route for [_i16.PrivateWorkoutFinderPage]
class PrivateWorkoutFinderRoute
    extends _i42.PageRouteInfo<PrivateWorkoutFinderRouteArgs> {
  PrivateWorkoutFinderRoute(
      {_i66.Key? key,
      required void Function(_i67.WorkoutSummary) selectWorkout})
      : super(name,
            path: 'personal-workouts',
            args: PrivateWorkoutFinderRouteArgs(
                key: key, selectWorkout: selectWorkout));

  static const String name = 'PrivateWorkoutFinderRoute';
}

class PrivateWorkoutFinderRouteArgs {
  const PrivateWorkoutFinderRouteArgs({this.key, required this.selectWorkout});

  final _i66.Key? key;

  final void Function(_i67.WorkoutSummary) selectWorkout;

  @override
  String toString() {
    return 'PrivateWorkoutFinderRouteArgs{key: $key, selectWorkout: $selectWorkout}';
  }
}

/// generated route for [_i17.PublicWorkoutPlanFinderPage]
class PublicWorkoutPlanFinderRoute
    extends _i42.PageRouteInfo<PublicWorkoutPlanFinderRouteArgs> {
  PublicWorkoutPlanFinderRoute(
      {_i66.Key? key,
      void Function(_i67.WorkoutPlanSummary)? selectWorkoutPlan})
      : super(name,
            path: 'community-plans',
            args: PublicWorkoutPlanFinderRouteArgs(
                key: key, selectWorkoutPlan: selectWorkoutPlan));

  static const String name = 'PublicWorkoutPlanFinderRoute';
}

class PublicWorkoutPlanFinderRouteArgs {
  const PublicWorkoutPlanFinderRouteArgs({this.key, this.selectWorkoutPlan});

  final _i66.Key? key;

  final void Function(_i67.WorkoutPlanSummary)? selectWorkoutPlan;

  @override
  String toString() {
    return 'PublicWorkoutPlanFinderRouteArgs{key: $key, selectWorkoutPlan: $selectWorkoutPlan}';
  }
}

/// generated route for [_i18.PrivateWorkoutPlanFinderPage]
class PrivateWorkoutPlanFinderRoute
    extends _i42.PageRouteInfo<PrivateWorkoutPlanFinderRouteArgs> {
  PrivateWorkoutPlanFinderRoute(
      {_i66.Key? key,
      required void Function(_i67.WorkoutPlanSummary) selectWorkoutPlan})
      : super(name,
            path: 'personal-plans',
            args: PrivateWorkoutPlanFinderRouteArgs(
                key: key, selectWorkoutPlan: selectWorkoutPlan));

  static const String name = 'PrivateWorkoutPlanFinderRoute';
}

class PrivateWorkoutPlanFinderRouteArgs {
  const PrivateWorkoutPlanFinderRouteArgs(
      {this.key, required this.selectWorkoutPlan});

  final _i66.Key? key;

  final void Function(_i67.WorkoutPlanSummary) selectWorkoutPlan;

  @override
  String toString() {
    return 'PrivateWorkoutPlanFinderRouteArgs{key: $key, selectWorkoutPlan: $selectWorkoutPlan}';
  }
}

/// generated route for [_i19.ClubDetailsPage]
class ClubDetailsRoute extends _i42.PageRouteInfo<ClubDetailsRouteArgs> {
  ClubDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'club/:id',
            args: ClubDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubDetailsRoute';
}

class ClubDetailsRouteArgs {
  const ClubDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i20.LoggedWorkoutDetailsPage]
class LoggedWorkoutDetailsRoute
    extends _i42.PageRouteInfo<LoggedWorkoutDetailsRouteArgs> {
  LoggedWorkoutDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'logged-workout/:id',
            args: LoggedWorkoutDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'LoggedWorkoutDetailsRoute';
}

class LoggedWorkoutDetailsRouteArgs {
  const LoggedWorkoutDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'LoggedWorkoutDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i21.PersonalBestDetailsPage]
class PersonalBestDetailsRoute
    extends _i42.PageRouteInfo<PersonalBestDetailsRouteArgs> {
  PersonalBestDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'personal-best/:id',
            args: PersonalBestDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'PersonalBestDetailsRoute';
}

class PersonalBestDetailsRouteArgs {
  const PersonalBestDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'PersonalBestDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i22.UserPublicProfileDetailsPage]
class UserPublicProfileDetailsRoute
    extends _i42.PageRouteInfo<UserPublicProfileDetailsRouteArgs> {
  UserPublicProfileDetailsRoute({_i66.Key? key, required String userId})
      : super(name,
            path: 'profile/:userId',
            args: UserPublicProfileDetailsRouteArgs(key: key, userId: userId),
            rawPathParams: {'userId': userId});

  static const String name = 'UserPublicProfileDetailsRoute';
}

class UserPublicProfileDetailsRouteArgs {
  const UserPublicProfileDetailsRouteArgs({this.key, required this.userId});

  final _i66.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserPublicProfileDetailsRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for [_i23.ProgressJournalDetailsPage]
class ProgressJournalDetailsRoute
    extends _i42.PageRouteInfo<ProgressJournalDetailsRouteArgs> {
  ProgressJournalDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'progress-journal/:id',
            args: ProgressJournalDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ProgressJournalDetailsRoute';
}

class ProgressJournalDetailsRouteArgs {
  const ProgressJournalDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'ProgressJournalDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i24.WorkoutDetailsPage]
class WorkoutDetailsRoute extends _i42.PageRouteInfo<WorkoutDetailsRouteArgs> {
  WorkoutDetailsRoute(
      {_i66.Key? key,
      required String id,
      _i67.ScheduledWorkout? scheduledWorkout})
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

  final _i66.Key? key;

  final String id;

  final _i67.ScheduledWorkout? scheduledWorkout;

  @override
  String toString() {
    return 'WorkoutDetailsRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout}';
  }
}

/// generated route for [_i25.WorkoutPlanDetailsPage]
class WorkoutPlanDetailsRoute
    extends _i42.PageRouteInfo<WorkoutPlanDetailsRouteArgs> {
  WorkoutPlanDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'workout-plan/:id',
            args: WorkoutPlanDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutPlanDetailsRoute';
}

class WorkoutPlanDetailsRouteArgs {
  const WorkoutPlanDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'WorkoutPlanDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i26.WorkoutPlanEnrolmentDetailsPage]
class WorkoutPlanEnrolmentDetailsRoute
    extends _i42.PageRouteInfo<WorkoutPlanEnrolmentDetailsRouteArgs> {
  WorkoutPlanEnrolmentDetailsRoute({_i66.Key? key, required String id})
      : super(name,
            path: 'workout-plan-progress/:id',
            args: WorkoutPlanEnrolmentDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutPlanEnrolmentDetailsRoute';
}

class WorkoutPlanEnrolmentDetailsRouteArgs {
  const WorkoutPlanEnrolmentDetailsRouteArgs({this.key, required this.id});

  final _i66.Key? key;

  final String id;

  @override
  String toString() {
    return 'WorkoutPlanEnrolmentDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for [_i27.BodyTrackingEntryCreatorPage]
class BodyTrackingEntryCreatorRoute
    extends _i42.PageRouteInfo<BodyTrackingEntryCreatorRouteArgs> {
  BodyTrackingEntryCreatorRoute(
      {_i66.Key? key, _i67.BodyTrackingEntry? bodyTrackingEntry})
      : super(name,
            path: 'create/body-tracking',
            args: BodyTrackingEntryCreatorRouteArgs(
                key: key, bodyTrackingEntry: bodyTrackingEntry));

  static const String name = 'BodyTrackingEntryCreatorRoute';
}

class BodyTrackingEntryCreatorRouteArgs {
  const BodyTrackingEntryCreatorRouteArgs({this.key, this.bodyTrackingEntry});

  final _i66.Key? key;

  final _i67.BodyTrackingEntry? bodyTrackingEntry;

  @override
  String toString() {
    return 'BodyTrackingEntryCreatorRouteArgs{key: $key, bodyTrackingEntry: $bodyTrackingEntry}';
  }
}

/// generated route for [_i28.ClubCreatorPage]
class ClubCreatorRoute extends _i42.PageRouteInfo<ClubCreatorRouteArgs> {
  ClubCreatorRoute({_i66.Key? key, _i67.Club? club})
      : super(name,
            path: 'create/club',
            args: ClubCreatorRouteArgs(key: key, club: club));

  static const String name = 'ClubCreatorRoute';
}

class ClubCreatorRouteArgs {
  const ClubCreatorRouteArgs({this.key, this.club});

  final _i66.Key? key;

  final _i67.Club? club;

  @override
  String toString() {
    return 'ClubCreatorRouteArgs{key: $key, club: $club}';
  }
}

/// generated route for [_i29.CollectionCreatorPage]
class CollectionCreatorRoute
    extends _i42.PageRouteInfo<CollectionCreatorRouteArgs> {
  CollectionCreatorRoute(
      {_i66.Key? key,
      _i67.Collection? collection,
      void Function(_i67.Collection)? onComplete})
      : super(name,
            path: 'create/collection',
            args: CollectionCreatorRouteArgs(
                key: key, collection: collection, onComplete: onComplete));

  static const String name = 'CollectionCreatorRoute';
}

class CollectionCreatorRouteArgs {
  const CollectionCreatorRouteArgs(
      {this.key, this.collection, this.onComplete});

  final _i66.Key? key;

  final _i67.Collection? collection;

  final void Function(_i67.Collection)? onComplete;

  @override
  String toString() {
    return 'CollectionCreatorRouteArgs{key: $key, collection: $collection, onComplete: $onComplete}';
  }
}

/// generated route for [_i30.CustomMoveCreatorPage]
class CustomMoveCreatorRoute
    extends _i42.PageRouteInfo<CustomMoveCreatorRouteArgs> {
  CustomMoveCreatorRoute({_i66.Key? key, _i67.Move? move})
      : super(name,
            path: 'create/custom-move',
            args: CustomMoveCreatorRouteArgs(key: key, move: move));

  static const String name = 'CustomMoveCreatorRoute';
}

class CustomMoveCreatorRouteArgs {
  const CustomMoveCreatorRouteArgs({this.key, this.move});

  final _i66.Key? key;

  final _i67.Move? move;

  @override
  String toString() {
    return 'CustomMoveCreatorRouteArgs{key: $key, move: $move}';
  }
}

/// generated route for [_i31.GymProfileCreatorPage]
class GymProfileCreatorRoute
    extends _i42.PageRouteInfo<GymProfileCreatorRouteArgs> {
  GymProfileCreatorRoute({_i66.Key? key, _i67.GymProfile? gymProfile})
      : super(name,
            path: 'create/gym-profile',
            args: GymProfileCreatorRouteArgs(key: key, gymProfile: gymProfile));

  static const String name = 'GymProfileCreatorRoute';
}

class GymProfileCreatorRouteArgs {
  const GymProfileCreatorRouteArgs({this.key, this.gymProfile});

  final _i66.Key? key;

  final _i67.GymProfile? gymProfile;

  @override
  String toString() {
    return 'GymProfileCreatorRouteArgs{key: $key, gymProfile: $gymProfile}';
  }
}

/// generated route for [_i32.ProgressJournalCreatorPage]
class ProgressJournalCreatorRoute
    extends _i42.PageRouteInfo<ProgressJournalCreatorRouteArgs> {
  ProgressJournalCreatorRoute(
      {_i66.Key? key, _i67.ProgressJournal? progressJournal})
      : super(name,
            path: 'create/journal',
            args: ProgressJournalCreatorRouteArgs(
                key: key, progressJournal: progressJournal));

  static const String name = 'ProgressJournalCreatorRoute';
}

class ProgressJournalCreatorRouteArgs {
  const ProgressJournalCreatorRouteArgs({this.key, this.progressJournal});

  final _i66.Key? key;

  final _i67.ProgressJournal? progressJournal;

  @override
  String toString() {
    return 'ProgressJournalCreatorRouteArgs{key: $key, progressJournal: $progressJournal}';
  }
}

/// generated route for [_i33.PersonalBestCreatorPage]
class PersonalBestCreatorRoute
    extends _i42.PageRouteInfo<PersonalBestCreatorRouteArgs> {
  PersonalBestCreatorRoute({_i66.Key? key, _i67.UserBenchmark? userBenchmark})
      : super(name,
            path: 'create/personal-best',
            args: PersonalBestCreatorRouteArgs(
                key: key, userBenchmark: userBenchmark));

  static const String name = 'PersonalBestCreatorRoute';
}

class PersonalBestCreatorRouteArgs {
  const PersonalBestCreatorRouteArgs({this.key, this.userBenchmark});

  final _i66.Key? key;

  final _i67.UserBenchmark? userBenchmark;

  @override
  String toString() {
    return 'PersonalBestCreatorRouteArgs{key: $key, userBenchmark: $userBenchmark}';
  }
}

/// generated route for [_i34.PostCreatorPage]
class PostCreatorRoute extends _i42.PageRouteInfo<void> {
  const PostCreatorRoute() : super(name, path: 'create/post');

  static const String name = 'PostCreatorRoute';
}

/// generated route for [_i35.ClubPostCreatorPage]
class ClubPostCreatorRoute
    extends _i42.PageRouteInfo<ClubPostCreatorRouteArgs> {
  ClubPostCreatorRoute(
      {_i66.Key? key,
      required String clubId,
      void Function(_i67.TimelinePostFullData)? onSuccess})
      : super(name,
            path: 'create/club-post',
            args: ClubPostCreatorRouteArgs(
                key: key, clubId: clubId, onSuccess: onSuccess));

  static const String name = 'ClubPostCreatorRoute';
}

class ClubPostCreatorRouteArgs {
  const ClubPostCreatorRouteArgs(
      {this.key, required this.clubId, this.onSuccess});

  final _i66.Key? key;

  final String clubId;

  final void Function(_i67.TimelinePostFullData)? onSuccess;

  @override
  String toString() {
    return 'ClubPostCreatorRouteArgs{key: $key, clubId: $clubId, onSuccess: $onSuccess}';
  }
}

/// generated route for [_i36.ScheduledWorkoutCreatorPage]
class ScheduledWorkoutCreatorRoute
    extends _i42.PageRouteInfo<ScheduledWorkoutCreatorRouteArgs> {
  ScheduledWorkoutCreatorRoute(
      {_i66.Key? key,
      _i67.ScheduledWorkout? scheduledWorkout,
      _i67.WorkoutSummary? workout,
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

  final _i66.Key? key;

  final _i67.ScheduledWorkout? scheduledWorkout;

  final _i67.WorkoutSummary? workout;

  final DateTime? scheduleOn;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'ScheduledWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workout: $workout, scheduleOn: $scheduleOn, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for [_i37.WorkoutCreatorPage]
class WorkoutCreatorRoute extends _i42.PageRouteInfo<WorkoutCreatorRouteArgs> {
  WorkoutCreatorRoute({_i66.Key? key, _i67.Workout? workout})
      : super(name,
            path: 'create/workout',
            args: WorkoutCreatorRouteArgs(key: key, workout: workout));

  static const String name = 'WorkoutCreatorRoute';
}

class WorkoutCreatorRouteArgs {
  const WorkoutCreatorRouteArgs({this.key, this.workout});

  final _i66.Key? key;

  final _i67.Workout? workout;

  @override
  String toString() {
    return 'WorkoutCreatorRouteArgs{key: $key, workout: $workout}';
  }
}

/// generated route for [_i38.LoggedWorkoutCreatorPage]
class LoggedWorkoutCreatorRoute
    extends _i42.PageRouteInfo<LoggedWorkoutCreatorRouteArgs> {
  LoggedWorkoutCreatorRoute(
      {_i66.Key? key,
      _i67.ScheduledWorkout? scheduledWorkout,
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

  final _i66.Key? key;

  final _i67.ScheduledWorkout? scheduledWorkout;

  final String workoutId;

  @override
  String toString() {
    return 'LoggedWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workoutId: $workoutId}';
  }
}

/// generated route for [_i39.WorkoutPlanCreatorPage]
class WorkoutPlanCreatorRoute
    extends _i42.PageRouteInfo<WorkoutPlanCreatorRouteArgs> {
  WorkoutPlanCreatorRoute({_i66.Key? key, _i67.WorkoutPlan? workoutPlan})
      : super(name,
            path: 'create/workout-plan',
            args: WorkoutPlanCreatorRouteArgs(
                key: key, workoutPlan: workoutPlan));

  static const String name = 'WorkoutPlanCreatorRoute';
}

class WorkoutPlanCreatorRouteArgs {
  const WorkoutPlanCreatorRouteArgs({this.key, this.workoutPlan});

  final _i66.Key? key;

  final _i67.WorkoutPlan? workoutPlan;

  @override
  String toString() {
    return 'WorkoutPlanCreatorRouteArgs{key: $key, workoutPlan: $workoutPlan}';
  }
}

/// generated route for [_i40.WorkoutPlanReviewCreatorPage]
class WorkoutPlanReviewCreatorRoute
    extends _i42.PageRouteInfo<WorkoutPlanReviewCreatorRouteArgs> {
  WorkoutPlanReviewCreatorRoute(
      {_i66.Key? key,
      _i67.WorkoutPlanReview? workoutPlanReview,
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

  final _i66.Key? key;

  final _i67.WorkoutPlanReview? workoutPlanReview;

  final String parentWorkoutPlanId;

  final String parentWorkoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutPlanReviewCreatorRouteArgs{key: $key, workoutPlanReview: $workoutPlanReview, parentWorkoutPlanId: $parentWorkoutPlanId, parentWorkoutPlanEnrolmentId: $parentWorkoutPlanEnrolmentId}';
  }
}

/// generated route for [_i41.PageNotFoundPage]
class RouteNotFoundRoute extends _i42.PageRouteInfo<void> {
  const RouteNotFoundRoute() : super(name, path: '404');

  static const String name = 'RouteNotFoundRoute';
}

/// generated route for [_i42.EmptyRouterPage]
class DiscoverStack extends _i42.PageRouteInfo<void> {
  const DiscoverStack({List<_i42.PageRouteInfo>? children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'DiscoverStack';
}

/// generated route for [_i43.SocialPage]
class SocialRoute extends _i42.PageRouteInfo<void> {
  const SocialRoute() : super(name, path: 'social');

  static const String name = 'SocialRoute';
}

/// generated route for [_i42.EmptyRouterPage]
class HomeStack extends _i42.PageRouteInfo<void> {
  const HomeStack({List<_i42.PageRouteInfo>? children})
      : super(name, path: 'studio', initialChildren: children);

  static const String name = 'HomeStack';
}

/// generated route for [_i42.EmptyRouterPage]
class ProgressStack extends _i42.PageRouteInfo<void> {
  const ProgressStack({List<_i42.PageRouteInfo>? children})
      : super(name, path: 'progress', initialChildren: children);

  static const String name = 'ProgressStack';
}

/// generated route for [_i44.ProfilePage]
class ProfileRoute extends _i42.PageRouteInfo<void> {
  const ProfileRoute() : super(name, path: 'profile');

  static const String name = 'ProfileRoute';
}

/// generated route for [_i45.DiscoverPage]
class DiscoverRoute extends _i42.PageRouteInfo<void> {
  const DiscoverRoute() : super(name, path: '');

  static const String name = 'DiscoverRoute';
}

/// generated route for [_i46.DiscoverPeoplePage]
class DiscoverPeopleRoute extends _i42.PageRouteInfo<void> {
  const DiscoverPeopleRoute() : super(name, path: 'discover-people');

  static const String name = 'DiscoverPeopleRoute';
}

/// generated route for [_i47.DiscoverClubsPage]
class DiscoverClubsRoute extends _i42.PageRouteInfo<void> {
  const DiscoverClubsRoute() : super(name, path: 'discover-clubs');

  static const String name = 'DiscoverClubsRoute';
}

/// generated route for [_i48.DiscoverCommunityPage]
class DiscoverCommunityRoute extends _i42.PageRouteInfo<void> {
  const DiscoverCommunityRoute() : super(name, path: 'community');

  static const String name = 'DiscoverCommunityRoute';
}

/// generated route for [_i49.DiscoverChampionsPage]
class DiscoverChampionsRoute extends _i42.PageRouteInfo<void> {
  const DiscoverChampionsRoute() : super(name, path: 'champions');

  static const String name = 'DiscoverChampionsRoute';
}

/// generated route for [_i50.HomePage]
class HomeRoute extends _i42.PageRouteInfo<void> {
  const HomeRoute() : super(name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for [_i51.YourAwardsPage]
class YourAwardsRoute extends _i42.PageRouteInfo<void> {
  const YourAwardsRoute() : super(name, path: 'your-awards');

  static const String name = 'YourAwardsRoute';
}

/// generated route for [_i52.YourClubsPage]
class YourClubsRoute extends _i42.PageRouteInfo<void> {
  const YourClubsRoute() : super(name, path: 'your-clubs');

  static const String name = 'YourClubsRoute';
}

/// generated route for [_i53.YourCollectionsPage]
class YourCollectionsRoute extends _i42.PageRouteInfo<void> {
  const YourCollectionsRoute() : super(name, path: 'your-collections');

  static const String name = 'YourCollectionsRoute';
}

/// generated route for [_i54.YourGymProfilesPage]
class YourGymProfilesRoute extends _i42.PageRouteInfo<void> {
  const YourGymProfilesRoute() : super(name, path: 'your-gym-profiles');

  static const String name = 'YourGymProfilesRoute';
}

/// generated route for [_i55.YourMovesLibraryPage]
class YourMovesLibraryRoute extends _i42.PageRouteInfo<void> {
  const YourMovesLibraryRoute() : super(name, path: 'your-moves');

  static const String name = 'YourMovesLibraryRoute';
}

/// generated route for [_i56.YourPlansPage]
class YourPlansRoute extends _i42.PageRouteInfo<void> {
  const YourPlansRoute() : super(name, path: 'your-plans');

  static const String name = 'YourPlansRoute';
}

/// generated route for [_i57.YourSchedulePage]
class YourScheduleRoute extends _i42.PageRouteInfo<YourScheduleRouteArgs> {
  YourScheduleRoute({_i66.Key? key, DateTime? openAtDate})
      : super(name,
            path: 'your-schedule',
            args: YourScheduleRouteArgs(key: key, openAtDate: openAtDate));

  static const String name = 'YourScheduleRoute';
}

class YourScheduleRouteArgs {
  const YourScheduleRouteArgs({this.key, this.openAtDate});

  final _i66.Key? key;

  final DateTime? openAtDate;

  @override
  String toString() {
    return 'YourScheduleRouteArgs{key: $key, openAtDate: $openAtDate}';
  }
}

/// generated route for [_i58.YourThrowdownsPage]
class YourThrowdownsRoute extends _i42.PageRouteInfo<void> {
  const YourThrowdownsRoute() : super(name, path: 'your-throwdowns');

  static const String name = 'YourThrowdownsRoute';
}

/// generated route for [_i59.YourWorkoutsPage]
class YourWorkoutsRoute extends _i42.PageRouteInfo<void> {
  const YourWorkoutsRoute() : super(name, path: 'your-workouts');

  static const String name = 'YourWorkoutsRoute';
}

/// generated route for [_i60.ProgressPage]
class ProgressRoute extends _i42.PageRouteInfo<void> {
  const ProgressRoute() : super(name, path: '');

  static const String name = 'ProgressRoute';
}

/// generated route for [_i61.PersonalBestsPage]
class PersonalBestsRoute extends _i42.PageRouteInfo<void> {
  const PersonalBestsRoute() : super(name, path: 'personal-bests');

  static const String name = 'PersonalBestsRoute';
}

/// generated route for [_i62.JournalsPage]
class JournalsRoute extends _i42.PageRouteInfo<void> {
  const JournalsRoute() : super(name, path: 'journals');

  static const String name = 'JournalsRoute';
}

/// generated route for [_i63.BodyTrackingPage]
class BodyTrackingRoute extends _i42.PageRouteInfo<void> {
  const BodyTrackingRoute() : super(name, path: 'body-tracking');

  static const String name = 'BodyTrackingRoute';
}

/// generated route for [_i64.LoggedWorkoutsPage]
class LoggedWorkoutsRoute extends _i42.PageRouteInfo<void> {
  const LoggedWorkoutsRoute() : super(name, path: 'workout-logs');

  static const String name = 'LoggedWorkoutsRoute';
}
