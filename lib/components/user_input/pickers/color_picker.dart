import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/user_input/pickers/modal_picker_title.dart';
import 'package:sofie_ui/components/user_input/pickers/save_and_close_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

class GoalTagsColorSwatch {
  static const brightRed = Color(0xFFED254E);
  static const yellow = Color(0xFFF9DC5C);
  static const purple = Color(0xFF7D5BA6);
  static const rose = Color(0xFFFC6471);
  static const green = Color(0xFF06A77D);
  static const orange = Color(0xFFFB5607);
  static const lightBlue = Color(0xFF3A86FF);
  static const red = Color(0xFFA64253);
  static const slateBlue = Color(0xFF3D348B);

  static List<Color> get colors => [
        red,
        yellow,
        brightRed,
        purple,
        rose,
        green,
        orange,
        lightBlue,
        slateBlue
      ];
}

Future<void> openColorPickerDialog(
    {required BuildContext context,
    Color? initialColor,
    String title = 'Select a color',
    required void Function(Color color) onSave}) async {
  context.showActionSheetPopup(
      child: MyColorPicker(
    title: title,
    onCancel: context.pop,
    onSave: (Color color) {
      onSave(color);
      context.pop();
    },
  ));
}

class MyColorPicker extends StatefulWidget {
  final String title;
  final Color? initialColor;
  final void Function(Color color) onSave;
  final void Function() onCancel;
  const MyColorPicker(
      {Key? key,
      required this.onSave,
      required this.onCancel,
      this.title = 'Select a Color',
      this.initialColor})
      : super(key: key);

  @override
  _MyColorPickerState createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  Color? _activeColor;

  @override
  void initState() {
    super.initState();
    _activeColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: 540,
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ModalPickerTitle(title: widget.title),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: GoalTagsColorSwatch.colors
                  .map((c) => CupertinoButton(
                        pressedOpacity: 0.9,
                        padding: const EdgeInsets.all(6),
                        onPressed: () => setState(() => _activeColor = c),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: c,
                                    boxShadow: kElevation[2],
                                    borderRadius: BorderRadius.circular(12)),
                                child: const SizedBox.expand()),
                            if (c == _activeColor)
                              const FadeIn(
                                child: Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: Styles.white,
                                  size: 40,
                                ),
                              )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SaveAndClosePicker(
              disabled: _activeColor == null,
              saveAndClose: () => widget.onSave(_activeColor!)),
        ),
      ]),
    ));
  }
}
