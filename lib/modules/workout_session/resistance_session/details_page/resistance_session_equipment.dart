import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/graphql_type_extensions.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';

class ResistanceSessionEquipment extends StatelessWidget {
  final ResistanceSession resistanceSession;
  const ResistanceSessionEquipment({Key? key, required this.resistanceSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moveDataRepo = context.watch<MoveDataRepo>();

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: resistanceSession
          .uniqueEquipments(moveDataRepo)
          .map((e) => EquipmentTile(
                equipment: e,
                iconSize: 40,
              ))
          .toList(),
    );
  }
}
