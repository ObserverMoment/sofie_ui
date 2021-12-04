import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

// Simple animated tabs which return a new tab index when clicked.
class MyTabBarNav extends StatelessWidget {
  final List<String> titles;

  /// Display a small icon on the top right of the tab title.
  /// Recommend [FONTSIZE.two] for text.
  final List<Widget?>? superscriptIcons;
  final int activeTabIndex;
  final Function(int newIndex) handleTabChange;
  final Alignment alignment;

  const MyTabBarNav({
    Key? key,
    required this.titles,
    required this.handleTabChange,
    required this.activeTabIndex,
    this.superscriptIcons,
    this.alignment = Alignment.centerLeft,
  })  : assert(superscriptIcons == null ||
            superscriptIcons.length == titles.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color cardColor = context.theme.cardBackground;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
      alignment: alignment,
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: titles
            .mapIndexed((index, title) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => handleTabChange(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: index == activeTabIndex
                              ? cardColor
                              : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedOpacity(
                              opacity: index == activeTabIndex ? 1 : 0.65,
                              duration: const Duration(milliseconds: 400),
                              child: MyText(
                                title.toUpperCase(),
                                size: FONTSIZE.four,
                                weight: index == activeTabIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (superscriptIcons?[index] != null)
                      Positioned(
                          top: -1, right: 3, child: superscriptIcons![index]!)
                  ],
                ))
            .toList(),
      ),
    );
  }
}
