import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/components/creators/body_tracking/body_tracking_entry_creator.dart';
import 'package:sofie_ui/components/creators/club_creator/club_creator.dart';
import 'package:sofie_ui/components/creators/collection_creator.dart';
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator.dart';
import 'package:sofie_ui/components/creators/post_creator/club_feed_post_creator_page.dart';
import 'package:sofie_ui/components/creators/post_creator/feed_post_creator_page.dart';
import 'package:sofie_ui/components/creators/scheduled_workout_creator.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_eat_well_log_creator_page.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_sleep_well_log_creator_page.dart';
import 'package:sofie_ui/components/creators/exercise_load_tracker_creator_page.dart';
import 'package:sofie_ui/components/creators/user_goal_creator_page.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_meditation_log_creator_page.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator.dart';
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator.dart';
import 'package:sofie_ui/components/creators/workout_plan_review_creator.dart';
import 'package:sofie_ui/components/do_workout/do_workout_wrapper_page.dart';
import 'package:sofie_ui/components/social/chat/chats_overview_page.dart';
import 'package:sofie_ui/components/social/chat/clubs/club_members_chat_page.dart';
import 'package:sofie_ui/components/social/chat/friends/one_to_one_chat_page.dart';
import 'package:sofie_ui/components/timers/timers_page.dart';
import 'package:sofie_ui/modules/home/home_page.dart';
import 'package:sofie_ui/modules/home/notifications_page.dart';
import 'package:sofie_ui/modules/home/your_posts_page.dart';
import 'package:sofie_ui/modules/profile/archive_page.dart';
import 'package:sofie_ui/modules/profile/edit_profile_page.dart';
import 'package:sofie_ui/modules/profile/gym_profile/gym_profile_creator.dart';
import 'package:sofie_ui/modules/profile/gym_profile/gym_profiles_page.dart';
import 'package:sofie_ui/modules/profile/profile_page.dart';
import 'package:sofie_ui/modules/profile/settings_page.dart';
import 'package:sofie_ui/modules/profile/skills/skills_page.dart';
import 'package:sofie_ui/modules/profile/social/social_links_page.dart';
import 'package:sofie_ui/modules/sign_in_registration/unauthed_landing_page.dart';
import 'package:sofie_ui/modules/workout_sessions/resistance_session/resistance_session_creator_page.dart';
import 'package:sofie_ui/pages/authed/circles/circles_page.dart';
import 'package:sofie_ui/pages/authed/circles/discover_clubs_page.dart';
import 'package:sofie_ui/pages/authed/circles/discover_people_page.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/logged_workouts_history_page.dart';
import 'package:sofie_ui/pages/authed/progress/user_goals_page.dart';
import 'package:sofie_ui/components/workout/workout_finders/public/public_workout_finder_page.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart';
import 'package:sofie_ui/main.dart';
import 'package:sofie_ui/pages/authed/authed_routes_wrapper_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/collection_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/logged_workout_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/user_public_profile_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/workout_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/workout_plan_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/workout_plan_enrolment_details_page.dart';
import 'package:sofie_ui/pages/authed/my_studio/my_studio_page.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_clubs.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_collections.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_moves_library.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_throwdowns.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_plans/your_plans.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_schedule.dart';
import 'package:sofie_ui/pages/authed/my_studio/your_workouts/your_workouts.dart';
import 'package:sofie_ui/pages/authed/landing_pages/club_invite_landing_page.dart';
import 'package:sofie_ui/modules/main_tabs/main_tabs_page.dart';
import 'package:sofie_ui/pages/authed/page_not_found.dart';
import 'package:sofie_ui/pages/authed/progress/body_tracking_page.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts_analysis_page.dart';
import 'package:sofie_ui/pages/authed/progress/personal_scorebook_page.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/auth', page: UnauthedLandingPage, fullscreenDialog: true),
    AutoRoute(
        path: '/loading', page: GlobalLoadingPage, fullscreenDialog: true),
    AutoRoute(
        path: '/',
        name: 'authedRouter',
        page: AuthedRoutesWrapperPage,
        fullscreenDialog: true,
        children: [
          // The main tabs screen has five tabs where each is a stack. Generally these are pages that are user specific and are not likely to be shared across users or groups. Each stack maintains its own state and navigation in iOS style.
          AutoRoute(initial: true, path: '', page: MainTabsPage, children: [
            AutoRoute(
              path: '',
              page: HomePage,
            ),
            AutoRoute(
              path: 'circles',
              page: CirclesPage,
            ),
            AutoRoute(path: 'studio', page: MyStudioPage),
            AutoRoute(
              path: 'progress',
              page: ProgressPage,
            ),
          ]),
          // These pages are 'stand-alone'. They push on top of the underlying main tabs UI / stacks and so go into full screen.
          // They can be pushed to from anywhere and are also pages that would want to be linkable. E.g. when sharing a workout details page with a group or another user.
          // Usually the flow from these pages ends up back on this page - where the user can hit [back] to go back to the main tabs view. E.g. MainTabsView -> WorkoutDetails -> Do Workout -> LogWorkout -> WorkoutDetails -> MainTabsView
          AutoRoute(path: 'chats', page: ChatsOverviewPage),
          AutoRoute(path: 'chat', page: OneToOneChatPage),
          AutoRoute(path: 'club-chat', page: ClubMembersChatPage),
          AutoRoute(path: 'club-invite/:id', page: ClubInviteLandingPage),
          AutoRoute(path: 'collection/:id', page: CollectionDetailsPage),
          AutoRoute(path: "do-workout/:id", page: DoWorkoutWrapperPage),

          /// User related.
          AutoRoute(path: 'profile', page: ProfilePage),
          AutoRoute(path: 'archive', page: ArchivePage),
          AutoRoute(path: 'settings', page: SettingsPage),
          AutoRoute(path: 'skills', page: SkillsPage),
          AutoRoute(path: 'social-links', page: SocialLinksPage),
          AutoRoute(path: 'notifications', page: NotificationsPage),
          AutoRoute(path: 'edit-profile', page: EditProfilePage),

          /// Misc
          AutoRoute(path: 'timers', page: TimersPage),

          /// Users own content.
          AutoRoute(path: 'your-clubs', page: YourClubsPage),
          AutoRoute(path: 'your-collections', page: YourCollectionsPage),
          AutoRoute(path: 'gym-profiles', page: GymProfilesPage),
          AutoRoute(path: 'your-moves', page: YourMovesLibraryPage),
          AutoRoute(path: 'your-plans', page: YourPlansPage),
          AutoRoute(path: "your-posts", page: YourPostsPage),
          AutoRoute(path: 'your-schedule', page: YourSchedulePage),
          AutoRoute(path: 'your-throwdowns', page: YourThrowdownsPage),
          AutoRoute(path: 'your-workouts', page: YourWorkoutsPage),

          /// User progress, stats and workout history
          AutoRoute(path: 'personal-scores', page: PersonalScoresPage),
          AutoRoute(path: 'goals', page: UserGoalsPage),
          AutoRoute(path: 'body-tracking', page: BodyTrackingPage),
          AutoRoute(
              path: 'workout-logs/analysis', page: LoggedWorkoutsAnalysisPage),
          AutoRoute(
              path: 'workout-logs/history', page: LoggedWorkoutsHistoryPage),

          /// Finders and Public Content.
          /// Consider renaming these all as discover?
          /// Is a finder different from discover?
          AutoRoute(path: 'public-workouts', page: PublicWorkoutFinderPage),
          AutoRoute(path: 'public-plans', page: PublicWorkoutPlanFinderPage),
          AutoRoute(path: 'discover-people', page: DiscoverPeoplePage),
          AutoRoute(path: 'discover-clubs', page: DiscoverClubsPage),

          /// Details pages - for certain object types.
          AutoRoute(path: 'club/:id', page: ClubDetailsPage),
          AutoRoute(path: 'logged-workout/:id', page: LoggedWorkoutDetailsPage),
          AutoRoute(
              path: 'profile/:userId', page: UserPublicProfileDetailsPage),

          AutoRoute(path: 'workout/:id', page: WorkoutDetailsPage),
          AutoRoute(path: 'workout-plan/:id', page: WorkoutPlanDetailsPage),
          AutoRoute(
              path: 'workout-plan-progress/:id',
              page: WorkoutPlanEnrolmentDetailsPage),

          /// Creator pages. CRUD pages for database models.
          AutoRoute(
              path: 'create/body-tracking', page: BodyTrackingEntryCreatorPage),
          AutoRoute(path: 'create/club', page: ClubCreatorPage),
          AutoRoute(path: 'create/collection', page: CollectionCreatorPage),
          AutoRoute(path: 'create/custom-move', page: CustomMoveCreatorPage),
          AutoRoute(path: 'create/gym-profile', page: GymProfileCreatorPage),
          AutoRoute(path: 'create/goal', page: UserGoalCreatorPage),
          AutoRoute(
              path: 'create/mindfulness-log',
              page: UserMeditationLogCreatorPage),
          AutoRoute(path: 'create/food-log', page: UserEatWellLogCreatorPage),
          AutoRoute(
              path: 'create/sleep-log', page: UserSleepWellLogCreatorPage),
          AutoRoute(path: 'create/post', page: FeedPostCreatorPage),
          AutoRoute(path: 'create/club-post', page: ClubFeedPostCreatorPage),
          AutoRoute(
              path: 'create/scheduled-workout',
              page: ScheduledWorkoutCreatorPage),
          AutoRoute(path: 'create/workout', page: WorkoutCreatorPage),
          AutoRoute(
              path: 'create/resistance-session',
              page: ResistanceSessionCreatorPage),
          AutoRoute(path: 'create/workout-plan', page: WorkoutPlanCreatorPage),
          AutoRoute(
              path: 'create/workout-plan-review',
              page: WorkoutPlanReviewCreatorPage),

          /// Create exercise tracker widgets.
          AutoRoute(
              path: 'create/max-lift-tracker',
              page: ExerciseLoadTrackerCreatorPage),

          AutoRoute(page: PageNotFoundPage, path: '404'),
          RedirectRoute(path: '*', redirectTo: '404')
        ]),
  ],
)
class $AppRouter {}
