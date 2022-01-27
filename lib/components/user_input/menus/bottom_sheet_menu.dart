import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/page_transitions.dart';
import 'package:sofie_ui/services/utils.dart';

class BottomSheetMenuItem {
  String text;
  IconData? icon;
  bool isDestructive;
  Function() onPressed;
  BottomSheetMenuItem(
      {required this.text,
      this.icon,
      this.isDestructive = false,
      required this.onPressed});
}

Future<dynamic> openBottomSheetMenu({
  required BuildContext context,

  /// Usually a [BottomSheetMenu]
  required Widget child,
  bool expand = false,
}) async {
  final result = await Navigator.of(context)
      .push(BottomSheetAnimateInPageRoute(page: MyPageScaffold(child: child)));
  return result;
}

class BottomSheetMenu extends StatelessWidget {
  final List<BottomSheetMenuItem> items;
  final BottomSheetMenuHeader? header;
  BottomSheetMenu({Key? key, required this.items, this.header})
      : assert(items.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (header != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (header != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: header,
                        ),
                      ),
                  ],
                ),
              ...items
                  .map((i) => BottomSheetMenuItemContainer(
                        i,
                      ))
                  .toList(),
              const SizedBox(height: 8),
              TextButton(
                text: 'Cancel',
                onPressed: context.pop,
                fontSize: FONTSIZE.four,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetMenuHeader extends StatelessWidget {
  final String? imageUri;
  final String name;
  final String? subtitle;
  const BottomSheetMenuHeader(
      {Key? key, this.imageUri, required this.name, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (Utils.textNotNull(imageUri))
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedUploadcareImage(
                imageUri!,
                displaySize: const Size(120, 120),
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyHeaderText(
              name,
              weight: FontWeight.normal,
            ),
            if (Utils.textNotNull(subtitle))
              MyText(
                subtitle!,
                subtext: true,
                lineHeight: 1.4,
              ),
          ],
        )
      ],
    );
  }
}

class BottomSheetMenuItemContainer extends StatelessWidget {
  final BottomSheetMenuItem bottomSheetMenuItem;
  const BottomSheetMenuItemContainer(this.bottomSheetMenuItem, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 20),
      onPressed: () {
        context.pop();
        bottomSheetMenuItem.onPressed();
      },
      child: Row(children: [
        if (bottomSheetMenuItem.icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(
              bottomSheetMenuItem.icon!,
              color: bottomSheetMenuItem.isDestructive
                  ? Styles.errorRed
                  : Styles.primaryAccent,
            ),
          ),
        MyText(
          bottomSheetMenuItem.text,
          color: bottomSheetMenuItem.isDestructive
              ? Styles.errorRed
              : context.theme.primary,
          size: FONTSIZE.four,
        ),
      ]),
    );
  }
}
