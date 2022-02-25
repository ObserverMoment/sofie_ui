import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

/// Classic Horizontal Bar Chart in a modern minimal style.
/// No x or y axis or grid lines.
class PercentageBarChart extends StatelessWidget {
  final List<BarChartItem> items;
  final double? itemHeight; // Auto calced when null.
  final double min;
  final double max;
  final Gradient gradient;
  final FONTSIZE fontSize;
  final double barPadding;
  const PercentageBarChart(
      {Key? key,
      required this.items,
      this.itemHeight,
      this.min = 0,
      required this.max,
      required this.gradient,
      this.fontSize = FONTSIZE.two,
      this.barPadding = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: items
              .map((i) => _BarChartBar(
                    item: i,
                    max: max,
                    min: min,
                    itemHeight:
                        itemHeight ?? (constraints.maxHeight / items.length),
                    maxWidth: constraints.maxWidth,
                    gradient: gradient,
                    fontSize: fontSize,
                    barPadding: barPadding,
                  ))
              .toList(),
        ),
      );
    });
  }
}

class _BarChartBar extends StatelessWidget {
  final BarChartItem item;
  final double min;
  final double max;
  final double maxWidth;
  final double itemHeight;
  final Gradient gradient;
  final FONTSIZE fontSize;
  final double barPadding;
  const _BarChartBar(
      {Key? key,
      required this.item,
      required this.min,
      required this.max,
      required this.maxWidth,
      required this.itemHeight,
      required this.gradient,
      this.fontSize = FONTSIZE.two,
      this.barPadding = 3})
      : super(key: key);

  int _percentageFromFraction(double fraction) => (fraction * 100).round();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: barPadding),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: itemHeight - (barPadding * 2),
            width: (item.fraction / max) * maxWidth,
            decoration: BoxDecoration(
                gradient: gradient, borderRadius: BorderRadius.circular(4)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MyText(
              '${item.label} (${_percentageFromFraction(item.fraction)}%)',
              size: fontSize,
              lineHeight: 1,
            ),
          )
        ],
      ),
    );
  }
}

class BarChartItem {
  final String label;

  /// Must be between 0 and 1.0.
  final double fraction;
  BarChartItem(this.label, this.fraction);
}
