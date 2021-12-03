import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class BottomSheetMenuItem {
  String text;
  Widget? icon;
  bool isDestructive;
  Function() onPressed;
  BottomSheetMenuItem(
      {required this.text,
      this.icon,
      this.isDestructive = false,
      required this.onPressed});
}

/// Light wrapper around [showBottomSheet] setting [expand] to [false].
Future<dynamic> openBottomSheetMenu({
  required BuildContext context,
  required Widget child,
  bool expand = false,
}) async {
  final result = await context.showBottomSheet(
    expand: expand,
    child: child,
  );
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (header != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: header,
                    ),
                  ),
                CupertinoButton(
                  onPressed: context.pop,
                  child: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: context.theme.primary.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          Container(
            padding: const EdgeInsets.only(
                top: 12.0, left: 16, right: 16, bottom: 20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => BottomSheetMenuItemContainer(
                      items[index],
                    )),
          ),
        ],
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
    return Row(
      children: [
        if (Utils.textNotNull(imageUri))
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedUploadcareImage(
                imageUri!,
                displaySize: const Size(60, 60),
              ),
            ),
          ),
        Expanded(
          child: Column(
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
          ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: context.theme.cardBackground.withOpacity(0.3),
            border: Border.all(
                color: bottomSheetMenuItem.isDestructive
                    ? Styles.errorRed
                    : context.theme.primary),
            borderRadius: BorderRadius.circular(30)),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          onPressed: () {
            context.pop();
            bottomSheetMenuItem.onPressed();
          },
          child: Row(
              mainAxisAlignment: bottomSheetMenuItem.icon != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                MyText(
                  bottomSheetMenuItem.text,
                  color: bottomSheetMenuItem.isDestructive
                      ? Styles.errorRed
                      : context.theme.primary,
                ),
                if (bottomSheetMenuItem.icon != null) bottomSheetMenuItem.icon!,
              ]),
        ),
      ),
    );
  }
}
