import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';

class MostLoggedMovesWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const MostLoggedMovesWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogAnalysisWidgetHeader(
          heading: 'Most Logged Moves',
        ),
        MyText('Most Logged Moves'),
      ],
    );
  }
}
