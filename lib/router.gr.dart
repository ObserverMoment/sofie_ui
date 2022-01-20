// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i62;
import 'package:flutter/cupertino.dart' as _i64;
import 'package:flutter/material.dart' as _i63;

import 'components/creators/body_tracking/body_tracking_entry_creator.dart'
    as _i41;
import 'components/creators/club_creator/club_creator.dart' as _i42;
import 'components/creators/collection_creator.dart' as _i43;
import 'components/creators/custom_move_creator/custom_move_creator.dart'
    as _i44;
import 'components/creators/gym_profile_creator.dart' as _i45;
import 'components/creators/journal_creators/journal_goal_creator_page.dart'
    as _i46;
import 'components/creators/journal_creators/journal_mood_creator_page.dart'
    as _i47;
import 'components/creators/logged_workout_creator/logged_workout_creator.dart'
    as _i53;
import 'components/creators/personal_best_creator/personal_best_creator.dart'
    as _i48;
import 'components/creators/post_creator/club_post_creator.dart' as _i50;
import 'components/creators/post_creator/feed_post_creator_page.dart' as _i49;
import 'components/creators/scheduled_workout_creator.dart' as _i51;
import 'components/creators/workout_creator/workout_creator.dart' as _i52;
import 'components/creators/workout_plan_creator/workout_plan_creator.dart'
    as _i54;
import 'components/creators/workout_plan_review_creator.dart' as _i55;
import 'components/do_workout/do_workout_wrapper_page.dart' as _i10;
import 'components/profile/user_public_content/profile_public_workout_plans.dart'
    as _i29;
import 'components/profile/user_public_content/profile_public_workouts.dart'
    as _i28;
import 'components/social/chat/chats_overview_page.dart' as _i5;
import 'components/social/chat/clubs/club_members_chat_page.dart' as _i7;
import 'components/social/chat/friends/one_to_one_chat_page.dart' as _i6;
import 'components/timers/timers_page.dart' as _i14;
import 'components/workout/workout_finders/public/public_workout_finder_page.dart'
    as _i30;
import 'components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart'
    as _i31;
import 'generated/api/graphql_api.dart' as _i65;
import 'main.dart' as _i2;
import 'pages/authed/authed_routes_wrapper_page.dart' as _i3;
import 'pages/authed/details_pages/club_details/club_details_page.dart' as _i34;
import 'pages/authed/details_pages/collection_details_page.dart' as _i9;
import 'pages/authed/details_pages/logged_workout_details_page.dart' as _i35;
import 'pages/authed/details_pages/personal_best_details_page.dart' as _i36;
import 'pages/authed/details_pages/user_public_profile_details_page.dart'
    as _i37;
import 'pages/authed/details_pages/workout_details_page.dart' as _i38;
import 'pages/authed/details_pages/workout_plan_details_page.dart' as _i39;
import 'pages/authed/details_pages/workout_plan_enrolment_details_page.dart'
    as _i40;
import 'pages/authed/discover/discover_clubs_page.dart' as _i33;
import 'pages/authed/discover/discover_page.dart' as _i58;
import 'pages/authed/discover/discover_people_page.dart' as _i32;
import 'pages/authed/home/home_page.dart' as _i59;
import 'pages/authed/home/your_clubs.dart' as _i15;
import 'pages/authed/home/your_collections.dart' as _i16;
import 'pages/authed/home/your_gym_profiles.dart' as _i17;
import 'pages/authed/home/your_moves_library.dart' as _i18;
import 'pages/authed/home/your_plans/your_plans.dart' as _i19;
import 'pages/authed/home/your_schedule.dart' as _i21;
import 'pages/authed/home/your_throwdowns.dart' as _i22;
import 'pages/authed/home/your_workouts/your_workouts.dart' as _i23;
import 'pages/authed/landing_pages/club_invite_landing_page.dart' as _i8;
import 'pages/authed/main_tabs_page.dart' as _i4;
import 'pages/authed/page_not_found.dart' as _i56;
import 'pages/authed/profile/archive_page.dart' as _i11;
import 'pages/authed/profile/edit_profile_page.dart' as _i13;
import 'pages/authed/profile/profile_page.dart' as _i61;
import 'pages/authed/profile/settings.dart' as _i12;
import 'pages/authed/progress/body_tracking_page.dart' as _i26;
import 'pages/authed/progress/journal_page.dart' as _i25;
import 'pages/authed/progress/logged_workouts_page.dart' as _i27;
import 'pages/authed/progress/personal_bests_page.dart' as _i24;
import 'pages/authed/progress/progress_page.dart' as _i60;
import 'pages/authed/social/social_page.dart' as _i57;
import 'pages/authed/social/your_posts_page.dart' as _i20;
import 'pages/unauthed/unauthed_landing.dart' as _i1;

