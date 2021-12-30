import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class WorkoutGoalsSelectorRow extends StatelessWidget {
  final List<WorkoutGoal> selectedWorkoutGoals;
  final void Function(List<WorkoutGoal>) updateSelectedWorkoutGoals;
  final int? max;
  final String name;
  const WorkoutGoalsSelectorRow(
      {Key? key,
      required this.selectedWorkoutGoals,
      required this.updateSelectedWorkoutGoals,
      this.max,
      this.name = 'Goals'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInputContainer(
        child: CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPressed: () => context.push(
          child: WorkoutGoalsSelector(
        selectedWorkoutGoals: selectedWorkoutGoals,
        updateSelectedWorkoutGoals: updateSelectedWorkoutGoals,
        max: max,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyText(
                    name,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Icon(
                    CupertinoIcons.scope,
                    size: 18,
                  ),
                ],
              ),
              Row(
                children: [
                  MyText(
                    selectedWorkoutGoals.isEmpty ? 'Add' : 'Edit',
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    selectedWorkoutGoals.isEmpty
                        ? CupertinoIcons.add
                        : CupertinoIcons.pencil,
                    size: 18,
                  )
                ],
              )
            ],
          ),
          GrowInOut(
              show: selectedWorkoutGoals.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 2),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedWorkoutGoals
                      .map((g) => FadeIn(
                            child: Tag(
                              tag: g.name,
                              color: Styles.primaryAccent,
                              textColor: Styles.white,
                            ),
                          ))
                      .toList(),
                ),
              ))
        ],
      ),
    ));
  }
}

class WorkoutGoalsSelector extends StatefulWidget {
  final List<WorkoutGoal> selectedWorkoutGoals;
  final void Function(List<WorkoutGoal> updated) updateSelectedWorkoutGoals;
  final int? max;
  const WorkoutGoalsSelector(
      {Key? key,
      required this.selectedWorkoutGoals,
      required this.updateSelectedWorkoutGoals,
      this.max})
      : super(key: key);

  @override
  _WorkoutGoalsSelectorState createState() => _WorkoutGoalsSelectorState();
}

class _WorkoutGoalsSelectorState extends State<WorkoutGoalsSelector> {
  List<WorkoutGoal> _activeSelectedWorkoutGoals = [];

  @override
  void initState() {
    super.initState();
    _activeSelectedWorkoutGoals = [...widget.selectedWorkoutGoals];
  }

  void _handleUpdateSelected(WorkoutGoal tapped) {
    if (widget.max == null ||
        _activeSelectedWorkoutGoals.length < widget.max! ||
        _activeSelectedWorkoutGoals.contains(tapped)) {
      setState(() {
        _activeSelectedWorkoutGoals =
            _activeSelectedWorkoutGoals.toggleItem<WorkoutGoal>(tapped);
      });

      widget.updateSelectedWorkoutGoals(_activeSelectedWorkoutGoals);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        trailing: TertiaryButton(
            backgroundGradient: Styles.primaryAccentGradient,
            textColor: Styles.white,
            text: 'Done',
            onPressed: context.pop),
        middle: const LeadingNavBarTitle(
          'Workout Goals',
        ),
      ),
      child: QueryObserver<WorkoutGoals$Query, json.JsonSerializable>(
          key: Key(
              'WorkoutGoalsSelector - ${WorkoutGoalsQuery().operationName}'),
          query: WorkoutGoalsQuery(),
          fetchPolicy: QueryFetchPolicy.storeFirst,
          loadingIndicator: const ShimmerCardList(
            itemCount: 10,
            cardHeight: 50,
          ),
          builder: (data) {
            return Column(
              children: [
                if (widget.max != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        'Select up to ${widget.max!} goals - ',
                      ),
                      MyText(
                        '${_activeSelectedWorkoutGoals.length} selected',
                        color: Styles.primaryAccent,
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: data.workoutGoals
                        .map((goal) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SelectableBoxExpanded(
                                onPressed: () => _handleUpdateSelected(goal),
                                height: 50,
                                isSelected:
                                    _activeSelectedWorkoutGoals.contains(goal),
                                text: goal.name,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
