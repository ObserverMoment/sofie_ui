import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class RepPickerDisplay extends StatelessWidget {
  final List<WorkoutMoveRepType> validRepTypes;
  final double reps;
  final void Function(double reps) updateReps;
  final WorkoutMoveRepType repType;
  final void Function(WorkoutMoveRepType repType) updateRepType;
  final DistanceUnit distanceUnit;
  final void Function(DistanceUnit distanceUnit) updateDistanceUnit;
  final TimeUnit timeUnit;
  final void Function(TimeUnit timeUnit) updateTimeUnit;
  final bool expandPopup;
  final FONTSIZE valueFontSize;
  final FONTSIZE suffixFontSize;

  const RepPickerDisplay(
      {Key? key,
      required this.validRepTypes,
      required this.reps,
      required this.updateReps,
      required this.repType,
      required this.updateRepType,
      required this.distanceUnit,
      required this.updateDistanceUnit,
      required this.timeUnit,
      required this.updateTimeUnit,
      this.expandPopup = false,
      this.valueFontSize = FONTSIZE.nine,
      this.suffixFontSize = FONTSIZE.five})
      : super(key: key);

  Widget _buildRepTypeDisplay() {
    switch (repType) {
      case WorkoutMoveRepType.distance:
        return MyText(
          describeEnum(distanceUnit),
          size: suffixFontSize,
        );
      case WorkoutMoveRepType.time:
        return MyText(
          describeEnum(timeUnit),
          size: suffixFontSize,
        );
      case WorkoutMoveRepType.reps:
        return MyText(
          reps == 1 ? 'rep' : 'reps',
          size: suffixFontSize,
        );
      case WorkoutMoveRepType.calories:
        return MyText(
          reps == 1 ? 'cal' : 'cals',
          size: suffixFontSize,
        );
      default:
        return MyText(
          describeEnum(repType),
          size: suffixFontSize,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.showBottomSheet(
          expand: expandPopup,
          child: RepPickerModal(
            reps: reps,
            updateReps: updateReps,
            repType: repType,
            validRepTypes: validRepTypes,
            updateRepType: updateRepType,
            distanceUnit: distanceUnit,
            updateDistanceUnit: updateDistanceUnit,
            timeUnit: timeUnit,
            updateTimeUnit: updateTimeUnit,
          )),
      child: ContentBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              reps.stringMyDouble(),
              size: valueFontSize,
            ),
            const SizedBox(
              width: 4,
            ),
            _buildRepTypeDisplay(),
          ],
        ),
      ),
    );
  }
}

class RepPickerModal extends StatefulWidget {
  final double reps;
  final void Function(double reps) updateReps;
  final List<WorkoutMoveRepType> validRepTypes;
  final WorkoutMoveRepType repType;
  final void Function(WorkoutMoveRepType repType) updateRepType;
  final DistanceUnit distanceUnit;
  final void Function(DistanceUnit distanceUnit) updateDistanceUnit;
  final TimeUnit timeUnit;
  final void Function(TimeUnit timeUnit) updateTimeUnit;
  const RepPickerModal({
    Key? key,
    required this.reps,
    required this.updateReps,
    required this.validRepTypes,
    required this.repType,
    required this.updateRepType,
    required this.distanceUnit,
    required this.updateDistanceUnit,
    required this.timeUnit,
    required this.updateTimeUnit,
  }) : super(key: key);

  @override
  _RepPickerModalState createState() => _RepPickerModalState();
}

class _RepPickerModalState extends State<RepPickerModal> {
  late TextEditingController _repsController;
  late double _activeReps;
  late WorkoutMoveRepType _activeRepType;
  late DistanceUnit _activeDistanceUnit;
  late TimeUnit _activeTimeUnit;

  @override
  void initState() {
    _activeReps = widget.reps;
    _activeRepType = widget.repType;
    _activeDistanceUnit = widget.distanceUnit;
    _activeTimeUnit = widget.timeUnit;

    _repsController = TextEditingController(text: widget.reps.stringMyDouble());
    _repsController.selection = TextSelection(
        baseOffset: 0, extentOffset: _repsController.value.text.length);
    _repsController.addListener(() {
      if (Utils.textNotNull(_repsController.text)) {
        setState(() => _activeReps = double.parse(_repsController.text));
      }
    });
    super.initState();
  }

