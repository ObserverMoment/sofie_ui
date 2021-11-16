import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';

/// Animates into a tick and then animates resets, ready for another submission.
/// Only the text animates into a tick - the rest of the container does not animate. Variation on [AnimatedSubmitButton].
class AnimatedSubmitButtonV2 extends StatefulWidget {
  /// The size of the sliding icon
  final double checkIconSize;

  /// The height of the component
  final double height;

  /// The text showed in the default Text widget
  final String? text;

  final FONTSIZE fontSize;

  /// The borderRadius of the sliding icon and of the background
  final double borderRadius;

  /// Callback called on submit
  /// If this is null the component will not animate to complete
  final VoidCallback? onSubmit;

  /// The duration of the animations
  final Duration animationDuration;

  /// Create a new instance of the widget
  const AnimatedSubmitButtonV2({
    Key? key,
    this.checkIconSize = 34,
    this.height = 90,
    this.borderRadius = 52,
    this.animationDuration = const Duration(milliseconds: 400),
    this.onSubmit,
    this.text,
    this.fontSize = FONTSIZE.five,
  }) : super(key: key);
  @override
  AnimatedSubmitButtonV2State createState() => AnimatedSubmitButtonV2State();
}

/// Use a GlobalKey to access the state. This is the only way to call [setCompleteButtonState.reset]
class AnimatedSubmitButtonV2State extends State<AnimatedSubmitButtonV2> {
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Vibrate.feedback(FeedbackType.light);
        if (!submitted) {
          widget.onSubmit!();
          setState(() {
            submitted = true;
          });

          Future.delayed(const Duration(milliseconds: 1000), () async {
            await reset();
          });
        }
      },
      child: Align(
        child: Container(
            height: widget.height,
            constraints: BoxConstraints.expand(height: widget.height),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: Styles.primaryAccentGradient,
            ),
            child: Center(
              child: AnimatedSwitcher(
                  duration: widget.animationDuration,
                  child: submitted
                      ? Icon(
                          CupertinoIcons.checkmark_alt,
                          color: Styles.white,
                          size: widget.checkIconSize,
                        )
                      : MyText(
                          submitted == true
                              ? ''
                              : (widget.text ?? 'Submit').toUpperCase(),
                          textAlign: TextAlign.center,
                          size: widget.fontSize,
                          color: Styles.white,
                        )),
            )),
      ),
    );
  }

  /// Call this method to revert the animations
  Future reset() async {
    if (mounted) {
      setState(() {
        submitted = false;
      });
    }
  }
}
