import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_sessions/resistance_session/components/resistance_rep_type_selector.dart';
import 'package:sofie_ui/modules/workout_sessions/resistance_session/resistance_session_bloc.dart';

class ResistanceSetEdit extends StatelessWidget {
  final ResistanceExercise resistanceExercise;
  final ResistanceSet resistanceSet;
  const ResistanceSetEdit(
      {Key? key, required this.resistanceSet, required this.resistanceExercise})
      : super(key: key);

  void _handleMoveUpdate(BuildContext context, Move move) {
    final prevEquipmentIsValid =
        move.selectableEquipments.contains(resistanceSet.equipment);

    context.read<ResistanceSessionBloc>().updateResistanceSet(
        resistanceExercise.id,
        resistanceSet.id,
        prevEquipmentIsValid
            ? {'Move': move.toJson()}
            : {
                'Move': move.toJson(),
                'Equipment': move.selectableEquipments.isNotEmpty
                    ? move.selectableEquipments[0].toJson()
                    : null
              });

    context.pop();
  }

  void _handleEquipmentUpdate(BuildContext context, Equipment? equipment) {
    context.read<ResistanceSessionBloc>().updateResistanceSet(
        resistanceExercise.id,
        resistanceSet.id,
        {'Equipment': equipment?.toJson()});
  }

  void _handleRepTypeUpdate(
      BuildContext context, ResistanceSetRepType repType) {
    context.read<ResistanceSessionBloc>().updateResistanceSet(
        resistanceExercise.id, resistanceSet.id, {'repType': repType.apiValue});
  }

  void _handleRepsUpdate(BuildContext context, List<int> updatedReps) {
    context.read<ResistanceSessionBloc>().updateResistanceSet(
        resistanceExercise.id, resistanceSet.id, {'reps': updatedReps});
  }

  @override
  Widget build(BuildContext context) {
    final reps = resistanceSet.reps;
    final setsPerMove = reps.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 2,
            runSpacing: 6,
            children: [
              GestureDetector(
                onTap: () => context.push(
                    fullscreenDialog: true,
                    child: MoveSelector(
                      pageTitle: 'Change Move',
                      selectMove: (move) => _handleMoveUpdate(context, move),
                      onCancel: context.pop,
                    )),
                child: Card(
                  child: MyText(
                    resistanceSet.move.name,
                  ),
                ),
              ),
              if (resistanceSet.move.selectableEquipments.isNotEmpty)
                GestureDetector(
                  onTap: () => context.push(
                      fullscreenDialog: true,
                      child: FullScreenEquipmentSelector(
                        allowMultiSelect: false,
                        selectedEquipments: resistanceSet.equipment != null
                            ? [resistanceSet.equipment!]
                            : [],
                        allEquipments: resistanceSet.move.selectableEquipments,
                        handleSelection: (e) => _handleEquipmentUpdate(
                            context, e.isNotEmpty ? e[0] : null),
                      )),
                  child: Card(
                    child: MyText(
                      resistanceSet.equipment != null
                          ? resistanceSet.equipment!.name
                          : 'select equipment',
                      subtext: resistanceSet.equipment == null,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                ResistanceRepTypeSelector(
                  height: 36,
                  resistanceSetRepType: resistanceSet.repType,
                  updateResistanceSetRepType: (repType) =>
                      _handleRepTypeUpdate(context, repType),
                ),
                ...List.generate(
                  setsPerMove,
                  (i) => SizedBox(
                    width: 70,
                    child: MyStatefulNumberInput(
                      padding: const EdgeInsets.all(8),
                      initialValue: reps[i],
                      update: (r) {
                        final updatedReps = [...reps];
                        updatedReps[i] = r.toInt();
                        _handleRepsUpdate(context, updatedReps);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
