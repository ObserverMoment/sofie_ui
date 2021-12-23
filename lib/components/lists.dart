import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class CommaSeparatedList extends StatelessWidget {
  final List<String> names;
  final FONTSIZE fontSize;
  final Color? textColor;
  final bool withFullStop;
  final WrapAlignment alignment;
  final double runSpacing;
  const CommaSeparatedList(this.names,
      {Key? key,
      this.alignment = WrapAlignment.start,
      this.runSpacing = 3,
      this.fontSize = FONTSIZE.two,
      this.textColor,
      this.withFullStop = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      spacing: 1,
      runSpacing: runSpacing,
      children: names
          .asMap()
          .map((index, name) => MapEntry(
              index,
              MyText(
                index == names.length - 1
                    ? withFullStop
                        ? '$name.'
                        : name
                    : '$name, ',
                size: fontSize,
                color: textColor,
              )))
          .values
          .toList(),
    );
  }
}

class ListAvoidFAB extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  const ListAvoidFAB({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount + 1,
        itemBuilder: (c, i) {
          if (i == itemCount) {
            /// The height (hard coded!) needed to allow the list to scroll clear of the FAB.
            return const SizedBox(height: 60);
          } else {
            return itemBuilder(context, i);
          }
        });
  }
}
