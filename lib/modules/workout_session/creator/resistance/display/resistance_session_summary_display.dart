import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/workout_session/creator/blocs/workout_session_bloc.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class ResistanceSessionSummaryDisplay extends StatelessWidget {
  final ResistanceSession resistanceSession;
  final WorkoutSession workoutSession;
  final WorkoutSessionBloc workoutSessionBloc;
  const ResistanceSessionSummaryDisplay(
      {Key? key,
      required this.resistanceSession,
      required this.workoutSessionBloc,
      required this.workoutSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = workoutSession.childrenOrder.indexOf(resistanceSession.id);

    /// Move up = make index smaller
    /// Move down = make index larger
    final canMoveUp = index > 0;
    final canMoveDown = index < workoutSession.childrenOrder.length - 1;
    return Card(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const MyHeaderText('Resistance'),
            Row(
              children: [
                if (canMoveUp)
                  IconButton(
                      size: 18,
                      iconData: CupertinoIcons.arrow_up,
                      onPressed: () {
                        workoutSessionBloc.updateWorkoutSession(
                            workoutSession: workoutSession,
                            data: {
                              'childrenOrder': workoutSession.childrenOrder
                                  .reorderItemInList<String>(index, index - 1)
                            });
                      }),
                if (canMoveDown)
                  IconButton(
                      size: 18,
                      iconData: CupertinoIcons.arrow_down,
                      onPressed: () {
                        workoutSessionBloc.updateWorkoutSession(
                            workoutSession: workoutSession,
                            data: {
                              'childrenOrder': workoutSession.childrenOrder
                                  .reorderItemInList<String>(index, index + 1)
                            });
                      }),
                IconButton(
                    size: 18,
                    iconData: CupertinoIcons.delete_simple,
                    onPressed: () {
                      context.showConfirmDeleteDialog(
                          itemType: 'Resistance',
                          onConfirm: () {
                            workoutSessionBloc.deleteResistanceSession(
                                workoutSession: workoutSession,
                                resistanceSession: resistanceSession,
                                onFail: () => context.showToast(
                                    message: kDefaultErrorMessage,
                                    toastType: ToastType.destructive));
                          });
                    }),
              ],
            )
          ],
        ),
        MyText(resistanceSession.note ?? 'no note'),
        MyText(resistanceSession.resistanceExercises.length.toString()),
      ],
    ));
  }
}
