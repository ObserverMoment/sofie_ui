import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_dashboard.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmarks_dashboard.dart';

class PersonalScoresPage extends StatelessWidget {
  const PersonalScoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Personal Scorebook'),
      ),
      child: ListView(
        children: [
          const FitnessBenchmarksDashboard(),
          const SizedBox(height: 24),
          ChangeNotifierProvider(
            create: (c) => ExerciseTrackersBloc(c),
            builder: (context, child) {
              final initialized = context
                  .select<ExerciseTrackersBloc, bool>((b) => b.initialized);

              return !initialized
                  ? const ShimmerCardGridCount(
                      itemCount: 9,
                      crossAxisCount: 3,
                    )
                  : const ExerciseTrackersDashboard();
            },
          ),
        ],
      ),
    );
  }
}
