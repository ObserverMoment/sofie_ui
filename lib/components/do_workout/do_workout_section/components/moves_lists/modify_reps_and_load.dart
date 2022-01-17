import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

//// NOTE: As of 17.01.22 this is no longer being used in the Lifting Moves List.
class ModifyMove extends StatefulWidget {
  final WorkoutMove workoutMove;
  final void Function(WorkoutMove workoutMove) updateWorkoutMove;
  const ModifyMove({
    Key? key,
    required this.workoutMove,
    required this.updateWorkoutMove,
  }) : super(key: key);

  @override
  State<ModifyMove> createState() => ModifyMoveState();
}

class ModifyMoveState extends State<ModifyMove> {
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  late LoadUnit _loadUnit;

  @override
  void initState() {
    _repsController.text = widget.workoutMove.reps.round().toString();
    _loadController.text = widget.workoutMove.loadAmount.stringMyDouble();
    _loadUnit = widget.workoutMove.loadUnit;
    super.initState();
  }

  void _saveAndUpdateWorkoutMove() {
    final updated = WorkoutMove.fromJson(widget.workoutMove.toJson());
    updated.reps = double.parse(_repsController.text);
    updated.loadAmount = double.parse(_loadController.text);
    updated.loadUnit = _loadUnit;

    widget.updateWorkoutMove(updated);
    context.pop();
  }

  @override
  void dispose() {
    _repsController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enableLoadAdjust = widget.workoutMove.loadAdjustable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText(
                'Modify Set',
                size: FONTSIZE.four,
              ),
              TertiaryButton(
                onPressed: context.pop,
                text: 'Cancel',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText('Reps'),
              const SizedBox(width: 16),
              SizedBox(
                width: 160,
                child: MyNumberInput(
                  _repsController,
                  key: const Key('modify-move-reps'),
                  textSize: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ],
          ),
        ),
        if (enableLoadAdjust)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyHeaderText('Load'),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 160,
                      child: MyNumberInput(
                        _loadController,
                        key: const Key('modify-move-load'),
                        allowDouble: true,
                        textSize: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MySlidingSegmentedControl<LoadUnit>(
                        value: _loadUnit,
                        fontSize: 14,
                        containerPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        childPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        children: {
                          for (final v in LoadUnit.values
                              .where((v) => v != LoadUnit.artemisUnknown))
                            v: v.display
                        },
                        updateValue: (loadUnit) =>
                            setState(() => _loadUnit = loadUnit)),
                  ],
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: PrimaryButton(
            onPressed: _saveAndUpdateWorkoutMove,
            text: 'Save',
          ),
        ),
      ],
    );
  }
}
