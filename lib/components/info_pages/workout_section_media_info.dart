import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutSectionMediaInfo extends StatelessWidget {
  const WorkoutSectionMediaInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          const MyHeaderText('Intro Video and Audio'),
          spacer,
          const InfoPageText(
            'These should be short promo / explainers for the section. Include an tips or anything the athlete should be aware of here.',
          ),
          spacer,
          spacer,
          const MyHeaderText('Class Video and Audio'),
          spacer,
          const InfoPageText(
            'These will play while the athlete is working out - they can be a classic "do along" style or they can just be motivational background. If you upload audio and video then the athlete can choose which style they prefer.',
          ),
        ],
      ),
    );
  }
}
