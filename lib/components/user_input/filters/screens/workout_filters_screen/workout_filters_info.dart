import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/selectors/difficulty_level_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/generic_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_goals_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_section_type_multi_selector.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_utils.dart';

class WorkoutFiltersInfo extends StatelessWidget {
  const WorkoutFiltersInfo({Key? key}) : super(key: key);

  /// 0 = any
  // 1 = < 15, 2 = 15 - 30, 3 = 30 - 45, 4 = 45 - 60, 5 = 60 >
  int _minLengthToInt(Duration? d) {
    switch (d?.inMinutes) {
      case null:
        return 0;
      case 0:
        return 1;
      case 15:
        return 2;
      case 30:
        return 3;
      case 45:
        return 4;
      case 60:
        return 5;
      default:
        return 0;
    }
  }

  Map<String, int?> _intToMinLengthMaxLength(int i) {
    switch (i) {
      case 0:
        return {
          'minLength': null,
          'maxLength': null,
        };
      case 1:
        return {
          'minLength': 0,
          'maxLength': 15,
        };
      case 2:
        return {
          'minLength': 15,
          'maxLength': 30,
        };
      case 3:
        return {
          'minLength': 30,
          'maxLength': 45,
        };
      case 4:
        return {
          'minLength': 45,
          'maxLength': 60,
        };
      case 5:
        return {
          'minLength': 60,
          'maxLength': null,
        };
      default:
        return {
          'minLength': null,
          'maxLength': null,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final minLength = context
        .select<WorkoutFiltersBloc, Duration?>((b) => b.filters.minLength);

    final workoutSectionTypes =
        context.select<WorkoutFiltersBloc, List<WorkoutSectionType>>(
            (b) => b.filters.workoutSectionTypes);

    final hasClassVideo = context
        .select<WorkoutFiltersBloc, bool?>((b) => b.filters.hasClassVideo);

    final hasClassAudio = context
        .select<WorkoutFiltersBloc, bool?>((b) => b.filters.hasClassAudio);

    final difficultyLevel =
        context.select<WorkoutFiltersBloc, DifficultyLevel?>(
            (b) => b.filters.difficultyLevel);

    final workoutGoals = context.select<WorkoutFiltersBloc, List<WorkoutGoal>>(
        (b) => b.filters.workoutGoals);

    final _updateFilters = context.read<WorkoutFiltersBloc>().updateFilters;

    return ListView(
      padding: const EdgeInsets.all(4),
      children: [
        UserInputContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: MyHeaderText(
                  'Length (minutes)',
                ),
              ),
              const SizedBox(height: 16),
              GenericSelector(
                ids: const ['0', '1', '2', '3', '4', '5'],
                names: const [
                  'Any',
                  'Under 15',
                  '15 to 30',
                  '30 - 45',
                  '45 - 60',
                  'Over 60'
                ],
                select: (v) =>
                    _updateFilters(_intToMinLengthMaxLength(int.parse(v))),
                selectedIds: [_minLengthToInt(minLength).toString()],
              ),
            ],
          ),
        ),
        DifficultyLevelSelectorRow(
          difficultyLevel: difficultyLevel,
          updateDifficultyLevel: (difficultyLevel) =>
              _updateFilters({'difficultyLevel': difficultyLevel.apiValue}),
        ),
        WorkoutGoalsSelectorRow(
            selectedWorkoutGoals: workoutGoals,
            updateSelectedWorkoutGoals: (goals) => _updateFilters(
                {'workoutGoals': goals.map((t) => t.toJson()).toList()})),
        UserInputContainer(
          child: WorkoutSectionTypeMultiSelector(
            direction: Axis.horizontal,
            selectedTypes: workoutSectionTypes,
            updateSelectedTypes: (types) => _updateFilters(
                {'workoutSectionTypes': types.map((t) => t.toJson()).toList()}),
          ),
        ),
        UserInputContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: MyHeaderText(
                  'Class Video',
                ),
              ),
              const SizedBox(height: 16),
              GenericSelector(
                ids: const ['0', '1', '2'],
                names: const [
                  'With Video',
                  'No Video',
                  "Don't Mind",
                ],
                select: (v) => _updateFilters({
                  'hasClassVideo': DataUtils.intToNullableBool(int.parse(v))
                }),
                selectedIds: [
                  DataUtils.nullableBoolToInt(value: hasClassVideo).toString()
                ],
              ),
            ],
          ),
        ),
        UserInputContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: MyHeaderText(
                  'With Class Audio',
                ),
              ),
              const SizedBox(height: 16),
              GenericSelector(
                ids: const ['0', '1', '2'],
                names: const [
                  'With Audio',
                  'No Audio',
                  "Don't Mind",
                ],
                select: (v) => _updateFilters({
                  'hasClassAudio': DataUtils.intToNullableBool(int.parse(v))
                }),
                selectedIds: [
                  DataUtils.nullableBoolToInt(value: hasClassAudio).toString()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