class AppRouter extends _i62.RootStackRouter {
  AppRouter([_i63.GlobalKey<_i63.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i62.PageFactory> pagesMap = {
    UnauthedLandingRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i1.UnauthedLandingPage(),
          fullscreenDialog: true);
    },
    GlobalLoadingRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i2.GlobalLoadingPage(),
          fullscreenDialog: true);
    },
    AuthedRouter.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i3.AuthedRoutesWrapperPage(),
          fullscreenDialog: true);
    },
    MainTabsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.MainTabsPage());
    },
    ChatsOverviewRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i5.ChatsOverviewPage());
    },
    OneToOneChatRoute.name: (routeData) {
      final args = routeData.argsAs<OneToOneChatRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i6.OneToOneChatPage(
              key: args.key, otherUserId: args.otherUserId));
    },
    ClubMembersChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClubMembersChatRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i7.ClubMembersChatPage(key: args.key, clubId: args.clubId));
    },
    ClubInviteLandingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubInviteLandingRouteArgs>(
          orElse: () =>
              ClubInviteLandingRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i8.ClubInviteLandingPage(key: args.key, id: args.id));
    },
    CollectionDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CollectionDetailsRouteArgs>(
          orElse: () =>
              CollectionDetailsRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i9.CollectionDetailsPage(key: args.key, id: args.id));
    },
    DoWorkoutWrapperRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DoWorkoutWrapperRouteArgs>(
          orElse: () =>
              DoWorkoutWrapperRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i10.DoWorkoutWrapperPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout,
              workoutPlanDayWorkoutId: args.workoutPlanDayWorkoutId,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    ArchiveRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i11.ArchivePage());
    },
    SettingsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i12.SettingsPage());
    },
    EditProfileRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i13.EditProfilePage());
    },
    TimersRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i14.TimersPage());
    },
    YourClubsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i15.YourClubsPage());
    },
    YourCollectionsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i16.YourCollectionsPage());
    },
    YourGymProfilesRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i17.YourGymProfilesPage());
    },
    YourMovesLibraryRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i18.YourMovesLibraryPage());
    },
    YourPlansRoute.name: (routeData) {
      final args = routeData.argsAs<YourPlansRouteArgs>(
          orElse: () => const YourPlansRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i19.YourPlansPage(
              key: args.key,
              selectPlan: args.selectPlan,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showJoined: args.showJoined,
              showSaved: args.showSaved));
    },
    YourPostsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i20.YourPostsPage());
    },
    YourScheduleRoute.name: (routeData) {
      final args = routeData.argsAs<YourScheduleRouteArgs>(
          orElse: () => const YourScheduleRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i21.YourSchedulePage(
              key: args.key, openAtDate: args.openAtDate));
    },
    YourThrowdownsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i22.YourThrowdownsPage());
    },
    YourWorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<YourWorkoutsRouteArgs>(
          orElse: () => const YourWorkoutsRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i23.YourWorkoutsPage(
              key: args.key,
              selectWorkout: args.selectWorkout,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showSaved: args.showSaved));
    },
    PersonalBestsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i24.PersonalBestsPage());
    },
    JournalRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i25.JournalPage());
    },
    BodyTrackingRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i26.BodyTrackingPage());
    },
    LoggedWorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutsRouteArgs>(
          orElse: () => const LoggedWorkoutsRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i27.LoggedWorkoutsPage(
              key: args.key,
              selectLoggedWorkout: args.selectLoggedWorkout,
              pageTitle: args.pageTitle));
    },
    ProfilePublicWorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<ProfilePublicWorkoutsRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i28.ProfilePublicWorkoutsPage(
              key: args.key,
              userId: args.userId,
              userDisplayName: args.userDisplayName));
    },
    ProfilePublicWorkoutPlansRoute.name: (routeData) {
      final args = routeData.argsAs<ProfilePublicWorkoutPlansRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i29.ProfilePublicWorkoutPlansPage(
              key: args.key,
              userId: args.userId,
              userDisplayName: args.userDisplayName));
    },
    PublicWorkoutFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutFinderRouteArgs>(
          orElse: () => const PublicWorkoutFinderRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i30.PublicWorkoutFinderPage(
              key: args.key, selectWorkout: args.selectWorkout));
    },
    PublicWorkoutPlanFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutPlanFinderRouteArgs>(
          orElse: () => const PublicWorkoutPlanFinderRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i31.PublicWorkoutPlanFinderPage(
              key: args.key, selectWorkoutPlan: args.selectWorkoutPlan));
    },
    DiscoverPeopleRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i32.DiscoverPeoplePage());
    },
    DiscoverClubsRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i33.DiscoverClubsPage());
    },
    ClubDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubDetailsRouteArgs>(
          orElse: () => ClubDetailsRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i34.ClubDetailsPage(key: args.key, id: args.id));
    },
    LoggedWorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoggedWorkoutDetailsRouteArgs>(
          orElse: () =>
              LoggedWorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i35.LoggedWorkoutDetailsPage(key: args.key, id: args.id));
    },
    PersonalBestDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PersonalBestDetailsRouteArgs>(
          orElse: () =>
              PersonalBestDetailsRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i36.PersonalBestDetailsPage(key: args.key, id: args.id));
    },
    UserPublicProfileDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicProfileDetailsRouteArgs>(
          orElse: () => UserPublicProfileDetailsRouteArgs(
              userId: pathParams.getString('userId')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i37.UserPublicProfileDetailsPage(
              key: args.key, userId: args.userId));
    },
    WorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutDetailsRouteArgs>(
          orElse: () =>
              WorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i38.WorkoutDetailsPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout,
              workoutPlanDayWorkoutId: args.workoutPlanDayWorkoutId,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutPlanDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanDetailsRouteArgs>(
          orElse: () =>
              WorkoutPlanDetailsRouteArgs(id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i39.WorkoutPlanDetailsPage(key: args.key, id: args.id));
    },
    WorkoutPlanEnrolmentDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanEnrolmentDetailsRouteArgs>(
          orElse: () => WorkoutPlanEnrolmentDetailsRouteArgs(
              id: pathParams.getString('id')));
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child:
              _i40.WorkoutPlanEnrolmentDetailsPage(key: args.key, id: args.id));
    },
    BodyTrackingEntryCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<BodyTrackingEntryCreatorRouteArgs>(
          orElse: () => const BodyTrackingEntryCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i41.BodyTrackingEntryCreatorPage(
              key: args.key, bodyTrackingEntry: args.bodyTrackingEntry));
    },
    ClubCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubCreatorRouteArgs>(
          orElse: () => const ClubCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i42.ClubCreatorPage(
              key: args.key, clubSummary: args.clubSummary));
    },
    CollectionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionCreatorRouteArgs>(
          orElse: () => const CollectionCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i43.CollectionCreatorPage(
              key: args.key,
              collection: args.collection,
              onComplete: args.onComplete));
    },
    CustomMoveCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CustomMoveCreatorRouteArgs>(
          orElse: () => const CustomMoveCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i44.CustomMoveCreatorPage(key: args.key, move: args.move));
    },
    GymProfileCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfileCreatorRouteArgs>(
          orElse: () => const GymProfileCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i45.GymProfileCreatorPage(
              key: args.key, gymProfile: args.gymProfile));
    },
    JournalGoalCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<JournalGoalCreatorRouteArgs>(
          orElse: () => const JournalGoalCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i46.JournalGoalCreatorPage(
              key: args.key, journalGoal: args.journalGoal));
    },
    JournalMoodCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<JournalMoodCreatorRouteArgs>(
          orElse: () => const JournalMoodCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i47.JournalMoodCreatorPage(
              key: args.key, journalMood: args.journalMood));
    },
    PersonalBestCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalBestCreatorRouteArgs>(
          orElse: () => const PersonalBestCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i48.PersonalBestCreatorPage(
              key: args.key, userBenchmark: args.userBenchmark));
    },
    FeedPostCreatorRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i49.FeedPostCreatorPage());
    },
    ClubPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubPostCreatorRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i50.ClubPostCreatorPage(
              key: args.key, clubId: args.clubId, onSuccess: args.onSuccess));
    },
    ScheduledWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduledWorkoutCreatorRouteArgs>(
          orElse: () => const ScheduledWorkoutCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i51.ScheduledWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workout: args.workout,
              scheduleOn: args.scheduleOn,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutCreatorRouteArgs>(
          orElse: () => const WorkoutCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i52.WorkoutCreatorPage(key: args.key, workout: args.workout));
    },
    LoggedWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutCreatorRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i53.LoggedWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workoutId: args.workoutId,
              workoutPlanDayWorkoutId: args.workoutPlanDayWorkoutId,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutPlanCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanCreatorRouteArgs>(
          orElse: () => const WorkoutPlanCreatorRouteArgs());
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i54.WorkoutPlanCreatorPage(
              key: args.key, workoutPlan: args.workoutPlan));
    },
    WorkoutPlanReviewCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanReviewCreatorRouteArgs>();
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i55.WorkoutPlanReviewCreatorPage(
              key: args.key,
              workoutPlanReview: args.workoutPlanReview,
              parentWorkoutPlanId: args.parentWorkoutPlanId,
              parentWorkoutPlanEnrolmentId: args.parentWorkoutPlanEnrolmentId));
    },
    RouteNotFoundRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i56.PageNotFoundPage());
    },
    SocialRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i57.SocialPage());
    },
    DiscoverRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i58.DiscoverPage());
    },
    HomeRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i59.HomePage());
    },
    ProgressRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i60.ProgressPage());
    },
    ProfileRoute.name: (routeData) {
      return _i62.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i61.ProfilePage());
    }
  };

  @override
  List<_i62.RouteConfig> get routes => [
        _i62.RouteConfig(UnauthedLandingRoute.name, path: '/auth'),
        _i62.RouteConfig(GlobalLoadingRoute.name, path: '/loading'),
        _i62.RouteConfig(AuthedRouter.name, path: '/', children: [
          _i62.RouteConfig(MainTabsRoute.name,
              path: '',
              parent: AuthedRouter.name,
              children: [
                _i62.RouteConfig(SocialRoute.name,
                    path: '', parent: MainTabsRoute.name),
                _i62.RouteConfig(DiscoverRoute.name,
                    path: 'discover', parent: MainTabsRoute.name),
                _i62.RouteConfig(HomeRoute.name,
                    path: 'studio', parent: MainTabsRoute.name),
                _i62.RouteConfig(ProgressRoute.name,
                    path: 'progress', parent: MainTabsRoute.name),
                _i62.RouteConfig(ProfileRoute.name,
                    path: 'profile', parent: MainTabsRoute.name)
              ]),
          _i62.RouteConfig(ChatsOverviewRoute.name,
              path: 'chats', parent: AuthedRouter.name),
          _i62.RouteConfig(OneToOneChatRoute.name,
              path: 'chat', parent: AuthedRouter.name),
          _i62.RouteConfig(ClubMembersChatRoute.name,
              path: 'club-chat', parent: AuthedRouter.name),
          _i62.RouteConfig(ClubInviteLandingRoute.name,
              path: 'club-invite/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(CollectionDetailsRoute.name,
              path: 'collection/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(DoWorkoutWrapperRoute.name,
              path: 'do-workout/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(ArchiveRoute.name,
              path: 'archive', parent: AuthedRouter.name),
          _i62.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: AuthedRouter.name),
          _i62.RouteConfig(EditProfileRoute.name,
              path: 'edit-profile', parent: AuthedRouter.name),
          _i62.RouteConfig(TimersRoute.name,
              path: 'timers', parent: AuthedRouter.name),
          _i62.RouteConfig(YourClubsRoute.name,
              path: 'your-clubs', parent: AuthedRouter.name),
          _i62.RouteConfig(YourCollectionsRoute.name,
              path: 'your-collections', parent: AuthedRouter.name),
          _i62.RouteConfig(YourGymProfilesRoute.name,
              path: 'your-gym-profiles', parent: AuthedRouter.name),
          _i62.RouteConfig(YourMovesLibraryRoute.name,
              path: 'your-moves', parent: AuthedRouter.name),
          _i62.RouteConfig(YourPlansRoute.name,
              path: 'your-plans', parent: AuthedRouter.name),
          _i62.RouteConfig(YourPostsRoute.name,
              path: 'your-posts', parent: AuthedRouter.name),
          _i62.RouteConfig(YourScheduleRoute.name,
              path: 'your-schedule', parent: AuthedRouter.name),
          _i62.RouteConfig(YourThrowdownsRoute.name,
              path: 'your-throwdowns', parent: AuthedRouter.name),
          _i62.RouteConfig(YourWorkoutsRoute.name,
              path: 'your-workouts', parent: AuthedRouter.name),
          _i62.RouteConfig(PersonalBestsRoute.name,
              path: 'personal-bests', parent: AuthedRouter.name),
          _i62.RouteConfig(JournalRoute.name,
              path: 'journal', parent: AuthedRouter.name),
          _i62.RouteConfig(BodyTrackingRoute.name,
              path: 'body-tracking', parent: AuthedRouter.name),
          _i62.RouteConfig(LoggedWorkoutsRoute.name,
              path: 'workout-logs', parent: AuthedRouter.name),
          _i62.RouteConfig(ProfilePublicWorkoutsRoute.name,
              path: 'public-workouts/:userId', parent: AuthedRouter.name),
          _i62.RouteConfig(ProfilePublicWorkoutPlansRoute.name,
              path: 'public-plans/:userId', parent: AuthedRouter.name),
          _i62.RouteConfig(PublicWorkoutFinderRoute.name,
              path: 'public-workouts', parent: AuthedRouter.name),
          _i62.RouteConfig(PublicWorkoutPlanFinderRoute.name,
              path: 'public-plans', parent: AuthedRouter.name),
          _i62.RouteConfig(DiscoverPeopleRoute.name,
              path: 'discover-people', parent: AuthedRouter.name),
          _i62.RouteConfig(DiscoverClubsRoute.name,
              path: 'discover-clubs', parent: AuthedRouter.name),
          _i62.RouteConfig(ClubDetailsRoute.name,
              path: 'club/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(LoggedWorkoutDetailsRoute.name,
              path: 'logged-workout/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(PersonalBestDetailsRoute.name,
              path: 'personal-best/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(UserPublicProfileDetailsRoute.name,
              path: 'profile/:userId', parent: AuthedRouter.name),
          _i62.RouteConfig(WorkoutDetailsRoute.name,
              path: 'workout/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(WorkoutPlanDetailsRoute.name,
              path: 'workout-plan/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(WorkoutPlanEnrolmentDetailsRoute.name,
              path: 'workout-plan-progress/:id', parent: AuthedRouter.name),
          _i62.RouteConfig(BodyTrackingEntryCreatorRoute.name,
              path: 'create/body-tracking', parent: AuthedRouter.name),
          _i62.RouteConfig(ClubCreatorRoute.name,
              path: 'create/club', parent: AuthedRouter.name),
          _i62.RouteConfig(CollectionCreatorRoute.name,
              path: 'create/collection', parent: AuthedRouter.name),
          _i62.RouteConfig(CustomMoveCreatorRoute.name,
              path: 'create/custom-move', parent: AuthedRouter.name),
          _i62.RouteConfig(GymProfileCreatorRoute.name,
              path: 'create/gym-profile', parent: AuthedRouter.name),
          _i62.RouteConfig(JournalGoalCreatorRoute.name,
              path: 'create/journal-goal', parent: AuthedRouter.name),
          _i62.RouteConfig(JournalMoodCreatorRoute.name,
              path: 'create/journal-mood', parent: AuthedRouter.name),
          _i62.RouteConfig(PersonalBestCreatorRoute.name,
              path: 'create/personal-best', parent: AuthedRouter.name),
          _i62.RouteConfig(FeedPostCreatorRoute.name,
              path: 'create/post', parent: AuthedRouter.name),
          _i62.RouteConfig(ClubPostCreatorRoute.name,
              path: 'create/club-post', parent: AuthedRouter.name),
          _i62.RouteConfig(ScheduledWorkoutCreatorRoute.name,
              path: 'create/scheduled-workout', parent: AuthedRouter.name),
          _i62.RouteConfig(WorkoutCreatorRoute.name,
              path: 'create/workout', parent: AuthedRouter.name),
          _i62.RouteConfig(LoggedWorkoutCreatorRoute.name,
              path: 'create/workout-log', parent: AuthedRouter.name),
          _i62.RouteConfig(WorkoutPlanCreatorRoute.name,
              path: 'create/workout-plan', parent: AuthedRouter.name),
          _i62.RouteConfig(WorkoutPlanReviewCreatorRoute.name,
              path: 'create/workout-plan-review', parent: AuthedRouter.name),
          _i62.RouteConfig(RouteNotFoundRoute.name,
              path: '404', parent: AuthedRouter.name),
          _i62.RouteConfig('*#redirect',
              path: '*',
              parent: AuthedRouter.name,
              redirectTo: '404',
              fullMatch: true)
        ])
      ];
}

