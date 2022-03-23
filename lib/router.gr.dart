// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i64;
import 'package:flutter/cupertino.dart' as _i66;
import 'package:flutter/material.dart' as _i65;

import 'components/creators/body_tracking/body_tracking_entry_creator.dart'
    as _i42;
import 'components/creators/club_creator/club_creator.dart' as _i43;
import 'components/creators/collection_creator.dart' as _i44;
import 'components/creators/custom_move_creator/custom_move_creator.dart'
    as _i45;
import 'components/creators/exercise_load_tracker_creator_page.dart' as _i57;
import 'components/creators/gym_profile_creator.dart' as _i46;
import 'components/creators/post_creator/club_feed_post_creator_page.dart'
    as _i52;
import 'components/creators/post_creator/feed_post_creator_page.dart' as _i51;
import 'components/creators/scheduled_workout_creator.dart' as _i53;
import 'components/creators/user_day_logs/user_eat_well_log_creator_page.dart'
    as _i49;
import 'components/creators/user_day_logs/user_meditation_log_creator_page.dart'
    as _i48;
import 'components/creators/user_day_logs/user_sleep_well_log_creator_page.dart'
    as _i50;
import 'components/creators/user_goal_creator_page.dart' as _i47;
import 'components/creators/workout_creator/workout_creator.dart' as _i54;
import 'components/creators/workout_plan_creator/workout_plan_creator.dart'
    as _i55;
import 'components/creators/workout_plan_review_creator.dart' as _i56;
import 'components/do_workout/do_workout_wrapper_page.dart' as _i10;
import 'components/profile/user_public_content/profile_public_workout_plans.dart'
    as _i31;
import 'components/profile/user_public_content/profile_public_workouts.dart'
    as _i30;
import 'components/social/chat/chats_overview_page.dart' as _i5;
import 'components/social/chat/clubs/club_members_chat_page.dart' as _i7;
import 'components/social/chat/friends/one_to_one_chat_page.dart' as _i6;
import 'components/timers/timers_page.dart' as _i15;
import 'components/workout/workout_finders/public/public_workout_finder_page.dart'
    as _i32;
import 'components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart'
    as _i33;
import 'generated/api/graphql_api.dart' as _i67;
import 'main.dart' as _i2;
import 'pages/authed/authed_routes_wrapper_page.dart' as _i3;
import 'pages/authed/details_pages/club_details/club_details_page.dart' as _i36;
import 'pages/authed/details_pages/collection_details_page.dart' as _i9;
import 'pages/authed/details_pages/logged_workout_details_page.dart' as _i37;
import 'pages/authed/details_pages/user_public_profile_details_page.dart'
    as _i38;
import 'pages/authed/details_pages/workout_details_page.dart' as _i39;
import 'pages/authed/details_pages/workout_plan_details_page.dart' as _i40;
import 'pages/authed/details_pages/workout_plan_enrolment_details_page.dart'
    as _i41;
import 'pages/authed/discover/discover_clubs_page.dart' as _i35;
import 'pages/authed/discover/discover_page.dart' as _i60;
import 'pages/authed/discover/discover_people_page.dart' as _i34;
import 'pages/authed/feed/feed_page.dart' as _i59;
import 'pages/authed/feed/notifications_page.dart' as _i13;
import 'pages/authed/feed/your_posts_page.dart' as _i21;
import 'pages/authed/landing_pages/club_invite_landing_page.dart' as _i8;
import 'pages/authed/main_tabs_page.dart' as _i4;
import 'pages/authed/my_studio/my_studio_page.dart' as _i61;
import 'pages/authed/my_studio/your_clubs.dart' as _i16;
import 'pages/authed/my_studio/your_collections.dart' as _i17;
import 'pages/authed/my_studio/your_gym_profiles.dart' as _i18;
import 'pages/authed/my_studio/your_moves_library.dart' as _i19;
import 'pages/authed/my_studio/your_plans/your_plans.dart' as _i20;
import 'pages/authed/my_studio/your_schedule.dart' as _i22;
import 'pages/authed/my_studio/your_throwdowns.dart' as _i23;
import 'pages/authed/my_studio/your_workouts/your_workouts.dart' as _i24;
import 'pages/authed/page_not_found.dart' as _i58;
import 'pages/authed/profile/archive_page.dart' as _i11;
import 'pages/authed/profile/edit_profile_page.dart' as _i14;
import 'pages/authed/profile/profile_page.dart' as _i63;
import 'pages/authed/profile/settings.dart' as _i12;
import 'pages/authed/progress/body_tracking_page.dart' as _i27;
import 'pages/authed/progress/logged_workouts/logged_workouts_history_page.dart'
    as _i29;
import 'pages/authed/progress/logged_workouts_analysis_page.dart' as _i28;
import 'pages/authed/progress/personal_scorebook_page.dart' as _i25;
import 'pages/authed/progress/progress_page.dart' as _i62;
import 'pages/authed/progress/user_goals_page.dart' as _i26;
import 'pages/unauthed/unauthed_landing.dart' as _i1;

