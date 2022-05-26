import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/model/enum.dart';

class TrialSelector extends StatelessWidget {
  final TrialType? trialType;
  final Function(TrialType trialType) setTrialType;
  final void Function() goToEnterDetails;
  const TrialSelector(
      {Key? key,
      this.trialType,
      required this.setTrialType,
      required this.goToEnterDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () => setTrialType(TrialType.basic),
              child: TrialSelectorBox(
                name: 'BASIC',
                cost: 4.99,
                isSelected: trialType == TrialType.basic,
                content: Column(
                  children: const [
                    MyText('Feature 1'),
                    MyText('Feature 2'),
                    MyText('Feature 3'),
                    MyText('Feature 4'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setTrialType(TrialType.pro),
              child: TrialSelectorBox(
                name: 'PRO',
                cost: 9.99,
                isSelected: trialType == TrialType.pro,
                content: Column(
                  children: const [
                    MyText('All from BASIC +'),
                    MyText('Feature a'),
                    MyText('Feature b'),
                    MyText('Feature c'),
                  ],
                ),
              ),
            ),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: MyText(
            'Free for 3 months, then billed monthly',
            size: FONTSIZE.two,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: MyText(
            'Cancel anytime.',
            size: FONTSIZE.two,
          ),
        ),
        const SizedBox(height: 8),
        if (trialType != null)
          FadeIn(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: PrimaryButton(
                onPressed: goToEnterDetails,
                text: 'Continue',
              ),
            ),
          ),
      ],
    );
  }
}

class TrialSelectorBox extends StatelessWidget {
  final String name;
  final double cost;
  final Widget content;
  final bool isSelected;
  const TrialSelectorBox(
      {Key? key,
      required this.name,
      required this.cost,
      required this.content,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 3,
                    color: isSelected
                        ? ThemeData.cupertinoDarkData.primaryContrastingColor
                        : ThemeData.cupertinoDarkData.primaryColor
                            .withOpacity(0.4))),
            padding: const EdgeInsets.all(10),
            width: 160,
            child: Column(
              children: [
                H1(name),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: content,
                ),
                MyText('£${cost.toString()} / month',
                    weight: FontWeight.bold, size: FONTSIZE.four),
              ],
            )),
        if (isSelected)
          Positioned(
              top: 5,
              right: 5,
              child: FadeIn(
                  child: Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: ThemeData.cupertinoDarkData.primaryContrastingColor,
              )))
      ],
    );
  }
}
