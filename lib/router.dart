import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/components/creators/body_tracking/body_tracking_entry_creator.dart';
import 'package:sofie_ui/components/creators/club_creator/club_creator.dart';
import 'package:sofie_ui/components/creators/collection_creator.dart';
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator.dart';
import 'package:sofie_ui/components/creators/gym_profile_creator.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/logged_workout_creator.dart';
import 'package:sofie_ui/components/creators/personal_best_creator/personal_best_creator.dart';
import 'package:sofie_ui/components/creators/post_creator/club_post_creator.dart';
import 'package:sofie_ui/components/creators/post_creator/post_creator.dart';
import 'package:sofie_ui/components/creators/progress_journal_creator/progress_journal_creator.dart';
import 'package:sofie_ui/components/creators/scheduled_workout_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator.dart';
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator.dart';
import 'package:sofie_ui/components/creators/workout_plan_review_creator.dart';
import 'package:sofie_ui/components/do_workout/do_workout_wrapper_page.dart';
import 'package:sofie_ui/components/social/chat/chats_overview_page.dart';
import 'package:sofie_ui/components/social/chat/club_members_chat_page.dart';
import 'package:sofie_ui/components/social/chat/one_to_one_chat_page.dart';
import 'package:sofie_ui/components/timers/timers_page.dart';
import 'package:sofie_ui/components/workout/workout_finders/private/private_workout_finder_page.dart';
import 'package:sofie_ui/components/workout/workout_finders/public/public_workout_finder_page.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_finder/private/private_workout_plan_finder.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_finder/public/public_workout_plan_finder_page.dart';
import 'package:sofie_ui/main.dart';
import 'package:sofie_ui/pages/authed/authed_routes_wrapper_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/club_details/club_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/collection_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/logged_workout_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/personal_best_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/progress_journal_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/user_public_profile_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/workout_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/workout_plan_details_page.dart';
import 'package:sofie_ui/pages/authed/details_pages/workout_plan_enrolment_details_page.dart';
import 'package:sofie_ui/pages/authed/discover/discover_champions_page.dart';
import 'package:sofie_ui/pages/authed/discover/discover_clubs_page.dart';
import 'package:sofie_ui/pages/authed/discover/discover_community_page.dart';
import 'package:sofie_ui/pages/authed/discover/discover_page.dart';
import 'package:sofie_ui/pages/authed/home/home_page.dart';
import 'package:sofie_ui/pages/authed/home/your_awards.dart';
import 'package:sofie_ui/pages/authed/home/your_clubs.dart';
import 'package:sofie_ui/pages/authed/home/your_collections.dart';
import 'package:sofie_ui/pages/authed/home/your_gym_profiles.dart';
import 'package:sofie_ui/pages/authed/home/your_moves_library.dart';
import 'package:sofie_ui/pages/authed/home/your_throwdowns.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_schedule.dart';
import 'package:sofie_ui/pages/authed/home/your_workouts/your_workouts.dart';
import 'package:sofie_ui/pages/authed/landing_pages/club_invite_landing_page.dart';
import 'package:sofie_ui/pages/authed/main_tabs_page.dart';
import 'package:sofie_ui/pages/authed/page_not_found.dart';
import 'package:sofie_ui/pages/authed/profile/archive_page.dart';
import 'package:sofie_ui/pages/authed/profile/profile_page.dart';
import 'package:sofie_ui/pages/authed/profile/settings.dart';
import 'package:sofie_ui/pages/authed/progress/body_tracking_page.dart';
import 'package:sofie_ui/pages/authed/progress/journals_page.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts_page.dart';
import 'package:sofie_ui/pages/authed/progress/personal_bests_page.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';
import 'package:sofie_ui/pages/authed/discover/discover_people_page.dart';
import 'package:sofie_ui/pages/authed/social/social_page.dart';
import 'package:sofie_ui/pages/unauthed/unauthed_landing.dart';

