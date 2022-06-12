// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i45;
import 'package:flutter/cupertino.dart' as _i53;
import 'package:flutter/material.dart' as _i52;
import 'package:sofie_ui/components/creators/body_tracking/body_tracking_entry_creator.dart'
    as _i27;
import 'package:sofie_ui/components/creators/club_creator/club_creator.dart'
    as _i28;
import 'package:sofie_ui/components/creators/collection_creator.dart' as _i29;
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator.dart'
    as _i30;
import 'package:sofie_ui/components/creators/post_creator/club_feed_post_creator_page.dart'
    as _i37;
import 'package:sofie_ui/components/creators/post_creator/feed_post_creator_page.dart'
    as _i36;
import 'package:sofie_ui/components/creators/scheduled_workout_creator.dart'
    as _i38;
import 'package:sofie_ui/components/creators/user_day_logs/user_eat_well_log_creator_page.dart'
    as _i34;
import 'package:sofie_ui/components/creators/user_day_logs/user_meditation_log_creator_page.dart'
    as _i33;
import 'package:sofie_ui/components/creators/user_day_logs/user_sleep_well_log_creator_page.dart'
    as _i35;
import 'package:sofie_ui/components/creators/user_goal_creator_page.dart'
    as _i32;
import 'package:sofie_ui/components/creators/workout_creator/workout_creator.dart'
    as _i39;
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator.dart'
    as _i41;
import 'package:sofie_ui/components/creators/workout_plan_review_creator.dart'
    as _i42;
import 'package:sofie_ui/components/do_workout/do_workout_wrapper_page.dart'
    as _i10;
import 'package:sofie_ui/components/social/chat/chats_overview_page.dart'
    as _i5;
import 'package:sofie_ui/components/social/chat/clubs/club_members_chat_page.dart'
    as _i7;
import 'package:sofie_ui/components/social/chat/friends/one_to_one_chat_page.dart'
    as _i6;
import 'package:sofie_ui/components/timers/timers_page.dart' as _i19;
import 'package:sofie_ui/generated/api/graphql_api.dart' as _i54;
import 'package:sofie_ui/main.dart' as _i2;
import 'package:sofie_ui/modules/calendar/calendar_page.dart' as _i17;
import 'package:sofie_ui/modules/gym_profile/gym_profile_creator.dart' as _i31;
import 'package:sofie_ui/modules/gym_profile/gym_profiles_page.dart' as _i51;
import 'package:sofie_ui/modules/home/home_page.dart' as _i44;
import 'package:sofie_ui/modules/home/notifications_page.dart' as _i15;
import 'package:sofie_ui/modules/main_tabs/main_tabs_page.dart' as _i4;
import 'package:sofie_ui/modules/profile/edit_profile_page.dart' as _i16;
import 'package:sofie_ui/modules/profile/profile_page.dart' as _i11;
import 'package:sofie_ui/modules/profile/settings_page.dart' as _i12;
import 'package:sofie_ui/modules/profile/skills/skills_page.dart' as _i13;
import 'package:sofie_ui/modules/profile/social/social_links_page.dart' as _i14;
import 'package:sofie_ui/modules/sign_in_registration/unauthed_landing_page.dart'
    as _i1;
import 'package:sofie_ui/modules/studio/exercise_library_page.dart' as _i50;
import 'package:sofie_ui/modules/studio/studio_page.dart' as _i47;
import 'package:sofie_ui/modules/training_plan/training_plans.dart' as _i49;
import 'package:sofie_ui/modules/workout_session/resistance_session/resistance_session_creator_page.dart'
    as _i40;
import 'package:sofie_ui/modules/workout_session/resistance_session/resistance_sessions_page.dart'
    as _i48;
import 'package:sofie_ui/pages/authed/authed_routes_wrapper_page.dart' as _i3;
import 'package:sofie_ui/pages/authed/circles/circles_page.dart' as _i18;
import 'package:sofie_ui/pages/authed/circles/discover_clubs_page.dart' as _i24;
import 'package:sofie_ui/pages/authed/circles/discover_people_page.dart'
    as _i23;
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_page.dart'
    as _i25;
import 'package:sofie_ui/pages/authed/details_pages/collection_details_page.dart'
    as _i9;
import 'package:sofie_ui/pages/authed/details_pages/user_public_profile_details_page.dart'
    as _i26;
import 'package:sofie_ui/pages/authed/landing_pages/club_invite_landing_page.dart'
    as _i8;
import 'package:sofie_ui/pages/authed/page_not_found.dart' as _i43;
import 'package:sofie_ui/pages/authed/progress/body_tracking_page.dart' as _i22;
import 'package:sofie_ui/pages/authed/progress/personal_scorebook_page.dart'
    as _i20;
import 'package:sofie_ui/pages/authed/progress/progress_page.dart' as _i46;
import 'package:sofie_ui/pages/authed/progress/user_goals_page.dart' as _i21;