class AppRouter extends _i64.RootStackRouter {
  AppRouter([_i65.GlobalKey<_i65.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i64.PageFactory> pagesMap = {
    UnauthedLandingRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i1.UnauthedLandingPage(),
          fullscreenDialog: true);
    },
    GlobalLoadingRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i2.GlobalLoadingPage(),
          fullscreenDialog: true);
    },
    AuthedRouter.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i3.AuthedRoutesWrapperPage(),
          fullscreenDialog: true);
    },
    MainTabsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i4.MainTabsPage());
    },
    ChatsOverviewRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i5.ChatsOverviewPage());
    },
    OneToOneChatRoute.name: (routeData) {
      final args = routeData.argsAs<OneToOneChatRouteArgs>();
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i6.OneToOneChatPage(
              key: args.key, otherUserId: args.otherUserId));
    },
    ClubMembersChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClubMembersChatRouteArgs>();
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i7.ClubMembersChatPage(key: args.key, clubId: args.clubId));
    },
    ClubInviteLandingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubInviteLandingRouteArgs>(
          orElse: () =>
              ClubInviteLandingRouteArgs(id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i8.ClubInviteLandingPage(key: args.key, id: args.id));
    },
    CollectionDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CollectionDetailsRouteArgs>(
          orElse: () =>
              CollectionDetailsRouteArgs(id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i9.CollectionDetailsPage(key: args.key, id: args.id));
    },
    DoWorkoutWrapperRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DoWorkoutWrapperRouteArgs>(
          orElse: () =>
              DoWorkoutWrapperRouteArgs(id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i10.DoWorkoutWrapperPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout,
              workoutPlanDayWorkoutId: args.workoutPlanDayWorkoutId,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    ArchiveRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i11.ArchivePage());
    },
    SettingsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i12.SettingsPage());
    },
    NotificationsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i13.NotificationsPage());
    },
    EditProfileRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i14.EditProfilePage());
    },
    TimersRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i15.TimersPage());
    },
    YourClubsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i16.YourClubsPage());
    },
    YourCollectionsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i17.YourCollectionsPage());
    },
    YourGymProfilesRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i18.YourGymProfilesPage());
    },
    YourMovesLibraryRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i19.YourMovesLibraryPage());
    },
    YourPlansRoute.name: (routeData) {
      final args = routeData.argsAs<YourPlansRouteArgs>(
          orElse: () => const YourPlansRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i20.YourPlansPage(
              key: args.key,
              selectPlan: args.selectPlan,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showJoined: args.showJoined,
              showSaved: args.showSaved));
    },
    YourPostsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i21.YourPostsPage());
    },
    YourScheduleRoute.name: (routeData) {
      final args = routeData.argsAs<YourScheduleRouteArgs>(
          orElse: () => const YourScheduleRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i22.YourSchedulePage(
              key: args.key, openAtDate: args.openAtDate));
    },
    YourThrowdownsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i23.YourThrowdownsPage());
    },
    YourWorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<YourWorkoutsRouteArgs>(
          orElse: () => const YourWorkoutsRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i24.YourWorkoutsPage(
              key: args.key,
              selectWorkout: args.selectWorkout,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showSaved: args.showSaved,
              displayFilter: args.displayFilter));
    },
    PersonalScoresRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i25.PersonalScoresPage());
    },
    UserGoalsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i26.UserGoalsPage());
    },
    BodyTrackingRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i27.BodyTrackingPage());
    },
    LoggedWorkoutsAnalysisRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutsAnalysisRouteArgs>(
          orElse: () => const LoggedWorkoutsAnalysisRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i28.LoggedWorkoutsAnalysisPage(
              key: args.key, pageTitle: args.pageTitle));
    },
    LoggedWorkoutsHistoryRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutsHistoryRouteArgs>(
          orElse: () => const LoggedWorkoutsHistoryRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i29.LoggedWorkoutsHistoryPage(
              key: args.key,
              selectLoggedWorkout: args.selectLoggedWorkout,
              pageTitle: args.pageTitle));
    },
    ProfilePublicWorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<ProfilePublicWorkoutsRouteArgs>();
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i30.ProfilePublicWorkoutsPage(
              key: args.key,
              userId: args.userId,
              userDisplayName: args.userDisplayName));
    },
    ProfilePublicWorkoutPlansRoute.name: (routeData) {
      final args = routeData.argsAs<ProfilePublicWorkoutPlansRouteArgs>();
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i31.ProfilePublicWorkoutPlansPage(
              key: args.key,
              userId: args.userId,
              userDisplayName: args.userDisplayName));
    },
    PublicWorkoutFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutFinderRouteArgs>(
          orElse: () => const PublicWorkoutFinderRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i32.PublicWorkoutFinderPage(
              key: args.key, selectWorkout: args.selectWorkout));
    },
    PublicWorkoutPlanFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutPlanFinderRouteArgs>(
          orElse: () => const PublicWorkoutPlanFinderRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i33.PublicWorkoutPlanFinderPage(
              key: args.key, selectWorkoutPlan: args.selectWorkoutPlan));
    },
    DiscoverPeopleRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i34.DiscoverPeoplePage());
    },
    DiscoverClubsRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i35.DiscoverClubsPage());
    },
    ClubDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubDetailsRouteArgs>(
          orElse: () => ClubDetailsRouteArgs(id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i36.ClubDetailsPage(key: args.key, id: args.id));
    },
    LoggedWorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoggedWorkoutDetailsRouteArgs>(
          orElse: () =>
              LoggedWorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i37.LoggedWorkoutDetailsPage(key: args.key, id: args.id));
    },
    UserPublicProfileDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicProfileDetailsRouteArgs>(
          orElse: () => UserPublicProfileDetailsRouteArgs(
              userId: pathParams.getString('userId')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i38.UserPublicProfileDetailsPage(
              key: args.key, userId: args.userId));
    },
    WorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutDetailsRouteArgs>(
          orElse: () =>
              WorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i39.WorkoutDetailsPage(
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
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i40.WorkoutPlanDetailsPage(key: args.key, id: args.id));
    },
    WorkoutPlanEnrolmentDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanEnrolmentDetailsRouteArgs>(
          orElse: () => WorkoutPlanEnrolmentDetailsRouteArgs(
              id: pathParams.getString('id')));
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child:
              _i41.WorkoutPlanEnrolmentDetailsPage(key: args.key, id: args.id));
    },
    BodyTrackingEntryCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<BodyTrackingEntryCreatorRouteArgs>(
          orElse: () => const BodyTrackingEntryCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i42.BodyTrackingEntryCreatorPage(
              key: args.key, bodyTrackingEntry: args.bodyTrackingEntry));
    },
    ClubCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubCreatorRouteArgs>(
          orElse: () => const ClubCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i43.ClubCreatorPage(
              key: args.key, clubSummary: args.clubSummary));
    },
    CollectionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionCreatorRouteArgs>(
          orElse: () => const CollectionCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i44.CollectionCreatorPage(
              key: args.key,
              collection: args.collection,
              onComplete: args.onComplete));
    },
    CustomMoveCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CustomMoveCreatorRouteArgs>(
          orElse: () => const CustomMoveCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i45.CustomMoveCreatorPage(key: args.key, move: args.move));
    },
    GymProfileCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfileCreatorRouteArgs>(
          orElse: () => const GymProfileCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i46.GymProfileCreatorPage(
              key: args.key, gymProfile: args.gymProfile));
    },
    UserGoalCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserGoalCreatorRouteArgs>(
          orElse: () => const UserGoalCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i47.UserGoalCreatorPage(
              key: args.key, journalGoal: args.journalGoal));
    },
    UserMeditationLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserMeditationLogCreatorRouteArgs>(
          orElse: () => const UserMeditationLogCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i48.UserMeditationLogCreatorPage(
              key: args.key,
              userMeditationLog: args.userMeditationLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    UserEatWellLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserEatWellLogCreatorRouteArgs>(
          orElse: () => const UserEatWellLogCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i49.UserEatWellLogCreatorPage(
              key: args.key,
              userEatWellLog: args.userEatWellLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    UserSleepWellLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserSleepWellLogCreatorRouteArgs>(
          orElse: () => const UserSleepWellLogCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i50.UserSleepWellLogCreatorPage(
              key: args.key,
              userSleepWellLog: args.userSleepWellLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    FeedPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<FeedPostCreatorRouteArgs>(
          orElse: () => const FeedPostCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i51.FeedPostCreatorPage(
              key: args.key,
              activityInput: args.activityInput,
              onComplete: args.onComplete,
              title: args.title));
    },
    ClubFeedPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubFeedPostCreatorRouteArgs>();
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i52.ClubFeedPostCreatorPage(
              key: args.key, clubId: args.clubId, onSuccess: args.onSuccess));
    },
    ScheduledWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduledWorkoutCreatorRouteArgs>(
          orElse: () => const ScheduledWorkoutCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i53.ScheduledWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workout: args.workout,
              scheduleOn: args.scheduleOn,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutCreatorRouteArgs>(
          orElse: () => const WorkoutCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i54.WorkoutCreatorPage(key: args.key, workout: args.workout));
    },
    WorkoutPlanCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanCreatorRouteArgs>(
          orElse: () => const WorkoutPlanCreatorRouteArgs());
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i55.WorkoutPlanCreatorPage(
              key: args.key, workoutPlan: args.workoutPlan));
    },
    WorkoutPlanReviewCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanReviewCreatorRouteArgs>();
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: _i56.WorkoutPlanReviewCreatorPage(
              key: args.key,
              workoutPlanReview: args.workoutPlanReview,
              parentWorkoutPlanId: args.parentWorkoutPlanId,
              parentWorkoutPlanEnrolmentId: args.parentWorkoutPlanEnrolmentId));
    },
    ExerciseLoadTrackerCreatorRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData,
          child: const _i57.ExerciseLoadTrackerCreatorPage());
    },
    RouteNotFoundRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i58.PageNotFoundPage());
    },
    FeedRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i59.FeedPage());
    },
    DiscoverRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i60.DiscoverPage());
    },
    MyStudioRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i61.MyStudioPage());
    },
    ProgressRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i62.ProgressPage());
    },
    ProfileRoute.name: (routeData) {
      return _i64.CupertinoPageX<dynamic>(
          routeData: routeData, child: const _i63.ProfilePage());
    }
  };

  @override
  List<_i64.RouteConfig> get routes => [
        _i64.RouteConfig(UnauthedLandingRoute.name, path: '/auth'),
        _i64.RouteConfig(GlobalLoadingRoute.name, path: '/loading'),
        _i64.RouteConfig(AuthedRouter.name, path: '/', children: [
          _i64.RouteConfig(MainTabsRoute.name,
              path: '',
              parent: AuthedRouter.name,
              children: [
                _i64.RouteConfig(FeedRoute.name,
                    path: '', parent: MainTabsRoute.name),
                _i64.RouteConfig(DiscoverRoute.name,
                    path: 'discover', parent: MainTabsRoute.name),
                _i64.RouteConfig(MyStudioRoute.name,
                    path: 'studio', parent: MainTabsRoute.name),
                _i64.RouteConfig(ProgressRoute.name,
                    path: 'progress', parent: MainTabsRoute.name),
                _i64.RouteConfig(ProfileRoute.name,
                    path: 'profile', parent: MainTabsRoute.name)
              ]),
          _i64.RouteConfig(ChatsOverviewRoute.name,
              path: 'chats', parent: AuthedRouter.name),
          _i64.RouteConfig(OneToOneChatRoute.name,
              path: 'chat', parent: AuthedRouter.name),
          _i64.RouteConfig(ClubMembersChatRoute.name,
              path: 'club-chat', parent: AuthedRouter.name),
          _i64.RouteConfig(ClubInviteLandingRoute.name,
              path: 'club-invite/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(CollectionDetailsRoute.name,
              path: 'collection/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(DoWorkoutWrapperRoute.name,
              path: 'do-workout/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(ArchiveRoute.name,
              path: 'archive', parent: AuthedRouter.name),
          _i64.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: AuthedRouter.name),
          _i64.RouteConfig(NotificationsRoute.name,
              path: 'notifications', parent: AuthedRouter.name),
          _i64.RouteConfig(EditProfileRoute.name,
              path: 'edit-profile', parent: AuthedRouter.name),
          _i64.RouteConfig(TimersRoute.name,
              path: 'timers', parent: AuthedRouter.name),
          _i64.RouteConfig(YourClubsRoute.name,
              path: 'your-clubs', parent: AuthedRouter.name),
          _i64.RouteConfig(YourCollectionsRoute.name,
              path: 'your-collections', parent: AuthedRouter.name),
          _i64.RouteConfig(YourGymProfilesRoute.name,
              path: 'your-gym-profiles', parent: AuthedRouter.name),
          _i64.RouteConfig(YourMovesLibraryRoute.name,
              path: 'your-moves', parent: AuthedRouter.name),
          _i64.RouteConfig(YourPlansRoute.name,
              path: 'your-plans', parent: AuthedRouter.name),
          _i64.RouteConfig(YourPostsRoute.name,
              path: 'your-posts', parent: AuthedRouter.name),
          _i64.RouteConfig(YourScheduleRoute.name,
              path: 'your-schedule', parent: AuthedRouter.name),
          _i64.RouteConfig(YourThrowdownsRoute.name,
              path: 'your-throwdowns', parent: AuthedRouter.name),
          _i64.RouteConfig(YourWorkoutsRoute.name,
              path: 'your-workouts', parent: AuthedRouter.name),
          _i64.RouteConfig(PersonalScoresRoute.name,
              path: 'personal-scores', parent: AuthedRouter.name),
          _i64.RouteConfig(UserGoalsRoute.name,
              path: 'goals', parent: AuthedRouter.name),
          _i64.RouteConfig(BodyTrackingRoute.name,
              path: 'body-tracking', parent: AuthedRouter.name),
          _i64.RouteConfig(LoggedWorkoutsAnalysisRoute.name,
              path: 'workout-logs/analysis', parent: AuthedRouter.name),
          _i64.RouteConfig(LoggedWorkoutsHistoryRoute.name,
              path: 'workout-logs/history', parent: AuthedRouter.name),
          _i64.RouteConfig(ProfilePublicWorkoutsRoute.name,
              path: 'public-workouts/:userId', parent: AuthedRouter.name),
          _i64.RouteConfig(ProfilePublicWorkoutPlansRoute.name,
              path: 'public-plans/:userId', parent: AuthedRouter.name),
          _i64.RouteConfig(PublicWorkoutFinderRoute.name,
              path: 'public-workouts', parent: AuthedRouter.name),
          _i64.RouteConfig(PublicWorkoutPlanFinderRoute.name,
              path: 'public-plans', parent: AuthedRouter.name),
          _i64.RouteConfig(DiscoverPeopleRoute.name,
              path: 'discover-people', parent: AuthedRouter.name),
          _i64.RouteConfig(DiscoverClubsRoute.name,
              path: 'discover-clubs', parent: AuthedRouter.name),
          _i64.RouteConfig(ClubDetailsRoute.name,
              path: 'club/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(LoggedWorkoutDetailsRoute.name,
              path: 'logged-workout/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(UserPublicProfileDetailsRoute.name,
              path: 'profile/:userId', parent: AuthedRouter.name),
          _i64.RouteConfig(WorkoutDetailsRoute.name,
              path: 'workout/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(WorkoutPlanDetailsRoute.name,
              path: 'workout-plan/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(WorkoutPlanEnrolmentDetailsRoute.name,
              path: 'workout-plan-progress/:id', parent: AuthedRouter.name),
          _i64.RouteConfig(BodyTrackingEntryCreatorRoute.name,
              path: 'create/body-tracking', parent: AuthedRouter.name),
          _i64.RouteConfig(ClubCreatorRoute.name,
              path: 'create/club', parent: AuthedRouter.name),
          _i64.RouteConfig(CollectionCreatorRoute.name,
              path: 'create/collection', parent: AuthedRouter.name),
          _i64.RouteConfig(CustomMoveCreatorRoute.name,
              path: 'create/custom-move', parent: AuthedRouter.name),
          _i64.RouteConfig(GymProfileCreatorRoute.name,
              path: 'create/gym-profile', parent: AuthedRouter.name),
          _i64.RouteConfig(UserGoalCreatorRoute.name,
              path: 'create/goal', parent: AuthedRouter.name),
          _i64.RouteConfig(UserMeditationLogCreatorRoute.name,
              path: 'create/mindfulness-log', parent: AuthedRouter.name),
          _i64.RouteConfig(UserEatWellLogCreatorRoute.name,
              path: 'create/food-log', parent: AuthedRouter.name),
          _i64.RouteConfig(UserSleepWellLogCreatorRoute.name,
              path: 'create/sleep-log', parent: AuthedRouter.name),
          _i64.RouteConfig(FeedPostCreatorRoute.name,
              path: 'create/post', parent: AuthedRouter.name),
          _i64.RouteConfig(ClubFeedPostCreatorRoute.name,
              path: 'create/club-post', parent: AuthedRouter.name),
          _i64.RouteConfig(ScheduledWorkoutCreatorRoute.name,
              path: 'create/scheduled-workout', parent: AuthedRouter.name),
          _i64.RouteConfig(WorkoutCreatorRoute.name,
              path: 'create/workout', parent: AuthedRouter.name),
          _i64.RouteConfig(WorkoutPlanCreatorRoute.name,
              path: 'create/workout-plan', parent: AuthedRouter.name),
          _i64.RouteConfig(WorkoutPlanReviewCreatorRoute.name,
              path: 'create/workout-plan-review', parent: AuthedRouter.name),
          _i64.RouteConfig(ExerciseLoadTrackerCreatorRoute.name,
              path: 'create/max-lift-tracker', parent: AuthedRouter.name),
          _i64.RouteConfig(RouteNotFoundRoute.name,
              path: '404', parent: AuthedRouter.name),
          _i64.RouteConfig('*#redirect',
              path: '*',
              parent: AuthedRouter.name,
              redirectTo: '404',
              fullMatch: true)
        ])
      ];
}