/// generated route for
/// [_i1.UnauthedLandingPage]
class UnauthedLandingRoute extends _i62.PageRouteInfo<void> {
  const UnauthedLandingRoute()
      : super(UnauthedLandingRoute.name, path: '/auth');

  static const String name = 'UnauthedLandingRoute';
}

/// generated route for
/// [_i2.GlobalLoadingPage]
class GlobalLoadingRoute extends _i62.PageRouteInfo<void> {
  const GlobalLoadingRoute() : super(GlobalLoadingRoute.name, path: '/loading');

  static const String name = 'GlobalLoadingRoute';
}

/// generated route for
/// [_i3.AuthedRoutesWrapperPage]
class AuthedRouter extends _i62.PageRouteInfo<void> {
  const AuthedRouter({List<_i62.PageRouteInfo>? children})
      : super(AuthedRouter.name, path: '/', initialChildren: children);

  static const String name = 'AuthedRouter';
}

/// generated route for
/// [_i4.MainTabsPage]
class MainTabsRoute extends _i62.PageRouteInfo<void> {
  const MainTabsRoute({List<_i62.PageRouteInfo>? children})
      : super(MainTabsRoute.name, path: '', initialChildren: children);

  static const String name = 'MainTabsRoute';
}

/// generated route for
/// [_i5.ChatsOverviewPage]
class ChatsOverviewRoute extends _i62.PageRouteInfo<void> {
  const ChatsOverviewRoute() : super(ChatsOverviewRoute.name, path: 'chats');