class AppRouter extends _i45.RootStackRouter {
  AppRouter([_i52.GlobalKey<_i52.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i45.PageFactory> pagesMap = {
    UnauthedLandingRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i1.UnauthedLandingPage(),
          fullscreenDialog: true);
    },
    GlobalLoadingRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i2.GlobalLoadingPage(),
          fullscreenDialog: true);
    },
    AuthedRouter.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: const _i3.AuthedRoutesWrapperPage(),
          fullscreenDialog: true);
    },
    MainTabsRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.MainTabsPage());
    },
    ChatsOverviewRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.ChatsOverviewPage());
    },
    OneToOneChatRoute.name: (routeData) {
      final args = routeData.argsAs<OneToOneChatRouteArgs>();
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i6.OneToOneChatPage(
              key: args.key, otherUserId: args.otherUserId));
    },
    ClubMembersChatRoute.name: (routeData) {
      final args = routeData.argsAs<ClubMembersChatRouteArgs>();
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i7.ClubMembersChatPage(key: args.key, clubId: args.clubId));
    },
    ClubInviteLandingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubInviteLandingRouteArgs>(
          orElse: () =>
              ClubInviteLandingRouteArgs(id: pathParams.getString('id')));
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i8.ClubInviteLandingPage(key: args.key, id: args.id));
    },
    CollectionDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CollectionDetailsRouteArgs>(
          orElse: () =>
              CollectionDetailsRouteArgs(id: pathParams.getString('id')));
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i9.CollectionDetailsPage(key: args.key, id: args.id));
    },
    DoWorkoutWrapperRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DoWorkoutWrapperRouteArgs>(
          orElse: () =>
              DoWorkoutWrapperRouteArgs(id: pathParams.getString('id')));
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i10.DoWorkoutWrapperPage(
              key: args.key,
              id: args.id,
              scheduledWorkout: args.scheduledWorkout,
              workoutPlanDayWorkoutId: args.workoutPlanDayWorkoutId,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    ProfileRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.ProfilePage());
    },
    SettingsRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i12.SettingsPage());
    },
    SkillsRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.SkillsPage());
    },
    SocialLinksRoute.name: (routeData) {
      final args = routeData.argsAs<SocialLinksRouteArgs>();
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i14.SocialLinksPage(key: args.key, profile: args.profile));
    },
    NotificationsRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.NotificationsPage());
    },
    EditProfileRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.EditProfilePage());
    },
    CalendarRoute.name: (routeData) {
      final args = routeData.argsAs<CalendarRouteArgs>(
          orElse: () => const CalendarRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i17.CalendarPage(
              key: args.key,
              openAtDate: args.openAtDate,
              previousPageTitle: args.previousPageTitle));
    },
    CirclesRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i18.CirclesPage());
    },
    TimersRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i19.TimersPage());
    },
    PersonalScoresRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i20.PersonalScoresPage());
    },
    UserGoalsRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i21.UserGoalsPage());
    },
    BodyTrackingRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i22.BodyTrackingPage());
    },
    DiscoverPeopleRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i23.DiscoverPeoplePage());
    },
    DiscoverClubsRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i24.DiscoverClubsPage());
    },
    ClubDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ClubDetailsRouteArgs>(
          orElse: () => ClubDetailsRouteArgs(id: pathParams.getString('id')));
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i25.ClubDetailsPage(key: args.key, id: args.id));
    },
    UserPublicProfileDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserPublicProfileDetailsRouteArgs>(
          orElse: () => UserPublicProfileDetailsRouteArgs(
              userId: pathParams.getString('userId')));
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i26.UserPublicProfileDetailsPage(
              key: args.key, userId: args.userId));
    },
    BodyTrackingEntryCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<BodyTrackingEntryCreatorRouteArgs>(
          orElse: () => const BodyTrackingEntryCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i27.BodyTrackingEntryCreatorPage(
              key: args.key, bodyTrackingEntry: args.bodyTrackingEntry));
    },
    ClubCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubCreatorRouteArgs>(
          orElse: () => const ClubCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i28.ClubCreatorPage(
              key: args.key, clubSummary: args.clubSummary));
    },
    CollectionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionCreatorRouteArgs>(
          orElse: () => const CollectionCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i29.CollectionCreatorPage(
              key: args.key,
              collection: args.collection,
              onComplete: args.onComplete));
    },
    CustomMoveCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<CustomMoveCreatorRouteArgs>(
          orElse: () => const CustomMoveCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i30.CustomMoveCreatorPage(key: args.key, move: args.move));
    },
    GymProfileCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfileCreatorRouteArgs>(
          orElse: () => const GymProfileCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i31.GymProfileCreatorPage(
              key: args.key, gymProfile: args.gymProfile));
    },
    UserGoalCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserGoalCreatorRouteArgs>(
          orElse: () => const UserGoalCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i32.UserGoalCreatorPage(
              key: args.key, journalGoal: args.journalGoal));
    },
    UserMeditationLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserMeditationLogCreatorRouteArgs>(
          orElse: () => const UserMeditationLogCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i33.UserMeditationLogCreatorPage(
              key: args.key,
              userMeditationLog: args.userMeditationLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    UserEatWellLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserEatWellLogCreatorRouteArgs>(
          orElse: () => const UserEatWellLogCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i34.UserEatWellLogCreatorPage(
              key: args.key,
              userEatWellLog: args.userEatWellLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    UserSleepWellLogCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<UserSleepWellLogCreatorRouteArgs>(
          orElse: () => const UserSleepWellLogCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i35.UserSleepWellLogCreatorPage(
              key: args.key,
              userSleepWellLog: args.userSleepWellLog,
              year: args.year,
              dayNumber: args.dayNumber));
    },
    FeedPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<FeedPostCreatorRouteArgs>(
          orElse: () => const FeedPostCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i36.FeedPostCreatorPage(
              key: args.key,
              activityInput: args.activityInput,
              onComplete: args.onComplete,
              title: args.title));
    },
    ClubFeedPostCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ClubFeedPostCreatorRouteArgs>();
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i37.ClubFeedPostCreatorPage(
              key: args.key, clubId: args.clubId, onSuccess: args.onSuccess));
    },
    ScheduledWorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduledWorkoutCreatorRouteArgs>(
          orElse: () => const ScheduledWorkoutCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i38.ScheduledWorkoutCreatorPage(
              key: args.key,
              scheduledWorkout: args.scheduledWorkout,
              workout: args.workout,
              scheduleOn: args.scheduleOn,
              workoutPlanEnrolmentId: args.workoutPlanEnrolmentId));
    },
    WorkoutCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutCreatorRouteArgs>(
          orElse: () => const WorkoutCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i39.WorkoutCreatorPage(key: args.key, workout: args.workout));
    },
    ResistanceSessionCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<ResistanceSessionCreatorRouteArgs>(
          orElse: () => const ResistanceSessionCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i40.ResistanceSessionCreatorPage(
              key: args.key, resistanceSession: args.resistanceSession));
    },
    WorkoutPlanCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanCreatorRouteArgs>(
          orElse: () => const WorkoutPlanCreatorRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i41.WorkoutPlanCreatorPage(
              key: args.key, workoutPlan: args.workoutPlan));
    },
    WorkoutPlanReviewCreatorRoute.name: (routeData) {
      final args = routeData.argsAs<WorkoutPlanReviewCreatorRouteArgs>();
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i42.WorkoutPlanReviewCreatorPage(
              key: args.key,
              workoutPlanReview: args.workoutPlanReview,
              parentWorkoutPlanId: args.parentWorkoutPlanId,
              parentWorkoutPlanEnrolmentId: args.parentWorkoutPlanEnrolmentId));
    },
    RouteNotFoundRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i43.PageNotFoundPage());
    },
    HomeRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i44.HomePage());
    },
    StudioStack.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i45.EmptyRouterPage());
    },
    ProgressRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i46.ProgressPage());
    },
    StudioRoute.name: (routeData) {
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i47.StudioPage());
    },
    ResistanceSessionsRoute.name: (routeData) {
      final args = routeData.argsAs<ResistanceSessionsRouteArgs>(
          orElse: () => const ResistanceSessionsRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i48.ResistanceSessionsPage(
              key: args.key, previousPageTitle: args.previousPageTitle));
    },
    TrainingPlansRoute.name: (routeData) {
      final args = routeData.argsAs<TrainingPlansRouteArgs>(
          orElse: () => const TrainingPlansRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i49.TrainingPlansPage(
              key: args.key,
              selectPlan: args.selectPlan,
              showCreateButton: args.showCreateButton,
              showDiscoverButton: args.showDiscoverButton,
              pageTitle: args.pageTitle,
              showJoined: args.showJoined,
              showSaved: args.showSaved));
    },
    ExerciseLibraryRoute.name: (routeData) {
      final args = routeData.argsAs<ExerciseLibraryRouteArgs>(
          orElse: () => const ExerciseLibraryRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i50.ExerciseLibraryPage(
              key: args.key, previousPageTitle: args.previousPageTitle));
    },
    GymProfilesRoute.name: (routeData) {
      final args = routeData.argsAs<GymProfilesRouteArgs>(
          orElse: () => const GymProfilesRouteArgs());
      return _i45.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i51.GymProfilesPage(
              key: args.key, previousPageTitle: args.previousPageTitle));
    }
  };

  @override
  List<_i45.RouteConfig> get routes => [
        _i45.RouteConfig(UnauthedLandingRoute.name, path: '/auth'),
        _i45.RouteConfig(GlobalLoadingRoute.name, path: '/loading'),
        _i45.RouteConfig(AuthedRouter.name, path: '/', children: [
          _i45.RouteConfig(MainTabsRoute.name,
              path: '',
              parent: AuthedRouter.name,
              children: [
                _i45.RouteConfig(HomeRoute.name,
                    path: '', parent: MainTabsRoute.name),
                _i45.RouteConfig(CirclesRoute.name,
                    path: 'circles', parent: MainTabsRoute.name),
                _i45.RouteConfig(StudioStack.name,
                    path: 'studio',
                    parent: MainTabsRoute.name,
                    children: [
                      _i45.RouteConfig(StudioRoute.name,
                          path: '', parent: StudioStack.name),
                      _i45.RouteConfig(ResistanceSessionsRoute.name,
                          path: 'resistance-sessions',
                          parent: StudioStack.name),
                      _i45.RouteConfig(TrainingPlansRoute.name,
                          path: 'training-plans', parent: StudioStack.name),
                      _i45.RouteConfig(ExerciseLibraryRoute.name,
                          path: 'exercise-library', parent: StudioStack.name),
                      _i45.RouteConfig(GymProfilesRoute.name,
                          path: 'gym-profiles', parent: StudioStack.name),
                      _i45.RouteConfig('*#redirect',
                          path: '*',
                          parent: StudioStack.name,
                          redirectTo: '',
                          fullMatch: true)
                    ]),
                _i45.RouteConfig(ProgressRoute.name,
                    path: 'progress', parent: MainTabsRoute.name)
              ]),
          _i45.RouteConfig(ChatsOverviewRoute.name,
              path: 'chats', parent: AuthedRouter.name),
          _i45.RouteConfig(OneToOneChatRoute.name,
              path: 'chat', parent: AuthedRouter.name),
          _i45.RouteConfig(ClubMembersChatRoute.name,
              path: 'club-chat', parent: AuthedRouter.name),
          _i45.RouteConfig(ClubInviteLandingRoute.name,
              path: 'club-invite/:id', parent: AuthedRouter.name),
          _i45.RouteConfig(CollectionDetailsRoute.name,
              path: 'collection/:id', parent: AuthedRouter.name),
          _i45.RouteConfig(DoWorkoutWrapperRoute.name,
              path: 'do-workout/:id', parent: AuthedRouter.name),
          _i45.RouteConfig(ProfileRoute.name,
              path: 'profile', parent: AuthedRouter.name),
          _i45.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: AuthedRouter.name),
          _i45.RouteConfig(SkillsRoute.name,
              path: 'skills', parent: AuthedRouter.name),
          _i45.RouteConfig(SocialLinksRoute.name,
              path: 'social-links', parent: AuthedRouter.name),
          _i45.RouteConfig(NotificationsRoute.name,
              path: 'notifications', parent: AuthedRouter.name),
          _i45.RouteConfig(EditProfileRoute.name,
              path: 'edit-profile', parent: AuthedRouter.name),
          _i45.RouteConfig(CalendarRoute.name,
              path: 'calendar', parent: AuthedRouter.name),
          _i45.RouteConfig(CirclesRoute.name,
              path: 'circles', parent: AuthedRouter.name),
          _i45.RouteConfig(TimersRoute.name,
              path: 'timers', parent: AuthedRouter.name),
          _i45.RouteConfig(PersonalScoresRoute.name,
              path: 'personal-scores', parent: AuthedRouter.name),
          _i45.RouteConfig(UserGoalsRoute.name,
              path: 'goals', parent: AuthedRouter.name),
          _i45.RouteConfig(BodyTrackingRoute.name,
              path: 'body-tracking', parent: AuthedRouter.name),
          _i45.RouteConfig(DiscoverPeopleRoute.name,
              path: 'discover-people', parent: AuthedRouter.name),
          _i45.RouteConfig(DiscoverClubsRoute.name,
              path: 'discover-clubs', parent: AuthedRouter.name),
          _i45.RouteConfig(ClubDetailsRoute.name,
              path: 'club/:id', parent: AuthedRouter.name),
          _i45.RouteConfig(UserPublicProfileDetailsRoute.name,
              path: 'profile/:userId', parent: AuthedRouter.name),
          _i45.RouteConfig(BodyTrackingEntryCreatorRoute.name,
              path: 'create/body-tracking', parent: AuthedRouter.name),
          _i45.RouteConfig(ClubCreatorRoute.name,
              path: 'create/club', parent: AuthedRouter.name),
          _i45.RouteConfig(CollectionCreatorRoute.name,
              path: 'create/collection', parent: AuthedRouter.name),
          _i45.RouteConfig(CustomMoveCreatorRoute.name,
              path: 'create/custom-move', parent: AuthedRouter.name),
          _i45.RouteConfig(GymProfileCreatorRoute.name,
              path: 'create/gym-profile', parent: AuthedRouter.name),
          _i45.RouteConfig(UserGoalCreatorRoute.name,
              path: 'create/goal', parent: AuthedRouter.name),
          _i45.RouteConfig(UserMeditationLogCreatorRoute.name,
              path: 'create/mindfulness-log', parent: AuthedRouter.name),
          _i45.RouteConfig(UserEatWellLogCreatorRoute.name,
              path: 'create/food-log', parent: AuthedRouter.name),
          _i45.RouteConfig(UserSleepWellLogCreatorRoute.name,
              path: 'create/sleep-log', parent: AuthedRouter.name),
          _i45.RouteConfig(FeedPostCreatorRoute.name,
              path: 'create/post', parent: AuthedRouter.name),
          _i45.RouteConfig(ClubFeedPostCreatorRoute.name,
              path: 'create/club-post', parent: AuthedRouter.name),
          _i45.RouteConfig(ScheduledWorkoutCreatorRoute.name,
              path: 'create/scheduled-workout', parent: AuthedRouter.name),
          _i45.RouteConfig(WorkoutCreatorRoute.name,
              path: 'create/workout', parent: AuthedRouter.name),
          _i45.RouteConfig(ResistanceSessionCreatorRoute.name,
              path: 'create/resistance-session', parent: AuthedRouter.name),
          _i45.RouteConfig(WorkoutPlanCreatorRoute.name,
              path: 'create/workout-plan', parent: AuthedRouter.name),
          _i45.RouteConfig(WorkoutPlanReviewCreatorRoute.name,
              path: 'create/workout-plan-review', parent: AuthedRouter.name),
          _i45.RouteConfig(RouteNotFoundRoute.name,
              path: '404', parent: AuthedRouter.name),
          _i45.RouteConfig('*#redirect',
              path: '*',
              parent: AuthedRouter.name,
              redirectTo: '404',
              fullMatch: true)
        ])
      ];
}

