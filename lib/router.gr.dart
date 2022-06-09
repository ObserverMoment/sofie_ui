// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i56;
import 'package:flutter/cupertino.dart' as _i64;
import 'package:flutter/material.dart' as _i63;
import 'package:sofie_ui/components/creators/body_tracking/body_tracking_entry_creator.dart'
    as _i37;
import 'package:sofie_ui/components/creators/club_creator/club_creator.dart'
    as _i38;
import 'package:sofie_ui/components/creators/collection_creator.dart' as _i39;
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator.dart'
    as _i40;
import 'package:sofie_ui/components/creators/exercise_load_tracker_creator_page.dart'
    as _i53;
import 'package:sofie_ui/components/creators/post_creator/club_feed_post_creator_page.dart'
    as _i47;
import 'package:sofie_ui/components/creators/post_creator/feed_post_creator_page.dart'
    as _i46;
import 'package:sofie_ui/components/creators/scheduled_workout_creator.dart'
    as _i48;
import 'package:sofie_ui/components/creators/user_day_logs/user_eat_well_log_creator_page.dart'
    as _i44;
import 'package:sofie_ui/components/creators/user_day_logs/user_meditation_log_creator_page.dart'
    as _i43;
import 'package:sofie_ui/components/creators/user_day_logs/user_sleep_well_log_creator_page.dart'
    as _i45;
import 'package:sofie_ui/components/creators/user_goal_creator_page.dart'
    as _i42;
import 'package:sofie_ui/components/creators/workout_creator/workout_creator.dart'
    as _i49;
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator.dart'
    as _i51;
import 'package:sofie_ui/components/creators/workout_plan_review_creator.dart'
    as _i52;
import 'package:sofie_ui/components/do_workout/do_workout_wrapper_page.dart'
    as _i10;
import 'package:sofie_ui/components/social/chat/chats_overview_page.dart'
    as _i5;
import 'package:sofie_ui/components/social/chat/clubs/club_members_chat_page.dart'
    as _i7;
import 'package:sofie_ui/components/social/chat/friends/one_to_one_chat_page.dart'
    as _i6;
import 'package:sofie_ui/components/timers/timers_page.dart' as _i21;
import 'package:sofie_ui/components/workout/workout_finders/public/public_workout_finder_page.dart'
    as _i27;
import 'package:sofie_ui/components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart'
    as _i28;
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart' as _i65;
import 'package:sofie_ui/main.dart' as _i2;
import 'package:sofie_ui/modules/home/home_page.dart' as _i55;
import 'package:sofie_ui/modules/home/notifications_page.dart' as _i16;
import 'package:sofie_ui/modules/main_tabs/main_tabs_page.dart' as _i4;
import 'package:sofie_ui/modules/profile/archive_page.dart' as _i12;
import 'package:sofie_ui/modules/profile/edit_profile_page.dart' as _i17;
import 'package:sofie_ui/modules/profile/gym_profile/gym_profile_creator.dart'
    as _i41;
import 'package:sofie_ui/modules/profile/gym_profile/gym_profiles_page.dart'
    as _i18;
import 'package:sofie_ui/modules/profile/profile_page.dart' as _i11;
import 'package:sofie_ui/modules/profile/settings_page.dart' as _i13;
import 'package:sofie_ui/modules/profile/skills/skills_page.dart' as _i14;
import 'package:sofie_ui/modules/profile/social/social_links_page.dart' as _i15;
import 'package:sofie_ui/modules/sign_in_registration/unauthed_landing_page.dart'
    as _i1;
import 'package:sofie_ui/modules/studio/calendar.dart' as _i19;
import 'package:sofie_ui/modules/studio/collections.dart' as _i59;
import 'package:sofie_ui/modules/studio/moves_library.dart' as _i60;
import 'package:sofie_ui/modules/studio/plans/plans.dart' as _i61;
import 'package:sofie_ui/modules/studio/studio_page.dart' as _i58;
import 'package:sofie_ui/modules/studio/workouts/workouts.dart' as _i62;
import 'package:sofie_ui/modules/workout_sessions/resistance_session/resistance_session_creator_page.dart'
    as _i50;
import 'package:sofie_ui/pages/authed/authed_routes_wrapper_page.dart' as _i3;
import 'package:sofie_ui/pages/authed/circles/circles_page.dart' as _i20;
import 'package:sofie_ui/pages/authed/circles/discover_clubs_page.dart' as _i30;
import 'package:sofie_ui/pages/authed/circles/discover_people_page.dart'
    as _i29;
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_page.dart'
    as _i31;
import 'package:sofie_ui/pages/authed/details_pages/collection_details_page.dart'
    as _i9;
import 'package:sofie_ui/pages/authed/details_pages/logged_workout_details_page.dart'
    as _i32;
import 'package:sofie_ui/pages/authed/details_pages/user_public_profile_details_page.dart'
    as _i33;
import 'package:sofie_ui/pages/authed/details_pages/workout_details_page.dart'
    as _i34;
import 'package:sofie_ui/pages/authed/details_pages/workout_plan_details_page.dart'
    as _i35;
import 'package:sofie_ui/pages/authed/details_pages/workout_plan_enrolment_details_page.dart'
    as _i36;
import 'package:sofie_ui/pages/authed/landing_pages/club_invite_landing_page.dart'
    as _i8;
import 'package:sofie_ui/pages/authed/page_not_found.dart' as _i54;
import 'package:sofie_ui/pages/authed/progress/body_tracking_page.dart' as _i24;
import 'package:sofie_ui/pages/authed/progress/logged_workouts/logged_workouts_history_page.dart'
    as _i26;
