import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

// The corner radius of the thumb.
const Radius _kThumbRadius = Radius.circular(60);
// The amount of space by which to expand the thumb from the size of the currently
// selected child.
const EdgeInsets _kThumbInsets = EdgeInsets.symmetric(horizontal: 1);

// Minimum height of the segmented control.
const double _kMinSegmentedControlHeight = 28.0;

// The amount of space by which to inset each separator.
// const EdgeInsets _kSeparatorInset = EdgeInsets.symmetric(vertical: 6);
const double _kSeparatorWidth = 0;

// The minimum scale factor of the thumb, when being pressed on for a sufficient
// amount of time.
const double _kMinThumbScale = 0.95;

// The minimum horizontal distance between the edges of the separator and the
// closest child.
const double _kSegmentMinPadding = 9.25;

// The threshold value used in hasDraggedTooFar, for checking against the square
// L2 distance from the location of the current drag pointer, to the closest
// vertex of the MySlidingSegmentedControl's Rect.
//
// Both the mechanism and the value are speculated.
const double _kTouchYDistanceThreshold = 50.0 * 50.0;

// The minimum opacity of an unselected segment, when the user presses on the
// segment and it starts to fadeout.
//
// Inspected from iOS 13.2 simulator.
const double _kContentPressedMinOpacity = 0.2;

// The spring animation used when the thumb changes its rect.
final SpringSimulation _kThumbSpringAnimationSimulation = SpringSimulation(
  const SpringDescription(mass: 1, stiffness: 503.551, damping: 44.8799),
  0,
  1,
  0, // Every time a new spring animation starts the previous animation stops.
);

const Duration _kSpringAnimationDuration = Duration(milliseconds: 412);

const Duration _kOpacityAnimationDuration = Duration(milliseconds: 470);

const Duration _kHighlightAnimationDuration = Duration(milliseconds: 200);

class MySlidingSegmentedControl<T> extends StatefulWidget {
  /// The map must have more than one entry.
  final Map<T, String> children;

  /// If this attribute is null, no widget will be initially selected.
  final T? value;
  final ValueChanged<T> updateValue;

  /// Will default to [theme.cardBackground].
  final Color? backgroundColor;

  /// [backgroundTransparent] will override [backgroundColor]
  final bool backgroundTransparent;

  /// Defaults to [theme.background]
  final Color? thumbColor;

  /// The amount of space by which to inset the [children].
  final EdgeInsetsGeometry containerPadding;

  /// The amount of child padding.
  final EdgeInsetsGeometry childPadding;
  final EdgeInsetsGeometry margin;

  final double fontSize;

  MySlidingSegmentedControl({
    Key? key,
    required this.children,
    required this.updateValue,
    required this.value,
    this.thumbColor,
    this.backgroundColor,
    this.containerPadding =
        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    this.childPadding =
        const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
    this.backgroundTransparent = false,
    this.fontSize = 17,
    this.margin = const EdgeInsets.symmetric(vertical: 4.0),
  })  : assert(children.length >= 2),
        assert(
          value == null || children.keys.contains(value),
          'The groupValue must be either null or one of the keys in the children map.',
        ),
        super(key: key);

  @override
  State<MySlidingSegmentedControl<T>> createState() =>
      _SegmentedControlState<T>();
}

