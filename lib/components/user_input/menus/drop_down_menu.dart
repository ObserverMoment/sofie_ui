import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';

/// Wraps a popover component and displays the currently selected option in a box with a title.
class DropdownMenu<T> extends StatelessWidget {
  final String title;
  final String placeholder;
  final T? selected;
  final Map<PopoverMenuItem, T> options;
  final VoidCallback? clearInput;
  const DropdownMenu(
      {Key? key,
      this.selected,
      required this.options,
      required this.title,
      required this.placeholder,
      this.clearInput})
      : super(key: key);

  PopoverMenuItem? get _selected => options.keys.firstWhere(
        (k) => options[k] == selected,
      );

  @override
  Widget build(BuildContext context) {
    return PopoverMenu(
      button: ContentBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MyText(
                  title,
                  size: FONTSIZE.two,
                  color: Styles.primaryAccent,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MyText(selected != null ? _selected!.text : placeholder,
                  size: FONTSIZE.four),
            )
          ],
        ),
      ),
      items: [
        ...options.keys.toList(),
        if (clearInput != null)
          PopoverMenuItem(
            iconData: CupertinoIcons.clear,
            onTap: clearInput!,
            text: 'Clear',
          )
      ],
    );
  }
}
