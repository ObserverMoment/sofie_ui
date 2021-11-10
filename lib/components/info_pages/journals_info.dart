import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class JournalsInfo extends StatelessWidget {
  const JournalsInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const InfoPageText(
              'Our journals let you do a number of things that will help you on your way on your fitness journey. You can create multiple journals if you need to, for different aspects of your journey.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Journaling'),
            spacer,
            const InfoPageText(
              'It has been shown that the acts of reflecting on and recording how you are feeling regulary are incredibly beneficial for maintaining a positive stable mental and emotional condition. The act of noting experiences, whether they be good or bad, helps to frame them objectively and allows you to evaluate them in a more rational way. Our journals let you take notes (voice or text) and record your emotional fluctuations over time - letting you notice trends and avoid downward spirals - leading to a better understanding of your own unique mental characteristics.',
            ),
            spacer,
            spacer,
            const MyHeaderText('Goals'),
            spacer,
            const InfoPageText(
              'Settings goals is an important part of being able to measure your progress. Thinking about where you want to be and when you would like to be there gives you targets to strive for, and lets you check off concrete achievements over time. Be realistic and ensure that goals are not so big as to be daunting! Lots of small goals is better than one massive one.',
            ),
          ],
        ),
      ),
    );
  }
}