  static const String name = 'ChatsOverviewRoute';
}

/// generated route for
/// [_i6.OneToOneChatPage]
class OneToOneChatRoute extends _i62.PageRouteInfo<OneToOneChatRouteArgs> {
  OneToOneChatRoute({_i64.Key? key, required String otherUserId})
      : super(OneToOneChatRoute.name,
            path: 'chat',
            args: OneToOneChatRouteArgs(key: key, otherUserId: otherUserId));

  static const String name = 'OneToOneChatRoute';
}

class OneToOneChatRouteArgs {
  const OneToOneChatRouteArgs({this.key, required this.otherUserId});

  final _i64.Key? key;

  final String otherUserId;

  @override
  String toString() {
    return 'OneToOneChatRouteArgs{key: $key, otherUserId: $otherUserId}';
  }
}

/// generated route for
/// [_i7.ClubMembersChatPage]
class ClubMembersChatRoute
    extends _i62.PageRouteInfo<ClubMembersChatRouteArgs> {
  ClubMembersChatRoute({_i64.Key? key, required String clubId})
      : super(ClubMembersChatRoute.name,
            path: 'club-chat',
            args: ClubMembersChatRouteArgs(key: key, clubId: clubId));

  static const String name = 'ClubMembersChatRoute';
}

class ClubMembersChatRouteArgs {
  const ClubMembersChatRouteArgs({this.key, required this.clubId});

  final _i64.Key? key;

  final String clubId;

  @override
  String toString() {
    return 'ClubMembersChatRouteArgs{key: $key, clubId: $clubId}';
  }
}

