import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/info_pages/workout_section_types_info.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/selectors/workout_section_type_multi_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// This screen is for when the user is changing the section type - to ensure that correct fields are copied or removed - as required depending on the type. Pass [previousSection] for this.
class ChangeSectionType extends StatefulWidget {
  final WorkoutSection previousSection;
  final void Function(WorkoutSection workoutSection) updatedWorkoutSection;
  const ChangeSectionType(
      {Key? key,
      required this.previousSection,
      required this.updatedWorkoutSection})
      : super(key: key);

  @override
  _ChangeSectionTypeState createState() => _ChangeSectionTypeState();
}

class _ChangeSectionTypeState extends State<ChangeSectionType> {
  late WorkoutSection _workoutSection;

  @override
  void initState() {
    super.initState();
    _workoutSection = WorkoutSection.fromJson(widget.previousSection.toJson());
  }

  void _handleUpdateSelectedType(WorkoutSectionType type) {
    _workoutSection.workoutSectionType = type;

    if (type.isAMRAP) {
      _openTimecapPicker();
    } else if (type.isLifting || type.isCustom) {
      /// Always reset to 1 for these workout types.
      _workoutSection.rounds = 1;
    }
    setState(() {});
  }

  void _openTimecapPicker() {
    context.showActionSheetPopup(
        child: DurationPicker(
            duration: Duration(seconds: _workoutSection.timecap),
            title: 'AMRAP in how long?',
            mode: CupertinoTimerPickerMode.hm,
            updateDuration: (timecap) {
              _workoutSection.timecap = timecap.inSeconds;
              setState(() {});
            }));
  }

  void _saveAndClose() {
    widget.updatedWorkoutSection(_workoutSection);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: const NavBarTitle('Change Section Type'),
        trailing: NavBarTertiarySaveButton(_saveAndClose),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: WorkoutSectionTypeTag(
                    workoutSection: _workoutSection,
                    fontSize: FONTSIZE.four,
                    showMediaIcons: false,
                  ),
                ),
                const InfoPopupButton(infoWidget: WorkoutSectionTypesInfo())
              ],
            ),
          ),
          WorkoutSectionTypeMultiSelector(
            selectedTypes: [_workoutSection.workoutSectionType],
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
