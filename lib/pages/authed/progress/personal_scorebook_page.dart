import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/pages/authed/progress/personal_bests_components/user_fastest_time_exercise_trackers.dart';
import 'package:sofie_ui/pages/authed/progress/personal_bests_components/user_max_load_exercise_trackets.dart';
import 'package:sofie_ui/pages/authed/progress/personal_bests_components/user_max_unbroken_exercise_tracker.dart';
import 'package:sofie_ui/pages/authed/progress/personal_bests_components/user_scored_workout_trackers.dart';

class PersonalScoresPage extends StatelessWidget {
  const PersonalScoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  const MySliverNavbar(
                    title: 'Personal Scorebook',
                  ),
                  SliverToBoxAdapter(
                    child: PrimaryButton(
                      onPressed: () {},
                      text: 'Create New Tracker',
                    ),
                  )
                ],
            body: ListView(
              shrinkWrap: true,
              children: const [
                UserScoredWorkoutTrackers(),
                UserMaxLoadExerciseTrackers(),
                UserFastestTimeExerciseTrackers(),
                UserMaxUnbrokenExerciseTrackers(),
              ],
            )));
  }
}

// /// Note: UserBenchmark (API) == Personal Best (UI)
// class _FilterablePBsList extends StatelessWidget {
//   final void Function(String benchmarkId) selectBenchmark;
//   final List<UserBenchmark> allBenchmarks;
//   const _FilterablePBsList({
//     Key? key,
//     required this.selectBenchmark,
//     required this.allBenchmarks,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final sortedBenchmarks =
//         allBenchmarks.sortedBy<DateTime>((w) => w.createdAt).reversed.toList();

//     return FABPage(
//       rowButtonsAlignment: MainAxisAlignment.end,
//       rowButtons: [
//         FloatingButton(
//             // gradient: Styles.primaryAccentGradient,
//             // contentColor: Styles.white,
//             icon: CupertinoIcons.add,
//             onTap: () => context.navigateTo(PersonalBestCreatorRoute())),
//       ],
//       child: ListView.builder(
//           shrinkWrap: true,
//           padding: const EdgeInsets.only(top: 4, bottom: 60),
//           itemCount: sortedBenchmarks.length,
//           itemBuilder: (c, i) => GestureDetector(
//                 key: Key(sortedBenchmarks[i].id),
//                 onTap: () => selectBenchmark(sortedBenchmarks[i].id),
//                 child: FadeInUp(
//                   key: Key(sortedBenchmarks[i].id),
//                   delay: 5,
//                   delayBasis: 20,
//                   duration: 100,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     child: PersonalBestCard(userBenchmark: sortedBenchmarks[i]),
//                   ),
//                 ),
//               )),
//     );
//   }
// }
