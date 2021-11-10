import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/save_and_close_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DatePicker extends StatefulWidget {
  final void Function(DateTime date) saveDate;
  final DateTime? selectedDate;
  final DateTime? initialDate;
  const DatePicker(
      {Key? key, required this.saveDate, this.selectedDate, this.initialDate})
      : super(key: key);
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? widget.selectedDate ?? DateTime.now();
  }

  void _handleDateTimeChange(DateTime date) =>
      setState(() => _selectedDate = date);

  void _handleSave() {
    if (_selectedDate != null) {
      widget.saveDate(_selectedDate!);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: H2('Select Date'),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: _handleDateTimeChange),
            ),
          ),
          SaveAndClosePicker(saveAndClose: _handleSave)
        ],
      ),
    );
  }
}
