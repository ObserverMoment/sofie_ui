import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class UserDayLogDisplay extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const UserDayLogDisplay({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () => print('open full screen'),
                  iconData: CupertinoIcons.calendar),
              IconButton(
                  onPressed: () => print('open full screen'),
                  iconData: CupertinoIcons.graph_square),
              IconButton(
                  onPressed: () => print('open settings'),
                  iconData: CupertinoIcons.settings),
            ],
          ),
        ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 0.6,
          crossAxisCount: 7,
          children: List.generate(
              28,
              (day) => Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ContentBox(
                        borderRadius: 0,
                        child: Center(child: MyText(day.toString()))),
                  )),
        ),
      ],
    );
  }
}
