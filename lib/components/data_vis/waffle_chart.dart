import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

List<Widget> _buildWaffleChartList(
    {int totalBlocks = 100, required List<WaffleChartInput> inputs}) {
  final sortedInputs = inputs.sortedBy<num>((i) => i.fraction);
  final List<Widget> children = [];

  /// The value already accounted for by the preceding inputs.
  double curRangeLow = 0.0;

  for (var i = 0; i < totalBlocks; i++) {
    if ((i / totalBlocks) >= sortedInputs[0].fraction + curRangeLow) {
      curRangeLow += sortedInputs[0].fraction;
      sortedInputs.removeAt(0);
    }
    children.add(Container(
      decoration: BoxDecoration(
        color: sortedInputs[0].color,
      ),
    ));
  }

  /// Reversed as we want the largest block at the top.
  return children.reversed.toList();
}

class WaffleChart extends StatelessWidget {
  final List<WaffleChartInput> inputs;
  final double width;
  const WaffleChart({Key? key, required this.inputs, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              crossAxisCount: 10,
              shrinkWrap: true,
              children: _buildWaffleChartList(inputs: inputs)),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: inputs
              .sortedBy<num>((i) => i.fraction)
              .reversed
              .map((i) => Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      MyText(
                        i.name,
                        size: FONTSIZE.two,
                      ),
                    ],
                  ))
              .toList(),
        )
      ],
    );
  }
}

class WaffleChartInput {
  final double fraction;
  final Color color;
  final String name;
  WaffleChartInput(
      {required this.fraction, required this.color, required this.name});
}
