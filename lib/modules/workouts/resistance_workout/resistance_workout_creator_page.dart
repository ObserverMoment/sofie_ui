import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/edit/resistance_workout_edit.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/resistance_workout_bloc.dart';
import 'package:sofie_ui/modules/workouts/workout_create.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ResistanceWorkoutCreatorPage extends StatefulWidget {
  final ResistanceWorkout? resistanceWorkout;
  const ResistanceWorkoutCreatorPage({Key? key, this.resistanceWorkout})
      : super(key: key);

  @override
  State<ResistanceWorkoutCreatorPage> createState() =>
      _ResistanceWorkoutCreatorPageState();
}

class _ResistanceWorkoutCreatorPageState
    extends State<ResistanceWorkoutCreatorPage> {
  ResistanceWorkoutBloc? _bloc;
  bool _creatingNewResistanceWorkout = false;

  @override
  void initState() {
    super.initState();
    if (widget.resistanceWorkout != null) {
      _initBloc(widget.resistanceWorkout!);
    }
  }

  void _initBloc(ResistanceWorkout resistanceWorkout) {
    setState(() => _bloc = ResistanceWorkoutBloc(resistanceWorkout));
  }

  /// Create a bare bones workout in the DB and add it to the store.
  Future<void> _createResistanceWorkout(String name) async {
    setState(() {
      _creatingNewResistanceWorkout = true;
    });

    final result = await GraphQLStore.store.create<
        CreateResistanceWorkout$Mutation, CreateResistanceWorkoutArguments>(
      mutation: CreateResistanceWorkoutMutation(
        variables: CreateResistanceWorkoutArguments(
            data: CreateResistanceWorkoutInput(name: name)),
      ),
      addRefToQueries: [GQLOpNames.userResistanceWorkouts],
    );

    checkOperationResult(result, onSuccess: () {
      _initBloc(result.data!.createResistanceWorkout);
    });

    setState(() {
      _creatingNewResistanceWorkout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _bloc != null
            ? ChangeNotifierProvider.value(
                value: _bloc,
                child: const ResistanceWorkoutEdit(),
              )
            : WorkoutCreate(
                createWorkout: _createResistanceWorkout,
                creatingNewWorkout: _creatingNewResistanceWorkout));
  }
}
