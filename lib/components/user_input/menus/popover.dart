import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
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
          barrierColor: Colors.transparent,
          radius: 12,
          direction: PopoverDirection.top,
          arrowHeight: 15,
          arrowWidth: 30,
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
    return SizedBox(
      width: 240,
      child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (c, i) => GestureDetector(
              onTap: () {
                items[i].onTap();
                context.pop();
              },
              child: items[i]),
          separatorBuilder: (c, i) => HorizontalLine(
                color: Styles.greyOne.withOpacity(0.2),
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
  final bool isLast;
  const PopoverMenuItem(
      {Key? key,
      required this.text,
      required this.onTap,
      this.iconData,
      this.confirm = false,
      this.isLast = false,
      this.destructive = false})
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
          MyText(
            text,
            color: color,
            textAlign: TextAlign.left,
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