/// generated route for
/// [_i8.ClubInviteLandingPage]
class ClubInviteLandingRoute
    extends _i62.PageRouteInfo<ClubInviteLandingRouteArgs> {
  ClubInviteLandingRoute({_i64.Key? key, required String id})
      : super(ClubInviteLandingRoute.name,
            path: 'club-invite/:id',
            args: ClubInviteLandingRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubInviteLandingRoute';
}

class ClubInviteLandingRouteArgs {
  const ClubInviteLandingRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubInviteLandingRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i9.CollectionDetailsPage]
class CollectionDetailsRoute
    extends _i62.PageRouteInfo<CollectionDetailsRouteArgs> {
  CollectionDetailsRoute({_i64.Key? key, required String id})
      : super(CollectionDetailsRoute.name,
            path: 'collection/:id',
            args: CollectionDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'CollectionDetailsRoute';
}

class CollectionDetailsRouteArgs {
  const CollectionDetailsRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'CollectionDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i10.DoWorkoutWrapperPage]
class DoWorkoutWrapperRoute
    extends _i62.PageRouteInfo<DoWorkoutWrapperRouteArgs> {
  DoWorkoutWrapperRoute(
      {_i64.Key? key,
      required String id,
      _i65.ScheduledWorkout? scheduledWorkout,
      String? workoutPlanDayWorkoutId,
      String? workoutPlanEnrolmentId})
      : super(DoWorkoutWrapperRoute.name,
            path: 'do-workout/:id',
            args: DoWorkoutWrapperRouteArgs(
                key: key,
                id: id,
                scheduledWorkout: scheduledWorkout,
                workoutPlanDayWorkoutId: workoutPlanDayWorkoutId,
                workoutPlanEnrolmentId: workoutPlanEnrolmentId),
            rawPathParams: {'id': id});

  static const String name = 'DoWorkoutWrapperRoute';
}

class DoWorkoutWrapperRouteArgs {
  const DoWorkoutWrapperRouteArgs(
      {this.key,
      required this.id,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId});

  final _i64.Key? key;

  final String id;

  final _i65.ScheduledWorkout? scheduledWorkout;

  final String? workoutPlanDayWorkoutId;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'DoWorkoutWrapperRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout, workoutPlanDayWorkoutId: $workoutPlanDayWorkoutId, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i11.ArchivePage]
class ArchiveRoute extends _i62.PageRouteInfo<void> {
  const ArchiveRoute() : super(ArchiveRoute.name, path: 'archive');

  static const String name = 'ArchiveRoute';
}

/// generated route for
/// [_i12.SettingsPage]
class SettingsRoute extends _i62.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i13.EditProfilePage]
class EditProfileRoute extends _i62.PageRouteInfo<void> {
  const EditProfileRoute() : super(EditProfileRoute.name, path: 'edit-profile');

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i14.TimersPage]
class TimersRoute extends _i62.PageRouteInfo<void> {
  const TimersRoute() : super(TimersRoute.name, path: 'timers');

  static const String name = 'TimersRoute';
}

/// generated route for
/// [_i15.YourClubsPage]
class YourClubsRoute extends _i62.PageRouteInfo<void> {
  const YourClubsRoute() : super(YourClubsRoute.name, path: 'your-clubs');

  static const String name = 'YourClubsRoute';
}

/// generated route for
/// [_i16.YourCollectionsPage]
class YourCollectionsRoute extends _i62.PageRouteInfo<void> {
  const YourCollectionsRoute()
      : super(YourCollectionsRoute.name, path: 'your-collections');

  static const String name = 'YourCollectionsRoute';
}

/// generated route for
/// [_i17.YourGymProfilesPage]
class YourGymProfilesRoute extends _i62.PageRouteInfo<void> {
  const YourGymProfilesRoute()
      : super(YourGymProfilesRoute.name, path: 'your-gym-profiles');

  static const String name = 'YourGymProfilesRoute';
}

/// generated route for
/// [_i18.YourMovesLibraryPage]
class YourMovesLibraryRoute extends _i62.PageRouteInfo<void> {
  const YourMovesLibraryRoute()
      : super(YourMovesLibraryRoute.name, path: 'your-moves');

  static const String name = 'YourMovesLibraryRoute';
}

/// generated route for
/// [_i19.YourPlansPage]
class YourPlansRoute extends _i62.PageRouteInfo<YourPlansRouteArgs> {
  YourPlansRoute(
      {_i64.Key? key,
      void Function(_i65.WorkoutPlanSummary)? selectPlan,
      bool showCreateButton = false,
      bool showDiscoverButton = false,
      String pageTitle = 'Plans',
      bool showJoined = true,
      bool showSaved = true})
      : super(YourPlansRoute.name,
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

  final _i64.Key? key;

  final void Function(_i65.WorkoutPlanSummary)? selectPlan;

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

/// generated route for
/// [_i20.YourPostsPage]
class YourPostsRoute extends _i62.PageRouteInfo<void> {
  const YourPostsRoute() : super(YourPostsRoute.name, path: 'your-posts');

  static const String name = 'YourPostsRoute';
}

/// generated route for
/// [_i21.YourSchedulePage]
class YourScheduleRoute extends _i62.PageRouteInfo<YourScheduleRouteArgs> {
  YourScheduleRoute({_i64.Key? key, DateTime? openAtDate})
      : super(YourScheduleRoute.name,
            path: 'your-schedule',
            args: YourScheduleRouteArgs(key: key, openAtDate: openAtDate));

  static const String name = 'YourScheduleRoute';
}

class YourScheduleRouteArgs {
  const YourScheduleRouteArgs({this.key, this.openAtDate});

  final _i64.Key? key;

  final DateTime? openAtDate;

  @override
  String toString() {
    return 'YourScheduleRouteArgs{key: $key, openAtDate: $openAtDate}';
  }
}

/// generated route for
/// [_i22.YourThrowdownsPage]
class YourThrowdownsRoute extends _i62.PageRouteInfo<void> {
  const YourThrowdownsRoute()
      : super(YourThrowdownsRoute.name, path: 'your-throwdowns');

  static const String name = 'YourThrowdownsRoute';
}

/// generated route for
/// [_i23.YourWorkoutsPage]
class YourWorkoutsRoute extends _i62.PageRouteInfo<YourWorkoutsRouteArgs> {
  YourWorkoutsRoute(
      {_i64.Key? key,
      void Function(_i65.WorkoutSummary)? selectWorkout,
      bool showCreateButton = false,
      bool showDiscoverButton = false,
      String? pageTitle,
      bool showSaved = true})
      : super(YourWorkoutsRoute.name,
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
      this.pageTitle,
      this.showSaved = true});

  final _i64.Key? key;

  final void Function(_i65.WorkoutSummary)? selectWorkout;

  final bool showCreateButton;

  final bool showDiscoverButton;

  final String? pageTitle;

  final bool showSaved;

  @override
  String toString() {
    return 'YourWorkoutsRouteArgs{key: $key, selectWorkout: $selectWorkout, showCreateButton: $showCreateButton, showDiscoverButton: $showDiscoverButton, pageTitle: $pageTitle, showSaved: $showSaved}';
  }
}

/// generated route for
/// [_i24.PersonalBestsPage]
class PersonalBestsRoute extends _i62.PageRouteInfo<void> {
  const PersonalBestsRoute()
      : super(PersonalBestsRoute.name, path: 'personal-bests');

  static const String name = 'PersonalBestsRoute';
}

/// generated route for
/// [_i25.JournalPage]
class JournalRoute extends _i62.PageRouteInfo<void> {
  const JournalRoute() : super(JournalRoute.name, path: 'journal');

  static const String name = 'JournalRoute';
}

/// generated route for
/// [_i26.BodyTrackingPage]
class BodyTrackingRoute extends _i62.PageRouteInfo<void> {
  const BodyTrackingRoute()
      : super(BodyTrackingRoute.name, path: 'body-tracking');

  static const String name = 'BodyTrackingRoute';
}

/// generated route for
/// [_i27.LoggedWorkoutsPage]
class LoggedWorkoutsRoute extends _i62.PageRouteInfo<LoggedWorkoutsRouteArgs> {
  LoggedWorkoutsRoute(
      {_i64.Key? key,
      void Function(_i65.LoggedWorkout)? selectLoggedWorkout,
      String pageTitle = 'Workout Logs'})
      : super(LoggedWorkoutsRoute.name,
            path: 'workout-logs',
            args: LoggedWorkoutsRouteArgs(
                key: key,
                selectLoggedWorkout: selectLoggedWorkout,
                pageTitle: pageTitle));

  static const String name = 'LoggedWorkoutsRoute';
}

class LoggedWorkoutsRouteArgs {
  const LoggedWorkoutsRouteArgs(
      {this.key, this.selectLoggedWorkout, this.pageTitle = 'Workout Logs'});

  final _i64.Key? key;

  final void Function(_i65.LoggedWorkout)? selectLoggedWorkout;

  final String pageTitle;

  @override
  String toString() {
    return 'LoggedWorkoutsRouteArgs{key: $key, selectLoggedWorkout: $selectLoggedWorkout, pageTitle: $pageTitle}';
  }
}

/// generated route for
/// [_i28.ProfilePublicWorkoutsPage]
class ProfilePublicWorkoutsRoute
    extends _i62.PageRouteInfo<ProfilePublicWorkoutsRouteArgs> {
  ProfilePublicWorkoutsRoute(
      {_i64.Key? key, required String userId, String? userDisplayName})
      : super(ProfilePublicWorkoutsRoute.name,
            path: 'public-workouts/:userId',
            args: ProfilePublicWorkoutsRouteArgs(
                key: key, userId: userId, userDisplayName: userDisplayName));

  static const String name = 'ProfilePublicWorkoutsRoute';
}

class ProfilePublicWorkoutsRouteArgs {
  const ProfilePublicWorkoutsRouteArgs(
      {this.key, required this.userId, this.userDisplayName});

  final _i64.Key? key;

  final String userId;

  final String? userDisplayName;

  @override
  String toString() {
    return 'ProfilePublicWorkoutsRouteArgs{key: $key, userId: $userId, userDisplayName: $userDisplayName}';
  }
}

/// generated route for
/// [_i29.ProfilePublicWorkoutPlansPage]
class ProfilePublicWorkoutPlansRoute
    extends _i62.PageRouteInfo<ProfilePublicWorkoutPlansRouteArgs> {
  ProfilePublicWorkoutPlansRoute(
      {_i64.Key? key, required String userId, String? userDisplayName})
      : super(ProfilePublicWorkoutPlansRoute.name,
            path: 'public-plans/:userId',
            args: ProfilePublicWorkoutPlansRouteArgs(
                key: key, userId: userId, userDisplayName: userDisplayName));

  static const String name = 'ProfilePublicWorkoutPlansRoute';
}

class ProfilePublicWorkoutPlansRouteArgs {
  const ProfilePublicWorkoutPlansRouteArgs(
      {this.key, required this.userId, this.userDisplayName});

  final _i64.Key? key;

  final String userId;

  final String? userDisplayName;

  @override
  String toString() {
    return 'ProfilePublicWorkoutPlansRouteArgs{key: $key, userId: $userId, userDisplayName: $userDisplayName}';
  }
}

/// generated route for
/// [_i30.PublicWorkoutFinderPage]
class PublicWorkoutFinderRoute
    extends _i62.PageRouteInfo<PublicWorkoutFinderRouteArgs> {
  PublicWorkoutFinderRoute(
      {_i64.Key? key, void Function(_i65.WorkoutSummary)? selectWorkout})
      : super(PublicWorkoutFinderRoute.name,
            path: 'public-workouts',
            args: PublicWorkoutFinderRouteArgs(
                key: key, selectWorkout: selectWorkout));

  static const String name = 'PublicWorkoutFinderRoute';
}

class PublicWorkoutFinderRouteArgs {
  const PublicWorkoutFinderRouteArgs({this.key, this.selectWorkout});

  final _i64.Key? key;

  final void Function(_i65.WorkoutSummary)? selectWorkout;

  @override
  String toString() {
    return 'PublicWorkoutFinderRouteArgs{key: $key, selectWorkout: $selectWorkout}';
  }
}

/// generated route for
/// [_i31.PublicWorkoutPlanFinderPage]
class PublicWorkoutPlanFinderRoute
    extends _i62.PageRouteInfo<PublicWorkoutPlanFinderRouteArgs> {
  PublicWorkoutPlanFinderRoute(
      {_i64.Key? key,
      void Function(_i65.WorkoutPlanSummary)? selectWorkoutPlan})
      : super(PublicWorkoutPlanFinderRoute.name,
            path: 'public-plans',
            args: PublicWorkoutPlanFinderRouteArgs(
                key: key, selectWorkoutPlan: selectWorkoutPlan));

  static const String name = 'PublicWorkoutPlanFinderRoute';
}

class PublicWorkoutPlanFinderRouteArgs {
  const PublicWorkoutPlanFinderRouteArgs({this.key, this.selectWorkoutPlan});

  final _i64.Key? key;

  final void Function(_i65.WorkoutPlanSummary)? selectWorkoutPlan;

  @override
  String toString() {
    return 'PublicWorkoutPlanFinderRouteArgs{key: $key, selectWorkoutPlan: $selectWorkoutPlan}';
  }
}

/// generated route for
/// [_i32.DiscoverPeoplePage]
class DiscoverPeopleRoute extends _i62.PageRouteInfo<void> {
  const DiscoverPeopleRoute()
      : super(DiscoverPeopleRoute.name, path: 'discover-people');

  static const String name = 'DiscoverPeopleRoute';
}

/// generated route for
/// [_i33.DiscoverClubsPage]
class DiscoverClubsRoute extends _i62.PageRouteInfo<void> {
  const DiscoverClubsRoute()
      : super(DiscoverClubsRoute.name, path: 'discover-clubs');

  static const String name = 'DiscoverClubsRoute';
}

/// generated route for
/// [_i34.ClubDetailsPage]
class ClubDetailsRoute extends _i62.PageRouteInfo<ClubDetailsRouteArgs> {
  ClubDetailsRoute({_i64.Key? key, required String id})
      : super(ClubDetailsRoute.name,
            path: 'club/:id',
            args: ClubDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubDetailsRoute';
}

class ClubDetailsRouteArgs {
  const ClubDetailsRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i35.LoggedWorkoutDetailsPage]
class LoggedWorkoutDetailsRoute
    extends _i62.PageRouteInfo<LoggedWorkoutDetailsRouteArgs> {
  LoggedWorkoutDetailsRoute({_i64.Key? key, required String id})
      : super(LoggedWorkoutDetailsRoute.name,
            path: 'logged-workout/:id',
            args: LoggedWorkoutDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'LoggedWorkoutDetailsRoute';
}

class LoggedWorkoutDetailsRouteArgs {
  const LoggedWorkoutDetailsRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'LoggedWorkoutDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i36.PersonalBestDetailsPage]
class PersonalBestDetailsRoute
    extends _i62.PageRouteInfo<PersonalBestDetailsRouteArgs> {
  PersonalBestDetailsRoute({_i64.Key? key, required String id})
      : super(PersonalBestDetailsRoute.name,
            path: 'personal-best/:id',
            args: PersonalBestDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'PersonalBestDetailsRoute';
}

class PersonalBestDetailsRouteArgs {
  const PersonalBestDetailsRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'PersonalBestDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i37.UserPublicProfileDetailsPage]
class UserPublicProfileDetailsRoute
    extends _i62.PageRouteInfo<UserPublicProfileDetailsRouteArgs> {
  UserPublicProfileDetailsRoute({_i64.Key? key, required String userId})
      : super(UserPublicProfileDetailsRoute.name,
            path: 'profile/:userId',
            args: UserPublicProfileDetailsRouteArgs(key: key, userId: userId),
            rawPathParams: {'userId': userId});

  static const String name = 'UserPublicProfileDetailsRoute';
}

class UserPublicProfileDetailsRouteArgs {
  const UserPublicProfileDetailsRouteArgs({this.key, required this.userId});

  final _i64.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserPublicProfileDetailsRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i38.WorkoutDetailsPage]
class WorkoutDetailsRoute extends _i62.PageRouteInfo<WorkoutDetailsRouteArgs> {
  WorkoutDetailsRoute(
      {_i64.Key? key,
      required String id,
      _i65.ScheduledWorkout? scheduledWorkout,
      String? workoutPlanDayWorkoutId,
      String? workoutPlanEnrolmentId})
      : super(WorkoutDetailsRoute.name,
            path: 'workout/:id',
            args: WorkoutDetailsRouteArgs(
                key: key,
                id: id,
                scheduledWorkout: scheduledWorkout,
                workoutPlanDayWorkoutId: workoutPlanDayWorkoutId,
                workoutPlanEnrolmentId: workoutPlanEnrolmentId),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutDetailsRoute';
}

class WorkoutDetailsRouteArgs {
  const WorkoutDetailsRouteArgs(
      {this.key,
      required this.id,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId});

  final _i64.Key? key;

  final String id;

  final _i65.ScheduledWorkout? scheduledWorkout;

  final String? workoutPlanDayWorkoutId;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutDetailsRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout, workoutPlanDayWorkoutId: $workoutPlanDayWorkoutId, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i39.WorkoutPlanDetailsPage]
class WorkoutPlanDetailsRoute
    extends _i62.PageRouteInfo<WorkoutPlanDetailsRouteArgs> {
  WorkoutPlanDetailsRoute({_i64.Key? key, required String id})
      : super(WorkoutPlanDetailsRoute.name,
            path: 'workout-plan/:id',
            args: WorkoutPlanDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutPlanDetailsRoute';
}

class WorkoutPlanDetailsRouteArgs {
  const WorkoutPlanDetailsRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'WorkoutPlanDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i40.WorkoutPlanEnrolmentDetailsPage]
class WorkoutPlanEnrolmentDetailsRoute
    extends _i62.PageRouteInfo<WorkoutPlanEnrolmentDetailsRouteArgs> {
  WorkoutPlanEnrolmentDetailsRoute({_i64.Key? key, required String id})
      : super(WorkoutPlanEnrolmentDetailsRoute.name,
            path: 'workout-plan-progress/:id',
            args: WorkoutPlanEnrolmentDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'WorkoutPlanEnrolmentDetailsRoute';
}

class WorkoutPlanEnrolmentDetailsRouteArgs {
  const WorkoutPlanEnrolmentDetailsRouteArgs({this.key, required this.id});

  final _i64.Key? key;

  final String id;

  @override
  String toString() {
    return 'WorkoutPlanEnrolmentDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i41.BodyTrackingEntryCreatorPage]
class BodyTrackingEntryCreatorRoute
    extends _i62.PageRouteInfo<BodyTrackingEntryCreatorRouteArgs> {
  BodyTrackingEntryCreatorRoute(
      {_i64.Key? key, _i65.BodyTrackingEntry? bodyTrackingEntry})
      : super(BodyTrackingEntryCreatorRoute.name,
            path: 'create/body-tracking',
            args: BodyTrackingEntryCreatorRouteArgs(
                key: key, bodyTrackingEntry: bodyTrackingEntry));

  static const String name = 'BodyTrackingEntryCreatorRoute';
}

class BodyTrackingEntryCreatorRouteArgs {
  const BodyTrackingEntryCreatorRouteArgs({this.key, this.bodyTrackingEntry});

  final _i64.Key? key;

  final _i65.BodyTrackingEntry? bodyTrackingEntry;

  @override
  String toString() {
    return 'BodyTrackingEntryCreatorRouteArgs{key: $key, bodyTrackingEntry: $bodyTrackingEntry}';
  }
}

/// generated route for
/// [_i42.ClubCreatorPage]
class ClubCreatorRoute extends _i62.PageRouteInfo<ClubCreatorRouteArgs> {
  ClubCreatorRoute({_i64.Key? key, _i65.ClubSummary? clubSummary})
      : super(ClubCreatorRoute.name,
            path: 'create/club',
            args: ClubCreatorRouteArgs(key: key, clubSummary: clubSummary));

  static const String name = 'ClubCreatorRoute';
}

class ClubCreatorRouteArgs {
  const ClubCreatorRouteArgs({this.key, this.clubSummary});

  final _i64.Key? key;

  final _i65.ClubSummary? clubSummary;

  @override
  String toString() {
    return 'ClubCreatorRouteArgs{key: $key, clubSummary: $clubSummary}';
  }
}

/// generated route for
/// [_i43.CollectionCreatorPage]
class CollectionCreatorRoute
    extends _i62.PageRouteInfo<CollectionCreatorRouteArgs> {
  CollectionCreatorRoute(
      {_i64.Key? key,
      _i65.Collection? collection,
      void Function(_i65.Collection)? onComplete})
      : super(CollectionCreatorRoute.name,
            path: 'create/collection',
            args: CollectionCreatorRouteArgs(
                key: key, collection: collection, onComplete: onComplete));

  static const String name = 'CollectionCreatorRoute';
}

class CollectionCreatorRouteArgs {
  const CollectionCreatorRouteArgs(
      {this.key, this.collection, this.onComplete});

  final _i64.Key? key;

  final _i65.Collection? collection;

  final void Function(_i65.Collection)? onComplete;

  @override
  String toString() {
    return 'CollectionCreatorRouteArgs{key: $key, collection: $collection, onComplete: $onComplete}';
  }
}

/// generated route for
/// [_i44.CustomMoveCreatorPage]
class CustomMoveCreatorRoute
    extends _i62.PageRouteInfo<CustomMoveCreatorRouteArgs> {
  CustomMoveCreatorRoute({_i64.Key? key, _i65.Move? move})
      : super(CustomMoveCreatorRoute.name,
            path: 'create/custom-move',
            args: CustomMoveCreatorRouteArgs(key: key, move: move));

  static const String name = 'CustomMoveCreatorRoute';
}

class CustomMoveCreatorRouteArgs {
  const CustomMoveCreatorRouteArgs({this.key, this.move});

  final _i64.Key? key;

  final _i65.Move? move;

  @override
  String toString() {
    return 'CustomMoveCreatorRouteArgs{key: $key, move: $move}';
  }
}

/// generated route for
/// [_i45.GymProfileCreatorPage]
class GymProfileCreatorRoute
    extends _i62.PageRouteInfo<GymProfileCreatorRouteArgs> {
  GymProfileCreatorRoute({_i64.Key? key, _i65.GymProfile? gymProfile})
      : super(GymProfileCreatorRoute.name,
            path: 'create/gym-profile',
            args: GymProfileCreatorRouteArgs(key: key, gymProfile: gymProfile));

  static const String name = 'GymProfileCreatorRoute';
}

class GymProfileCreatorRouteArgs {
  const GymProfileCreatorRouteArgs({this.key, this.gymProfile});

  final _i64.Key? key;

  final _i65.GymProfile? gymProfile;

  @override
  String toString() {
    return 'GymProfileCreatorRouteArgs{key: $key, gymProfile: $gymProfile}';
  }
}

/// generated route for
/// [_i46.JournalGoalCreatorPage]
class JournalGoalCreatorRoute
    extends _i62.PageRouteInfo<JournalGoalCreatorRouteArgs> {
  JournalGoalCreatorRoute({_i64.Key? key, _i65.JournalGoal? journalGoal})
      : super(JournalGoalCreatorRoute.name,
            path: 'create/journal-goal',
            args: JournalGoalCreatorRouteArgs(
                key: key, journalGoal: journalGoal));

  static const String name = 'JournalGoalCreatorRoute';
}

class JournalGoalCreatorRouteArgs {
  const JournalGoalCreatorRouteArgs({this.key, this.journalGoal});

  final _i64.Key? key;

  final _i65.JournalGoal? journalGoal;

  @override
  String toString() {
    return 'JournalGoalCreatorRouteArgs{key: $key, journalGoal: $journalGoal}';
  }
}

/// generated route for
/// [_i47.JournalMoodCreatorPage]
class JournalMoodCreatorRoute
    extends _i62.PageRouteInfo<JournalMoodCreatorRouteArgs> {
  JournalMoodCreatorRoute({_i64.Key? key, _i65.JournalMood? journalMood})
      : super(JournalMoodCreatorRoute.name,
            path: 'create/journal-mood',
            args: JournalMoodCreatorRouteArgs(
                key: key, journalMood: journalMood));

  static const String name = 'JournalMoodCreatorRoute';
}

class JournalMoodCreatorRouteArgs {
  const JournalMoodCreatorRouteArgs({this.key, this.journalMood});

  final _i64.Key? key;

  final _i65.JournalMood? journalMood;

  @override
  String toString() {
    return 'JournalMoodCreatorRouteArgs{key: $key, journalMood: $journalMood}';
  }
}

/// generated route for
/// [_i48.PersonalBestCreatorPage]
class PersonalBestCreatorRoute
    extends _i62.PageRouteInfo<PersonalBestCreatorRouteArgs> {
  PersonalBestCreatorRoute({_i64.Key? key, _i65.UserBenchmark? userBenchmark})
      : super(PersonalBestCreatorRoute.name,
            path: 'create/personal-best',
            args: PersonalBestCreatorRouteArgs(
                key: key, userBenchmark: userBenchmark));

  static const String name = 'PersonalBestCreatorRoute';
}

class PersonalBestCreatorRouteArgs {
  const PersonalBestCreatorRouteArgs({this.key, this.userBenchmark});

  final _i64.Key? key;

  final _i65.UserBenchmark? userBenchmark;

  @override
  String toString() {
    return 'PersonalBestCreatorRouteArgs{key: $key, userBenchmark: $userBenchmark}';
  }
}

/// generated route for
/// [_i49.FeedPostCreatorPage]
class FeedPostCreatorRoute extends _i62.PageRouteInfo<void> {
  const FeedPostCreatorRoute()
      : super(FeedPostCreatorRoute.name, path: 'create/post');

  static const String name = 'FeedPostCreatorRoute';
}

/// generated route for
/// [_i50.ClubPostCreatorPage]
class ClubPostCreatorRoute
    extends _i62.PageRouteInfo<ClubPostCreatorRouteArgs> {
  ClubPostCreatorRoute(
      {_i64.Key? key,
      required String clubId,
      void Function(_i65.TimelinePostFullData)? onSuccess})
      : super(ClubPostCreatorRoute.name,
            path: 'create/club-post',
            args: ClubPostCreatorRouteArgs(
                key: key, clubId: clubId, onSuccess: onSuccess));

  static const String name = 'ClubPostCreatorRoute';
}

class ClubPostCreatorRouteArgs {
  const ClubPostCreatorRouteArgs(
      {this.key, required this.clubId, this.onSuccess});

  final _i64.Key? key;

  final String clubId;

  final void Function(_i65.TimelinePostFullData)? onSuccess;

  @override
  String toString() {
    return 'ClubPostCreatorRouteArgs{key: $key, clubId: $clubId, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [_i51.ScheduledWorkoutCreatorPage]
class ScheduledWorkoutCreatorRoute
    extends _i62.PageRouteInfo<ScheduledWorkoutCreatorRouteArgs> {
  ScheduledWorkoutCreatorRoute(
      {_i64.Key? key,
      _i65.ScheduledWorkout? scheduledWorkout,
      _i65.WorkoutSummary? workout,
      DateTime? scheduleOn,
      String? workoutPlanEnrolmentId})
      : super(ScheduledWorkoutCreatorRoute.name,
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

  final _i64.Key? key;

  final _i65.ScheduledWorkout? scheduledWorkout;

  final _i65.WorkoutSummary? workout;

  final DateTime? scheduleOn;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'ScheduledWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workout: $workout, scheduleOn: $scheduleOn, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i52.WorkoutCreatorPage]
class WorkoutCreatorRoute extends _i62.PageRouteInfo<WorkoutCreatorRouteArgs> {
  WorkoutCreatorRoute({_i64.Key? key, _i65.Workout? workout})
      : super(WorkoutCreatorRoute.name,
            path: 'create/workout',
            args: WorkoutCreatorRouteArgs(key: key, workout: workout));

  static const String name = 'WorkoutCreatorRoute';
}

class WorkoutCreatorRouteArgs {
  const WorkoutCreatorRouteArgs({this.key, this.workout});

  final _i64.Key? key;

  final _i65.Workout? workout;

  @override
  String toString() {
    return 'WorkoutCreatorRouteArgs{key: $key, workout: $workout}';
  }
}

/// generated route for
/// [_i53.LoggedWorkoutCreatorPage]
class LoggedWorkoutCreatorRoute
    extends _i62.PageRouteInfo<LoggedWorkoutCreatorRouteArgs> {
  LoggedWorkoutCreatorRoute(
      {_i64.Key? key,
      _i65.ScheduledWorkout? scheduledWorkout,
      required String workoutId,
      String? workoutPlanDayWorkoutId,
      String? workoutPlanEnrolmentId})
      : super(LoggedWorkoutCreatorRoute.name,
            path: 'create/workout-log',
            args: LoggedWorkoutCreatorRouteArgs(
                key: key,
                scheduledWorkout: scheduledWorkout,
                workoutId: workoutId,
                workoutPlanDayWorkoutId: workoutPlanDayWorkoutId,
                workoutPlanEnrolmentId: workoutPlanEnrolmentId));

  static const String name = 'LoggedWorkoutCreatorRoute';
}

class LoggedWorkoutCreatorRouteArgs {
  const LoggedWorkoutCreatorRouteArgs(
      {this.key,
      this.scheduledWorkout,
      required this.workoutId,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId});

  final _i64.Key? key;

  final _i65.ScheduledWorkout? scheduledWorkout;

  final String workoutId;

  final String? workoutPlanDayWorkoutId;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'LoggedWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workoutId: $workoutId, workoutPlanDayWorkoutId: $workoutPlanDayWorkoutId, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i54.WorkoutPlanCreatorPage]
class WorkoutPlanCreatorRoute
    extends _i62.PageRouteInfo<WorkoutPlanCreatorRouteArgs> {
  WorkoutPlanCreatorRoute({_i64.Key? key, _i65.WorkoutPlan? workoutPlan})
      : super(WorkoutPlanCreatorRoute.name,
            path: 'create/workout-plan',
            args: WorkoutPlanCreatorRouteArgs(
                key: key, workoutPlan: workoutPlan));

  static const String name = 'WorkoutPlanCreatorRoute';
}

class WorkoutPlanCreatorRouteArgs {
  const WorkoutPlanCreatorRouteArgs({this.key, this.workoutPlan});

  final _i64.Key? key;

  final _i65.WorkoutPlan? workoutPlan;

  @override
  String toString() {
    return 'WorkoutPlanCreatorRouteArgs{key: $key, workoutPlan: $workoutPlan}';
  }
}

/// generated route for
/// [_i55.WorkoutPlanReviewCreatorPage]
class WorkoutPlanReviewCreatorRoute
    extends _i62.PageRouteInfo<WorkoutPlanReviewCreatorRouteArgs> {
  WorkoutPlanReviewCreatorRoute(
      {_i64.Key? key,
      _i65.WorkoutPlanReview? workoutPlanReview,
      required String parentWorkoutPlanId,
      required String parentWorkoutPlanEnrolmentId})
      : super(WorkoutPlanReviewCreatorRoute.name,
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

  final _i64.Key? key;

  final _i65.WorkoutPlanReview? workoutPlanReview;

  final String parentWorkoutPlanId;

  final String parentWorkoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutPlanReviewCreatorRouteArgs{key: $key, workoutPlanReview: $workoutPlanReview, parentWorkoutPlanId: $parentWorkoutPlanId, parentWorkoutPlanEnrolmentId: $parentWorkoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i56.PageNotFoundPage]
class RouteNotFoundRoute extends _i62.PageRouteInfo<void> {
  const RouteNotFoundRoute() : super(RouteNotFoundRoute.name, path: '404');

  static const String name = 'RouteNotFoundRoute';
}

/// generated route for
/// [_i57.SocialPage]
class SocialRoute extends _i62.PageRouteInfo<void> {
  const SocialRoute() : super(SocialRoute.name, path: '');

  static const String name = 'SocialRoute';
}

/// generated route for
/// [_i58.DiscoverPage]
class DiscoverRoute extends _i62.PageRouteInfo<void> {
  const DiscoverRoute() : super(DiscoverRoute.name, path: 'discover');

  static const String name = 'DiscoverRoute';
}

/// generated route for
/// [_i59.HomePage]
class HomeRoute extends _i62.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: 'studio');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i60.ProgressPage]
class ProgressRoute extends _i62.PageRouteInfo<void> {
  const ProgressRoute() : super(ProgressRoute.name, path: 'progress');

  static const String name = 'ProgressRoute';
}

/// generated route for
/// [_i61.ProfilePage]
class ProfileRoute extends _i62.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile');

  static const String name = 'ProfileRoute';
}
