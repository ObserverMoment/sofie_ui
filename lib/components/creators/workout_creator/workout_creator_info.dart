import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/selectors/content_access_scope_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_goals_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_tags_selector.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutCreatorInfo extends StatelessWidget {
  const WorkoutCreatorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _updateWorkoutMeta =
        context.read<WorkoutCreatorBloc>().updateWorkoutInfo;

    final workoutData =
        context.select<WorkoutCreatorBloc, Workout>((b) => b.workout);

    return ListView(
      shrinkWrap: true,
      children: [
        UserInputContainer(
          child: EditableTextFieldRow(
            title: 'Name',
            text: workoutData.name,
            onSave: (text) => _updateWorkoutMeta({'name': text}),
            inputValidation: (t) => t.length > 2 && t.length <= 50,
            maxChars: 50,
            validationMessage: 'Required. Min 3 chars. max 50',
          ),
        ),
        UserInputContainer(
          child: EditableTextAreaRow(
            title: 'Description',
            text: workoutData.description ?? '',
            onSave: (text) => _updateWorkoutMeta({'description': text}),
            inputValidation: (t) => true,
          ),
        ),
        DurationPickerRowDisplay(
          duration: workoutData.lengthMinutes != null
              ? Duration(minutes: workoutData.lengthMinutes!)
              : null,
          updateDuration: (d) =>
              _updateWorkoutMeta({'lengthMinutes': d.inMinutes}),
        ),
        WorkoutGoalsSelectorRow(
            selectedWorkoutGoals: workoutData.workoutGoals,
            max: 2,
            updateSelectedWorkoutGoals: (goals) => _updateWorkoutMeta(
                {'WorkoutGoals': goals.map((g) => g.toJson()).toList()})),
        WorkoutTagsSelectorRow(
          selectedWorkoutTags: workoutData.workoutTags,
          updateSelectedWorkoutTags: (tags) => _updateWorkoutMeta(
              {'WorkoutTags': tags.map((t) => t.toJson()).toList()}),
        ),
        ContentAccessScopeSelector(
            contentAccessScope: workoutData.contentAccessScope,
            updateContentAccessScope: (scope) =>
                _updateWorkoutMeta({'contentAccessScope': scope.apiValue}))
      ],
    );
  }
}
