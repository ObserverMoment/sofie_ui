import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/animated/my_reorderable_list.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout/fab_page/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/layout/fab_page/floating_icon_button.dart';
import 'package:sofie_ui/components/layout/fab_page/floating_text_button.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/components/resistance_exercise_generator.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/display/resistance_exercise_display.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/edit/resistance_exercise_edit.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/resistance_workout_bloc.dart';

class ResistanceWorkoutEdit extends StatelessWidget {
  const ResistanceWorkoutEdit({
    Key? key,
  }) : super(key: key);

  void _openGenerator(BuildContext context, ResistanceWorkoutBloc bloc) {
    context.push(child: ResistanceExerciseGenerator(onSave: (e) {
      e.sortPosition = bloc.resistanceWorkout.resistanceExercises.length;
      context.pop();
      bloc.createResistanceExercise(
          resistanceExercise: e,
          onFail: () => context.showToast(
              message: kDefaultErrorMessage, toastType: ToastType.destructive));
    }));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ResistanceWorkoutBloc>();
    final workout = bloc.resistanceWorkout;

    final sortedExercises =
        workout.resistanceExercises.sortedBy<num>((e) => e.sortPosition);

    return MyPageScaffold(
        navigationBar: MyNavBar(
          automaticallyImplyLeading: false,
          middle: const LeadingNavBarTitle(
            'Resistance',
          ),
          trailing: NavBarSaveButton(
            context.pop,
          ),
        ),
        child: FABPage(
          rowButtons: [
            FloatingTextButton(
                icon: CupertinoIcons.add,
                text: 'Add Set',
                onTap: () => _openGenerator(context, bloc))
          ],
          child: FABPageList(
            children: [
              UserInputContainer(
                child: EditableTextFieldRow(
                  title: 'Name',
                  text: workout.name,
                  onSave: (text) =>
                      bloc.updateResistanceWorkout({'name': text}),
                  inputValidation: (t) => t.length > 2 && t.length <= 50,
                  maxChars: 50,
                  validationMessage: 'Required. Min 3 chars. max 50',
                ),
              ),
              UserInputContainer(
                child: EditableTextAreaRow(
                  title: 'Notes',
                  text: workout.note ?? '',
                  placeholder: 'Add note',
                  onSave: (text) =>
                      bloc.updateResistanceWorkout({'note': text}),
                  inputValidation: (t) => true,
                ),
              ),
              MyReorderableList<ResistanceExercise>(
                listPadding: const EdgeInsets.all(4),
                physics: const NeverScrollableScrollPhysics(),
                items: sortedExercises,
                itemBuilder: (context, index, item) => FadeIn(
                  key: Key(item.id),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ChangeNotifierProvider.value(
                        value: bloc,
                        child: ResistanceExerciseEdit(
                          resistanceExerciseId: item.id,
                        ),
                      ),
                    )),
                    child: AnimatedSlidable(
                      key: Key(item.id),
                      index: index,
                      itemType: 'Exercise',
                      removeItem: (_) => bloc.deleteResistanceExercise(item.id),
                      secondaryActions: [
                        SlidableAction(
                          label: 'Copy',
                          padding: EdgeInsets.zero,
                          icon: CupertinoIcons.doc_on_doc,
                          backgroundColor: context.theme.primary,
                          foregroundColor: context.theme.background,
                          onPressed: (_) => bloc.duplicateResistanceExercise(
                              resistanceExercise: item,
                              onFail: () => context.showToast(
                                  message: kDefaultErrorMessage,
                                  toastType: ToastType.destructive)),
                        ),
                      ],
                      child: ResistanceExerciseDisplay(
                        resistanceExercise: item,
                      ),
                    ),
                  ),
                ),
                reorderItems: (_, to, __, movedItem) {
                  bloc.reorderResistanceExercise(movedItem.id, to);
                },
              ),
            ],
          ),
        ));
  }
}
