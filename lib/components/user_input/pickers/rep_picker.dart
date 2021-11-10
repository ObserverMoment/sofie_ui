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
      this.expandPopup = false})
      : super(key: key);

  Widget _buildRepTypeDisplay() {
    switch (repType) {
      case WorkoutMoveRepType.distance:
        return MyText(
          describeEnum(distanceUnit),
          size: FONTSIZE.five,
        );
      case WorkoutMoveRepType.time:
        return MyText(
          describeEnum(timeUnit),
          size: FONTSIZE.five,
        );
      case WorkoutMoveRepType.reps:
        return MyText(
          reps == 1 ? 'rep' : 'reps',
          size: FONTSIZE.five,
        );
      case WorkoutMoveRepType.calories:
        return MyText(
          reps == 1 ? 'cal' : 'cals',
          size: FONTSIZE.five,
        );
      default:
        return MyText(
          describeEnum(repType),
          size: FONTSIZE.five,
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
              size: FONTSIZE.nine,
            ),
            const SizedBox(
              width: 6,
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
                  SlidingSelect<WorkoutMoveRepType>(
                      value: _activeRepType,
                      children: {
                        for (final v in WorkoutMoveRepType.values.where((v) =>
                            v != WorkoutMoveRepType.artemisUnknown &&
                            widget.validRepTypes.contains(v)))
                          v: MyText(v.display)
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
              SlidingSelect<TimeUnit>(
                  value: _activeTimeUnit,
                  children: {
                    for (final v in TimeUnit.values
                        .where((v) => v != TimeUnit.artemisUnknown))
                      v: MyText(describeEnum(v))
                  },
                  updateValue: (timeUnit) =>
                      setState(() => _activeTimeUnit = timeUnit)),
            if ([WorkoutMoveRepType.calories, WorkoutMoveRepType.reps]
                .contains(_activeRepType))
              FadeIn(child: MyText(_activeRepType.display)),
            if (_activeRepType == WorkoutMoveRepType.distance)
              FadeIn(
                child: SlidingSelect<DistanceUnit>(
                    value: _activeDistanceUnit,
                    children: {
                      for (final v in DistanceUnit.values
                          .where((v) => v != DistanceUnit.artemisUnknown))
                        v: MyText(v.display)
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
        SlidingSelect<TimeUnit>(
            value: timeUnit,
            children: {
              for (final v
                  in TimeUnit.values.where((v) => v != TimeUnit.artemisUnknown))
                v: MyText(describeEnum(v))
            },
            updateValue: (timeUnit) => updateTimeUnit(timeUnit)),
      ],
    );
  }
}
