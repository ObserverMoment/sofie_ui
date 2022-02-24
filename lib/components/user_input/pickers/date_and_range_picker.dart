import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class DateAndRangePickerDisplay extends StatefulWidget {
  final DateTime? from;
  final DateTime? to;
  final void Function(DateTime? from, DateTime? to) updateRange;
  const DateAndRangePickerDisplay({
    Key? key,
    required this.from,
    required this.to,
    required this.updateRange,
  }) : super(key: key);

  @override
  State<DateAndRangePickerDisplay> createState() =>
      _DateAndRangePickerDisplayState();
}

enum _DateRange {
  thirtyDays,
  sixtyDays,
  ninetyDays,
  allTime,
}

class _DateAndRangePickerDisplayState extends State<DateAndRangePickerDisplay> {
  _DateRange? _activeDateRange;

  void _updateFromDate(DateTime from) {
    widget.updateRange(from, widget.to);
    setState(() {
      _activeDateRange = null;
    });
  }

  void _updateToDate(DateTime to) {
    widget.updateRange(widget.from, to);
    setState(() {
      _activeDateRange = null;
    });
  }

  /// Via the pre-set ranges. E.g "30 Days", "60 Days" etc.
  void _updateRange(_DateRange range) {
    final now = DateTime.now();

    switch (range) {
      case _DateRange.thirtyDays:
        widget.updateRange(now.daysBefore(30), now);
        setState(() {
          _activeDateRange = range;
        });
        break;
      case _DateRange.sixtyDays:
        widget.updateRange(now.daysBefore(60), now);
        setState(() {
          _activeDateRange = range;
        });
        break;
      case _DateRange.ninetyDays:
        widget.updateRange(now.daysBefore(90), now);
        setState(() {
          _activeDateRange = range;
        });
        break;
      case _DateRange.allTime:
        widget.updateRange(null, now);
        setState(() {
          _activeDateRange = range;
        });
        break;
      default:
        throw Exception(
            'DateAndRangePickerDisplay._updateRange: No case defined for input $range');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentBox(
        borderRadius: 0,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            _DatePickerinputDisplay(
              date: widget.from,
              label: 'From',
              placeholder: 'Big Bang',
            ),
            const SizedBox(width: 6),
            _DatePickerinputDisplay(
              date: widget.to,
              label: 'To',
              placeholder: 'Today',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SelectableRangeTag(
                        isSelected: _activeDateRange == _DateRange.thirtyDays,
                        onPressed: () => _updateRange(_DateRange.thirtyDays),
                        text: '30 Days',
                      ),
                      _SelectableRangeTag(
                          isSelected: _activeDateRange == _DateRange.sixtyDays,
                          onPressed: () => _updateRange(_DateRange.sixtyDays),
                          text: '60 Days'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SelectableRangeTag(
                          isSelected: _activeDateRange == _DateRange.ninetyDays,
                          onPressed: () => _updateRange(_DateRange.ninetyDays),
                          text: '90 Days'),
                      _SelectableRangeTag(
                          isSelected: _activeDateRange == _DateRange.allTime,
                          onPressed: () => _updateRange(_DateRange.allTime),
                          text: 'All Time'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class _DatePickerinputDisplay extends StatelessWidget {
  final DateTime? date;
  final String label;
  final String placeholder;
  const _DatePickerinputDisplay(
      {Key? key,
      required this.date,
      required this.placeholder,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 56,
      child: ContentBox(
        backgroundColor: context.theme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              label,
              size: FONTSIZE.one,
            ),
            const SizedBox(height: 4),
            date != null
                ? MyText(date!.minimalDateStringYear)
                : MyText(
                    placeholder,
                    subtext: true,
                  ),
          ],
        ),
      ),
    );
  }
}

class _SelectableRangeTag extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;
  final String text;
  const _SelectableRangeTag(
      {Key? key,
      required this.isSelected,
      required this.onPressed,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SelectableBoxTextOnly(
        isSelected: isSelected,
        onPressed: onPressed,
        text: text,
        fontSize: FONTSIZE.two,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
