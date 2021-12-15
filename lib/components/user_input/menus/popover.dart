import 'package:flutter/cupertino.dart';
import 'package:popover/popover.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class PopoverMenu extends StatelessWidget {
  final Widget button;
  final List<PopoverMenuItem> items;
  const PopoverMenu({Key? key, required this.button, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        context.theme.cardBackground.withOpacity(0.99);
    return GestureDetector(
      child: button,
      onTap: () {
        showPopover(
          context: context,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) => ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PopoverMenuContainer(
              items: items,
            ),
          ),
          backgroundColor: backgroundColor,
          barrierColor: Styles.black.withOpacity(0.2),
          radius: 16,
          direction: PopoverDirection.top,
          arrowHeight: 10,
          arrowWidth: 0,
        );
      },
    );
  }
}

class PopoverMenuContainer extends StatelessWidget {
  final List<PopoverMenuItem> items;
  const PopoverMenuContainer({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.primary.withOpacity(0.07)),
      ),
      child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (c, i) => GestureDetector(
              onTap: () {
                context.pop();
                items[i].onTap();
              },
              child: items[i]),
          separatorBuilder: (c, i) => HorizontalLine(
                color: context.theme.primary.withOpacity(0.06),
                verticalPadding: 0,
              ),
          itemCount: items.length),
    );
  }
}

class PopoverMenuItem extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final bool confirm;
  final bool destructive;
  final void Function() onTap;
  final bool isActive;
  final bool isLast;
  const PopoverMenuItem(
      {Key? key,
      required this.text,
      required this.onTap,
      this.iconData,
      this.confirm = false,
      this.isLast = false,
      this.destructive = false,
      required this.isActive})
      : assert(!(confirm && destructive)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = confirm
        ? Styles.infoBlue
        : destructive
            ? Styles.errorRed
            : context.theme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
          border: isLast
              ? const Border(bottom: BorderSide(color: Styles.greyOne))
              : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MyText(
                text,
                color: color,
                textAlign: TextAlign.left,
              ),
              if (isActive)
                const FadeIn(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(CupertinoIcons.circle_fill,
                      size: 10, color: Styles.primaryAccent),
                ))
            ],
          ),
          if (iconData != null)
            Icon(
              iconData,
              size: 21,
              color: color,
            )
        ],
      ),
    );
  }
}