import 'package:sofie_ui/pages/authed/progress/logged_workouts_analysis_page.dart'
    as _i25;
import 'package:sofie_ui/pages/authed/progress/personal_scorebook_page.dart'
    as _i22;
import 'package:sofie_ui/pages/authed/progress/progress_page.dart' as _i57;
import 'package:sofie_ui/pages/authed/progress/user_goals_page.dart' as _i23;

class AppRouter extends _i56.RootStackRouter {
  AppRouter([_i63.GlobalKey<_i63.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i56.PageFactory> pagesMap = {
    UnauthedLandingRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i1.UnauthedLandingPage(),
          fullscreenDialog: true);
    },
    GlobalLoadingRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i2.GlobalLoadingPage(),
          fullscreenDialog: true);
    },
    AuthedRouter.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i3.AuthedRoutesWrapperPage(),
          fullscreenDialog: true);
    },
    MainTabsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.MainTabsPage());
    },
    ChatsOverviewRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.ChatsOverviewPage());
    },
    OneToOneChatRoute.name: (routeData) {
      final args = routeData.argsAs<OneToOneChatRouteArgs>();
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i6.OneToOneChatPage(
              key: args.key, otherUserId: args.otherUserId));
    },
    ClubMembersChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClubMembersChatRouteArgs>();
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i7.ClubMembersChatPage(key: args.key, clubId: args.clubId));
    },
    ClubInviteLandingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubInviteLandingRouteArgs>(
          orElse: () =>
              ClubInviteLandingRouteArgs(id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i8.ClubInviteLandingPage(key: args.key, id: args.id));
    },
    CollectionDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CollectionDetailsRouteArgs>(
          orElse: () =>
              CollectionDetailsRouteArgs(id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i9.CollectionDetailsPage(key: args.key, id: args.id));
    },
    DoWorkoutWrapperRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DoWorkoutWrapperRouteArgs>(
          orElse: () =>
              DoWorkoutWrapperRouteArgs(id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i10.DoWorkoutWrapperPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout,
              workoutPlanDayWorkoutId: args.workoutPlanDayWorkoutId,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    ProfileRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.ProfilePage());
    },
    ArchiveRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i12.ArchivePage());
    },
    SettingsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.SettingsPage());
    },
    SkillsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i14.SkillsPage());
    },
    SocialLinksRoute.name: (routeData) {
      final args = routeData.argsAs<SocialLinksRouteArgs>();
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i15.SocialLinksPage(key: args.key, profile: args.profile));
    },
    NotificationsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.NotificationsPage());
    },
    EditProfileRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i17.EditProfilePage());
    },
    GymProfilesRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i18.GymProfilesPage());
    },
    CalendarRoute.name: (routeData) {
      final args = routeData.argsAs<CalendarRouteArgs>(
          orElse: () => const CalendarRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i19.CalendarPage(key: args.key, openAtDate: args.openAtDate));
    },
    CirclesRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i20.CirclesPage());
    },
    TimersRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i21.TimersPage());
    },
    PersonalScoresRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i22.PersonalScoresPage());
    },
    UserGoalsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i23.UserGoalsPage());
    },
    BodyTrackingRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i24.BodyTrackingPage());
    },
    LoggedWorkoutsAnalysisRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutsAnalysisRouteArgs>(
          orElse: () => const LoggedWorkoutsAnalysisRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i25.LoggedWorkoutsAnalysisPage(
              key: args.key, pageTitle: args.pageTitle));
    },
    LoggedWorkoutsHistoryRoute.name: (routeData) {
      final args = routeData.argsAs<LoggedWorkoutsHistoryRouteArgs>(
          orElse: () => const LoggedWorkoutsHistoryRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i26.LoggedWorkoutsHistoryPage(
              key: args.key,
              selectLoggedWorkout: args.selectLoggedWorkout,
              pageTitle: args.pageTitle));
    },
    PublicWorkoutFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutFinderRouteArgs>(
          orElse: () => const PublicWorkoutFinderRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i27.PublicWorkoutFinderPage(
              key: args.key, selectWorkout: args.selectWorkout));
    },
    PublicWorkoutPlanFinderRoute.name: (routeData) {
      final args = routeData.argsAs<PublicWorkoutPlanFinderRouteArgs>(
          orElse: () => const PublicWorkoutPlanFinderRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i28.PublicWorkoutPlanFinderPage(
              key: args.key, selectWorkoutPlan: args.selectWorkoutPlan));
    },
    DiscoverPeopleRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i29.DiscoverPeoplePage());
    },
    DiscoverClubsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i30.DiscoverClubsPage());
    },
    ClubDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubDetailsRouteArgs>(
          orElse: () => ClubDetailsRouteArgs(id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i31.ClubDetailsPage(key: args.key, id: args.id));
    },
    LoggedWorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoggedWorkoutDetailsRouteArgs>(
          orElse: () =>
              LoggedWorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i32.LoggedWorkoutDetailsPage(key: args.key, id: args.id));
    },
    UserPublicProfileDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicProfileDetailsRouteArgs>(
          orElse: () => UserPublicProfileDetailsRouteArgs(
              userId: pathParams.getString('userId')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i33.UserPublicProfileDetailsPage(
              key: args.key, userId: args.userId));
    },
    WorkoutDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutDetailsRouteArgs>(
          orElse: () =>
              WorkoutDetailsRouteArgs(id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i34.WorkoutDetailsPage(
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
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i35.WorkoutPlanDetailsPage(key: args.key, id: args.id));
    },
    WorkoutPlanEnrolmentDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkoutPlanEnrolmentDetailsRouteArgs>(
          orElse: () => WorkoutPlanEnrolmentDetailsRouteArgs(
              id: pathParams.getString('id')));
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child:
              _i36.WorkoutPlanEnrolmentDetailsPage(key: args.key, id: args.id));
    },
    BodyTrackingEntryCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<BodyTrackingEntryCreatorRouteArgs>(
          orElse: () => const BodyTrackingEntryCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i37.BodyTrackingEntryCreatorPage(
              key: args.key, bodyTrackingEntry: args.bodyTrackingEntry));
    },
    ClubCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubCreatorRouteArgs>(
          orElse: () => const ClubCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i38.ClubCreatorPage(
              key: args.key, clubSummary: args.clubSummary));
    },
    CollectionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionCreatorRouteArgs>(
          orElse: () => const CollectionCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i39.CollectionCreatorPage(
              key: args.key,
              collection: args.collection,
              onComplete: args.onComplete));
    },
    CustomMoveCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CustomMoveCreatorRouteArgs>(
          orElse: () => const CustomMoveCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i40.CustomMoveCreatorPage(key: args.key, move: args.move));
    },
    GymProfileCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfileCreatorRouteArgs>(
          orElse: () => const GymProfileCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i41.GymProfileCreatorPage(
              key: args.key, gymProfile: args.gymProfile));
    },
    UserGoalCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserGoalCreatorRouteArgs>(
          orElse: () => const UserGoalCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i42.UserGoalCreatorPage(
              key: args.key, journalGoal: args.journalGoal));
    },
    UserMeditationLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserMeditationLogCreatorRouteArgs>(
          orElse: () => const UserMeditationLogCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i43.UserMeditationLogCreatorPage(
              key: args.key,
              userMeditationLog: args.userMeditationLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    UserEatWellLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserEatWellLogCreatorRouteArgs>(
          orElse: () => const UserEatWellLogCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i44.UserEatWellLogCreatorPage(
              key: args.key,
              userEatWellLog: args.userEatWellLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    UserSleepWellLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserSleepWellLogCreatorRouteArgs>(
          orElse: () => const UserSleepWellLogCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i45.UserSleepWellLogCreatorPage(
              key: args.key,
              userSleepWellLog: args.userSleepWellLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    FeedPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<FeedPostCreatorRouteArgs>(
          orElse: () => const FeedPostCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i46.FeedPostCreatorPage(
              key: args.key,
              activityInput: args.activityInput,
              onComplete: args.onComplete,
              title: args.title));
    },
    ClubFeedPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubFeedPostCreatorRouteArgs>();
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i47.ClubFeedPostCreatorPage(
              key: args.key, clubId: args.clubId, onSuccess: args.onSuccess));
    },
    ScheduledWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduledWorkoutCreatorRouteArgs>(
          orElse: () => const ScheduledWorkoutCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i48.ScheduledWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workout: args.workout,
              scheduleOn: args.scheduleOn,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutCreatorRouteArgs>(
          orElse: () => const WorkoutCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i49.WorkoutCreatorPage(key: args.key, workout: args.workout));
    },
    ResistanceSessionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ResistanceSessionCreatorRouteArgs>(
          orElse: () => const ResistanceSessionCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i50.ResistanceSessionCreatorPage(
              key: args.key, resistanceSession: args.resistanceSession));
    },
    WorkoutPlanCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanCreatorRouteArgs>(
          orElse: () => const WorkoutPlanCreatorRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i51.WorkoutPlanCreatorPage(
              key: args.key, workoutPlan: args.workoutPlan));
    },
    WorkoutPlanReviewCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanReviewCreatorRouteArgs>();
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i52.WorkoutPlanReviewCreatorPage(
              key: args.key,
              workoutPlanReview: args.workoutPlanReview,
              parentWorkoutPlanId: args.parentWorkoutPlanId,
              parentWorkoutPlanEnrolmentId: args.parentWorkoutPlanEnrolmentId));
    },
    ExerciseLoadTrackerCreatorRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i53.ExerciseLoadTrackerCreatorPage());
    },
    RouteNotFoundRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i54.PageNotFoundPage());
    },
    HomeRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i55.HomePage());
    },
    StudioStack.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i56.EmptyRouterPage());
    },
    ProgressRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i57.ProgressPage());
    },
    StudioRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i58.StudioPage());
    },
    CollectionsRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i59.CollectionsPage());
    },
    MovesLibraryRoute.name: (routeData) {
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i60.MovesLibraryPage());
    },
    PlansRoute.name: (routeData) {
      final args = routeData.argsAs<PlansRouteArgs>(
          orElse: () => const PlansRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i61.PlansPage(
              key: args.key,
              selectPlan: args.selectPlan,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showJoined: args.showJoined,
              showSaved: args.showSaved));
    },
    WorkoutsRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutsRouteArgs>(
          orElse: () => const WorkoutsRouteArgs());
      return _i56.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i62.WorkoutsPage(
              key: args.key, previousPageTitle: args.previousPageTitle));
    }
  };

  @override
  List<_i56.RouteConfig> get routes => [
        _i56.RouteConfig(UnauthedLandingRoute.name, path: '/auth'),
        _i56.RouteConfig(GlobalLoadingRoute.name, path: '/loading'),
        _i56.RouteConfig(AuthedRouter.name, path: '/', children: [
          _i56.RouteConfig(MainTabsRoute.name,
              path: '',
              parent: AuthedRouter.name,
              children: [
                _i56.RouteConfig(HomeRoute.name,
                    path: '', parent: MainTabsRoute.name),
                _i56.RouteConfig(CirclesRoute.name,
                    path: 'circles', parent: MainTabsRoute.name),
                _i56.RouteConfig(StudioStack.name,
                    path: 'studio',
                    parent: MainTabsRoute.name,
                    children: [
                      _i56.RouteConfig(StudioRoute.name,
                          path: '', parent: StudioStack.name),
                      _i56.RouteConfig(CollectionsRoute.name,
                          path: 'collections', parent: StudioStack.name),
                      _i56.RouteConfig(MovesLibraryRoute.name,
                          path: 'moves', parent: StudioStack.name),
                      _i56.RouteConfig(PlansRoute.name,
                          path: 'plans', parent: StudioStack.name),
                      _i56.RouteConfig(WorkoutsRoute.name,
                          path: 'workouts', parent: StudioStack.name),
                      _i56.RouteConfig('*#redirect',
                          path: '*',
                          parent: StudioStack.name,
                          redirectTo: '',
                          fullMatch: true)
                    ]),
                _i56.RouteConfig(ProgressRoute.name,
                    path: 'progress', parent: MainTabsRoute.name)
              ]),
          _i56.RouteConfig(ChatsOverviewRoute.name,
              path: 'chats', parent: AuthedRouter.name),
          _i56.RouteConfig(OneToOneChatRoute.name,
              path: 'chat', parent: AuthedRouter.name),
          _i56.RouteConfig(ClubMembersChatRoute.name,
              path: 'club-chat', parent: AuthedRouter.name),
          _i56.RouteConfig(ClubInviteLandingRoute.name,
              path: 'club-invite/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(CollectionDetailsRoute.name,
              path: 'collection/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(DoWorkoutWrapperRoute.name,
              path: 'do-workout/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(ProfileRoute.name,
              path: 'profile', parent: AuthedRouter.name),
          _i56.RouteConfig(ArchiveRoute.name,
              path: 'archive', parent: AuthedRouter.name),
          _i56.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: AuthedRouter.name),
          _i56.RouteConfig(SkillsRoute.name,
              path: 'skills', parent: AuthedRouter.name),
          _i56.RouteConfig(SocialLinksRoute.name,
              path: 'social-links', parent: AuthedRouter.name),
          _i56.RouteConfig(NotificationsRoute.name,
              path: 'notifications', parent: AuthedRouter.name),
          _i56.RouteConfig(EditProfileRoute.name,
              path: 'edit-profile', parent: AuthedRouter.name),
          _i56.RouteConfig(GymProfilesRoute.name,
              path: 'gym-profiles', parent: AuthedRouter.name),
          _i56.RouteConfig(CalendarRoute.name,
              path: 'calendar', parent: AuthedRouter.name),
          _i56.RouteConfig(CirclesRoute.name,
              path: 'circles', parent: AuthedRouter.name),
          _i56.RouteConfig(TimersRoute.name,
              path: 'timers', parent: AuthedRouter.name),
          _i56.RouteConfig(PersonalScoresRoute.name,
              path: 'personal-scores', parent: AuthedRouter.name),
          _i56.RouteConfig(UserGoalsRoute.name,
              path: 'goals', parent: AuthedRouter.name),
          _i56.RouteConfig(BodyTrackingRoute.name,
              path: 'body-tracking', parent: AuthedRouter.name),
          _i56.RouteConfig(LoggedWorkoutsAnalysisRoute.name,
              path: 'workout-logs/analysis', parent: AuthedRouter.name),
          _i56.RouteConfig(LoggedWorkoutsHistoryRoute.name,
              path: 'workout-logs/history', parent: AuthedRouter.name),
          _i56.RouteConfig(PublicWorkoutFinderRoute.name,
              path: 'public-workouts', parent: AuthedRouter.name),
          _i56.RouteConfig(PublicWorkoutPlanFinderRoute.name,
              path: 'public-plans', parent: AuthedRouter.name),
          _i56.RouteConfig(DiscoverPeopleRoute.name,
              path: 'discover-people', parent: AuthedRouter.name),
          _i56.RouteConfig(DiscoverClubsRoute.name,
              path: 'discover-clubs', parent: AuthedRouter.name),
          _i56.RouteConfig(ClubDetailsRoute.name,
              path: 'club/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(LoggedWorkoutDetailsRoute.name,
              path: 'logged-workout/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(UserPublicProfileDetailsRoute.name,
              path: 'profile/:userId', parent: AuthedRouter.name),
          _i56.RouteConfig(WorkoutDetailsRoute.name,
              path: 'workout/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(WorkoutPlanDetailsRoute.name,
              path: 'workout-plan/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(WorkoutPlanEnrolmentDetailsRoute.name,
              path: 'workout-plan-progress/:id', parent: AuthedRouter.name),
          _i56.RouteConfig(BodyTrackingEntryCreatorRoute.name,
              path: 'create/body-tracking', parent: AuthedRouter.name),
          _i56.RouteConfig(ClubCreatorRoute.name,
              path: 'create/club', parent: AuthedRouter.name),
          _i56.RouteConfig(CollectionCreatorRoute.name,
              path: 'create/collection', parent: AuthedRouter.name),
          _i56.RouteConfig(CustomMoveCreatorRoute.name,
              path: 'create/custom-move', parent: AuthedRouter.name),
          _i56.RouteConfig(GymProfileCreatorRoute.name,
              path: 'create/gym-profile', parent: AuthedRouter.name),
          _i56.RouteConfig(UserGoalCreatorRoute.name,
              path: 'create/goal', parent: AuthedRouter.name),
          _i56.RouteConfig(UserMeditationLogCreatorRoute.name,
              path: 'create/mindfulness-log', parent: AuthedRouter.name),
          _i56.RouteConfig(UserEatWellLogCreatorRoute.name,
              path: 'create/food-log', parent: AuthedRouter.name),
          _i56.RouteConfig(UserSleepWellLogCreatorRoute.name,
              path: 'create/sleep-log', parent: AuthedRouter.name),
          _i56.RouteConfig(FeedPostCreatorRoute.name,
              path: 'create/post', parent: AuthedRouter.name),
          _i56.RouteConfig(ClubFeedPostCreatorRoute.name,
              path: 'create/club-post', parent: AuthedRouter.name),
          _i56.RouteConfig(ScheduledWorkoutCreatorRoute.name,
              path: 'create/scheduled-workout', parent: AuthedRouter.name),
          _i56.RouteConfig(WorkoutCreatorRoute.name,
              path: 'create/workout', parent: AuthedRouter.name),
          _i56.RouteConfig(ResistanceSessionCreatorRoute.name,
              path: 'create/resistance-session', parent: AuthedRouter.name),
          _i56.RouteConfig(WorkoutPlanCreatorRoute.name,
              path: 'create/workout-plan', parent: AuthedRouter.name),
          _i56.RouteConfig(WorkoutPlanReviewCreatorRoute.name,
              path: 'create/workout-plan-review', parent: AuthedRouter.name),
          _i56.RouteConfig(ExerciseLoadTrackerCreatorRoute.name,
              path: 'create/max-lift-tracker', parent: AuthedRouter.name),
          _i56.RouteConfig(RouteNotFoundRoute.name,
              path: '404', parent: AuthedRouter.name),
          _i56.RouteConfig('*#redirect',
              path: '*',
              parent: AuthedRouter.name,
              redirectTo: '404',
              fullMatch: true)
        ])
      ];
}

