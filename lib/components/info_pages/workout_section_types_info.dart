import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutSectionTypesInfo extends StatelessWidget {
  const WorkoutSectionTypesInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const MyHeaderText('HIIT Circuit'),
            spacer,
            const InfoPageText(
              'High Intensity Interval Training. HIIT Circuits have "stations", and you spend a fixed amount of time doing a move or set of moves at each station before moving onto the next one.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Lifting'),
            spacer,
            const InfoPageText(
              'Strength training that is usually structured as sets and reps. Do classic style sets such such as 3 x 10, 5 x 5 or pyramids. A great workout type which also allows you to really concentrate on specifics.',
            ),
            spacer,
            spacer,
            const MyHeaderText('AMRAP (As Many Reps as Possible)'),
            spacer,
            const InfoPageText(
              'This is a scored / competitive workout type. Given a fixed amount of time (a timecap) your aim is to complete as many reps and rounds of the set of specified moves as possible. Your score at the end will be the number of reps that you managed to complete.',
            ),
            spacer,
            spacer,
            const MyHeaderText('For Time'),
            spacer,
            const InfoPageText(
              'This is a scored / competitive workout type where you try to complete everything in the section as fast as possible. Your "score" at the end is the time that you took. It is a race against yourself or others!',
            ),
            spacer,
            spacer,
            const MyHeaderText('EMOM (Every Minute On the Minute)'),
            spacer,
            const InfoPageText(
              'A fun workout type where you have to complete sets of moves in fixed periods of time - which usually starts of easy and then gets progressively harder as fatigue starts to hit you! The classic time period is the minute, but actually you can set your period length to be whatever you want.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Tabata Style'),
            spacer,
            const InfoPageText(
              'Tabata is a workout type where you alternative short sets of high intensity work with rest. The classic design is for you to go all out for 20 seconds and then rest for 10 seconds, and then repeat this 8 times for a total of 4 minutes. Of course, you can decide to use whatever time periods you want!',
            ),
            spacer,
            spacer,
            const MyHeaderText('Custom'),
            spacer,
            const InfoPageText(
              'Unstructured section of the workout where you can add anything that you like. When doing this section you can also add and remove parts of it in real time. Use this for your custom freestyle gym sessions.',
            ),
            spacer,
            spacer,
          ],
        ),
      ),
    );
  }
}
