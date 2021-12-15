import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/personal_best/entry_top_score_display.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class PersonalBestCard extends StatelessWidget {
  final UserBenchmark userBenchmark;
  const PersonalBestCard({Key? key, required this.userBenchmark})
      : super(key: key);

  List<UserBenchmarkEntry>? _sortEntries() {
    final entries =
        userBenchmark.userBenchmarkEntries.sortedBy<num>((e) => e.score);
    if (entries.isEmpty) {
      return null;
    }
    return userBenchmark.benchmarkType == BenchmarkType.fastesttime
        ? entries
        : entries.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final bestEntry = _sortEntries()?[0];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: MyHeaderText(
                        userBenchmark.name,
                      ),
                    ),
                    MyText(
                      userBenchmark.benchmarkType.display,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 6),
                    if (Utils.textNotNull(userBenchmark.equipmentInfo))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: MyText(userBenchmark.equipmentInfo!,
                            maxLines: 5, weight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
              if (bestEntry == null)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MyText('No scores'),
                )
              else
                UserBenchmarkScoreDisplay(
                  benchmark: userBenchmark,
                  benchmarkEntry: bestEntry,
                ),
            ],
          ),
          if (Utils.textNotNull(userBenchmark.description))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: MyText(
                userBenchmark.description!,
                maxLines: 3,
                size: FONTSIZE.two,
                lineHeight: 1.4,
              ),
            ),
        ],
      ),
    );
  }
}
