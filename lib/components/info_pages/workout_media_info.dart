import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutMediaInfo extends StatelessWidget {
  const WorkoutMediaInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          const InfoPageText(
            'You can provide a cover image, an intro video and an intro audio file for each workout that you create.',
          ),
          spacer,
          const InfoPageText(
            'Introduce yourself, walk through the workout, give tips, motivate, lay down some challenges, whatever you want. This media will be displayed on the workout details pages for people to see.',
          ),
        ],
      ),
    );
  }
}