/// generated route for
/// [_i1.UnauthedLandingPage]
class UnauthedLandingRoute extends _i64.PageRouteInfo<void> {
  const UnauthedLandingRoute()
      : super(UnauthedLandingRoute.name, path: '/auth');

  static const String name = 'UnauthedLandingRoute';
}

/// generated route for
/// [_i2.GlobalLoadingPage]
class GlobalLoadingRoute extends _i64.PageRouteInfo<void> {
  const GlobalLoadingRoute() : super(GlobalLoadingRoute.name, path: '/loading');

  static const String name = 'GlobalLoadingRoute';
}

/// generated route for
/// [_i3.AuthedRoutesWrapperPage]
class AuthedRouter extends _i64.PageRouteInfo<void> {
  const AuthedRouter({List<_i64.PageRouteInfo>? children})
      : super(AuthedRouter.name, path: '/', initialChildren: children);

  static const String name = 'AuthedRouter';
}

/// generated route for
/// [_i4.MainTabsPage]
class MainTabsRoute extends _i64.PageRouteInfo<void> {
  const MainTabsRoute({List<_i64.PageRouteInfo>? children})
      : super(MainTabsRoute.name, path: '', initialChildren: children);

  static const String name = 'MainTabsRoute';
}

/// generated route for
/// [_i5.ChatsOverviewPage]
class ChatsOverviewRoute extends _i64.PageRouteInfo<void> {
  const ChatsOverviewRoute() : super(ChatsOverviewRoute.name, path: 'chats');

