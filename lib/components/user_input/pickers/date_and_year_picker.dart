import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DateAndYearPicker extends StatefulWidget {
  const DateAndYearPicker({Key? key}) : super(key: key);

  @override
  State<DateAndYearPicker> createState() => _DateAndYearPickerState();
}

class _DateAndYearPickerState extends State<DateAndYearPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoPicker(
          itemExtent: 200,
          onSelectedItemChanged: (int value) {},
          children: [],
        ),
        CupertinoPicker(
          itemExtent: 200,
          onSelectedItemChanged: (int value) {},
          children: [],
        ),
      ],
    );
  }
}
