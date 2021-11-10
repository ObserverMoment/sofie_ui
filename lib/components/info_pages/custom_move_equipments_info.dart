import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class CustomMoveEquipmentInfo extends StatelessWidget {
  const CustomMoveEquipmentInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          const MyHeaderText('Required'),
          spacer,
          const InfoPageText(
            'Any equipment that is necessary to be able to perform this move. For example, you need a jump rope to perform double unders.',
          ),
          spacer,
          spacer,
          const MyHeaderText('Selectable'),
          spacer,
          const InfoPageText(
            'NOTE: If you are only adding a single equipment to this list then that equipment should probably go under required equipment instead!',
          ),
          spacer,
          const InfoPageText(
            'When an athlete can perform a move with a range of different equipment those equipment should be listed here. For example you can perform a bicep curl with dumbell, barbell, kettlebell, bands etc.',
          ),
        ],
      ),
    );
  }
}
