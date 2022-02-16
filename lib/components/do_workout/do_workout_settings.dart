import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/number_picker_modal.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:provider/provider.dart';

class DoWorkoutSettings extends StatelessWidget {
  const DoWorkoutSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enableWakelock = context.select<DoWorkoutBloc, bool>(
        (b) => b.userWorkoutSettingsBloc.settings.activeWakelockSetting);

    final countdownToStartSeconds = context.select<DoWorkoutBloc, int>(
        (b) => b.userWorkoutSettingsBloc.settings.countdownToStartSeconds);

    final enableAutoRestTimer = context.select<DoWorkoutBloc, bool>(
        (b) => b.userWorkoutSettingsBloc.settings.enableAutoRestTimer);

    final autoRestTimerSeconds = context.select<DoWorkoutBloc, int>(
        (b) => b.userWorkoutSettingsBloc.settings.autoRestTimerSeconds);

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
                    title: 'Auto Rest Timer',
                    updateValue: (v) => context
                        .read<DoWorkoutBloc>()
                        .toggleEnableAutoRestTimer(v),
                    value: enableAutoRestTimer),
                GrowInOut(
                  show: enableAutoRestTimer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () => context.showActionSheetPopup(
                            child: DurationPicker(
                          mode: CupertinoTimerPickerMode.ms,
                          duration: Duration(seconds: autoRestTimerSeconds),
                          updateDuration: (d) => context
                              .read<DoWorkoutBloc>()
                              .adjustAutoRestTime(d.inSeconds),
                          title: 'Rest Timer Length',
                        )),
                        padding: const EdgeInsets.only(top: 4, bottom: 12),
                        child: ContentBox(
                          child: CompactTimerIcon(
                            fontSize: FONTSIZE.six,
                            iconSize: 22,
                            duration: Duration(seconds: autoRestTimerSeconds),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: MyText(
                      'When enabled this rest timer will start after each set that you complete. For custom and non-timed workouts e.g Lifting, Custom, Cardio.',
                      maxLines: 4,
                      size: FONTSIZE.two,
                      subtext: true,
                      lineHeight: 1.4),
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
          UserInputContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoSwitchRow(
                    title: 'Disable Sleep Mode',
                    updateValue: (v) =>
                        context.read<DoWorkoutBloc>().toggleWakelock(v),
                    value: enableWakelock),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: MyText(
                      'When sleep mode is disabled your screen will not sleep when you are training.',
                      maxLines: 4,
                      size: FONTSIZE.two,
                      subtext: true,
                      lineHeight: 1.4),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
