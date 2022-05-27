import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_spinners.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
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
                gradient: isComplete ? Styles.primaryAccentGradient : null,
                border: Border.all(
                    color: isComplete || isActive
                        ? Styles.primaryAccent
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
        final isComplete = currentStage > index;
        final isActive = currentStage == index;

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
                    opacity: isComplete || isActive ? 1 : 0.6,
                    child: MyText(
                      titles![index],
                      weight: isActive ? FontWeight.bold : FontWeight.w300,
                    ))
                : null,
            beforeLineStyle: LineStyle(
                thickness: 2,
                color: isComplete || isActive
                    ? Styles.primaryAccent
                    : CupertinoColors.inactiveGray),
            afterLineStyle: LineStyle(
                thickness: 2,
                color: isComplete
                    ? Styles.primaryAccent
                    : CupertinoColors.inactiveGray),
            indicatorStyle: IndicatorStyle(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(6),
                drawGap: true,
                indicator: _buildDot(
                    context: context,
                    index: index,
                    isComplete: isComplete,
                    isActive: isActive)),
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

/// DEPRECATED ////
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  const LoadingIndicator({Key? key, this.color, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: size ?? 20);
  }
}

class NavBarLoadingIndicator extends StatelessWidget {
  final Color? color;
  const NavBarLoadingIndicator({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: LoadingSpinnerCircle(size: 14),
    );
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
                  gradient: gradient ?? Styles.primaryAccentGradient),
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

/// Full page indicator wrapped in a CupertinoPageScaffold.
/// For use when objects can be "not found" by the API (i.e when return result is nullable and the object has been deleted).
class ObjectNotFoundIndicator extends StatelessWidget {
  final double size;

  /// E.g. Workout or User's Profile. For display in message.
  final String? notFoundItemName;

  /// Message will override any [objectType]
  final String? message;
  const ObjectNotFoundIndicator(
      {Key? key, this.size = 90, this.message, this.notFoundItemName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = message ??
        'Sorry, we could not find ${notFoundItemName ?? "the required data"}. It may have been moved or deleted.';

    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Item Not Found'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Opacity(
                opacity: 0.6,
                child: Icon(MyCustomIcons.itemNotFoundIcon, size: size)),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyText(
                msg,
                maxLines: 3,
                subtext: true,
                lineHeight: 1.4,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoResultsToDisplay extends StatelessWidget {
  final String message;
  const NoResultsToDisplay({Key? key, this.message = 'No results to display'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.search,
          size: 70,
          color: context.theme.primary.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
          child: MyText(
            message,
            color: context.theme.primary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class PageResultsErrorIndicator extends StatelessWidget {
  final String message;
  const PageResultsErrorIndicator(
      {Key? key, this.message = 'Something went wrong...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.exclamationmark_octagon_fill,
          size: 70,
          color: context.theme.primary.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
          child: MyText(
            message,
            subtext: true,
          ),
        ),
      ],
    );
  }
}