/// generated route for
/// [_i1.UnauthedLandingPage]
class UnauthedLandingRoute extends _i45.PageRouteInfo<void> {
  const UnauthedLandingRoute()
      : super(UnauthedLandingRoute.name, path: '/auth');

  static const String name = 'UnauthedLandingRoute';
}

/// generated route for
/// [_i2.GlobalLoadingPage]
class GlobalLoadingRoute extends _i45.PageRouteInfo<void> {
  const GlobalLoadingRoute() : super(GlobalLoadingRoute.name, path: '/loading');

  static const String name = 'GlobalLoadingRoute';
}

/// generated route for
/// [_i3.AuthedRoutesWrapperPage]
class AuthedRouter extends _i45.PageRouteInfo<void> {
  const AuthedRouter({List<_i45.PageRouteInfo>? children})
      : super(AuthedRouter.name, path: '/', initialChildren: children);

  static const String name = 'AuthedRouter';
}

/// generated route for
/// [_i4.MainTabsPage]
class MainTabsRoute extends _i45.PageRouteInfo<void> {
  const MainTabsRoute({List<_i45.PageRouteInfo>? children})
      : super(MainTabsRoute.name, path: '', initialChildren: children);

  static const String name = 'MainTabsRoute';
}

/// generated route for
/// [_i5.ChatsOverviewPage]
class ChatsOverviewRoute extends _i45.PageRouteInfo<void> {
  const ChatsOverviewRoute() : super(ChatsOverviewRoute.name, path: 'chats');

