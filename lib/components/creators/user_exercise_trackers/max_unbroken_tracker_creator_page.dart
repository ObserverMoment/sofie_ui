import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class MaxUnbrokenTrackerCreatorPage extends StatefulWidget {
  const MaxUnbrokenTrackerCreatorPage({Key? key}) : super(key: key);

  @override
  MaxUnbrokenTrackerCreatorPageState createState() =>
      MaxUnbrokenTrackerCreatorPageState();
}

class MaxUnbrokenTrackerCreatorPageState
    extends State<MaxUnbrokenTrackerCreatorPage> {
  bool _loading = false;

  LoadUnit _loadUnit = LoadUnit.kg;
  DistanceUnit _distanceUnit = DistanceUnit.metres;
  Move? _move;
  Equipment? _equipment;
  double _loadAmount = 0;
  WorkoutMoveRepType _repType = WorkoutMoveRepType.reps;

  Future<void> _createMaxUnbrokenTracker() async {
    if (_move == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final variables = CreateUserMaxUnbrokenExerciseTrackerArguments(
        data: CreateUserMaxUnbrokenExerciseTrackerInput(
            distanceUnit: _distanceUnit,
            loadAmount: _loadAmount,
            loadUnit: _loadUnit,
            move: ConnectRelationInput(id: _move!.id),
            equipment: _equipment != null
                ? ConnectRelationInput(id: _equipment!.id)
                : null,
            repType: _repType));

    final result = await context.graphQLStore.create(
        mutation:
            CreateUserMaxUnbrokenExerciseTrackerMutation(variables: variables),
        addRefToQueries: [GQLOpNames.userMaxUnbrokenExerciseTrackers]);

    checkOperationResult(context, result, onSuccess: () {
      setState(() {
        _loading = true;
      });
      context.pop();
    }, onFail: () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
