import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class PersonalBestRepTypeInfo extends StatelessWidget {
  const PersonalBestRepTypeInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const MyHeaderText('AMRAP (As Many Reps As Possible)'),
            spacer,
            const InfoPageText(
              'A classic scored workout type. Just do as many of the specified reps as possible in the time allowed. This is usually used for workouts but you can also use this for single moves - "As many press-ups as you can in two minutes" - for example.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Fastest Time'),
            spacer,
            const InfoPageText(
              'Standard across most athletics events. You do some specified amount of work / move / set of moves as fast as you can. "200 squats as fast as possible" or "Run 400 metres as fast as possible".',
            ),
            spacer,
            spacer,
            const MyHeaderText('Max Load'),
            spacer,
            const InfoPageText(
              'One for the weight lifters! You would usually use this for your "1 rep max", "5 rep max" personal bests, but you can use it for any personal best where you want to monitor your weight increasing over time.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Reps Unbroken'),
            spacer,
            const InfoPageText(
              'Max unbroken pull ups, squats, assault bike calories. Wherever your aim is to build up muscle endurance and cardio resilience.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Time Unbroken'),
            spacer,
            const InfoPageText(
              'Great for things like holds, planks, hangs and other cardio moves where the aim is to stick it out for as long as possible.',
            ),
          ],
        ),
      ),
    );
  }
}
