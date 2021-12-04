import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/profile/personal_best_score_icon.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class PersonalBestsSlider extends StatelessWidget {
  final List<UserBenchmarkWithBestEntry> benchmarks;
  const PersonalBestsSlider({Key? key, required this.benchmarks})
      : super(key: key);

  double get cardHeight => 150.0;
  double cardWidth(BoxConstraints constraints) => constraints.maxWidth / 3.4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      MyHeaderText('Personal Bests'),
                    ],
                  ),
                ),
                Container(
                  height: cardHeight,
                  padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                  child: ListView.builder(
                    itemCount: benchmarks.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: SizedBox(
                        width: cardWidth(constraints),
                        height: cardHeight,
                        child: PersonalBestScoreIcon(
                            userBenchmarkWithBestEntry: benchmarks[i]),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }
}
