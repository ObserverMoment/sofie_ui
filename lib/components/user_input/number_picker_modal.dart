import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/modal_picker_title.dart';
import 'package:sofie_ui/components/user_input/pickers/save_and_close_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// This widget uses scroll and step input to select an integer value within a min and max range.
/// For standard number input modals see [NumberInputModalInt] and [NumberInputModalDouble]
class NumberPickerModal extends StatefulWidget {
  final String title;
  final int? initialValue;
  final int min;
  final int max;
  final void Function(int value) saveValue;
  const NumberPickerModal(
      {Key? key,
      required this.initialValue,
      required this.saveValue,
      this.title = 'Enter...',
      required this.min,
      required this.max})
      : super(key: key);
  @override
  State<NumberPickerModal> createState() => _NumberPickerModalState();
}

class _NumberPickerModalState<T> extends State<NumberPickerModal> {
  late int _activeValue;
  late FixedExtentScrollController _scrollController;
  final double _itemExtent = 40;

  @override
  void initState() {
    super.initState();
    _activeValue = widget.initialValue ?? widget.min;
    _scrollController =
        FixedExtentScrollController(initialItem: _activeValue - widget.min);
  }

  void _handleScrollValueChange(int index) =>
      setState(() => _activeValue = widget.min + index);

  void _handleStepIncrement() {
    final newIndex = _scrollController.selectedItem + 1;
    setState(() => _activeValue = newIndex + widget.min);
    _animateToItem(newIndex);
  }

  void _handleStepDecrement() {
    final newIndex = _scrollController.selectedItem - 1;
    setState(() => _activeValue = newIndex + widget.min);
    _animateToItem(newIndex);
  }

  void _animateToItem(int index) => _scrollController.animateToItem(index,
      duration: const Duration(milliseconds: 100), curve: Curves.easeInCubic);

  void _saveValue() {
    widget.saveValue(_activeValue);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModalPickerTitle(title: widget.title),
          SizedBox(
            height: 240,
            width: 150,
            child: CupertinoPicker(
                scrollController: _scrollController,
                itemExtent: _itemExtent,
                useMagnifier: true,
                magnification: 1.5,
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: context.theme.primary,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                ),
                onSelectedItemChanged: _handleScrollValueChange,
                children: List<Widget>.generate(
                    widget.max - widget.min + 1,
                    (i) => Center(
                            child: MyText(
                          (i + widget.min).toString(),
                          lineHeight: 1.2,
                          weight: FontWeight.bold,
                          size: FONTSIZE.six,
                        )))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                  onPressed:
                      _activeValue != widget.min ? _handleStepDecrement : null,
                  child: const Icon(
                    CupertinoIcons.minus_rectangle,
                    size: 40,
                  )),
              CupertinoButton(
                  onPressed:
                      _activeValue != widget.max ? _handleStepIncrement : null,
                  child: const Icon(
                    CupertinoIcons.plus_rectangle,
                    size: 40,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveAndClosePicker(
                disabled: _activeValue == widget.initialValue,
                saveAndClose: _saveValue),
          ),
        ],
      ),
    );
  }
}
