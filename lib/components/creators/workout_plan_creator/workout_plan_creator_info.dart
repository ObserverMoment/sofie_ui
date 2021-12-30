import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_plan_creator_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/number_picker_row_tap_to_edit.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/selectors/content_access_scope_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_tags_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutPlanCreatorInfo extends StatelessWidget {
  const WorkoutPlanCreatorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _updateWorkoutPlanInfo =
        context.read<WorkoutPlanCreatorBloc>().updateWorkoutPlanInfo;

    final workoutPlanData = context
        .select<WorkoutPlanCreatorBloc, WorkoutPlan>((b) => b.workoutPlan);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            UserInputContainer(
                child: IntPickerRowTapToEdit(
              value: workoutPlanData.lengthWeeks,
              min: 1,
              max: 52,
              saveValue: (lengthWeeks) {
                if (lengthWeeks < workoutPlanData.lengthWeeks) {
                  context.showConfirmDialog(
                      title: 'Reduce Length of Plan?',
                      message:
                          'If you have planned workouts in later weeks will be deleted. OK?',
                      onConfirm: () => context
                          .read<WorkoutPlanCreatorBloc>()
                          .reduceWorkoutPlanlength(lengthWeeks));
                } else {
                  _updateWorkoutPlanInfo({'lengthWeeks': lengthWeeks});
                }
              },
              title: 'Plan Length',
              suffix: 'weeks',
            )),
            UserInputContainer(
                child: IntPickerRowTapToEdit(
              value: workoutPlanData.daysPerWeek,
              min: 1,
              max: 7,
              saveValue: (daysPerWeek) =>
                  _updateWorkoutPlanInfo({'daysPerWeek': daysPerWeek}),
              title: 'Days Per Week',
              suffix: 'days / week',
            )),
            UserInputContainer(
              child: EditableTextFieldRow(
                title: 'Name',
                text: workoutPlanData.name,
                onSave: (text) => _updateWorkoutPlanInfo({'name': text}),
                inputValidation: (t) => t.length > 2 && t.length <= 50,
                maxChars: 50,
                validationMessage: 'Required. Min 3 chars. max 50',
              ),
            ),
            UserInputContainer(
              child: EditableTextAreaRow(
                title: 'Description',
                text: workoutPlanData.description ?? '',
                placeholder: 'Add',
                onSave: (text) => _updateWorkoutPlanInfo({'description': text}),
                inputValidation: (t) => true,
                maxDisplayLines: 2,
              ),
            ),
            WorkoutTagsSelectorRow(
              selectedWorkoutTags: workoutPlanData.workoutTags,
              updateSelectedWorkoutTags: (tags) => _updateWorkoutPlanInfo(
                  {'WorkoutTags': tags.map((t) => t.toJson()).toList()}),
            ),
            ContentAccessScopeSelector(
                contentAccessScope: workoutPlanData.contentAccessScope,
                updateContentAccessScope: (scope) => _updateWorkoutPlanInfo(
                    {'contentAccessScope': scope.apiValue}))
          ],
        ),
      ),
    );
  }
}