  static const String name = 'ChatsOverviewRoute';
}

/// generated route for
/// [_i6.OneToOneChatPage]
class OneToOneChatRoute extends _i45.PageRouteInfo<OneToOneChatRouteArgs> {
  OneToOneChatRoute({_i53.Key? key, required String otherUserId})
      : super(OneToOneChatRoute.name,
            path: 'chat',
            args: OneToOneChatRouteArgs(key: key, otherUserId: otherUserId));

  static const String name = 'OneToOneChatRoute';
}

class OneToOneChatRouteArgs {
  const OneToOneChatRouteArgs({this.key, required this.otherUserId});

  final _i53.Key? key;

  final String otherUserId;

  @override
  String toString() {
    return 'OneToOneChatRouteArgs{key: $key, otherUserId: $otherUserId}';
  }
}

/// generated route for
/// [_i7.ClubMembersChatPage]
class ClubMembersChatRoute
    extends _i45.PageRouteInfo<ClubMembersChatRouteArgs> {
  ClubMembersChatRoute({_i53.Key? key, required String clubId})
      : super(ClubMembersChatRoute.name,
            path: 'club-chat',
            args: ClubMembersChatRouteArgs(key: key, clubId: clubId));

  static const String name = 'ClubMembersChatRoute';
}

class ClubMembersChatRouteArgs {
  const ClubMembersChatRouteArgs({this.key, required this.clubId});

  final _i53.Key? key;

  final String clubId;

  @override
  String toString() {
    return 'ClubMembersChatRouteArgs{key: $key, clubId: $clubId}';
  }
}

