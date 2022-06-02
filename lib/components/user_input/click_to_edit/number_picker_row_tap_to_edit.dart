import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/number_input_modal.dart';
import 'package:sofie_ui/components/user_input/number_picker_modal.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class IntPickerRowTapToEdit extends StatelessWidget {
  final String title;
  final String? suffix;
  final int? value;
  final void Function(int) saveValue;
  final int min;
  final int max;
  const IntPickerRowTapToEdit(
      {Key? key,
      this.min = 1,
      this.max = 500,
      this.value,
      required this.saveValue,
      required this.title,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TappableRow(
        onTap: () => context.showActionSheetPopup(
                child: NumberPickerModal(
              initialValue: value,
              min: min,
              max: max,
              saveValue: saveValue,
              title: title,
            )),
        display: Row(
          children: [
            ContentBox(
              child: MyText(
                value == null ? ' - ' : value.toString(),
                size: FONTSIZE.six,
                lineHeight: 1.2,
              ),
            ),
            if (suffix != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MyText(suffix!),
              )
          ],
        ),
        title: title);
  }
}

class DoublePickerRowTapToEdit extends StatelessWidget {
  final String title;
  final String? suffix;
  final double? value;
  final void Function(double) saveValue;
  final bool allowNegative;
  final String? inputUnitDisplay;
  const DoublePickerRowTapToEdit(
      {Key? key,
      this.value,
      required this.saveValue,
      required this.title,
      this.suffix,
      this.allowNegative = false,
      this.inputUnitDisplay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TappableRow(
        onTap: () => context.showBottomSheet(
            child: NumberInputModalDouble(
                value: value,
                saveValue: saveValue,
                title: title,
                unitDisplay: inputUnitDisplay,
                allowNegative: allowNegative)),
        display: Row(
          children: [
            ContentBox(
              child: MyText(
                value == null ? ' - ' : value.toString(),
                size: FONTSIZE.six,
                lineHeight: 1.2,
              ),
            ),
            if (suffix != null)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: MyText(suffix!),
              )
          ],
        ),
        title: title);
  }
}
