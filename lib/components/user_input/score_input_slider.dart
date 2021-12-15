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

  const ScoreInputSlider(
      {Key? key,
      this.name,
      required this.value,
      this.min = 0.0,
      this.max = 1.0,
      this.divisions,
      required this.saveValue})
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: material.Material(
                  color: material.Colors.transparent,
                  child: material.SliderTheme(
                    data: const material.SliderThemeData(
                      trackHeight: 20.0,
                      thumbShape: material.RoundSliderThumbShape(
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
        )
      ],
    );
  }
}
