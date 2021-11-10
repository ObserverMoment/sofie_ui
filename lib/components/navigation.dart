import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      alignment: alignment,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.theme.cardBackground)),
      ),
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: titles
            .mapIndexed((index, title) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.only(left: 4, right: 10),
                      pressedOpacity: 0.9,
                      alignment: Alignment.centerLeft,
                      onPressed: () => handleTabChange(index),
                      child: AnimatedContainer(
                        duration: kStandardAnimationDuration,
                        height: 46,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: index == activeTabIndex
                                        ? Styles.primaryAccent
                                        : Colors.transparent))),
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
