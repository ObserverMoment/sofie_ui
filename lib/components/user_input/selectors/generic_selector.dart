import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';

class GenericSelector extends StatelessWidget {
  final List<String> names;
  final List<String> ids;
  final List<String> selectedIds;
  final void Function(String id) select;
  final WrapAlignment alignment;
  const GenericSelector(
      {Key? key,
      required this.names,
      required this.select,
      required this.ids,
      required this.selectedIds,
      this.alignment = WrapAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        alignment: alignment,
        spacing: 10,
        runSpacing: 10,
        children: names
            .mapIndexed((i, name) => SelectableBox(
                isSelected: selectedIds.contains(ids[i]),
                onPressed: () => select(ids[i]),
                text: name))
            .toList());
  }
}
