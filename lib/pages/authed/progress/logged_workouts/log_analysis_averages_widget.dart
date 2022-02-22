import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

class LogAnalysisAveragesWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const LogAnalysisAveragesWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: [
        ContentBox(
            child: Column(
          children: [
            Column(
              children: [
                MyHeaderText('Per Month'),
                MyHeaderText(
                  'Avg.',
                  subtext: true,
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    MyText('10'),
                    MyText(
                      'SESSIONS',
                      subtext: true,
                    ),
                  ],
                ),
                Column(
                  children: [
                    MyText('300'),
                    MyText(
                      'MINUTES',
                      subtext: true,
                    ),
                  ],
                ),
              ],
            )
          ],
        ))
      ],
    );
  }
}
