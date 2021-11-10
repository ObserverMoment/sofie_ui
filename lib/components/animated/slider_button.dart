import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Slider call to action component
class SliderButton extends StatefulWidget {
  /// The size of the sliding icon
  final double sliderButtonIconSize;

  /// Tha padding of the sliding icon
  final double sliderButtonIconPadding;

  /// The offset on the y axis of the slider icon
  final double sliderButtonYOffset;

  /// If the slider icon rotates
  final bool sliderRotate;

  /// The child that is rendered instead of the default Text widget
  final Widget? child;

  /// The height of the component
  final double height;

  /// The color of the inner circular button, of the tick icon of the text.
  /// If not set, this attribute defaults to primaryIconTheme.
  final Color? innerColor;

  /// The color of the external area and of the arrow icon.
  /// If not set, this attribute defaults to accentColor from your theme.
  final Color? outerColor;

  /// The text showed in the default Text widget
  final String? text;

  final FONTSIZE fontSize;

  /// The borderRadius of the sliding icon and of the background
  final double borderRadius;

  /// Callback called on submit
  /// If this is null the component will not animate to complete
  final VoidCallback? onSubmit;

  /// Elevation of the component
  final double elevation;

  /// The widget to render instead of the default icon
  final Widget? sliderButtonIcon;

  /// The widget to render instead of the default submitted icon
  final Widget? submittedIcon;

  /// The duration of the animations
  final Duration animationDuration;

  /// If true the widget will be reversed
  final bool reversed;

  /// the alignment of the widget once it's submitted
  final Alignment alignment;

  /// Create a new instance of the widget
  const SliderButton({
    Key? key,
    this.sliderButtonIconSize = 24,
    this.sliderButtonIconPadding = 16,
    this.sliderButtonYOffset = 0,
    this.sliderRotate = true,
    this.height = 70,
    this.outerColor,
    this.borderRadius = 52,
    this.elevation = 6,
    this.animationDuration = const Duration(milliseconds: 150),
    this.reversed = false,
    this.alignment = Alignment.center,
    this.submittedIcon,
    this.onSubmit,
    this.child,
    this.innerColor,
    this.text,
    this.fontSize = FONTSIZE.three,
    this.sliderButtonIcon,
  }) : super(key: key);
  @override
  SliderButtonState createState() => SliderButtonState();
}

