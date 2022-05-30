import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/workout_session_create.dart';
import 'package:sofie_ui/modules/workout_session/creator/workout_session_creator_bloc.dart';
import 'package:sofie_ui/modules/workout_session/creator/workout_session_edit.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class WorkoutSessionCreatorPage extends StatefulWidget {
  final WorkoutSession? workoutSession;
  const WorkoutSessionCreatorPage({Key? key, this.workoutSession})
      : super(key: key);

  @override
  State<WorkoutSessionCreatorPage> createState() =>
      _WorkoutSessionCreatorPageState();
}

class _WorkoutSessionCreatorPageState extends State<WorkoutSessionCreatorPage> {
  WorkoutSessionCreatorBloc? _bloc;
  bool _creatingNewWorkoutSession = false;

  @override
  void initState() {
    super.initState();
    if (widget.workoutSession != null) {
      _initBloc(widget.workoutSession!);
    }
  }

  void _initBloc(WorkoutSession workoutSession) {
    setState(() => _bloc = WorkoutSessionCreatorBloc(workoutSession));
  }

  /// Create a bare bones workout in the DB and add it to the store.
  Future<void> _createWorkoutSession(CreateWorkoutSessionInput input) async {
    setState(() {
      _creatingNewWorkoutSession = true;
    });

    final result = await GraphQLStore.store
        .create<CreateWorkoutSession$Mutation, CreateWorkoutSessionArguments>(
            mutation: CreateWorkoutSessionMutation(
              variables: CreateWorkoutSessionArguments(data: input),
            ),
            addRefToQueries: [GQLOpNames.userWorkoutSessions]);

    checkOperationResult(result, onSuccess: () {
      _initBloc(result.data!.createWorkoutSession);
    });

    setState(() {
      _creatingNewWorkoutSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _bloc != null
            ? WorkoutSessionEdit(bloc: _bloc!)
            : WorkoutSessionCreate(
                createWorkoutSession: _createWorkoutSession,
                creatingNewWorkoutSession: _creatingNewWorkoutSession));
  }
}
