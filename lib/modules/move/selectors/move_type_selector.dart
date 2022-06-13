import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';

class MoveTypeSelector extends StatelessWidget {
  final MoveType? moveType;
  final void Function(MoveType updated) updateMoveType;
  const MoveTypeSelector(
      {Key? key, required this.moveType, required this.updateMoveType})
      : super(key: key);

  void _handleSelectMoveType(BuildContext context, MoveType moveType) {
    updateMoveType(moveType);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final moveTypes = CoreDataRepo.moveTypes;

    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: context.pop,
              child: const MyText(
                'Done',
                weight: FontWeight.bold,
              )),
          middle: const NavBarTitle('Move Types'),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: moveTypes
                .map((type) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SelectableBoxExpanded(
                        onPressed: () => _handleSelectMoveType(context, type),
                        text: type.name,
                        isSelected: moveType == type,
                        height: 50,
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}