@CupertinoAutoRouter(
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
          AutoRoute(path: '', page: MainTabsPage, children: [
            AutoRoute(
                path: '',
                name: 'discoverStack',
                page: EmptyRouterPage,
                children: [
                  AutoRoute(path: '', page: DiscoverPage),
                  AutoRoute(path: 'discover-people', page: DiscoverPeoplePage),
                  AutoRoute(path: 'discover-clubs', page: DiscoverClubsPage),
                  AutoRoute(path: 'community', page: DiscoverCommunityPage),
                  AutoRoute(path: 'champions', page: DiscoverChampionsPage),
                ]),
            AutoRoute(
              path: 'social',
              page: SocialPage,
            ),
            AutoRoute(
                path: 'studio',
                name: 'homeStack',
                page: EmptyRouterPage,
                children: [
                  AutoRoute(path: '', page: HomePage),
                  AutoRoute(path: 'your-awards', page: YourAwardsPage),
                  AutoRoute(path: 'your-clubs', page: YourClubsPage),
                  AutoRoute(
                      path: 'your-collections', page: YourCollectionsPage),
                  AutoRoute(
                      path: 'your-gym-profiles', page: YourGymProfilesPage),
                  AutoRoute(path: 'your-moves', page: YourMovesLibraryPage),
                  AutoRoute(path: 'your-plans', page: YourPlansPage),
                  AutoRoute(path: 'your-schedule', page: YourSchedulePage),
                  AutoRoute(path: 'your-throwdowns', page: YourThrowdownsPage),
                  AutoRoute(path: 'your-workouts', page: YourWorkoutsPage),
                ]),
            AutoRoute(
                path: 'progress',
                name: 'progressStack',
                page: EmptyRouterPage,
                children: [
                  AutoRoute(initial: true, path: '', page: ProgressPage),
                  AutoRoute(path: 'personal-bests', page: PersonalBestsPage),
                  AutoRoute(path: 'journals', page: JournalsPage),
                  AutoRoute(path: 'body-tracking', page: BodyTrackingPage),
                  AutoRoute(path: 'workout-logs', page: LoggedWorkoutsPage),
                ]),
            AutoRoute(path: 'profile', page: ProfilePage),
          ]),
          // These pages are 'stand-alone'. They push on top of the underlying main tabs UI / stacks and so go into full screen.
          // They can be pushed to from anywhere and are also pages that would want to be linkable. E.g. when sharing a workout details page with a group or another user.
          // Usually the flow from these pages ends up back on this page - where the user can hit [back] to go back to the main tabs view. E.g. MainTabsView -> WorkoutDetails -> Do Workout -> LogWorkout -> WorkoutDetails -> MainTabsView
          AutoRoute(path: 'archive', page: ArchivePage),
          AutoRoute(path: 'chats', page: ChatsOverviewPage),
          AutoRoute(path: 'chat', page: OneToOneChatPage),
          AutoRoute(path: 'club-chat', page: ClubMembersChatPage),
          AutoRoute(path: 'club-invite/:id', page: ClubInviteLandingPage),
          AutoRoute(path: 'collection/:id', page: CollectionDetailsPage),
          AutoRoute(path: "do-workout/:id", page: DoWorkoutWrapperPage),

          AutoRoute(path: 'settings', page: SettingsPage),
          AutoRoute(path: 'timers', page: TimersPage),

          /// Finders.
          AutoRoute(path: 'community-workouts', page: PublicWorkoutFinderPage),
          AutoRoute(path: 'personal-workouts', page: PrivateWorkoutFinderPage),
          AutoRoute(path: 'community-plans', page: PublicWorkoutPlanFinderPage),
          AutoRoute(path: 'personal-plans', page: PrivateWorkoutPlanFinderPage),

          /// Details pages - for certain object types.
          AutoRoute(path: 'club/:id', page: ClubDetailsPage),
          AutoRoute(path: 'logged-workout/:id', page: LoggedWorkoutDetailsPage),
          AutoRoute(path: 'personal-best/:id', page: PersonalBestDetailsPage),
          AutoRoute(
              path: 'profile/:userId', page: UserPublicProfileDetailsPage),
          AutoRoute(
              path: 'progress-journal/:id', page: ProgressJournalDetailsPage),
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
          AutoRoute(path: 'create/journal', page: ProgressJournalCreatorPage),
          AutoRoute(
              path: 'create/personal-best', page: PersonalBestCreatorPage),
          AutoRoute(path: 'create/post', page: PostCreatorPage),
          AutoRoute(path: 'create/club-post', page: ClubPostCreatorPage),
          AutoRoute(
              path: 'create/scheduled-workout',
              page: ScheduledWorkoutCreatorPage),
          AutoRoute(path: 'create/workout', page: WorkoutCreatorPage),
          AutoRoute(path: 'create/workout-log', page: LoggedWorkoutCreatorPage),
          AutoRoute(path: 'create/workout-plan', page: WorkoutPlanCreatorPage),
          AutoRoute(
              path: 'create/workout-plan-review',
              page: WorkoutPlanReviewCreatorPage),
          AutoRoute(path: '*', page: PageNotFoundPage),
        ]),
  ],
)
class $AppRouter {}