  void _saveChanges() {
    if (_activeReps != widget.reps) {
      widget.updateReps(_activeReps);
    }
    if (_activeRepType != widget.repType) {
      widget.updateRepType(_activeRepType);
    }
    if (_activeDistanceUnit != widget.distanceUnit) {
      widget.updateDistanceUnit(_activeDistanceUnit);
    }
    if (_activeTimeUnit != widget.timeUnit) {
      widget.updateTimeUnit(_activeTimeUnit);
    }
    context.pop();
  }

  @override
  void dispose() {
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
      cancel: context.pop,
      save: _saveChanges,
      validToSave: Utils.textNotNull(_repsController.text),
      title: 'Reps',
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.validRepTypes.length > 1)
                  MySlidingSegmentedControl<WorkoutMoveRepType>(
                      value: _activeRepType,
                      fontSize: 15,
                      containerPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 2),
                      childPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
                      children: {
                        for (final v in WorkoutMoveRepType.values.where((v) =>
                            v != WorkoutMoveRepType.artemisUnknown &&
                            widget.validRepTypes.contains(v)))
                          v: v.display
                      },
                      updateValue: (repType) =>
                          setState(() => _activeRepType = repType)),
              ],
            ),
            FadeIn(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MyNumberInput(
                  _repsController,
                  autoFocus: true,
                  allowDouble: _activeRepType != WorkoutMoveRepType.time,
                ),
              ),
            ),
            if (_activeRepType == WorkoutMoveRepType.time)
              MySlidingSegmentedControl<TimeUnit>(
                  value: _activeTimeUnit,
                  fontSize: 15,
                  children: {
                    for (final v in TimeUnit.values
                        .where((v) => v != TimeUnit.artemisUnknown))
                      v: describeEnum(v)
                  },
                  updateValue: (timeUnit) =>
                      setState(() => _activeTimeUnit = timeUnit)),
            if ([WorkoutMoveRepType.calories, WorkoutMoveRepType.reps]
                .contains(_activeRepType))
              FadeIn(child: MyText(_activeRepType.display)),
            if (_activeRepType == WorkoutMoveRepType.distance)
              FadeIn(
                child: MySlidingSegmentedControl<DistanceUnit>(
                    value: _activeDistanceUnit,
                    containerPadding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                    childPadding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8),
                    fontSize: 14,
                    children: {
                      for (final v in DistanceUnit.values
                          .where((v) => v != DistanceUnit.artemisUnknown))
                        v: v.display
                    },
                    updateValue: (distanceUnit) =>
                        setState(() => _activeDistanceUnit = distanceUnit)),
              )
          ],
        ),
      ),
    );
  }
}

/// User can pick from hours, minutes or seconds and dial in the number they want to work for.
class RepTimePicker extends StatelessWidget {
  final double reps;
  final void Function(double reps) updateReps;
  final TimeUnit timeUnit;
  final void Function(TimeUnit timeUnit) updateTimeUnit;
  const RepTimePicker(
      {Key? key,
      required this.reps,
      required this.updateReps,
      required this.timeUnit,
      required this.updateTimeUnit})
      : super(key: key);

  int get maxInput => 500;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            height: 180,
            width: 200,
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: min(reps.toInt(), maxInput) - 1),
                itemExtent: 35,
                onSelectedItemChanged: (index) => updateReps(index + 1),
                children: List<Widget>.generate(maxInput - 1,
                    (i) => Center(child: H3((i + 1).toString()))))),
        MySlidingSegmentedControl<TimeUnit>(
            value: timeUnit,
            fontSize: 15,
            children: {
              for (final v
                  in TimeUnit.values.where((v) => v != TimeUnit.artemisUnknown))
                v: describeEnum(v)
            },
            updateValue: (timeUnit) => updateTimeUnit(timeUnit)),
      ],
    );
  }
}
