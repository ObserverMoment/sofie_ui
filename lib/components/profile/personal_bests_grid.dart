import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/profile/personal_best_score_icon.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';

class PersonalBestsGrid extends StatelessWidget {
  final List<UserBenchmarkWithBestEntry> benchmarks;
  const PersonalBestsGrid({Key? key, required this.benchmarks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return benchmarks.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              YourContentEmptyPlaceholder(
                  message: 'No personal bests logged', actions: []),
            ],
          )
        : GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: benchmarks
                .map(
                  (b) => PersonalBestScoreIcon(userBenchmarkWithBestEntry: b),
                )
                .toList(),
          );
  }
}
