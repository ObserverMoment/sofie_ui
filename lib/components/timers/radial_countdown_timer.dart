import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// The circle fills as the timer gets closer to complete.
/// Pass a value between 0.0 and 1.0.
class RadialCountdownTimer extends StatelessWidget {
  final double size;
  final double value;
  final Color progressColor;
  final Color? backgroundColor;

  /// When tru do not display a ring around the outside of the circle.
  final bool hideOutline;

  /// Fills the background with background color - if false then we only see an outline of the circle. Overridden by [hideOutline] = true.
  final bool fullBackground;
  const RadialCountdownTimer(
      {Key? key,
      required this.size,
      required this.value,
      this.hideOutline = false,
      this.progressColor = Styles.primaryAccent,
      this.backgroundColor,
      this.fullBackground = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final indicatorWidthFraction = hideOutline ? 0.96 : 0.92;
    return SizedBox(
      height: size,
      width: size,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            maximum: 1,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            axisLineStyle: AxisLineStyle(
              thickness: hideOutline
                  ? 0
                  : fullBackground
                      ? 1
                      : 0.02,
              color: backgroundColor ?? context.theme.primary.withOpacity(0.1),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: value,
                width: indicatorWidthFraction,
                pointerOffset: 1 - indicatorWidthFraction,
                sizeUnit: GaugeSizeUnit.factor,
                color: progressColor.withOpacity(0.8),
              )
            ],
          )
        ],
      ),
    );
  }
}