/// generated route for
/// [_i1.UnauthedLandingPage]
class UnauthedLandingRoute extends _i56.PageRouteInfo<void> {
  const UnauthedLandingRoute()
      : super(UnauthedLandingRoute.name, path: '/auth');

  static const String name = 'UnauthedLandingRoute';
}

/// generated route for
/// [_i2.GlobalLoadingPage]
class GlobalLoadingRoute extends _i56.PageRouteInfo<void> {
  const GlobalLoadingRoute() : super(GlobalLoadingRoute.name, path: '/loading');

  static const String name = 'GlobalLoadingRoute';
}

/// generated route for
/// [_i3.AuthedRoutesWrapperPage]
class AuthedRouter extends _i56.PageRouteInfo<void> {
  const AuthedRouter({List<_i56.PageRouteInfo>? children})
      : super(AuthedRouter.name, path: '/', initialChildren: children);

  static const String name = 'AuthedRouter';
}

/// generated route for
/// [_i4.MainTabsPage]
class MainTabsRoute extends _i56.PageRouteInfo<void> {
  const MainTabsRoute({List<_i56.PageRouteInfo>? children})
      : super(MainTabsRoute.name, path: '', initialChildren: children);

  static const String name = 'MainTabsRoute';
}

/// generated route for
/// [_i5.ChatsOverviewPage]
class ChatsOverviewRoute extends _i56.PageRouteInfo<void> {
  const ChatsOverviewRoute() : super(ChatsOverviewRoute.name, path: 'chats');