/// generated route for
/// [_i8.ClubInviteLandingPage]
class ClubInviteLandingRoute
    extends _i45.PageRouteInfo<ClubInviteLandingRouteArgs> {
  ClubInviteLandingRoute({_i53.Key? key, required String id})
      : super(ClubInviteLandingRoute.name,
            path: 'club-invite/:id',
            args: ClubInviteLandingRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubInviteLandingRoute';
}

class ClubInviteLandingRouteArgs {
  const ClubInviteLandingRouteArgs({this.key, required this.id});

  final _i53.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubInviteLandingRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i9.CollectionDetailsPage]
class CollectionDetailsRoute
    extends _i45.PageRouteInfo<CollectionDetailsRouteArgs> {
  CollectionDetailsRoute({_i53.Key? key, required String id})
      : super(CollectionDetailsRoute.name,
            path: 'collection/:id',
            args: CollectionDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'CollectionDetailsRoute';
}

class CollectionDetailsRouteArgs {
  const CollectionDetailsRouteArgs({this.key, required this.id});

  final _i53.Key? key;

  final String id;

  @override
  String toString() {
    return 'CollectionDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i10.DoWorkoutWrapperPage]
class DoWorkoutWrapperRoute
    extends _i45.PageRouteInfo<DoWorkoutWrapperRouteArgs> {
  DoWorkoutWrapperRoute(
      {_i53.Key? key,
      required String id,
      _i54.ScheduledWorkout? scheduledWorkout,
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

  final _i53.Key? key;

  final String id;

  final _i54.ScheduledWorkout? scheduledWorkout;

  final String? workoutPlanDayWorkoutId;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'DoWorkoutWrapperRouteArgs{key: $key, id: $id, scheduledWorkout: $scheduledWorkout, workoutPlanDayWorkoutId: $workoutPlanDayWorkoutId, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i11.ProfilePage]
class ProfileRoute extends _i45.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i12.SettingsPage]
class SettingsRoute extends _i45.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i13.SkillsPage]
class SkillsRoute extends _i45.PageRouteInfo<void> {
  const SkillsRoute() : super(SkillsRoute.name, path: 'skills');

  static const String name = 'SkillsRoute';
}

/// generated route for
/// [_i14.SocialLinksPage]
class SocialLinksRoute extends _i45.PageRouteInfo<SocialLinksRouteArgs> {
  SocialLinksRoute({_i53.Key? key, required _i54.UserProfile profile})
      : super(SocialLinksRoute.name,
            path: 'social-links',
            args: SocialLinksRouteArgs(key: key, profile: profile));

  static const String name = 'SocialLinksRoute';
}

class SocialLinksRouteArgs {
  const SocialLinksRouteArgs({this.key, required this.profile});

  final _i53.Key? key;

  final _i54.UserProfile profile;

  @override
  String toString() {
    return 'SocialLinksRouteArgs{key: $key, profile: $profile}';
  }
}

/// generated route for
/// [_i15.NotificationsPage]
class NotificationsRoute extends _i45.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(NotificationsRoute.name, path: 'notifications');

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i16.EditProfilePage]
class EditProfileRoute extends _i45.PageRouteInfo<void> {
  const EditProfileRoute() : super(EditProfileRoute.name, path: 'edit-profile');

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i17.CalendarPage]
class CalendarRoute extends _i45.PageRouteInfo<CalendarRouteArgs> {
  CalendarRoute(
      {_i53.Key? key, DateTime? openAtDate, String? previousPageTitle})
      : super(CalendarRoute.name,
            path: 'calendar',
            args: CalendarRouteArgs(
                key: key,
                openAtDate: openAtDate,
                previousPageTitle: previousPageTitle));

  static const String name = 'CalendarRoute';
}

class CalendarRouteArgs {
  const CalendarRouteArgs({this.key, this.openAtDate, this.previousPageTitle});

  final _i53.Key? key;

  final DateTime? openAtDate;

  final String? previousPageTitle;

  @override
  String toString() {
    return 'CalendarRouteArgs{key: $key, openAtDate: $openAtDate, previousPageTitle: $previousPageTitle}';
  }
}

/// generated route for
/// [_i18.CirclesPage]
class CirclesRoute extends _i45.PageRouteInfo<void> {
  const CirclesRoute() : super(CirclesRoute.name, path: 'circles');

  static const String name = 'CirclesRoute';
}

/// generated route for
/// [_i19.TimersPage]
class TimersRoute extends _i45.PageRouteInfo<void> {
  const TimersRoute() : super(TimersRoute.name, path: 'timers');

  static const String name = 'TimersRoute';
}

/// generated route for
/// [_i20.PersonalScoresPage]
class PersonalScoresRoute extends _i45.PageRouteInfo<void> {
  const PersonalScoresRoute()
      : super(PersonalScoresRoute.name, path: 'personal-scores');

  static const String name = 'PersonalScoresRoute';
}

/// generated route for
/// [_i21.UserGoalsPage]
class UserGoalsRoute extends _i45.PageRouteInfo<void> {
  const UserGoalsRoute() : super(UserGoalsRoute.name, path: 'goals');

  static const String name = 'UserGoalsRoute';
}

/// generated route for
/// [_i22.BodyTrackingPage]
class BodyTrackingRoute extends _i45.PageRouteInfo<void> {
  const BodyTrackingRoute()
      : super(BodyTrackingRoute.name, path: 'body-tracking');

  static const String name = 'BodyTrackingRoute';
}

/// generated route for
/// [_i23.DiscoverPeoplePage]
class DiscoverPeopleRoute extends _i45.PageRouteInfo<void> {
  const DiscoverPeopleRoute()
      : super(DiscoverPeopleRoute.name, path: 'discover-people');

  static const String name = 'DiscoverPeopleRoute';
}

/// generated route for
/// [_i24.DiscoverClubsPage]
class DiscoverClubsRoute extends _i45.PageRouteInfo<void> {
  const DiscoverClubsRoute()
      : super(DiscoverClubsRoute.name, path: 'discover-clubs');

  static const String name = 'DiscoverClubsRoute';
}

/// generated route for
/// [_i25.ClubDetailsPage]
class ClubDetailsRoute extends _i45.PageRouteInfo<ClubDetailsRouteArgs> {
  ClubDetailsRoute({_i53.Key? key, required String id})
      : super(ClubDetailsRoute.name,
            path: 'club/:id',
            args: ClubDetailsRouteArgs(key: key, id: id),
            rawPathParams: {'id': id});

  static const String name = 'ClubDetailsRoute';
}

class ClubDetailsRouteArgs {
  const ClubDetailsRouteArgs({this.key, required this.id});

  final _i53.Key? key;

  final String id;

  @override
  String toString() {
    return 'ClubDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i26.UserPublicProfileDetailsPage]
class UserPublicProfileDetailsRoute
    extends _i45.PageRouteInfo<UserPublicProfileDetailsRouteArgs> {
  UserPublicProfileDetailsRoute({_i53.Key? key, required String userId})
      : super(UserPublicProfileDetailsRoute.name,
            path: 'profile/:userId',
            args: UserPublicProfileDetailsRouteArgs(key: key, userId: userId),
            rawPathParams: {'userId': userId});

  static const String name = 'UserPublicProfileDetailsRoute';
}

class UserPublicProfileDetailsRouteArgs {
  const UserPublicProfileDetailsRouteArgs({this.key, required this.userId});

  final _i53.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserPublicProfileDetailsRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i27.BodyTrackingEntryCreatorPage]
class BodyTrackingEntryCreatorRoute
    extends _i45.PageRouteInfo<BodyTrackingEntryCreatorRouteArgs> {
  BodyTrackingEntryCreatorRoute(
      {_i53.Key? key, _i54.BodyTrackingEntry? bodyTrackingEntry})
      : super(BodyTrackingEntryCreatorRoute.name,
            path: 'create/body-tracking',
            args: BodyTrackingEntryCreatorRouteArgs(
                key: key, bodyTrackingEntry: bodyTrackingEntry));

  static const String name = 'BodyTrackingEntryCreatorRoute';
}

class BodyTrackingEntryCreatorRouteArgs {
  const BodyTrackingEntryCreatorRouteArgs({this.key, this.bodyTrackingEntry});

  final _i53.Key? key;

  final _i54.BodyTrackingEntry? bodyTrackingEntry;

  @override
  String toString() {
    return 'BodyTrackingEntryCreatorRouteArgs{key: $key, bodyTrackingEntry: $bodyTrackingEntry}';
  }
}

/// generated route for
/// [_i28.ClubCreatorPage]
class ClubCreatorRoute extends _i45.PageRouteInfo<ClubCreatorRouteArgs> {
  ClubCreatorRoute({_i53.Key? key, _i54.ClubSummary? clubSummary})
      : super(ClubCreatorRoute.name,
            path: 'create/club',
            args: ClubCreatorRouteArgs(key: key, clubSummary: clubSummary));

  static const String name = 'ClubCreatorRoute';
}

class ClubCreatorRouteArgs {
  const ClubCreatorRouteArgs({this.key, this.clubSummary});

  final _i53.Key? key;

  final _i54.ClubSummary? clubSummary;

  @override
  String toString() {
    return 'ClubCreatorRouteArgs{key: $key, clubSummary: $clubSummary}';
  }
}

/// generated route for
/// [_i29.CollectionCreatorPage]
class CollectionCreatorRoute
    extends _i45.PageRouteInfo<CollectionCreatorRouteArgs> {
  CollectionCreatorRoute(
      {_i53.Key? key,
      _i54.Collection? collection,
      void Function(_i54.Collection)? onComplete})
      : super(CollectionCreatorRoute.name,
            path: 'create/collection',
            args: CollectionCreatorRouteArgs(
                key: key, collection: collection, onComplete: onComplete));

  static const String name = 'CollectionCreatorRoute';
}

class CollectionCreatorRouteArgs {
  const CollectionCreatorRouteArgs(
      {this.key, this.collection, this.onComplete});

  final _i53.Key? key;

  final _i54.Collection? collection;

  final void Function(_i54.Collection)? onComplete;

  @override
  String toString() {
    return 'CollectionCreatorRouteArgs{key: $key, collection: $collection, onComplete: $onComplete}';
  }
}

/// generated route for
/// [_i30.CustomMoveCreatorPage]
class CustomMoveCreatorRoute
    extends _i45.PageRouteInfo<CustomMoveCreatorRouteArgs> {
  CustomMoveCreatorRoute({_i53.Key? key, _i54.MoveData? move})
      : super(CustomMoveCreatorRoute.name,
            path: 'create/custom-move',
            args: CustomMoveCreatorRouteArgs(key: key, move: move));

  static const String name = 'CustomMoveCreatorRoute';
}

class CustomMoveCreatorRouteArgs {
  const CustomMoveCreatorRouteArgs({this.key, this.move});

  final _i53.Key? key;

  final _i54.MoveData? move;

  @override
  String toString() {
    return 'CustomMoveCreatorRouteArgs{key: $key, move: $move}';
  }
}

/// generated route for
/// [_i31.GymProfileCreatorPage]
class GymProfileCreatorRoute
    extends _i45.PageRouteInfo<GymProfileCreatorRouteArgs> {
  GymProfileCreatorRoute({_i53.Key? key, _i54.GymProfile? gymProfile})
      : super(GymProfileCreatorRoute.name,
            path: 'create/gym-profile',
            args: GymProfileCreatorRouteArgs(key: key, gymProfile: gymProfile));

  static const String name = 'GymProfileCreatorRoute';
}

class GymProfileCreatorRouteArgs {
  const GymProfileCreatorRouteArgs({this.key, this.gymProfile});

  final _i53.Key? key;

  final _i54.GymProfile? gymProfile;

  @override
  String toString() {
    return 'GymProfileCreatorRouteArgs{key: $key, gymProfile: $gymProfile}';
  }
}

/// generated route for
/// [_i32.UserGoalCreatorPage]
class UserGoalCreatorRoute
    extends _i45.PageRouteInfo<UserGoalCreatorRouteArgs> {
  UserGoalCreatorRoute({_i53.Key? key, _i54.UserGoal? journalGoal})
      : super(UserGoalCreatorRoute.name,
            path: 'create/goal',
            args: UserGoalCreatorRouteArgs(key: key, journalGoal: journalGoal));

  static const String name = 'UserGoalCreatorRoute';
}

class UserGoalCreatorRouteArgs {
  const UserGoalCreatorRouteArgs({this.key, this.journalGoal});

  final _i53.Key? key;

  final _i54.UserGoal? journalGoal;

  @override
  String toString() {
    return 'UserGoalCreatorRouteArgs{key: $key, journalGoal: $journalGoal}';
  }
}

/// generated route for
/// [_i33.UserMeditationLogCreatorPage]
class UserMeditationLogCreatorRoute
    extends _i45.PageRouteInfo<UserMeditationLogCreatorRouteArgs> {
  UserMeditationLogCreatorRoute(
      {_i53.Key? key,
      _i54.UserMeditationLog? userMeditationLog,
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

  final _i53.Key? key;

  final _i54.UserMeditationLog? userMeditationLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserMeditationLogCreatorRouteArgs{key: $key, userMeditationLog: $userMeditationLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i34.UserEatWellLogCreatorPage]
class UserEatWellLogCreatorRoute
    extends _i45.PageRouteInfo<UserEatWellLogCreatorRouteArgs> {
  UserEatWellLogCreatorRoute(
      {_i53.Key? key,
      _i54.UserEatWellLog? userEatWellLog,
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

  final _i53.Key? key;

  final _i54.UserEatWellLog? userEatWellLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserEatWellLogCreatorRouteArgs{key: $key, userEatWellLog: $userEatWellLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i35.UserSleepWellLogCreatorPage]
class UserSleepWellLogCreatorRoute
    extends _i45.PageRouteInfo<UserSleepWellLogCreatorRouteArgs> {
  UserSleepWellLogCreatorRoute(
      {_i53.Key? key,
      _i54.UserSleepWellLog? userSleepWellLog,
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

  final _i53.Key? key;

  final _i54.UserSleepWellLog? userSleepWellLog;

  final int? year;

  final int? dayNumber;

  @override
  String toString() {
    return 'UserSleepWellLogCreatorRouteArgs{key: $key, userSleepWellLog: $userSleepWellLog, year: $year, dayNumber: $dayNumber}';
  }
}

/// generated route for
/// [_i36.FeedPostCreatorPage]
class FeedPostCreatorRoute
    extends _i45.PageRouteInfo<FeedPostCreatorRouteArgs> {
  FeedPostCreatorRoute(
      {_i53.Key? key,
      _i54.CreateStreamFeedActivityInput? activityInput,
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

  final _i53.Key? key;

  final _i54.CreateStreamFeedActivityInput? activityInput;

  final void Function()? onComplete;

  final String? title;

  @override
  String toString() {
    return 'FeedPostCreatorRouteArgs{key: $key, activityInput: $activityInput, onComplete: $onComplete, title: $title}';
  }
}

/// generated route for
/// [_i37.ClubFeedPostCreatorPage]
class ClubFeedPostCreatorRoute
    extends _i45.PageRouteInfo<ClubFeedPostCreatorRouteArgs> {
  ClubFeedPostCreatorRoute(
      {_i53.Key? key,
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

  final _i53.Key? key;

  final String clubId;

  final void Function() onSuccess;

  @override
  String toString() {
    return 'ClubFeedPostCreatorRouteArgs{key: $key, clubId: $clubId, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [_i38.ScheduledWorkoutCreatorPage]
class ScheduledWorkoutCreatorRoute
    extends _i45.PageRouteInfo<ScheduledWorkoutCreatorRouteArgs> {
  ScheduledWorkoutCreatorRoute(
      {_i53.Key? key,
      _i54.ScheduledWorkout? scheduledWorkout,
      _i54.WorkoutSummary? workout,
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

  final _i53.Key? key;

  final _i54.ScheduledWorkout? scheduledWorkout;

  final _i54.WorkoutSummary? workout;

  final DateTime? scheduleOn;

  final String? workoutPlanEnrolmentId;

  @override
  String toString() {
    return 'ScheduledWorkoutCreatorRouteArgs{key: $key, scheduledWorkout: $scheduledWorkout, workout: $workout, scheduleOn: $scheduleOn, workoutPlanEnrolmentId: $workoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i39.WorkoutCreatorPage]
class WorkoutCreatorRoute extends _i45.PageRouteInfo<WorkoutCreatorRouteArgs> {
  WorkoutCreatorRoute({_i53.Key? key, _i54.Workout? workout})
      : super(WorkoutCreatorRoute.name,
            path: 'create/workout',
            args: WorkoutCreatorRouteArgs(key: key, workout: workout));

  static const String name = 'WorkoutCreatorRoute';
}

class WorkoutCreatorRouteArgs {
  const WorkoutCreatorRouteArgs({this.key, this.workout});

  final _i53.Key? key;

  final _i54.Workout? workout;

  @override
  String toString() {
    return 'WorkoutCreatorRouteArgs{key: $key, workout: $workout}';
  }
}

/// generated route for
/// [_i40.ResistanceSessionCreatorPage]
class ResistanceSessionCreatorRoute
    extends _i45.PageRouteInfo<ResistanceSessionCreatorRouteArgs> {
  ResistanceSessionCreatorRoute(
      {_i53.Key? key, _i54.ResistanceSession? resistanceSession})
      : super(ResistanceSessionCreatorRoute.name,
            path: 'create/resistance-session',
            args: ResistanceSessionCreatorRouteArgs(
                key: key, resistanceSession: resistanceSession));

  static const String name = 'ResistanceSessionCreatorRoute';
}

class ResistanceSessionCreatorRouteArgs {
  const ResistanceSessionCreatorRouteArgs({this.key, this.resistanceSession});

  final _i53.Key? key;

  final _i54.ResistanceSession? resistanceSession;

  @override
  String toString() {
    return 'ResistanceSessionCreatorRouteArgs{key: $key, resistanceSession: $resistanceSession}';
  }
}

/// generated route for
/// [_i41.WorkoutPlanCreatorPage]
class WorkoutPlanCreatorRoute
    extends _i45.PageRouteInfo<WorkoutPlanCreatorRouteArgs> {
  WorkoutPlanCreatorRoute({_i53.Key? key, _i54.WorkoutPlan? workoutPlan})
      : super(WorkoutPlanCreatorRoute.name,
            path: 'create/workout-plan',
            args: WorkoutPlanCreatorRouteArgs(
                key: key, workoutPlan: workoutPlan));

  static const String name = 'WorkoutPlanCreatorRoute';
}

class WorkoutPlanCreatorRouteArgs {
  const WorkoutPlanCreatorRouteArgs({this.key, this.workoutPlan});

  final _i53.Key? key;

  final _i54.WorkoutPlan? workoutPlan;

  @override
  String toString() {
    return 'WorkoutPlanCreatorRouteArgs{key: $key, workoutPlan: $workoutPlan}';
  }
}

/// generated route for
/// [_i42.WorkoutPlanReviewCreatorPage]
class WorkoutPlanReviewCreatorRoute
    extends _i45.PageRouteInfo<WorkoutPlanReviewCreatorRouteArgs> {
  WorkoutPlanReviewCreatorRoute(
      {_i53.Key? key,
      _i54.WorkoutPlanReview? workoutPlanReview,
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

  final _i53.Key? key;

  final _i54.WorkoutPlanReview? workoutPlanReview;

  final String parentWorkoutPlanId;

  final String parentWorkoutPlanEnrolmentId;

  @override
  String toString() {
    return 'WorkoutPlanReviewCreatorRouteArgs{key: $key, workoutPlanReview: $workoutPlanReview, parentWorkoutPlanId: $parentWorkoutPlanId, parentWorkoutPlanEnrolmentId: $parentWorkoutPlanEnrolmentId}';
  }
}

/// generated route for
/// [_i43.PageNotFoundPage]
class RouteNotFoundRoute extends _i45.PageRouteInfo<void> {
  const RouteNotFoundRoute() : super(RouteNotFoundRoute.name, path: '404');

  static const String name = 'RouteNotFoundRoute';
}

/// generated route for
/// [_i44.HomePage]
class HomeRoute extends _i45.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i45.EmptyRouterPage]
class StudioStack extends _i45.PageRouteInfo<void> {
  const StudioStack({List<_i45.PageRouteInfo>? children})
      : super(StudioStack.name, path: 'studio', initialChildren: children);

  static const String name = 'StudioStack';
}

/// generated route for
/// [_i46.ProgressPage]
class ProgressRoute extends _i45.PageRouteInfo<void> {
  const ProgressRoute() : super(ProgressRoute.name, path: 'progress');

  static const String name = 'ProgressRoute';
}

/// generated route for
/// [_i47.StudioPage]
class StudioRoute extends _i45.PageRouteInfo<void> {
  const StudioRoute() : super(StudioRoute.name, path: '');

  static const String name = 'StudioRoute';
}

/// generated route for
/// [_i48.ResistanceSessionsPage]
class ResistanceSessionsRoute
    extends _i45.PageRouteInfo<ResistanceSessionsRouteArgs> {
  ResistanceSessionsRoute({_i53.Key? key, String? previousPageTitle})
      : super(ResistanceSessionsRoute.name,
            path: 'resistance-sessions',
            args: ResistanceSessionsRouteArgs(
                key: key, previousPageTitle: previousPageTitle));

  static const String name = 'ResistanceSessionsRoute';
}

class ResistanceSessionsRouteArgs {
  const ResistanceSessionsRouteArgs({this.key, this.previousPageTitle});

  final _i53.Key? key;

  final String? previousPageTitle;

  @override
  String toString() {
    return 'ResistanceSessionsRouteArgs{key: $key, previousPageTitle: $previousPageTitle}';
  }
}

/// generated route for
/// [_i49.TrainingPlansPage]
class TrainingPlansRoute extends _i45.PageRouteInfo<TrainingPlansRouteArgs> {
  TrainingPlansRoute(
      {_i53.Key? key,
      void Function(_i54.WorkoutPlanSummary)? selectPlan,
      bool showCreateButton = false,
      bool showDiscoverButton = false,
      String pageTitle = 'Plans',
      bool showJoined = true,
      bool showSaved = true})
      : super(TrainingPlansRoute.name,
            path: 'training-plans',
            args: TrainingPlansRouteArgs(
                key: key,
                selectPlan: selectPlan,
                showCreateButton: showCreateButton,
                showDiscoverButton: showDiscoverButton,
                pageTitle: pageTitle,
                showJoined: showJoined,
                showSaved: showSaved));

  static const String name = 'TrainingPlansRoute';
}

class TrainingPlansRouteArgs {
  const TrainingPlansRouteArgs(
      {this.key,
      this.selectPlan,
      this.showCreateButton = false,
      this.showDiscoverButton = false,
      this.pageTitle = 'Plans',
      this.showJoined = true,
      this.showSaved = true});

  final _i53.Key? key;

  final void Function(_i54.WorkoutPlanSummary)? selectPlan;

  final bool showCreateButton;

  final bool showDiscoverButton;

  final String pageTitle;

  final bool showJoined;

  final bool showSaved;

  @override
  String toString() {
    return 'TrainingPlansRouteArgs{key: $key, selectPlan: $selectPlan, showCreateButton: $showCreateButton, showDiscoverButton: $showDiscoverButton, pageTitle: $pageTitle, showJoined: $showJoined, showSaved: $showSaved}';
  }
}

/// generated route for
/// [_i50.ExerciseLibraryPage]
class ExerciseLibraryRoute
    extends _i45.PageRouteInfo<ExerciseLibraryRouteArgs> {
  ExerciseLibraryRoute({_i53.Key? key, String? previousPageTitle})
      : super(ExerciseLibraryRoute.name,
            path: 'exercise-library',
            args: ExerciseLibraryRouteArgs(
                key: key, previousPageTitle: previousPageTitle));

  static const String name = 'ExerciseLibraryRoute';
}

class ExerciseLibraryRouteArgs {
  const ExerciseLibraryRouteArgs({this.key, this.previousPageTitle});

  final _i53.Key? key;

  final String? previousPageTitle;

  @override
  String toString() {
    return 'ExerciseLibraryRouteArgs{key: $key, previousPageTitle: $previousPageTitle}';
  }
}

/// generated route for
/// [_i51.GymProfilesPage]
class GymProfilesRoute extends _i45.PageRouteInfo<GymProfilesRouteArgs> {
  GymProfilesRoute({_i53.Key? key, String? previousPageTitle})
      : super(GymProfilesRoute.name,
            path: 'gym-profiles',
            args: GymProfilesRouteArgs(
                key: key, previousPageTitle: previousPageTitle));

  static const String name = 'GymProfilesRoute';
}

class GymProfilesRouteArgs {
  const GymProfilesRouteArgs({this.key, this.previousPageTitle});

  final _i53.Key? key;

  final String? previousPageTitle;

  @override
  String toString() {
    return 'GymProfilesRouteArgs{key: $key, previousPageTitle: $previousPageTitle}';
  }
}