  static const String name = 'ChatsOverviewRoute';
}

/// generated route for
/// [_i6.OneToOneChatPage]
class OneToOneChatRoute extends _i64.PageRouteInfo<OneToOneChatRouteArgs> {
  OneToOneChatRoute({_i66.Key? key, required String otherUserId})
      : super(OneToOneChatRoute.name,
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

/// generated route for
/// [_i7.ClubMembersChatPage]
class ClubMembersChatRoute
    extends _i64.PageRouteInfo<ClubMembersChatRouteArgs> {
  ClubMembersChatRoute({_i66.Key? key, required String clubId})
      : super(ClubMembersChatRoute.name,
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

/// generated route for
/// [_i8.ClubInviteLandingPage]
class ClubInviteLandingRoute
    extends _i64.PageRouteInfo<ClubInviteLandingRouteArgs> {
  ClubInviteLandingRoute({_i66.Key? key, required String id})
      : super(ClubInviteLandingRoute.name,
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

/// generated route for
/// [_i9.CollectionDetailsPage]
class CollectionDetailsRoute
    extends _i64.PageRouteInfo<CollectionDetailsRouteArgs> {
  CollectionDetailsRoute({_i66.Key? key, required String id})
      : super(CollectionDetailsRoute.name,
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

/// generated route for
/// [_i10.DoWorkoutWrapperPage]
class DoWorkoutWrapperRoute
    extends _i64.PageRouteInfo<DoWorkoutWrapperRouteArgs> {
  DoWorkoutWrapperRoute(
      {_i66.Key? key,
      required String id,
      _i67.ScheduledWorkout? scheduledWorkout,
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

  final _i66.Key? key;

  final String id;

  final _i67.ScheduledWorkout? scheduledWorkout;

  final String? workoutPlanDayWorkoutId;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'DoWorkoutWrapperRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout, workoutPlanDayWorkoutId: $workoutPlanDayWorkoutId, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i11.ArchivePage]
class ArchiveRoute extends _i64.PageRouteInfo<void> {
  const ArchiveRoute() : super(ArchiveRoute.name, path: 'archive');

  static const String name = 'ArchiveRoute';
}

/// generated route for
/// [_i12.SettingsPage]
class SettingsRoute extends _i64.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i13.NotificationsPage]
class NotificationsRoute extends _i64.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(NotificationsRoute.name, path: 'notifications');

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i14.EditProfilePage]
class EditProfileRoute extends _i64.PageRouteInfo<void> {
  const EditProfileRoute() : super(EditProfileRoute.name, path: 'edit-profile');

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i15.TimersPage]
class TimersRoute extends _i64.PageRouteInfo<void> {
  const TimersRoute() : super(TimersRoute.name, path: 'timers');

  static const String name = 'TimersRoute';
}

/// generated route for
/// [_i16.YourClubsPage]
class YourClubsRoute extends _i64.PageRouteInfo<void> {
  const YourClubsRoute() : super(YourClubsRoute.name, path: 'your-clubs');

  static const String name = 'YourClubsRoute';
}

/// generated route for
/// [_i17.YourCollectionsPage]
class YourCollectionsRoute extends _i64.PageRouteInfo<void> {
  const YourCollectionsRoute()
      : super(YourCollectionsRoute.name, path: 'your-collections');

  static const String name = 'YourCollectionsRoute';
}

/// generated route for
/// [_i18.YourGymProfilesPage]
class YourGymProfilesRoute extends _i64.PageRouteInfo<void> {
  const YourGymProfilesRoute()
      : super(YourGymProfilesRoute.name, path: 'your-gym-profiles');

  static const String name = 'YourGymProfilesRoute';
}

/// generated route for
/// [_i19.YourMovesLibraryPage]
class YourMovesLibraryRoute extends _i64.PageRouteInfo<void> {
  const YourMovesLibraryRoute()
      : super(YourMovesLibraryRoute.name, path: 'your-moves');

  static const String name = 'YourMovesLibraryRoute';
}

/// generated route for
/// [_i20.YourPlansPage]
class YourPlansRoute extends _i64.PageRouteInfo<YourPlansRouteArgs> {
  YourPlansRoute(
      {_i66.Key? key,
      void Function(_i67.WorkoutPlanSummary)? selectPlan,
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

  final _i66.Key? key;

  final void Function(_i67.WorkoutPlanSummary)? selectPlan;

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
/// [_i21.YourPostsPage]
class YourPostsRoute extends _i64.PageRouteInfo<void> {
  const YourPostsRoute() : super(YourPostsRoute.name, path: 'your-posts');

  static const String name = 'YourPostsRoute';
}

/// generated route for
/// [_i22.YourSchedulePage]
class YourScheduleRoute extends _i64.PageRouteInfo<YourScheduleRouteArgs> {
  YourScheduleRoute({_i66.Key? key, DateTime? openAtDate})
      : super(YourScheduleRoute.name,
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

/// generated route for
/// [_i23.YourThrowdownsPage]
class YourThrowdownsRoute extends _i64.PageRouteInfo<void> {
  const YourThrowdownsRoute()
      : super(YourThrowdownsRoute.name, path: 'your-throwdowns');

  static const String name = 'YourThrowdownsRoute';
}

/// generated route for
/// [_i24.YourWorkoutsPage]
class YourWorkoutsRoute extends _i64.PageRouteInfo<YourWorkoutsRouteArgs> {
  YourWorkoutsRoute(
      {_i66.Key? key,
      void Function(_i67.WorkoutSummary)? selectWorkout,
      bool showCreateButton = true,
      bool showDiscoverButton = false,
      String? pageTitle,
      bool showSaved = true,
      bool Function(_i67.WorkoutSummary)? displayFilter})
      : super(YourWorkoutsRoute.name,
            path: 'your-workouts',
            args: YourWorkoutsRouteArgs(
                key: key,
                selectWorkout: selectWorkout,
                showCreateButton: showCreateButton,
                showDiscoverButton: showDiscoverButton,
                pageTitle: pageTitle,
                showSaved: showSaved,
                displayFilter: displayFilter));

  static const String name = 'YourWorkoutsRoute';
}

class YourWorkoutsRouteArgs {
  const YourWorkoutsRouteArgs(
      {this.key,
      this.selectWorkout,
      this.showCreateButton = true,
      this.showDiscoverButton = false,
      this.pageTitle,
      this.showSaved = true,
      this.displayFilter});

  final _i66.Key? key;

  final void Function(_i67.WorkoutSummary)? selectWorkout;

  final bool showCreateButton;

  final bool showDiscoverButton;

  final String? pageTitle;

  final bool showSaved;

  final bool Function(_i67.WorkoutSummary)? displayFilter;

  @override
  String toString() {
    return 'YourWorkoutsRouteArgs{key: $key, selectWorkout: $selectWorkout, showCreateButton: $showCreateButton, showDiscoverButton: $showDiscoverButton, pageTitle: $pageTitle, showSaved: $showSaved, displayFilter: $displayFilter}';
  }
}

/// generated route for
/// [_i25.PersonalScoresPage]
class PersonalScoresRoute extends _i64.PageRouteInfo<void> {
  const PersonalScoresRoute()
      : super(PersonalScoresRoute.name, path: 'personal-scores');

  static const String name = 'PersonalScoresRoute';
}

/// generated route for
/// [_i26.UserGoalsPage]
class UserGoalsRoute extends _i64.PageRouteInfo<void> {
  const UserGoalsRoute() : super(UserGoalsRoute.name, path: 'goals');

  static const String name = 'UserGoalsRoute';
}

/// generated route for
/// [_i27.BodyTrackingPage]
class BodyTrackingRoute extends _i64.PageRouteInfo<void> {
  const BodyTrackingRoute()
      : super(BodyTrackingRoute.name, path: 'body-tracking');

  static const String name = 'BodyTrackingRoute';
}

/// generated route for
/// [_i28.LoggedWorkoutsAnalysisPage]
class LoggedWorkoutsAnalysisRoute
    extends _i64.PageRouteInfo<LoggedWorkoutsAnalysisRouteArgs> {
  LoggedWorkoutsAnalysisRoute(
      {_i66.Key? key, String pageTitle = 'Logs & Analysis'})
      : super(LoggedWorkoutsAnalysisRoute.name,
            path: 'workout-logs/analysis',
            args: LoggedWorkoutsAnalysisRouteArgs(
                key: key, pageTitle: pageTitle));

  static const String name = 'LoggedWorkoutsAnalysisRoute';
}

class LoggedWorkoutsAnalysisRouteArgs {
  const LoggedWorkoutsAnalysisRouteArgs(
      {this.key, this.pageTitle = 'Logs & Analysis'});

  final _i66.Key? key;

  final String pageTitle;

  @override
  String toString() {
    return 'LoggedWorkoutsAnalysisRouteArgs{key: $key, pageTitle: $pageTitle}';
  }
}

/// generated route for
/// [_i29.LoggedWorkoutsHistoryPage]
class LoggedWorkoutsHistoryRoute
    extends _i64.PageRouteInfo<LoggedWorkoutsHistoryRouteArgs> {
  LoggedWorkoutsHistoryRoute(
      {_i66.Key? key,
      void Function(_i67.LoggedWorkout)? selectLoggedWorkout,
      String pageTitle = 'Workout Logs'})
      : super(LoggedWorkoutsHistoryRoute.name,
            path: 'workout-logs/history',
            args: LoggedWorkoutsHistoryRouteArgs(
                key: key,
                selectLoggedWorkout: selectLoggedWorkout,
                pageTitle: pageTitle));

  static const String name = 'LoggedWorkoutsHistoryRoute';
}

class LoggedWorkoutsHistoryRouteArgs {
  const LoggedWorkoutsHistoryRouteArgs(
      {this.key, this.selectLoggedWorkout, this.pageTitle = 'Workout Logs'});

  final _i66.Key? key;

  final void Function(_i67.LoggedWorkout)? selectLoggedWorkout;

  final String pageTitle;

  @override
  String toString() {
    return 'LoggedWorkoutsHistoryRouteArgs{key: $key, selectLoggedWorkout: $selectLoggedWorkout, pageTitle: $pageTitle}';
  }
}

/// generated route for
/// [_i30.ProfilePublicWorkoutsPage]
class ProfilePublicWorkoutsRoute
    extends _i64.PageRouteInfo<ProfilePublicWorkoutsRouteArgs> {
  ProfilePublicWorkoutsRoute(
      {_i66.Key? key, required String userId, String? userDisplayName})
      : super(ProfilePublicWorkoutsRoute.name,
            path: 'public-workouts/:userId',
            args: ProfilePublicWorkoutsRouteArgs(
                key: key, userId: userId, userDisplayName: userDisplayName));

  static const String name = 'ProfilePublicWorkoutsRoute';
}

class ProfilePublicWorkoutsRouteArgs {
  const ProfilePublicWorkoutsRouteArgs(
      {this.key, required this.userId, this.userDisplayName});

  final _i66.Key? key;

  final String userId;

  final String? userDisplayName;

  @override
  String toString() {
    return 'ProfilePublicWorkoutsRouteArgs{key: $key, userId: $userId, userDisplayName: $userDisplayName}';
  }
}

/// generated route for
/// [_i31.ProfilePublicWorkoutPlansPage]
class ProfilePublicWorkoutPlansRoute
    extends _i64.PageRouteInfo<ProfilePublicWorkoutPlansRouteArgs> {
  ProfilePublicWorkoutPlansRoute(
      {_i66.Key? key, required String userId, String? userDisplayName})
      : super(ProfilePublicWorkoutPlansRoute.name,
            path: 'public-plans/:userId',
            args: ProfilePublicWorkoutPlansRouteArgs(
                key: key, userId: userId, userDisplayName: userDisplayName));

  static const String name = 'ProfilePublicWorkoutPlansRoute';
}

class ProfilePublicWorkoutPlansRouteArgs {
  const ProfilePublicWorkoutPlansRouteArgs(
      {this.key, required this.userId, this.userDisplayName});

  final _i66.Key? key;

  final String userId;

  final String? userDisplayName;

  @override
  String toString() {
    return 'ProfilePublicWorkoutPlansRouteArgs{key: $key, userId: $userId, userDisplayName: $userDisplayName}';
  }
}

/// generated route for
/// [_i32.PublicWorkoutFinderPage]
class PublicWorkoutFinderRoute
    extends _i64.PageRouteInfo<PublicWorkoutFinderRouteArgs> {
  PublicWorkoutFinderRoute(
      {_i66.Key? key, void Function(_i67.WorkoutSummary)? selectWorkout})
      : super(PublicWorkoutFinderRoute.name,
            path: 'public-workouts',
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

/// generated route for
/// [_i33.PublicWorkoutPlanFinderPage]
class PublicWorkoutPlanFinderRoute
    extends _i64.PageRouteInfo<PublicWorkoutPlanFinderRouteArgs> {
  PublicWorkoutPlanFinderRoute(
      {_i66.Key? key,
      void Function(_i67.WorkoutPlanSummary)? selectWorkoutPlan})
      : super(PublicWorkoutPlanFinderRoute.name,
            path: 'public-plans',
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

/// generated route for
/// [_i34.DiscoverPeoplePage]
class DiscoverPeopleRoute extends _i64.PageRouteInfo<void> {
  const DiscoverPeopleRoute()
      : super(DiscoverPeopleRoute.name, path: 'discover-people');

  static const String name = 'DiscoverPeopleRoute';
}

/// generated route for
/// [_i35.DiscoverClubsPage]
class DiscoverClubsRoute extends _i64.PageRouteInfo<void> {
  const DiscoverClubsRoute()
      : super(DiscoverClubsRoute.name, path: 'discover-clubs');

  static const String name = 'DiscoverClubsRoute';
}

/// generated route for
/// [_i36.ClubDetailsPage]
class ClubDetailsRoute extends _i64.PageRouteInfo<ClubDetailsRouteArgs> {
  ClubDetailsRoute({_i66.Key? key, required String id})
      : super(ClubDetailsRoute.name,
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

/// generated route for
/// [_i37.LoggedWorkoutDetailsPage]
class LoggedWorkoutDetailsRoute
    extends _i64.PageRouteInfo<LoggedWorkoutDetailsRouteArgs> {
  LoggedWorkoutDetailsRoute({_i66.Key? key, required String id})
      : super(LoggedWorkoutDetailsRoute.name,
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

/// generated route for
/// [_i38.UserPublicProfileDetailsPage]
class UserPublicProfileDetailsRoute
    extends _i64.PageRouteInfo<UserPublicProfileDetailsRouteArgs> {
  UserPublicProfileDetailsRoute({_i66.Key? key, required String userId})
      : super(UserPublicProfileDetailsRoute.name,
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

/// generated route for
/// [_i39.WorkoutDetailsPage]
class WorkoutDetailsRoute extends _i64.PageRouteInfo<WorkoutDetailsRouteArgs> {
  WorkoutDetailsRoute(
      {_i66.Key? key,
      required String id,
      _i67.ScheduledWorkout? scheduledWorkout,
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

  final _i66.Key? key;

  final String id;

  final _i67.ScheduledWorkout? scheduledWorkout;

  final String? workoutPlanDayWorkoutId;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutDetailsRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout, workoutPlanDayWorkoutId: $workoutPlanDayWorkoutId, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i40.WorkoutPlanDetailsPage]
class WorkoutPlanDetailsRoute
    extends _i64.PageRouteInfo<WorkoutPlanDetailsRouteArgs> {
  WorkoutPlanDetailsRoute({_i66.Key? key, required String id})
      : super(WorkoutPlanDetailsRoute.name,
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

/// generated route for
/// [_i41.WorkoutPlanEnrolmentDetailsPage]
class WorkoutPlanEnrolmentDetailsRoute
    extends _i64.PageRouteInfo<WorkoutPlanEnrolmentDetailsRouteArgs> {
  WorkoutPlanEnrolmentDetailsRoute({_i66.Key? key, required String id})
      : super(WorkoutPlanEnrolmentDetailsRoute.name,
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

/// generated route for
/// [_i42.BodyTrackingEntryCreatorPage]
class BodyTrackingEntryCreatorRoute
    extends _i64.PageRouteInfo<BodyTrackingEntryCreatorRouteArgs> {
  BodyTrackingEntryCreatorRoute(
      {_i66.Key? key, _i67.BodyTrackingEntry? bodyTrackingEntry})
      : super(BodyTrackingEntryCreatorRoute.name,
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

/// generated route for
/// [_i43.ClubCreatorPage]
class ClubCreatorRoute extends _i64.PageRouteInfo<ClubCreatorRouteArgs> {
  ClubCreatorRoute({_i66.Key? key, _i67.ClubSummary? clubSummary})
      : super(ClubCreatorRoute.name,
            path: 'create/club',
            args: ClubCreatorRouteArgs(key: key, clubSummary: clubSummary));

  static const String name = 'ClubCreatorRoute';
}

class ClubCreatorRouteArgs {
  const ClubCreatorRouteArgs({this.key, this.clubSummary});

  final _i66.Key? key;

  final _i67.ClubSummary? clubSummary;

  @override
  String toString() {
    return 'ClubCreatorRouteArgs{key: $key, clubSummary: $clubSummary}';
  }
}

/// generated route for
/// [_i44.CollectionCreatorPage]
class CollectionCreatorRoute
    extends _i64.PageRouteInfo<CollectionCreatorRouteArgs> {
  CollectionCreatorRoute(
      {_i66.Key? key,
      _i67.Collection? collection,
      void Function(_i67.Collection)? onComplete})
      : super(CollectionCreatorRoute.name,
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

/// generated route for
/// [_i45.CustomMoveCreatorPage]
class CustomMoveCreatorRoute
    extends _i64.PageRouteInfo<CustomMoveCreatorRouteArgs> {
  CustomMoveCreatorRoute({_i66.Key? key, _i67.Move? move})
      : super(CustomMoveCreatorRoute.name,
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

/// generated route for
/// [_i46.GymProfileCreatorPage]
class GymProfileCreatorRoute
    extends _i64.PageRouteInfo<GymProfileCreatorRouteArgs> {
  GymProfileCreatorRoute({_i66.Key? key, _i67.GymProfile? gymProfile})
      : super(GymProfileCreatorRoute.name,
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

/// generated route for
/// [_i47.UserGoalCreatorPage]
class UserGoalCreatorRoute
    extends _i64.PageRouteInfo<UserGoalCreatorRouteArgs> {
  UserGoalCreatorRoute({_i66.Key? key, _i67.UserGoal? journalGoal})
      : super(UserGoalCreatorRoute.name,
            path: 'create/goal',
            args: UserGoalCreatorRouteArgs(key: key, journalGoal: journalGoal));

  static const String name = 'UserGoalCreatorRoute';
}

class UserGoalCreatorRouteArgs {
  const UserGoalCreatorRouteArgs({this.key, this.journalGoal});

  final _i66.Key? key;

  final _i67.UserGoal? journalGoal;

  @override
  String toString() {
    return 'UserGoalCreatorRouteArgs{key: $key, journalGoal: $journalGoal}';
  }
}

/// generated route for
/// [_i48.UserMeditationLogCreatorPage]
class UserMeditationLogCreatorRoute
    extends _i64.PageRouteInfo<UserMeditationLogCreatorRouteArgs> {
  UserMeditationLogCreatorRoute(
      {_i66.Key? key,
      _i67.UserMeditationLog? userMeditationLog,
      int? year,
      int? dayNumber})
      : super(UserMeditationLogCreatorRoute.name,
            path: 'create/mindfulness-log',
            args: UserMeditationLogCreatorRouteArgs(
                key: key,
                userMeditationLog: userMeditationLog,
                year: year,
                dayNumber: dayNumber));

  static const String name = 'UserMeditationLogCreatorRoute';
}

class UserMeditationLogCreatorRouteArgs {
  const UserMeditationLogCreatorRouteArgs(
      {this.key, this.userMeditationLog, this.year, this.dayNumber});

  final _i66.Key? key;

  final _i67.UserMeditationLog? userMeditationLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserMeditationLogCreatorRouteArgs{key: $key, userMeditationLog: $userMeditationLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i49.UserEatWellLogCreatorPage]
class UserEatWellLogCreatorRoute
    extends _i64.PageRouteInfo<UserEatWellLogCreatorRouteArgs> {
  UserEatWellLogCreatorRoute(
      {_i66.Key? key,
      _i67.UserEatWellLog? userEatWellLog,
      int? year,
      int? dayNumber})
      : super(UserEatWellLogCreatorRoute.name,
            path: 'create/food-log',
            args: UserEatWellLogCreatorRouteArgs(
                key: key,
                userEatWellLog: userEatWellLog,
                year: year,
                dayNumber: dayNumber));

  static const String name = 'UserEatWellLogCreatorRoute';
}

class UserEatWellLogCreatorRouteArgs {
  const UserEatWellLogCreatorRouteArgs(
      {this.key, this.userEatWellLog, this.year, this.dayNumber});

  final _i66.Key? key;

  final _i67.UserEatWellLog? userEatWellLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserEatWellLogCreatorRouteArgs{key: $key, userEatWellLog: $userEatWellLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i50.UserSleepWellLogCreatorPage]
class UserSleepWellLogCreatorRoute
    extends _i64.PageRouteInfo<UserSleepWellLogCreatorRouteArgs> {
  UserSleepWellLogCreatorRoute(
      {_i66.Key? key,
      _i67.UserSleepWellLog? userSleepWellLog,
      int? year,
      int? dayNumber})
      : super(UserSleepWellLogCreatorRoute.name,
            path: 'create/sleep-log',
            args: UserSleepWellLogCreatorRouteArgs(
                key: key,
                userSleepWellLog: userSleepWellLog,
                year: year,
                dayNumber: dayNumber));

  static const String name = 'UserSleepWellLogCreatorRoute';
}

class UserSleepWellLogCreatorRouteArgs {
  const UserSleepWellLogCreatorRouteArgs(
      {this.key, this.userSleepWellLog, this.year, this.dayNumber});

  final _i66.Key? key;

  final _i67.UserSleepWellLog? userSleepWellLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserSleepWellLogCreatorRouteArgs{key: $key, userSleepWellLog: $userSleepWellLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i51.FeedPostCreatorPage]
class FeedPostCreatorRoute
    extends _i64.PageRouteInfo<FeedPostCreatorRouteArgs> {
  FeedPostCreatorRoute(
      {_i66.Key? key,
      _i67.CreateStreamFeedActivityInput? activityInput,
      void Function()? onComplete,
      String? title})
      : super(FeedPostCreatorRoute.name,
            path: 'create/post',
            args: FeedPostCreatorRouteArgs(
                key: key,
                activityInput: activityInput,
                onComplete: onComplete,
                title: title));

  static const String name = 'FeedPostCreatorRoute';
}

class FeedPostCreatorRouteArgs {
  const FeedPostCreatorRouteArgs(
      {this.key, this.activityInput, this.onComplete, this.title});

  final _i66.Key? key;

  final _i67.CreateStreamFeedActivityInput? activityInput;

  final void Function()? onComplete;

  final String? title;

  @override
  String toString() {
    return 'FeedPostCreatorRouteArgs{key: $key, activityInput: $activityInput, onComplete: $onComplete, title: $title}';
  }
}

/// generated route for
/// [_i52.ClubFeedPostCreatorPage]
class ClubFeedPostCreatorRoute
    extends _i64.PageRouteInfo<ClubFeedPostCreatorRouteArgs> {
  ClubFeedPostCreatorRoute(
      {_i66.Key? key,
      required String clubId,
      required void Function() onSuccess})
      : super(ClubFeedPostCreatorRoute.name,
            path: 'create/club-post',
            args: ClubFeedPostCreatorRouteArgs(
                key: key, clubId: clubId, onSuccess: onSuccess));

  static const String name = 'ClubFeedPostCreatorRoute';
}

class ClubFeedPostCreatorRouteArgs {
  const ClubFeedPostCreatorRouteArgs(
      {this.key, required this.clubId, required this.onSuccess});

  final _i66.Key? key;

  final String clubId;

  final void Function() onSuccess;

  @override
  String toString() {
    return 'ClubFeedPostCreatorRouteArgs{key: $key, clubId: $clubId, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [_i53.ScheduledWorkoutCreatorPage]
class ScheduledWorkoutCreatorRoute
    extends _i64.PageRouteInfo<ScheduledWorkoutCreatorRouteArgs> {
  ScheduledWorkoutCreatorRoute(
      {_i66.Key? key,
      _i67.ScheduledWorkout? scheduledWorkout,
      _i67.WorkoutSummary? workout,
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

/// generated route for
/// [_i54.WorkoutCreatorPage]
class WorkoutCreatorRoute extends _i64.PageRouteInfo<WorkoutCreatorRouteArgs> {
  WorkoutCreatorRoute({_i66.Key? key, _i67.Workout? workout})
      : super(WorkoutCreatorRoute.name,
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

/// generated route for
/// [_i55.WorkoutPlanCreatorPage]
class WorkoutPlanCreatorRoute
    extends _i64.PageRouteInfo<WorkoutPlanCreatorRouteArgs> {
  WorkoutPlanCreatorRoute({_i66.Key? key, _i67.WorkoutPlan? workoutPlan})
      : super(WorkoutPlanCreatorRoute.name,
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

/// generated route for
/// [_i56.WorkoutPlanReviewCreatorPage]
class WorkoutPlanReviewCreatorRoute
    extends _i64.PageRouteInfo<WorkoutPlanReviewCreatorRouteArgs> {
  WorkoutPlanReviewCreatorRoute(
      {_i66.Key? key,
      _i67.WorkoutPlanReview? workoutPlanReview,
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

  final _i66.Key? key;

  final _i67.WorkoutPlanReview? workoutPlanReview;

  final String parentWorkoutPlanId;

  final String parentWorkoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutPlanReviewCreatorRouteArgs{key: $key, workoutPlanReview: $workoutPlanReview, parentWorkoutPlanId: $parentWorkoutPlanId, parentWorkoutPlanEnrolmentId: $parentWorkoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i57.ExerciseLoadTrackerCreatorPage]
class ExerciseLoadTrackerCreatorRoute extends _i64.PageRouteInfo<void> {
  const ExerciseLoadTrackerCreatorRoute()
      : super(ExerciseLoadTrackerCreatorRoute.name,
            path: 'create/max-lift-tracker');

  static const String name = 'ExerciseLoadTrackerCreatorRoute';
}

/// generated route for
/// [_i58.PageNotFoundPage]
class RouteNotFoundRoute extends _i64.PageRouteInfo<void> {
  const RouteNotFoundRoute() : super(RouteNotFoundRoute.name, path: '404');

  static const String name = 'RouteNotFoundRoute';
}

/// generated route for
/// [_i59.FeedPage]
class FeedRoute extends _i64.PageRouteInfo<void> {
  const FeedRoute() : super(FeedRoute.name, path: '');

  static const String name = 'FeedRoute';
}

/// generated route for
/// [_i60.DiscoverPage]
class DiscoverRoute extends _i64.PageRouteInfo<void> {
  const DiscoverRoute() : super(DiscoverRoute.name, path: 'discover');

  static const String name = 'DiscoverRoute';
}

/// generated route for
/// [_i61.MyStudioPage]
class MyStudioRoute extends _i64.PageRouteInfo<void> {
  const MyStudioRoute() : super(MyStudioRoute.name, path: 'studio');

  static const String name = 'MyStudioRoute';
}

/// generated route for
/// [_i62.ProgressPage]
class ProgressRoute extends _i64.PageRouteInfo<void> {
  const ProgressRoute() : super(ProgressRoute.name, path: 'progress');

  static const String name = 'ProgressRoute';
}

/// generated route for
/// [_i63.ProfilePage]
class ProfileRoute extends _i64.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile');

  static const String name = 'ProfileRoute';
}
