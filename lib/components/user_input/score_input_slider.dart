import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class ScoreInputSlider extends StatelessWidget {
  final String? name;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final Function(double v) saveValue;
  final List<String> labels;

  const ScoreInputSlider(
      {Key? key,
      this.name,
      required this.value,
      this.min = 0.0,
      this.max = 1.0,
      this.divisions,
      required this.saveValue,
      this.labels = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (name != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: H3(
                  name!,
                ),
              ),
              H3(value.stringMyDouble())
            ],
          ),
        Container(
          padding: const EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: material.Material(
                  color: material.Colors.transparent,
                  child: material.SliderTheme(
                    data: material.SliderThemeData(
                      trackHeight: 20.0,
                      overlayShape: material.SliderComponentShape.noOverlay,
                      thumbShape: const material.RoundSliderThumbShape(
                          enabledThumbRadius: 11),
                    ),
                    child: material.Slider(
                      min: min,
                      max: max,
                      divisions: divisions,
                      value: value,
                      onChanged: saveValue,
                      activeColor: Styles.primaryAccent,
                      inactiveColor: context.theme.primary.withOpacity(0.08),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (labels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  labels.map((l) => MyText(l, size: FONTSIZE.two)).toList(),
            ),
          )
      ],
    );
  }
}
