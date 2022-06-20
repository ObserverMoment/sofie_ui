import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DateAndYearPicker extends StatefulWidget {
  final DateTime dateTime;
  final void Function(DateTime dateTime) update;
  const DateAndYearPicker(
      {Key? key, required this.dateTime, required this.update})
      : super(key: key);

  @override
  State<DateAndYearPicker> createState() => _DateAndYearPickerState();
}

class _DateAndYearPickerState extends State<DateAndYearPicker> {
  /// 10 years before and 10 years after current.
  late List<int> _years;
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  late DateTime _dateTime;

  late FixedExtentScrollController _monthScrollController;
  late FixedExtentScrollController _yearScrollController;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.dateTime;
    final earliestYear = DateTime.now().year - 10;
    _years = List.generate(21, (i) => (earliestYear + i));

    _monthScrollController =
        FixedExtentScrollController(initialItem: _dateTime.month - 1);
    _yearScrollController = FixedExtentScrollController(
        initialItem: _years.indexOf(_dateTime.year));
  }

  void _handleNewMonth(int index) {
    setState(() {
      _dateTime = DateTime(_dateTime.year, index + 1);
    });
    widget.update(_dateTime);
  }

  void _handleNewYear(int index) {
    setState(() {
      _dateTime = DateTime(_years[index], _dateTime.month);
    });
    widget.update(_dateTime);
  }

  Widget _buildItem(String text) => Center(
        child: MyText(
          text,
          size: FONTSIZE.four,
        ),
      );

  @override
  void dispose() {
    _monthScrollController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: context.theme.cardBackground,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: _monthScrollController,
              onSelectedItemChanged: _handleNewMonth,
              children: List.generate(12, (i) => _buildItem(_months[i])),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: _yearScrollController,
              onSelectedItemChanged: _handleNewYear,
              children: _years.map((y) => _buildItem(y.toString())).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
