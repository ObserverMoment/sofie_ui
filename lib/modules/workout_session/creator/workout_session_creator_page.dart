import 'package:flutter/src/widgets/framework.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutSessionCreatorPage extends StatefulWidget {
  final WorkoutSession? workoutSession;
  const WorkoutSessionCreatorPage({Key? key, this.workoutSession})
      : super(key: key);

  @override
  State<WorkoutSessionCreatorPage> createState() =>
      _WorkoutSessionCreatorPageState();
}

class _WorkoutSessionCreatorPageState extends State<WorkoutSessionCreatorPage> {
  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(child: MyText('Creator'));
  }
}