class _SegmentedControlState<T> extends State<MySlidingSegmentedControl<T>>
    with TickerProviderStateMixin<MySlidingSegmentedControl<T>> {
  late final AnimationController thumbController = AnimationController(
      duration: _kSpringAnimationDuration, value: 0, vsync: this);
  Animatable<Rect?>? thumbAnimatable;

  late final AnimationController thumbScaleController = AnimationController(
      duration: _kSpringAnimationDuration, value: 0, vsync: this);
  late Animation<double> thumbScaleAnimation =
      thumbScaleController.drive(Tween<double>(begin: 1, end: _kMinThumbScale));

  final TapGestureRecognizer tap = TapGestureRecognizer();
  final HorizontalDragGestureRecognizer drag =
      HorizontalDragGestureRecognizer();
  final LongPressGestureRecognizer longPress = LongPressGestureRecognizer();

  @override
  void initState() {
    super.initState();
    // If the long press or horizontal drag recognizer gets accepted, we know for
    // sure the gesture is meant for the segmented control. Hand everything to
    // the drag gesture recognizer.
    final GestureArenaTeam team = GestureArenaTeam();
    longPress.team = team;
    drag.team = team;
    team.captain = drag;

    drag
      ..onDown = onDown
      ..onUpdate = onUpdate
      ..onEnd = onEnd
      ..onCancel = onCancel;

    tap.onTapUp = onTapUp;

    // Empty callback to enable the long press recognizer.
    longPress.onLongPress = () {};

    highlighted = widget.value;
  }

  @override
  void didUpdateWidget(MySlidingSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Temporarily ignore highlight changes from the widget when the thumb is
    // being dragged. When the drag gesture finishes the widget will be forced
    // to build (see the onEnd method), and didUpdateWidget will be called again.
    if (!isThumbDragging && highlighted != widget.value) {
      thumbController.animateWith(_kThumbSpringAnimationSimulation);
      thumbAnimatable = null;
      highlighted = widget.value;
    }
  }

  @override
  void dispose() {
    thumbScaleController.dispose();
    thumbController.dispose();

    drag.dispose();
    tap.dispose();
    longPress.dispose();

    super.dispose();
  }

  // Whether the current drag gesture started on a selected segment. When this
  // flag is false, the `onUpdate` method does not update `highlighted`.
  // Otherwise the thumb can be dragged around in an ongoing drag gesture.
  bool? _startedOnSelectedSegment;

  // Whether an ongoing horizontal drag gesture that started on the thumb is
  // present. When true, defer/ignore changes to the `highlighted` variable
  // from other sources (except for semantics) until the gesture ends, preventing
  // them from interfering with the active drag gesture.
  bool get isThumbDragging => _startedOnSelectedSegment ?? false;

  // Converts local coordinate to segments. This method assumes each segment has
  // the same width.
  T segmentForXPosition(double dx) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final int numOfChildren = widget.children.length;
    assert(renderBox.hasSize);
    assert(numOfChildren >= 2);
    int index = (dx ~/ (renderBox.size.width / numOfChildren))
        .clamp(0, numOfChildren - 1);

    switch (Directionality.of(context)) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        index = numOfChildren - 1 - index;
        break;
    }

    return widget.children.keys.elementAt(index);
  }

  bool _hasDraggedTooFar(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    assert(renderBox.hasSize);
    final Size size = renderBox.size;
    final Offset offCenter =
        details.localPosition - Offset(size.width / 2, size.height / 2);
    final double l2 =
        math.pow(math.max(0.0, offCenter.dx.abs() - size.width / 2), 2) +
                math.pow(math.max(0.0, offCenter.dy.abs() - size.height / 2), 2)
            as double;
    return l2 > _kTouchYDistanceThreshold;
  }

  // The thumb shrinks when the user presses on it, and starts expanding when
  // the user lets go.
  // This animation must be synced with the segment scale animation (see the
  // _Segment widget) to make the overall animation look natural when the thumb
  // is not sliding.
  void _playThumbScaleAnimation({required bool isExpanding}) {
    thumbScaleAnimation = thumbScaleController.drive(
      Tween<double>(
        begin: thumbScaleAnimation.value,
        end: isExpanding ? 1 : _kMinThumbScale,
      ),
    );
    thumbScaleController.animateWith(_kThumbSpringAnimationSimulation);
  }

  void onHighlightChangedByGesture(T newValue) {
    if (highlighted == newValue) return;
    setState(() {
      highlighted = newValue;
    });
    // Additionally, start the thumb animation if the highlighted segment
    // changes. If the thumbController is already running, the render object's
    // paint method will create a new tween to drive the animation with.
    // TODO(LongCatIsLooong): https://github.com/flutter/flutter/issues/74356:
    // the current thumb will be painted at the same location twice (before and
    // after the new animation starts).
    thumbController.animateWith(_kThumbSpringAnimationSimulation);
    thumbAnimatable = null;
  }

  void onPressedChangedByGesture(T? newValue) {
    if (pressed != newValue) {
      setState(() {
        pressed = newValue;
      });
    }
  }

  void onTapUp(TapUpDetails details) {
    // No gesture should interfere with an ongoing thumb drag.
    if (isThumbDragging) return;
    final T segment = segmentForXPosition(details.localPosition.dx);
    onPressedChangedByGesture(null);
    if (segment != widget.value && segment != null) {
      widget.updateValue(segment);
    }
  }

  void onDown(DragDownDetails details) {
    final T touchDownSegment = segmentForXPosition(details.localPosition.dx);
    _startedOnSelectedSegment = touchDownSegment == highlighted;
    onPressedChangedByGesture(touchDownSegment);

    if (isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: false);
    }
  }

  void onUpdate(DragUpdateDetails details) {
    if (isThumbDragging) {
      final T segment = segmentForXPosition(details.localPosition.dx);
      onPressedChangedByGesture(segment);
      onHighlightChangedByGesture(segment);
    } else {
      final T? segment = _hasDraggedTooFar(details)
          ? null
          : segmentForXPosition(details.localPosition.dx);
      onPressedChangedByGesture(segment);
    }
  }

  void onEnd(DragEndDetails details) {
    final T? pressed = this.pressed;
    if (isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: true);
      if (highlighted != widget.value && highlighted != null) {
        widget.updateValue(highlighted!);
      }
    } else if (pressed != null) {
      onHighlightChangedByGesture(pressed);
      assert(pressed == highlighted);
      if (highlighted != widget.value && highlighted != null) {
        widget.updateValue(highlighted!);
      }
    }

    onPressedChangedByGesture(null);
    _startedOnSelectedSegment = null;
  }

  void onCancel() {
    if (isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: true);
    }

    onPressedChangedByGesture(null);
    _startedOnSelectedSegment = null;
  }

  // The segment the sliding thumb is currently located at, or animating to. It
  // may have a different value from widget.groupValue, since this widget does
  // not report a selection change via `onValueChanged` until the user stops
  // interacting with the widget (onTapUp). For example, the user can drag the
  // thumb around, and the `onValueChanged` callback will not be invoked until
  // the thumb is let go.
  T? highlighted;

  // The segment the user is currently pressing.
  T? pressed;

  @override
  Widget build(BuildContext context) {
    final Color thumbColor = widget.thumbColor ?? context.theme.background;
    final Color backgroundColor =
        widget.backgroundColor ?? context.theme.cardBackground;

    assert(widget.children.length >= 2);
    List<Widget> children = <Widget>[];
    bool isPreviousSegmentHighlighted = false;

    int index = 0;
    int? highlightedIndex;
    for (final MapEntry<T, String> entry in widget.children.entries) {
      final bool isHighlighted = highlighted == entry.key;
      if (isHighlighted) {
        highlightedIndex = index;
      }

      if (index != 0) {
        children.add(
          _SegmentSeparator(
            // Let separators be TextDirection-invariant. If the TextDirection
            // changes, the separators should mostly stay where they were.
            key: ValueKey<int>(index),
            highlighted: isPreviousSegmentHighlighted || isHighlighted,
          ),
        );
      }

      children.add(
        Semantics(
          button: true,
          onTap: () {
            widget.updateValue(entry.key);
          },
          inMutuallyExclusiveGroup: true,
          selected: widget.value == entry.key,
          child: _Segment<T>(
              key: ValueKey<T>(entry.key),
              highlighted: isHighlighted,
              pressed: pressed == entry.key,
              isDragging: isThumbDragging,
              text: entry.value,
              padding: widget.childPadding,
              fontSize: widget.fontSize),
        ),
      );

      index += 1;
      isPreviousSegmentHighlighted = isHighlighted;
    }

    assert((highlightedIndex == null) == (highlighted == null));

    switch (Directionality.of(context)) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        children = children.reversed.toList(growable: false);
        if (highlightedIndex != null) {
          highlightedIndex = index - 1 - highlightedIndex;
        }
        break;
    }

    return Padding(
      padding: widget.margin,
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: Container(
          padding: widget.containerPadding.resolve(Directionality.of(context)),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(_kThumbRadius),
            color: widget.backgroundTransparent
                ? material.Colors.transparent
                : backgroundColor,
          ),
          child: AnimatedBuilder(
            animation: thumbScaleAnimation,
            builder: (BuildContext context, Widget? child) {
              return _SegmentedControlRenderWidget<T>(
                highlightedIndex: highlightedIndex,
                thumbScale: thumbScaleAnimation.value,
                thumbColor: thumbColor,
                state: this,
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Segment<T> extends StatefulWidget {
  const _Segment({
    required ValueKey<T> key,
    required this.text,
    required this.pressed,
    required this.highlighted,
    required this.isDragging,
    required this.padding,
    required this.fontSize,
  }) : super(key: key);

  final String text;
  final double fontSize;

  final bool pressed;
  final bool highlighted;

  // Whether the thumb of the parent widget (MySlidingSegmentedControl)
  // is currently being dragged.
  final bool isDragging;

  final EdgeInsetsGeometry padding;

  bool get shouldFadeoutContent => pressed && !highlighted;
  bool get shouldScaleContent => pressed && highlighted && isDragging;

  @override
  _SegmentState<T> createState() => _SegmentState<T>();
}

class _SegmentState<T> extends State<_Segment<T>>
    with TickerProviderStateMixin<_Segment<T>> {
  late final AnimationController highlightPressScaleController;
  late Animation<double> highlightPressScaleAnimation;

  @override
  void initState() {
    super.initState();
    highlightPressScaleController = AnimationController(
      duration: _kOpacityAnimationDuration,
      value: widget.shouldScaleContent ? 1 : 0,
      vsync: this,
    );

    highlightPressScaleAnimation = highlightPressScaleController.drive(
      Tween<double>(begin: 1.0, end: _kMinThumbScale),
    );
  }

  @override
  void didUpdateWidget(_Segment<T> oldWidget) {
    assert(oldWidget.key == widget.key);
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldScaleContent != widget.shouldScaleContent) {
      highlightPressScaleAnimation = highlightPressScaleController.drive(
        Tween<double>(
          begin: highlightPressScaleAnimation.value,
          end: widget.shouldScaleContent ? _kMinThumbScale : 1.0,
        ),
      );
      highlightPressScaleController
          .animateWith(_kThumbSpringAnimationSimulation);
    }
  }

  Widget get _buildChild => Padding(
        padding: widget.padding,
        child: Text(widget.text),
      );

  @override
  void dispose() {
    highlightPressScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MetaData(
      behavior: HitTestBehavior.opaque,
      child: IndexedStack(
        index: 0,
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity:
                widget.shouldFadeoutContent ? _kContentPressedMinOpacity : 1,
            duration: _kOpacityAnimationDuration,
            curve: Curves.ease,
            child: AnimatedDefaultTextStyle(
              style: DefaultTextStyle.of(context).style.merge(TextStyle(
                    fontSize: widget.fontSize,
                    color: context.theme.primary,
                    fontWeight: widget.highlighted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              duration: _kHighlightAnimationDuration,
              curve: Curves.ease,
              child: ScaleTransition(
                scale: highlightPressScaleAnimation,
                child: _buildChild,
              ),
            ),
          ),
          // The entire widget will assume the size of this widget, so when a
          // segment's "highlight" animation plays the size of the parent stays
          // the same and will always be greater than equal to that of the
          // visible child (at index 0), to keep the size of the entire
          // SegmentedControl widget consistent throughout the animation.
          Offstage(
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              child: _buildChild,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedControlRenderWidget<T> extends MultiChildRenderObjectWidget {
  _SegmentedControlRenderWidget({
    Key? key,
    List<Widget> children = const <Widget>[],
    required this.highlightedIndex,
    required this.thumbColor,
    required this.thumbScale,
    required this.state,
  }) : super(key: key, children: children);

  final int? highlightedIndex;
  final Color thumbColor;
  final double thumbScale;
  final _SegmentedControlState<T> state;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSegmentedControl<T>(
      highlightedIndex: highlightedIndex,
      thumbColor: thumbColor,
      thumbScale: thumbScale,
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSegmentedControl<T> renderObject) {
    assert(renderObject.state == state);
    renderObject
      ..thumbColor = thumbColor
      ..thumbScale = thumbScale
      ..highlightedIndex = highlightedIndex;
  }
}

class _SegmentedControlContainerBoxParentData
    extends ContainerBoxParentData<RenderBox> {}

// The behavior of a UISegmentedControl as observed on iOS 13.1:
//
// 1. Tap up inside events will set the current selected index to the index of the
//    segment at the tap up location instantaneously (there might be animation but
//    the index change seems to happen before animation finishes), unless the tap
//    down event from the same touch event didn't happen within the segmented
//    control, in which case the touch event will be ignored entirely (will be
//    referring to these touch events as invalid touch events below).
//
// 2. A valid tap up event will also trigger the sliding CASpringAnimation (even
//    when it lands on the current segment), starting from the current `frame`
//    of the thumb. The previous sliding animation, if still playing, will be
//    removed and its velocity reset to 0. The sliding animation has a fixed
//    duration, regardless of the distance or transform.
//
// 3. When the sliding animation plays two other animations take place. In one animation
//    the content of the current segment gradually becomes "highlighted", turning the
//    font weight to semibold (CABasicAnimation, timingFunction = default, duration = 0.2).
//    The other is the separator fadein/fadeout animation (duration = 0.41).
//
// 4. A tap down event on the segment pointed to by the current selected
//    index will trigger a CABasicAnimation that shrinks the thumb to 95% of its
//    original size, even if the sliding animation is still playing. The
///   corresponding tap up event inverts the process (eyeballed).
//
// 5. A tap down event on other segments will trigger a CABasicAnimation
//    (timingFunction = default, duration = 0.47.) that fades out the content
//    from its current alpha, eventually reducing the alpha of that segment to
//    20% unless interrupted by a tap up event or the pointer moves out of the
//    region (either outside of the segmented control's vicinity or to a
//    different segment). The reverse animation has the same duration and timing
//    function.
class _RenderSegmentedControl<T> extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            ContainerBoxParentData<RenderBox>>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            ContainerBoxParentData<RenderBox>> {
  _RenderSegmentedControl({
    required int? highlightedIndex,
    required Color thumbColor,
    required double thumbScale,
    required this.state,
  })  : _highlightedIndex = highlightedIndex,
        _thumbColor = thumbColor,
        _thumbScale = thumbScale;

  final _SegmentedControlState<T> state;

  // The current **Unscaled** Thumb Rect in this RenderBox's coordinate space.
  Rect? currentThumbRect;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    state.thumbController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    state.thumbController.removeListener(markNeedsPaint);
    super.detach();
  }

  double get thumbScale => _thumbScale;
  double _thumbScale;
  set thumbScale(double value) {
    if (_thumbScale == value) {
      return;
    }

    _thumbScale = value;
    if (state.highlighted != null) markNeedsPaint();
  }

  int? get highlightedIndex => _highlightedIndex;
  int? _highlightedIndex;
  set highlightedIndex(int? value) {
    if (_highlightedIndex == value) {
      return;
    }

    _highlightedIndex = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) {
      return;
    }
    _thumbColor = value;
    markNeedsPaint();
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    // No gesture should interfere with an ongoing thumb drag.
    if (event is PointerDownEvent && !state.isThumbDragging) {
      state.tap.addPointer(event);
      state.longPress.addPointer(event);
      state.drag.addPointer(event);
    }
  }

  // Intrinsic Dimensions

  double get totalSeparatorWidth => 0;

  RenderBox? nonSeparatorChildAfter(RenderBox child) {
    final RenderBox? nextChild = childAfter(child);
    return nextChild == null ? null : childAfter(nextChild);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final int childCount = this.childCount ~/ 2 + 1;
    RenderBox? child = firstChild;
    double maxMinChildWidth = 0;
    while (child != null) {
      final double childWidth = child.getMinIntrinsicWidth(height);
      maxMinChildWidth = math.max(maxMinChildWidth, childWidth);
      child = nonSeparatorChildAfter(child);
    }
    return (maxMinChildWidth + 2 * _kSegmentMinPadding) * childCount +
        totalSeparatorWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final int childCount = this.childCount ~/ 2 + 1;
    RenderBox? child = firstChild;
    double maxMaxChildWidth = 0;
    while (child != null) {
      final double childWidth = child.getMaxIntrinsicWidth(height);
      maxMaxChildWidth = math.max(maxMaxChildWidth, childWidth);
      child = nonSeparatorChildAfter(child);
    }
    return (maxMaxChildWidth + 2 * _kSegmentMinPadding) * childCount +
        totalSeparatorWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    RenderBox? child = firstChild;
    double maxMinChildHeight = _kMinSegmentedControlHeight;
    while (child != null) {
      final double childHeight = child.getMinIntrinsicHeight(width);
      maxMinChildHeight = math.max(maxMinChildHeight, childHeight);
      child = nonSeparatorChildAfter(child);
    }
    return maxMinChildHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    RenderBox? child = firstChild;
    double maxMaxChildHeight = _kMinSegmentedControlHeight;
    while (child != null) {
      final double childHeight = child.getMaxIntrinsicHeight(width);
      maxMaxChildHeight = math.max(maxMaxChildHeight, childHeight);
      child = nonSeparatorChildAfter(child);
    }
    return maxMaxChildHeight;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SegmentedControlContainerBoxParentData) {
      child.parentData = _SegmentedControlContainerBoxParentData();
    }
  }

  Size _calculateChildSize(BoxConstraints constraints) {
    final int childCount = this.childCount ~/ 2 + 1;
    double childWidth =
        (constraints.minWidth - totalSeparatorWidth) / childCount;
    double maxHeight = _kMinSegmentedControlHeight;
    RenderBox? child = firstChild;
    while (child != null) {
      childWidth = math.max(
          childWidth,
          child.getMaxIntrinsicWidth(double.infinity) +
              2 * _kSegmentMinPadding);
      child = nonSeparatorChildAfter(child);
    }
    childWidth = math.min(
      childWidth,
      (constraints.maxWidth - totalSeparatorWidth) / childCount,
    );
    child = firstChild;
    while (child != null) {
      final double boxHeight = child.getMaxIntrinsicHeight(childWidth);
      maxHeight = math.max(maxHeight, boxHeight);
      child = nonSeparatorChildAfter(child);
    }
    return Size(childWidth, maxHeight);
  }

  Size _computeOverallSizeFromChildSize(
      Size childSize, BoxConstraints constraints) {
    final int childCount = this.childCount ~/ 2 + 1;
    return constraints.constrain(Size(
        childSize.width * childCount + totalSeparatorWidth, childSize.height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final Size childSize = _calculateChildSize(constraints);
    return _computeOverallSizeFromChildSize(childSize, constraints);
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final Size childSize = _calculateChildSize(constraints);
    final BoxConstraints childConstraints = BoxConstraints.tight(childSize);
    final BoxConstraints separatorConstraints =
        childConstraints.heightConstraints();

    RenderBox? child = firstChild;
    int index = 0;
    double start = 0;
    while (child != null) {
      child.layout(index.isEven ? childConstraints : separatorConstraints,
          parentUsesSize: true);
      final _SegmentedControlContainerBoxParentData childParentData =
          child.parentData! as _SegmentedControlContainerBoxParentData;
      final Offset childOffset = Offset(start, 0);
      childParentData.offset = childOffset;
      start += child.size.width;

      child = childAfter(child);
      index += 1;
    }

    size = _computeOverallSizeFromChildSize(childSize, constraints);
  }

  // This method is used to convert the original unscaled thumb rect painted in
  // the previous frame, to a Rect that is within the valid boundary defined by
  // the child segments.
  //
  // The overall size does not include that of the thumb. That is, if the thumb
  // is located at the first or the last segment, the thumb can get cut off if
  // one of the values in _kThumbInsets is positive.
  Rect? moveThumbRectInBound(Rect? thumbRect, List<RenderBox> children) {
    assert(hasSize);
    assert(children.length >= 2);
    if (thumbRect == null) return null;

    final Offset firstChildOffset =
        (children.first.parentData! as _SegmentedControlContainerBoxParentData)
            .offset;
    final double leftMost = firstChildOffset.dx;
    final double rightMost =
        (children.last.parentData! as _SegmentedControlContainerBoxParentData)
                .offset
                .dx +
            children.last.size.width;
    assert(rightMost > leftMost);

    // Ignore the horizontal position and the height of `thumbRect`, and
    // calculates them from `children`.
    return Rect.fromLTRB(
      math.max(thumbRect.left, leftMost - _kThumbInsets.left),
      firstChildOffset.dy - _kThumbInsets.top,
      math.min(thumbRect.right, rightMost + _kThumbInsets.right),
      firstChildOffset.dy + children.first.size.height + _kThumbInsets.bottom,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final List<RenderBox> children = getChildrenAsList();

    for (int index = 1; index < childCount; index += 2) {
      _paintSeparator(context, offset, children[index]);
    }

    final int? highlightedChildIndex = highlightedIndex;
    // Paint thumb if there's a highlighted segment.
    if (highlightedChildIndex != null) {
      final RenderBox selectedChild = children[highlightedChildIndex * 2];

      final _SegmentedControlContainerBoxParentData childParentData =
          selectedChild.parentData! as _SegmentedControlContainerBoxParentData;
      final Rect newThumbRect = _kThumbInsets
          .inflateRect(childParentData.offset & selectedChild.size);

      // Update thumb animation's tween, in case the end rect changed (e.g., a
      // new segment is added during the animation).
      if (state.thumbController.isAnimating) {
        final Animatable<Rect?>? thumbTween = state.thumbAnimatable;
        if (thumbTween == null) {
          // This is the first frame of the animation.
          final Rect startingRect =
              moveThumbRectInBound(currentThumbRect, children) ?? newThumbRect;
          state.thumbAnimatable =
              RectTween(begin: startingRect, end: newThumbRect);
        } else if (newThumbRect != thumbTween.transform(1)) {
          // The thumbTween of the running sliding animation needs updating,
          // without restarting the animation.
          final Rect startingRect =
              moveThumbRectInBound(currentThumbRect, children) ?? newThumbRect;
          state.thumbAnimatable =
              RectTween(begin: startingRect, end: newThumbRect).chain(
                  CurveTween(curve: Interval(state.thumbController.value, 1)));
        }
      } else {
        state.thumbAnimatable = null;
      }

      final Rect unscaledThumbRect =
          state.thumbAnimatable?.evaluate(state.thumbController) ??
              newThumbRect;
      currentThumbRect = unscaledThumbRect;
      final Rect thumbRect = Rect.fromCenter(
        center: unscaledThumbRect.center,
        width: unscaledThumbRect.width * thumbScale,
        height: unscaledThumbRect.height * thumbScale,
      );

      _paintThumb(context, offset, thumbRect);
    } else {
      currentThumbRect = null;
    }

    for (int index = 0; index < children.length; index += 2) {
      _paintChild(context, offset, children[index]);
    }
  }

  // Paint the separator to the right of the given child.
  final Paint separatorPaint = Paint();
  void _paintSeparator(
      PaintingContext context, Offset offset, RenderBox child) {
    final _SegmentedControlContainerBoxParentData childParentData =
        child.parentData! as _SegmentedControlContainerBoxParentData;
    context.paintChild(child, offset + childParentData.offset);
  }

  void _paintChild(PaintingContext context, Offset offset, RenderBox child) {
    final _SegmentedControlContainerBoxParentData childParentData =
        child.parentData! as _SegmentedControlContainerBoxParentData;
    context.paintChild(child, childParentData.offset + offset);
  }

  void _paintThumb(PaintingContext context, Offset offset, Rect thumbRect) {
    // Colors extracted from https://developer.apple.com/design/resources/.
    const List<BoxShadow> thumbShadow = <BoxShadow>[
      BoxShadow(
        color: Color(0x1F000000),
        offset: Offset(0, 3),
        blurRadius: 8,
      ),
      BoxShadow(
        color: Color(0x0A000000),
        offset: Offset(0, 3),
        blurRadius: 1,
      ),
    ];

    final RRect thumbRRect =
        RRect.fromRectAndRadius(thumbRect.shift(offset), _kThumbRadius);

    for (final BoxShadow shadow in thumbShadow) {
      context.canvas
          .drawRRect(thumbRRect.shift(shadow.offset), shadow.toPaint());
    }

    context.canvas.drawRRect(
      thumbRRect.inflate(0.5),
      Paint()..color = const Color(0x0A000000),
    );

    context.canvas.drawRRect(
      thumbRRect,
      Paint()..color = thumbColor,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _SegmentedControlContainerBoxParentData childParentData =
          child.parentData! as _SegmentedControlContainerBoxParentData;
      if ((childParentData.offset & child.size).contains(position)) {
        return result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset localOffset) {
            assert(localOffset == position - childParentData.offset);
            return child!.hitTest(result, position: localOffset);
          },
        );
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}

class _SegmentSeparator extends StatelessWidget {
  const _SegmentSeparator({
    required ValueKey<int> key,
    required this.highlighted,
  }) : super(key: key);

  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: _kSeparatorWidth);
  }
}
