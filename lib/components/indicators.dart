import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StageProgressIndicator extends StatelessWidget {
  final int numStages;
  final List<String>? titles;
  final int currentStage;
  final Duration animationDuration;
  const StageProgressIndicator(
      {Key? key,
      required this.numStages,
      this.titles,
      required this.currentStage,
      this.animationDuration = const Duration(milliseconds: 300)})
      : assert(titles == null || titles.length == numStages),
        assert(currentStage <= numStages && currentStage >= 0),
        super(key: key);

  Widget _buildDot(
          {required BuildContext context,
          required int index,
          required bool isComplete,
          required bool isActive}) =>
      AnimatedOpacity(
        duration: animationDuration,
        opacity: isComplete || isActive ? 1 : 0.6,
        child: AnimatedContainer(
            duration: animationDuration,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isComplete ? Styles.secondaryAccentGradient : null,
                border: Border.all(
                    color: isComplete || isActive
                        ? Styles.secondaryAccent
                        : CupertinoTheme.of(context).primaryColor)),
            child: AnimatedSwitcher(
              duration: animationDuration,
              child: isComplete
                  ? const Icon(CupertinoIcons.checkmark_alt)
                  : MyText('${index + 1}'),
            )),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(numStages, (index) {
        final _isComplete = currentStage > index;
        final _isActive = currentStage == index;

        return SizedBox(
          height: titles == null ? 64 : 100,
          child: TimelineTile(
            alignment: TimelineAlign.center,
            isFirst: index == 0,
            isLast: index == numStages - 1,
            axis: TimelineAxis.horizontal,
            endChild: titles != null
                ? AnimatedOpacity(
                    duration: animationDuration,
                    opacity: _isComplete || _isActive ? 1 : 0.6,
                    child: MyText(
                      titles![index],
                      weight: _isActive ? FontWeight.bold : FontWeight.w300,
                    ))
                : null,
            beforeLineStyle: LineStyle(
                thickness: 2,
                color: _isComplete || _isActive
                    ? Styles.secondaryAccent
                    : CupertinoColors.inactiveGray),
            afterLineStyle: LineStyle(
                thickness: 2,
                color: _isComplete
                    ? Styles.secondaryAccent
                    : CupertinoColors.inactiveGray),
            indicatorStyle: IndicatorStyle(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(6),
                drawGap: true,
                indicator: _buildDot(
                    context: context,
                    index: index,
                    isComplete: _isComplete,
                    isActive: _isActive)),
          ),
        );
      }),
    );
  }
}

class BasicProgressDots extends StatelessWidget {
  final int numDots;
  final int currentIndex;
  final double? dotSize;
  final Color? color;
  const BasicProgressDots(
      {Key? key,
      required this.numDots,
      required this.currentIndex,
      this.dotSize = 10,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(numDots, (index) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: currentIndex == index ? 1 : 0.4,
          child: Container(
            margin: const EdgeInsets.all(6),
            height: dotSize,
            width: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? context.theme.primary,
            ),
          ),
        );
      }),
    );
  }
}

class LoadingDots extends StatelessWidget {
  final Color? color;
  final double? size;
  const LoadingDots({Key? key, this.color, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
        color: color ?? CupertinoTheme.of(context).primaryColor,
        size: size ?? 20);
  }
}

class NavBarLoadingDots extends StatelessWidget {
  final Color? color;
  const NavBarLoadingDots({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SpinKitThreeBounce(
          color: color ?? CupertinoTheme.of(context).primaryColor, size: 13),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  final Color? color;
  final double? size;
  const LoadingCircle({Key? key, this.color, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
        lineWidth: 2,
        color: color ?? CupertinoTheme.of(context).primaryColor,
        size: size ?? 30);
  }
}

class LinearProgressIndicator extends StatelessWidget {
  final double progress;
  final double width;
  final double? height;
  final Duration animationDuration;
  final double progressColorOpacity;
  final Gradient? gradient;

  LinearProgressIndicator(
      {Key? key,
      required this.progress,
      required this.width,
      this.height = 6,
      this.progressColorOpacity = 1,
      this.gradient,
      this.animationDuration = const Duration(milliseconds: 100)})
      : super(key: key);

  final _borderRadius = BorderRadius.circular(30);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: Stack(
        children: <Widget>[
          Container(
            clipBehavior: Clip.hardEdge,
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              color: context.theme.primary.withOpacity(0.5),
            ),
          ),
          Opacity(
            opacity: progressColorOpacity,
            child: AnimatedContainer(
              height: height,
              width: progress * width,
              curve: Curves.easeIn,
              duration: animationDuration,
              decoration: BoxDecoration(
                  borderRadius: _borderRadius,
                  gradient: gradient ?? Styles.secondaryAccentGradient),
            ),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Color? color;
  final double diameter;
  final Border? border;
  const Dot({Key? key, this.color, required this.diameter, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        border: border,
        shape: BoxShape.circle,
        color: color ?? context.theme.primary,
      ),
    );
  }
}
