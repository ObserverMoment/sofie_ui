import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutPlanMediaInfo extends StatelessWidget {
  const WorkoutPlanMediaInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          const InfoPageText(
            'You can provide a cover image, an intro video and an intro audio file for each plan that you create.',
          ),
          spacer,
          const InfoPageText(
            'Introduce yourself, walk through the plan overview, give tips, motivate, lay down some challenges, whatever you want. This media will be displayed on the plan details pages for people to see.',
          ),
        ],
      ),
    );
  }
}
