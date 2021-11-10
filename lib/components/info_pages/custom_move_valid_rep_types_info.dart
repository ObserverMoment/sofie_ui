import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class CustomMoveValidRepTypesInfo extends StatelessWidget {
  const CustomMoveValidRepTypesInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const InfoPageText(
              'Different moves can be quantified in different ways.',
            ),
            const MyHeaderText('Time'),
            spacer,
            const InfoPageText(
              'All moves can be performed for a set amount of time, so "time" is selected by default',
            ),
            spacer,
            spacer,
            const MyHeaderText('Reps'),
            spacer,
            const InfoPageText(
              'This is the standard way to specify how much of a move should be done. "Do 10 reps of bench press". Most moves can be counted in reps but some may be better counted in other ways - for example "10 metres sandbag carry" - distance, or "plank hold for 30 seconds" - time.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Distance'),
            spacer,
            const InfoPageText(
              'A standard way to measure cardio moves like running or cycling, this could also be used for carry moves or any move where you are covering ground, such as lunges or jumps.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Calories'),
            spacer,
            const InfoPageText(
              'Some equipment can use calories to indicate work done - concept 2 rowing machines and assault bikes for example. This setting could also be useful if athletes have some calorie measuring tech that they prefer to use.',
            ),
            spacer,
          ],
        ),
      ),
    );
  }
}
