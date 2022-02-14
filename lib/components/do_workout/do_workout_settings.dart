import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/number_picker_modal.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:provider/provider.dart';

class DoWorkoutSettings extends StatelessWidget {
  const DoWorkoutSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enableWakelock =
        context.select<DoWorkoutBloc, bool>((b) => b.activeWakelockSetting);
    final countdownToStartSeconds =
        context.select<DoWorkoutBloc, int>((b) => b.countdownToStartSeconds);

    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarChevronDownButton(context.pop),
        middle: const NavBarTitle('Workout Settings'),
      ),
      child: ListView(
        children: [
          UserInputContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoSwitchRow(
                    title: 'Workout Mode',
                    updateValue: (v) =>
                        context.read<DoWorkoutBloc>().toggleWakelock(v),
                    value: enableWakelock),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: MyText(
                    'When in Workout Mode your screen will not sleep when you are training.',
                    maxLines: 3,
                    size: FONTSIZE.two,
                  ),
                )
              ],
            ),
          ),
          UserInputContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: TappableRow(
                  onTap: () => context.showActionSheetPopup(
                          child: NumberPickerModal(
                        initialValue: countdownToStartSeconds,
                        min: 1,
                        max: 20,
                        saveValue: (seconds) => context
                            .read<DoWorkoutBloc>()
                            .adjustCountdownToStartSeconds(seconds),
                        title: 'Seconds',
                      )),
                  display: Row(
                    children: [
                      ContentBox(
                        child: MyText(
                          countdownToStartSeconds.toString(),
                          size: FONTSIZE.six,
                          weight: FontWeight.bold,
                          lineHeight: 1.2,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const MyText('seconds')
                    ],
                  ),
                  title: 'Countdown to Start'),
            ),
          ),
        ],
      ),
    );
  }
}
