import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/animated/my_reorderable_list.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/workout_session/creator/blocs/resistance_session_bloc.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/display/resistance_exercise_display.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/edit/resistance_exercise_edit.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/resistance_exercise_generator.dart';

class ResistanceSessionEdit extends StatelessWidget {
  final ResistanceSession resistanceSession;
  final String workoutSessionId;
  const ResistanceSessionEdit(
      {Key? key,
      required this.resistanceSession,
      required this.workoutSessionId})
      : super(key: key);

  void _openGenerator(BuildContext context, ResistanceSessionBloc bloc) {
    context.push(child: ResistanceExerciseGenerator(onSave: (e) {
      e.sortPosition = resistanceSession.resistanceExercises.length;
      context.pop();
      bloc.createResistanceExercise(
          resistanceExercise: e,
          onFail: () => context.showToast(
              message: kDefaultErrorMessage, toastType: ToastType.destructive));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResistanceSessionBloc(
          initial: resistanceSession, workoutSessionId: workoutSessionId),
      builder: (context, child) {
        final bloc = context.watch<ResistanceSessionBloc>();
        final session = bloc.resistanceSession;

        final sortedExercises =
            session.resistanceExercises.sortedBy<num>((e) => e.sortPosition);

        return MyPageScaffold(
            navigationBar: MyNavBar(
              withoutLeading: true,
              middle: const LeadingNavBarTitle(
                'Resistance',
              ),
              trailing: NavBarSaveButton(
                context.pop,
              ),
            ),
            child: FABPage(
              rowButtons: [
                FloatingButton(
                    icon: CupertinoIcons.add,
                    text: 'Add Set',
                    onTap: () => _openGenerator(context, bloc))
              ],
              child: FABPageList(
                children: [
                  UserInputContainer(
                    child: EditableTextAreaRow(
                      title: 'Notes',
                      text: session.note ?? '',
                      placeholder: 'Add note',
                      onSave: (text) =>
                          bloc.updateResistanceSession({'note': text}),
                      inputValidation: (t) => true,
                    ),
                  ),
                  MyReorderableList<ResistanceExercise>(
                    physics: const NeverScrollableScrollPhysics(),
                    items: sortedExercises,
                    itemBuilder: (context, index, item) => FadeIn(
                      key: Key(item.id),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(CupertinoPageRoute(
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
                          removeItem: (_) =>
                              bloc.deleteResistanceExercise(item.id),
                          secondaryActions: [
                            SlidableAction(
                              label: 'Copy',
                              padding: EdgeInsets.zero,
                              icon: CupertinoIcons.doc_on_doc,
                              backgroundColor: context.theme.primary,
                              foregroundColor: context.theme.background,
                              onPressed: (_) =>
                                  bloc.duplicateResistanceExercise(
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
      },
    );
  }
}