/// Use a GlobalKey to access the state. This is the only way to call [SliderButtonState.reset]
class SliderButtonState extends State<SliderButton>
    with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _sliderKey = GlobalKey();
  double _dx = 0;
  double _maxDx = 0;
  double get _progress => _dx == 0 ? 0 : _dx / _maxDx;
  double _endDx = 0;
  double _dz = 1;
  double? _initialContainerWidth;
  double? _containerWidth;
  double _checkAnimationDx = 0;
  bool submitted = false;
  late AnimationController _checkAnimationController;
  late AnimationController _shrinkAnimationController;
  late AnimationController _resizeAnimationController;
  late AnimationController _cancelAnimationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: (details) async {
        _endDx = _dx;
        if (_progress <= 0.25 || widget.onSubmit == null) {
          _cancelAnimation();
        } else {
          widget.onSubmit!();
          await _resizeAnimation();

          await _shrinkAnimation();

          await _checkAnimation();

          Future.delayed(const Duration(milliseconds: 300), () async {
            await reset();
          });
        }
      },
      child: Align(
        alignment: widget.alignment,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(widget.reversed ? pi : 0),
          child: Container(
            key: _containerKey,
            height: widget.height,
            width: _containerWidth,
            constraints: _containerWidth != null
                ? null
                : BoxConstraints.expand(height: widget.height),
            child: Material(
              elevation: widget.elevation,
              color: widget.outerColor ?? Styles.primaryAccent,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: submitted
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(widget.reversed ? pi : 0),
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          children: <Widget>[
                            widget.submittedIcon ??
                                Icon(
                                  Icons.done,
                                  color: widget.innerColor ??
                                      context.theme.primary,
                                ),
                            Positioned.fill(
                              child: Transform(
                                transform: Matrix4.rotationY(
                                    _checkAnimationDx * (pi / 2)),
                                alignment: Alignment.centerRight,
                                child: Container(
                                  color:
                                      widget.outerColor ?? Styles.primaryAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Opacity(
                          opacity: 1 - 1 * _progress,
                          child: Transform(
                            alignment: Alignment.center,
                            transform:
                                Matrix4.rotationY(widget.reversed ? pi : 0),
                            child: widget.child ??
                                MyText(
                                  (widget.text ?? 'Slide to act').toUpperCase(),
                                  textAlign: TextAlign.center,
                                  size: widget.fontSize,
                                  color: widget.innerColor,
                                  weight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Positioned(
                          left: widget.sliderButtonYOffset,
                          child: Transform.scale(
                            scale: _dz,
                            origin: Offset(_dx, 0),
                            child: Transform.translate(
                              offset: Offset(_dx, 0),
                              child: Container(
                                key: _sliderKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius),
                                    color: widget.innerColor ??
                                        Styles.primaryAccent,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          widget.sliderButtonIconPadding),
                                      child: Transform.rotate(
                                        angle: widget.sliderRotate
                                            ? -pi * _progress
                                            : 0,
                                        child: Center(
                                          child: widget.sliderButtonIcon ??
                                              Icon(
                                                Icons.arrow_forward,
                                                size:
                                                    widget.sliderButtonIconSize,
                                                color: widget.outerColor ??
                                                    Styles.primaryAccent,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  /// Call this method to revert the animations
  Future reset() async {
    if (mounted) {
      await _checkAnimationController.reverse();

      submitted = false;

      await _shrinkAnimationController.reverse();

      await _resizeAnimationController.reverse();

      await _cancelAnimation();
    }
  }

  Future _checkAnimation() async {
    if (mounted) {
      _checkAnimationController.reset();

      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _checkAnimationController,
        curve: Curves.slowMiddle,
      ));

      animation.addListener(() {
        if (mounted) {
          setState(() {
            _checkAnimationDx = animation.value;
          });
        }
      });
      await _checkAnimationController.forward();
    }
  }

  Future _shrinkAnimation() async {
    if (mounted) {
      _shrinkAnimationController.reset();

      final diff = _initialContainerWidth! - widget.height;
      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _shrinkAnimationController,
        curve: Curves.easeOutCirc,
      ));

      animation.addListener(() {
        if (mounted) {
          setState(() {
            _containerWidth =
                _initialContainerWidth! - (diff * animation.value);
          });
        }
      });

      setState(() {
        submitted = true;
      });
      await _shrinkAnimationController.forward();
    }
  }

  Future _resizeAnimation() async {
    if (mounted) {
      _resizeAnimationController.reset();

      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _resizeAnimationController,
        curve: Curves.easeInBack,
      ));

      animation.addListener(() {
        if (mounted) {
          setState(() {
            _dz = 1 - animation.value;
          });
        }
      });
      await _resizeAnimationController.forward();
    }
  }

  Future _cancelAnimation() async {
    if (mounted) {
      _cancelAnimationController.reset();
      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _cancelAnimationController,
        curve: Curves.fastOutSlowIn,
      ));

      animation.addListener(() {
        if (mounted) {
          setState(() {
            _dx = _endDx - (_endDx * animation.value);
          });
        }
      });
      _cancelAnimationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _cancelAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _checkAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _shrinkAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _resizeAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final containerBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox?;
      _containerWidth = containerBox?.size.width ?? 300.0;
      _initialContainerWidth = _containerWidth;

      final sliderBox =
          _sliderKey.currentContext!.findRenderObject() as RenderBox?;

      final sliderWidth = sliderBox?.size.width ?? _containerWidth;

      _maxDx = _containerWidth! -
          (sliderWidth! / 2) -
          40 -
          widget.sliderButtonYOffset;
    });
  }

  @override
  void dispose() {
    _cancelAnimationController.dispose();
    _checkAnimationController.dispose();
    _shrinkAnimationController.dispose();
    _resizeAnimationController.dispose();
    super.dispose();
  }
}
