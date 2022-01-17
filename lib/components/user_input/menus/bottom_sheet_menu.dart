import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (header != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (header != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: header,
                      ),
                    ),
                ],
              ),
            Container(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) => BottomSheetMenuItemContainer(
                        items[index],
                      )),
            ),
            TextButton(
              text: 'Cancel',
              onPressed: context.pop,
              fontSize: FONTSIZE.four,
            ),
          ],
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

class BottomSheetAnimateInPageRoute extends PageRouteBuilder {
  final Widget page;
  BottomSheetAnimateInPageRoute({
    required this.page,
  }) : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                        parent: animation, curve: Curves.easeOutCirc),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animation, curve: Curves.easeInCirc)),
                    child: child,
                  ),
                ));
}
