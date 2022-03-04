import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_move_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class FastestTimeTrackerCreatorPage extends StatefulWidget {
  const FastestTimeTrackerCreatorPage({Key? key}) : super(key: key);

  @override
  FastestTimeTrackerCreatorPageState createState() =>
      FastestTimeTrackerCreatorPageState();
}

class FastestTimeTrackerCreatorPageState
    extends State<FastestTimeTrackerCreatorPage> {
  bool _loading = false;

  WorkoutMove? _workoutMove;

  Future<void> _createFastestTimeTracker() async {
    if (_workoutMove == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final variables = CreateUserFastestTimeExerciseTrackerArguments(
        data: CreateUserFastestTimeExerciseTrackerInput(
            distanceUnit: _workoutMove!.distanceUnit,
            loadAmount: _workoutMove!.loadAmount,
            loadUnit: _workoutMove!.loadUnit,
            move: ConnectRelationInput(id: _workoutMove!.move.id),
            equipment: _workoutMove!.equipment != null
                ? ConnectRelationInput(id: _workoutMove!.equipment!.id)
                : null,
            reps: _workoutMove!.reps,
            repType: _workoutMove!.repType));

    final result = await context.graphQLStore.create(
        mutation:
            CreateUserFastestTimeExerciseTrackerMutation(variables: variables),
        addRefToQueries: [GQLOpNames.userFastestTimeExerciseTrackers]);

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

  void _defineWorkoutMove() => context.push(
          child: WorkoutMoveCreator(
              pageTitle: 'Define Exercise',
              saveWorkoutMove: (wm) {
                setState(() {
                  _workoutMove = wm;
                });
              },
              workoutMove: _workoutMove,
              sortPosition: 0, // Does not matter.
              validRepTypes: const [
            WorkoutMoveRepType.reps,
            WorkoutMoveRepType.calories,
            WorkoutMoveRepType.distance,
          ]));

  bool get _validToSave => _workoutMove != null;

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: CreateEditNavBarSimple(
          loading: _loading,
          onSave: _createFastestTimeTracker,
          title: 'Fastest Time Tracker',
          validToSave: _validToSave,
          onCancel: context.pop,
        ),
        child: _workoutMove == null
            ? YourContentEmptyPlaceholder(
                message: 'Track Fastest Time Scores!',
                explainer:
                    'Specify exercise, distance or reps, and any equipment. For e.g. "400m sprint, 1000m row, 100 burpees with 10kg vest"',
                showIcon: false,
                actions: [
                    EmptyPlaceholderAction(
                        action: _defineWorkoutMove,
                        buttonIcon: CupertinoIcons.add,
                        buttonText: 'Define Exercise'),
                  ])
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TertiaryButton(
                            suffixIconData: CupertinoIcons.pen,
                            text: 'Edit Exercise',
                            onPressed: _defineWorkoutMove),
                      ),
                      _WorkoutMoveForTrackerDisplay(
                        workoutMove: _workoutMove!,
                      ),
                    ],
                  ),
                ],
              ));
  }
}

class _WorkoutMoveForTrackerDisplay extends StatelessWidget {
  final WorkoutMove workoutMove;
  const _WorkoutMoveForTrackerDisplay({Key? key, required this.workoutMove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showLoad = workoutMove.loadAdjustable;

    return ContentBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
            workoutMove.move.name,
            size: FONTSIZE.six,
          ),
          const SizedBox(height: 8),
          if (Utils.textNotNull(workoutMove.equipment?.name))
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyText(workoutMove.equipment!.name, size: FONTSIZE.three),
            ),
          if (showLoad)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyText(
                    workoutMove.loadAmount.stringMyDouble(),
                    lineHeight: 1.1,
                    size: FONTSIZE.seven,
                  ),
                  const SizedBox(width: 4),
                  MyText(
                    workoutMove.loadUnit.display,
                    size: FONTSIZE.three,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyText(
                  workoutMove.reps.stringMyDouble(),
                  lineHeight: 1.1,
                  size: FONTSIZE.seven,
                ),
                const SizedBox(width: 4),
                MyText(
                  workoutMove.repDisplay,
                  size: FONTSIZE.four,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
