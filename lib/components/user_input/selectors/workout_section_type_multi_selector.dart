import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';

class WorkoutSectionTypeMultiSelector extends StatelessWidget {
  final String name;
  final void Function(List<WorkoutSectionType> types) updateSelectedTypes;
  final List<WorkoutSectionType> selectedTypes;
  final bool allowMultiSelect;

  /// If [Axis.vertical], physics will be set to [NeverScrollablePhysics]
  ///  If [Axis.horizontal] will display within a horizontal [Wrap]
  final Axis direction;
  final bool hideTitle;
  const WorkoutSectionTypeMultiSelector(
      {Key? key,
      required this.updateSelectedTypes,
      required this.selectedTypes,
      this.allowMultiSelect = true,
      this.name = 'Workout Types',
      this.direction = Axis.horizontal,
      this.hideTitle = false})
      : super(key: key);

  void _handleTap(WorkoutSectionType type) {
    if (allowMultiSelect) {
      updateSelectedTypes(selectedTypes.toggleItem<WorkoutSectionType>(type));
    } else {
      updateSelectedTypes([type]);
    }
  }

  List<Widget> _buildChildren(List<WorkoutSectionType> types) {
    return types
        .sortedBy<num>((type) => int.parse(type.id))
        .map((type) => Padding(
              padding: direction == Axis.vertical
                  ? const EdgeInsets.only(bottom: 8.0)
                  : EdgeInsets.zero,
              child: direction == Axis.vertical
                  ? SelectableBoxExpanded(
                      onPressed: () => _handleTap(type),
                      isSelected: selectedTypes.contains(type),
                      text: type.name,
                    )
                  : SelectableBox(
                      onPressed: () => _handleTap(type),
                      isSelected: selectedTypes.contains(type),
                      text: type.name,
                    ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final workoutSectionTypes = CoreDataRepo.workoutSectionTypes;

    return Column(
      children: [
        if (!hideTitle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyHeaderText(
                  name,
                ),
                if (allowMultiSelect)
                  MyText(
                    selectedTypes.isEmpty
                        ? 'All'
                        : '${selectedTypes.length} selected',
                    subtext: true,
                  )
              ],
            ),
          ),
        const SizedBox(height: 16),
        if (direction == Axis.vertical)
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildChildren(workoutSectionTypes),
          )
        else
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: _buildChildren(workoutSectionTypes),
          ),
      ],
    );
  }
}
