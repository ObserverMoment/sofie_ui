import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

/// Like an ios context menu but that (by default) opens on tap instead of on long press.
class ContextMenu extends StatelessWidget {
  /// Also use this as the Hero tag.
  @override
  final Key key;
  final Widget child;

  /// How the child will display when opened.
  final Widget? menuChild;
  final List<ContextMenuAction> actions;
  const ContextMenu(
      {required this.key,
      required this.actions,
      required this.child,
      this.menuChild})
      : super(key: key);

  double get kContextMenuBorderRadius => 18.0;
  double get kContextMenuActionsWidth => 240.0;
  Duration get kAnimationDuration => const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Utils.hideKeyboard(context);
          Navigator.of(context, rootNavigator: true).push(
            PageRouteBuilder(
              opaque: false,
              fullscreenDialog: true,
              barrierColor: Styles.black.withOpacity(0.5),
              barrierDismissible: true,
              transitionDuration: kAnimationDuration,
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (_, __, ___) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                          tag: key.toString(),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  kContextMenuBorderRadius),
                              child: menuChild ?? child)),
                      const SizedBox(height: 12),
                      Container(
                        width: kContextMenuActionsWidth,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: context.theme.primary.withOpacity(0.1)),
                            borderRadius:
                                BorderRadius.circular(kContextMenuBorderRadius),
                            color:
                                context.theme.cardBackground.withOpacity(0.9)),
                        child: ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (c, i) => GestureDetector(
                                onTap: () {
                                  context.pop(rootNavigator: true);
                                  // Wait for the hero animation to complete before running callback.
                                  Future.delayed(
                                      kAnimationDuration, actions[i].onTap);
                                },
                                child: actions[i]),
                            separatorBuilder: (c, i) => HorizontalLine(
                                  color: Styles.greyOne.withOpacity(0.2),
                                  verticalPadding: 0,
                                ),
                            itemCount: actions.length),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Hero(
          tag: key.toString(),

          /// Hack to stop renderflex overflow error when hero animates from smaller [menuChild] to larger [child]
          child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(), child: child),
        ));
  }
}

class ContextMenuAction extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final bool destructive;
  final void Function() onTap;
  final bool isLast;
  const ContextMenuAction(
      {Key? key,
      required this.text,
      required this.onTap,
      this.iconData,
      this.isLast = false,
      this.destructive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Styles.errorRed : context.theme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
