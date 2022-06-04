import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
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

        final sortedExercises = session.childrenOrder
            .map((id) =>
                session.resistanceExercises.firstWhere((e) => e.id == id))
            .toList();

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
                      title: 'Session Notes',
                      text: session.note ?? '',
                      placeholder: 'Add note',
                      onSave: (text) =>
                          bloc.updateResistanceSession({'note': text}),
                      inputValidation: (t) => true,
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: sortedExercises
                        .map(
                          (e) => FadeIn(
                            key: Key(e.id),
                            child: ResistanceExerciseDisplay(
                              resistanceExercise: e,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
