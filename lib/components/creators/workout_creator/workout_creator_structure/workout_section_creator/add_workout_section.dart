import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/info_pages/workout_section_types_info.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_section_type_multi_selector.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// When adding a new section this screen opens to allow the user to select the section type and any required attributes for that section type. Should return a [WorkoutSection] which can then be passed to the bloc for creation.
class AddWorkoutSection extends StatefulWidget {
  final int sortPosition;
  final void Function(WorkoutSection workoutSection) addWorkoutSection;
  const AddWorkoutSection(
      {Key? key, required this.addWorkoutSection, required this.sortPosition})
      : super(key: key);

  @override
  _AddWorkoutSectionState createState() => _AddWorkoutSectionState();
}

class _AddWorkoutSectionState extends State<AddWorkoutSection> {
  WorkoutSection? _workoutSection;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_workoutSection != null) {
        setState(() => _workoutSection!.name = _nameController.text);
      }
    });
  }

  void _handleUpdateSelectedType(WorkoutSectionType type) {
    if (_workoutSection != null) {
      _workoutSection!.workoutSectionType = type;
    } else {
      _workoutSection = WorkoutSection()
        ..workoutSectionType = type
        ..workoutSets = []
        ..id = 'temp'
        ..rounds = 1
        ..timecap = 600
        ..sortPosition = widget.sortPosition;
    }

    if (type.name == kAMRAPName) {
      _openTimecapPicker();
    }
    setState(() {});
  }

  void _saveAndClose() {
    widget.addWorkoutSection(_workoutSection!);
    context.pop();
  }

  void _openTimecapPicker() {
    context.showBottomSheet(
        expand: false,
        child: DurationPicker(
            duration: _workoutSection?.timecap != null
                ? Duration(seconds: _workoutSection!.timecap)
                : const Duration(minutes: 10),
            title: 'AMRAP in how long?',
            updateDuration: (timecap) {
              _workoutSection!.timecap = timecap.inSeconds;
              setState(() {});
            }));
  }

  bool get _validToSubmit => _workoutSection != null;

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: const NavBarTitle('Add Section'),
        trailing: _validToSubmit
            ? FadeIn(
                child: NavBarSaveButton(_saveAndClose),
              )
            : null,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 46,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_workoutSection?.workoutSectionType != null)
                    FadeIn(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: WorkoutSectionTypeTag(
                        workoutSection: _workoutSection!,
                        fontSize: FONTSIZE.four,
                      ),
                    )),
                  const Positioned(
                    right: 0,
                    child:
                        InfoPopupButton(infoWidget: WorkoutSectionTypesInfo()),
                  )
                ],
              ),
            ),
          ),
          if (_workoutSection?.workoutSectionType != null)
            GrowIn(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 12),
              child: MyTextFormFieldRow(
                backgroundColor: context.theme.cardBackground,
                controller: _nameController,
                placeholder: 'Name (optional). E.g. Warm Up, Core',
                keyboardType: TextInputType.text,
                validator: () =>
                    _nameController.text.isNotEmpty &&
                    _nameController.text.length < 26,
                validationMessage: 'Max 25 characters',
              ),
            )),
          WorkoutSectionTypeMultiSelector(
            selectedTypes: _workoutSection?.workoutSectionType != null
                ? [_workoutSection!.workoutSectionType]
                : [],
            allowMultiSelect: false,
            direction: Axis.vertical,
            hideTitle: true,
            updateSelectedTypes: (types) => _handleUpdateSelectedType(types[0]),
          ),
        ],
      ),
    );
  }
}