  static const String name = 'ChatsOverviewRoute';
}

/// generated route for
/// [_i6.OneToOneChatPage]
class OneToOneChatRoute extends _i56.PageRouteInfo<OneToOneChatRouteArgs> {
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
    extends _i56.PageRouteInfo<ClubMembersChatRouteArgs> {
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
    extends _i56.PageRouteInfo<ClubInviteLandingRouteArgs> {
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
    extends _i56.PageRouteInfo<CollectionDetailsRouteArgs> {
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
    extends _i56.PageRouteInfo<DoWorkoutWrapperRouteArgs> {
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
/// [_i11.ProfilePage]
class ProfileRoute extends _i56.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i12.ArchivePage]
class ArchiveRoute extends _i56.PageRouteInfo<void> {
  const ArchiveRoute() : super(ArchiveRoute.name, path: 'archive');

  static const String name = 'ArchiveRoute';
}

/// generated route for
/// [_i13.SettingsPage]
class SettingsRoute extends _i56.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i14.SkillsPage]
class SkillsRoute extends _i56.PageRouteInfo<void> {
  const SkillsRoute() : super(SkillsRoute.name, path: 'skills');

  static const String name = 'SkillsRoute';
}

/// generated route for
/// [_i15.SocialLinksPage]
class SocialLinksRoute extends _i56.PageRouteInfo<SocialLinksRouteArgs> {
  SocialLinksRoute({_i64.Key? key, required _i65.UserProfile profile})
      : super(SocialLinksRoute.name,
            path: 'social-links',
            args: SocialLinksRouteArgs(key: key, profile: profile));

  static const String name = 'SocialLinksRoute';
}

class SocialLinksRouteArgs {
  const SocialLinksRouteArgs({this.key, required this.profile});

  final _i64.Key? key;

  final _i65.UserProfile profile;

  @override
  String toString() {
    return 'SocialLinksRouteArgs{key: $key, profile: $profile}';
  }
}

/// generated route for
/// [_i16.NotificationsPage]
class NotificationsRoute extends _i56.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(NotificationsRoute.name, path: 'notifications');

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i17.EditProfilePage]
class EditProfileRoute extends _i56.PageRouteInfo<void> {
  const EditProfileRoute() : super(EditProfileRoute.name, path: 'edit-profile');

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i18.GymProfilesPage]
class GymProfilesRoute extends _i56.PageRouteInfo<void> {
  const GymProfilesRoute() : super(GymProfilesRoute.name, path: 'gym-profiles');

  static const String name = 'GymProfilesRoute';
}

/// generated route for
/// [_i19.CalendarPage]
class CalendarRoute extends _i56.PageRouteInfo<CalendarRouteArgs> {
  CalendarRoute({_i64.Key? key, DateTime? openAtDate})
      : super(CalendarRoute.name,
            path: 'calendar',
            args: CalendarRouteArgs(key: key, openAtDate: openAtDate));

  static const String name = 'CalendarRoute';
}

class CalendarRouteArgs {
  const CalendarRouteArgs({this.key, this.openAtDate});

  final _i64.Key? key;

  final DateTime? openAtDate;

  @override
  String toString() {
    return 'CalendarRouteArgs{key: $key, openAtDate: $openAtDate}';
  }
}

/// generated route for
/// [_i20.CirclesPage]
class CirclesRoute extends _i56.PageRouteInfo<void> {
  const CirclesRoute() : super(CirclesRoute.name, path: 'circles');

  static const String name = 'CirclesRoute';
}

/// generated route for
/// [_i21.TimersPage]
class TimersRoute extends _i56.PageRouteInfo<void> {
  const TimersRoute() : super(TimersRoute.name, path: 'timers');

  static const String name = 'TimersRoute';
}

/// generated route for
/// [_i22.PersonalScoresPage]
class PersonalScoresRoute extends _i56.PageRouteInfo<void> {
  const PersonalScoresRoute()
      : super(PersonalScoresRoute.name, path: 'personal-scores');

  static const String name = 'PersonalScoresRoute';
}

/// generated route for
/// [_i23.UserGoalsPage]
class UserGoalsRoute extends _i56.PageRouteInfo<void> {
  const UserGoalsRoute() : super(UserGoalsRoute.name, path: 'goals');

  static const String name = 'UserGoalsRoute';
}

/// generated route for
/// [_i24.BodyTrackingPage]
class BodyTrackingRoute extends _i56.PageRouteInfo<void> {
  const BodyTrackingRoute()
      : super(BodyTrackingRoute.name, path: 'body-tracking');

  static const String name = 'BodyTrackingRoute';
}

/// generated route for
/// [_i25.LoggedWorkoutsAnalysisPage]
class LoggedWorkoutsAnalysisRoute
    extends _i56.PageRouteInfo<LoggedWorkoutsAnalysisRouteArgs> {
  LoggedWorkoutsAnalysisRoute(
      {_i64.Key? key, String pageTitle = 'Logs & Analysis'})
      : super(LoggedWorkoutsAnalysisRoute.name,
            path: 'workout-logs/analysis',
            args: LoggedWorkoutsAnalysisRouteArgs(
                key: key, pageTitle: pageTitle));

  static const String name = 'LoggedWorkoutsAnalysisRoute';
}

class LoggedWorkoutsAnalysisRouteArgs {
  const LoggedWorkoutsAnalysisRouteArgs(
      {this.key, this.pageTitle = 'Logs & Analysis'});

  final _i64.Key? key;

  final String pageTitle;

  @override
  String toString() {
    return 'LoggedWorkoutsAnalysisRouteArgs{key: $key, pageTitle: $pageTitle}';
  }
}

/// generated route for
/// [_i26.LoggedWorkoutsHistoryPage]
class LoggedWorkoutsHistoryRoute
    extends _i56.PageRouteInfo<LoggedWorkoutsHistoryRouteArgs> {
  LoggedWorkoutsHistoryRoute(
      {_i64.Key? key,
      void Function(_i65.LoggedWorkout)? selectLoggedWorkout,
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

  final _i64.Key? key;

  final void Function(_i65.LoggedWorkout)? selectLoggedWorkout;

  final String pageTitle;

  @override
  String toString() {
    return 'LoggedWorkoutsHistoryRouteArgs{key: $key, selectLoggedWorkout: $selectLoggedWorkout, pageTitle: $pageTitle}';
  }
}

/// generated route for
/// [_i27.PublicWorkoutFinderPage]
class PublicWorkoutFinderRoute
    extends _i56.PageRouteInfo<PublicWorkoutFinderRouteArgs> {
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
/// [_i28.PublicWorkoutPlanFinderPage]
class PublicWorkoutPlanFinderRoute
    extends _i56.PageRouteInfo<PublicWorkoutPlanFinderRouteArgs> {
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
/// [_i29.DiscoverPeoplePage]
class DiscoverPeopleRoute extends _i56.PageRouteInfo<void> {
  const DiscoverPeopleRoute()
      : super(DiscoverPeopleRoute.name, path: 'discover-people');

  static const String name = 'DiscoverPeopleRoute';
}

/// generated route for
/// [_i30.DiscoverClubsPage]
class DiscoverClubsRoute extends _i56.PageRouteInfo<void> {
  const DiscoverClubsRoute()
      : super(DiscoverClubsRoute.name, path: 'discover-clubs');

  static const String name = 'DiscoverClubsRoute';
}

/// generated route for
/// [_i31.ClubDetailsPage]
class ClubDetailsRoute extends _i56.PageRouteInfo<ClubDetailsRouteArgs> {
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
/// [_i32.LoggedWorkoutDetailsPage]
class LoggedWorkoutDetailsRoute
    extends _i56.PageRouteInfo<LoggedWorkoutDetailsRouteArgs> {
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
/// [_i33.UserPublicProfileDetailsPage]
class UserPublicProfileDetailsRoute
    extends _i56.PageRouteInfo<UserPublicProfileDetailsRouteArgs> {
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
/// [_i34.WorkoutDetailsPage]
class WorkoutDetailsRoute extends _i56.PageRouteInfo<WorkoutDetailsRouteArgs> {
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
/// [_i35.WorkoutPlanDetailsPage]
class WorkoutPlanDetailsRoute
    extends _i56.PageRouteInfo<WorkoutPlanDetailsRouteArgs> {
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
/// [_i36.WorkoutPlanEnrolmentDetailsPage]
class WorkoutPlanEnrolmentDetailsRoute
    extends _i56.PageRouteInfo<WorkoutPlanEnrolmentDetailsRouteArgs> {
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
/// [_i37.BodyTrackingEntryCreatorPage]
class BodyTrackingEntryCreatorRoute
    extends _i56.PageRouteInfo<BodyTrackingEntryCreatorRouteArgs> {
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
/// [_i38.ClubCreatorPage]
class ClubCreatorRoute extends _i56.PageRouteInfo<ClubCreatorRouteArgs> {
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
/// [_i39.CollectionCreatorPage]
class CollectionCreatorRoute
    extends _i56.PageRouteInfo<CollectionCreatorRouteArgs> {
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
/// [_i40.CustomMoveCreatorPage]
class CustomMoveCreatorRoute
    extends _i56.PageRouteInfo<CustomMoveCreatorRouteArgs> {
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
/// [_i41.GymProfileCreatorPage]
class GymProfileCreatorRoute
    extends _i56.PageRouteInfo<GymProfileCreatorRouteArgs> {
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
/// [_i42.UserGoalCreatorPage]
class UserGoalCreatorRoute
    extends _i56.PageRouteInfo<UserGoalCreatorRouteArgs> {
  UserGoalCreatorRoute({_i64.Key? key, _i65.UserGoal? journalGoal})
      : super(UserGoalCreatorRoute.name,
            path: 'create/goal',
            args: UserGoalCreatorRouteArgs(key: key, journalGoal: journalGoal));

  static const String name = 'UserGoalCreatorRoute';
}

class UserGoalCreatorRouteArgs {
  const UserGoalCreatorRouteArgs({this.key, this.journalGoal});

  final _i64.Key? key;

  final _i65.UserGoal? journalGoal;

  @override
  String toString() {
    return 'UserGoalCreatorRouteArgs{key: $key, journalGoal: $journalGoal}';
  }
}

/// generated route for
/// [_i43.UserMeditationLogCreatorPage]
class UserMeditationLogCreatorRoute
    extends _i56.PageRouteInfo<UserMeditationLogCreatorRouteArgs> {
  UserMeditationLogCreatorRoute(
      {_i64.Key? key,
      _i65.UserMeditationLog? userMeditationLog,
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

  final _i64.Key? key;

  final _i65.UserMeditationLog? userMeditationLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserMeditationLogCreatorRouteArgs{key: $key, userMeditationLog: $userMeditationLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i44.UserEatWellLogCreatorPage]
class UserEatWellLogCreatorRoute
    extends _i56.PageRouteInfo<UserEatWellLogCreatorRouteArgs> {
  UserEatWellLogCreatorRoute(
      {_i64.Key? key,
      _i65.UserEatWellLog? userEatWellLog,
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

  final _i64.Key? key;

  final _i65.UserEatWellLog? userEatWellLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserEatWellLogCreatorRouteArgs{key: $key, userEatWellLog: $userEatWellLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i45.UserSleepWellLogCreatorPage]
class UserSleepWellLogCreatorRoute
    extends _i56.PageRouteInfo<UserSleepWellLogCreatorRouteArgs> {
  UserSleepWellLogCreatorRoute(
      {_i64.Key? key,
      _i65.UserSleepWellLog? userSleepWellLog,
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

  final _i64.Key? key;

  final _i65.UserSleepWellLog? userSleepWellLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserSleepWellLogCreatorRouteArgs{key: $key, userSleepWellLog: $userSleepWellLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i46.FeedPostCreatorPage]
class FeedPostCreatorRoute
    extends _i56.PageRouteInfo<FeedPostCreatorRouteArgs> {
  FeedPostCreatorRoute(
      {_i64.Key? key,
      _i65.CreateStreamFeedActivityInput? activityInput,
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

  final _i64.Key? key;

  final _i65.CreateStreamFeedActivityInput? activityInput;

  final void Function()? onComplete;

  final String? title;

  @override
  String toString() {
    return 'FeedPostCreatorRouteArgs{key: $key, activityInput: $activityInput, onComplete: $onComplete, title: $title}';
  }
}

/// generated route for
/// [_i47.ClubFeedPostCreatorPage]
class ClubFeedPostCreatorRoute
    extends _i56.PageRouteInfo<ClubFeedPostCreatorRouteArgs> {
  ClubFeedPostCreatorRoute(
      {_i64.Key? key,
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

  final _i64.Key? key;

  final String clubId;

  final void Function() onSuccess;

  @override
  String toString() {
    return 'ClubFeedPostCreatorRouteArgs{key: $key, clubId: $clubId, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [_i48.ScheduledWorkoutCreatorPage]
class ScheduledWorkoutCreatorRoute
    extends _i56.PageRouteInfo<ScheduledWorkoutCreatorRouteArgs> {
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
/// [_i49.WorkoutCreatorPage]
class WorkoutCreatorRoute extends _i56.PageRouteInfo<WorkoutCreatorRouteArgs> {
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
/// [_i50.ResistanceSessionCreatorPage]
class ResistanceSessionCreatorRoute
    extends _i56.PageRouteInfo<ResistanceSessionCreatorRouteArgs> {
  ResistanceSessionCreatorRoute(
      {_i64.Key? key, _i65.ResistanceSession? resistanceSession})
      : super(ResistanceSessionCreatorRoute.name,
            path: 'create/resistance-session',
            args: ResistanceSessionCreatorRouteArgs(
                key: key, resistanceSession: resistanceSession));

  static const String name = 'ResistanceSessionCreatorRoute';
}

class ResistanceSessionCreatorRouteArgs {
  const ResistanceSessionCreatorRouteArgs({this.key, this.resistanceSession});

  final _i64.Key? key;

  final _i65.ResistanceSession? resistanceSession;

  @override
  String toString() {
    return 'ResistanceSessionCreatorRouteArgs{key: $key, resistanceSession: $resistanceSession}';
  }
}

/// generated route for
/// [_i51.WorkoutPlanCreatorPage]
class WorkoutPlanCreatorRoute
    extends _i56.PageRouteInfo<WorkoutPlanCreatorRouteArgs> {
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
/// [_i52.WorkoutPlanReviewCreatorPage]
class WorkoutPlanReviewCreatorRoute
    extends _i56.PageRouteInfo<WorkoutPlanReviewCreatorRouteArgs> {
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
/// [_i53.ExerciseLoadTrackerCreatorPage]
class ExerciseLoadTrackerCreatorRoute extends _i56.PageRouteInfo<void> {
  const ExerciseLoadTrackerCreatorRoute()
      : super(ExerciseLoadTrackerCreatorRoute.name,
            path: 'create/max-lift-tracker');

  static const String name = 'ExerciseLoadTrackerCreatorRoute';
}

/// generated route for
/// [_i54.PageNotFoundPage]
class RouteNotFoundRoute extends _i56.PageRouteInfo<void> {
  const RouteNotFoundRoute() : super(RouteNotFoundRoute.name, path: '404');

  static const String name = 'RouteNotFoundRoute';
}

/// generated route for
/// [_i55.HomePage]
class HomeRoute extends _i56.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i56.EmptyRouterPage]
class StudioStack extends _i56.PageRouteInfo<void> {
  const StudioStack({List<_i56.PageRouteInfo>? children})
      : super(StudioStack.name, path: 'studio', initialChildren: children);

  static const String name = 'StudioStack';
}

/// generated route for
/// [_i57.ProgressPage]
class ProgressRoute extends _i56.PageRouteInfo<void> {
  const ProgressRoute() : super(ProgressRoute.name, path: 'progress');

  static const String name = 'ProgressRoute';
}

/// generated route for
/// [_i58.StudioPage]
class StudioRoute extends _i56.PageRouteInfo<void> {
  const StudioRoute() : super(StudioRoute.name, path: '');

  static const String name = 'StudioRoute';
}

/// generated route for
/// [_i59.CollectionsPage]
class CollectionsRoute extends _i56.PageRouteInfo<void> {
  const CollectionsRoute() : super(CollectionsRoute.name, path: 'collections');

  static const String name = 'CollectionsRoute';
}

/// generated route for
/// [_i60.MovesLibraryPage]
class MovesLibraryRoute extends _i56.PageRouteInfo<void> {
  const MovesLibraryRoute() : super(MovesLibraryRoute.name, path: 'moves');

  static const String name = 'MovesLibraryRoute';
}

/// generated route for
/// [_i61.PlansPage]
class PlansRoute extends _i56.PageRouteInfo<PlansRouteArgs> {
  PlansRoute(
      {_i64.Key? key,
      void Function(_i65.WorkoutPlanSummary)? selectPlan,
      bool showCreateButton = false,
      bool showDiscoverButton = false,
      String pageTitle = 'Plans',
      bool showJoined = true,
      bool showSaved = true})
      : super(PlansRoute.name,
            path: 'plans',
            args: PlansRouteArgs(
                key: key,
                selectPlan: selectPlan,
                showCreateButton: showCreateButton,
                showDiscoverButton: showDiscoverButton,
                pageTitle: pageTitle,
                showJoined: showJoined,
                showSaved: showSaved));

  static const String name = 'PlansRoute';
}

class PlansRouteArgs {
  const PlansRouteArgs(
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
    return 'PlansRouteArgs{key: $key, selectPlan: $selectPlan, showCreateButton: $showCreateButton, showDiscoverButton: $showDiscoverButton, pageTitle: $pageTitle, showJoined: $showJoined, showSaved: $showSaved}';
  }
}

/// generated route for
/// [_i62.WorkoutsPage]
class WorkoutsRoute extends _i56.PageRouteInfo<WorkoutsRouteArgs> {
  WorkoutsRoute({_i64.Key? key, String? previousPageTitle})
      : super(WorkoutsRoute.name,
            path: 'workouts',
            args: WorkoutsRouteArgs(
                key: key, previousPageTitle: previousPageTitle));

  static const String name = 'WorkoutsRoute';
}

class WorkoutsRouteArgs {
  const WorkoutsRouteArgs({this.key, this.previousPageTitle});

  final _i64.Key? key;

  final String? previousPageTitle;

  @override
  String toString() {
    return 'WorkoutsRouteArgs{key: $key, previousPageTitle: $previousPageTitle}';
  }
}
