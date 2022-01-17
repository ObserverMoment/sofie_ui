import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd();
  return dateFormat.format(date);
}

String formatDateSameWeek(DateTime date) {
  DateFormat dateFormat;
  if (date.day == DateTime.now().day) {
    dateFormat = DateFormat('hh:mm a');
  } else {
    dateFormat = DateFormat('EEEE');
  }
  return dateFormat.format(date);
}

String formatDateMessage(DateTime date) {
  final dateFormat = DateFormat('EEE. MMM. d ' 'yy' '  hh:mm a');
  return dateFormat.format(date);
}

bool isSameWeek(DateTime timestamp) =>
    DateTime.now().difference(timestamp).inDays < 7;

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 1,
          color: CupertinoColors.systemGrey5,
        ),
      ),
    );
  }
}
