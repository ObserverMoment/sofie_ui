import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

enum ExitAnimProps { offset, scale }

/// A wrapper that will animate itself and its child offscreen, then reduce its size to zero, before calling a remove item function to remove it from its parent list
/// Used in lists to allow items to animate out smoothly when deleted.
/// Remove action is provided by default - other actions can be supplied.
/// Initially intended for use with workoutMoves in lists.
/// A confirmation prompt will display before running the animation and removeItem callback.
/// See below for a non animated verion of this widget aka [MySlidable]
class AnimatedSlidable extends StatefulWidget {
  @override
  final Key key;
  final int index;
  final Widget child;

  /// Remove is added by default - just provide a removeItem callback
  final List<IconSlideAction> secondaryActions;
  // final List<SlidableAction> secondaryActions;
  final Function(int index) removeItem;
  final bool enabled;
  final String itemType;
  final String? itemName;
  final String? confirmMessage;

  /// Before the type. Eg Delete Workout vs Remove Workout vs Archive Workout.
  /// [verb] [itemType] will display.
  /// [verb] will also display on the [IconSlideAction].
  final String? verb;

  /// For the delete action.
  final IconData iconData;

  const AnimatedSlidable({
    required this.key,
    required this.child,
    required this.removeItem,
    required this.secondaryActions,
    required this.index,
    this.enabled = true,
    required this.itemType,
    this.itemName,
    this.confirmMessage,
    this.verb = 'Delete',
    this.iconData = CupertinoIcons.delete,
  }) : super(key: key);
  @override
  _AnimatedSlidableState createState() => _AnimatedSlidableState();
}

// https://github.com/felixblaschke/simple_animations/blob/master/example/lib/examples/switchlike_checkbox.dart
class _AnimatedSlidableState extends State<AnimatedSlidable>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool _deleted = false;

  double get _iconSize => 18.0;

  @override
  void initState() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    ));

    _slideAnimation.addListener(() {
      if (_slideAnimation.isCompleted) {
        // Start the scale animation;
        _scaleController.forward();
      }
    });

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation.addListener(() {
      if (_scaleAnimation.isCompleted) {
        // Run the remove item function.
        if (!_deleted) {
          _deleted = true;
          widget.removeItem(widget.index);
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _confirmRemoveItem() async {
    context.showConfirmDeleteDialog(
        itemType: widget.itemType,
        itemName: widget.itemName,
        verb: widget.verb,
        message: widget.confirmMessage,
        onConfirm: _beginExitAnimation);
  }

  void _beginExitAnimation() {
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _scaleAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: IconTheme(
          data: IconThemeData(color: Styles.white, size: _iconSize),
          child: Slidable(
            key: widget.key,
            actionPane: const SlidableDrawerActionPane(),
            enabled: widget.enabled,
            actionExtentRatio: 0.20,
            secondaryActions: <IconSlideAction>[
              ...widget.secondaryActions,
              IconSlideAction(
                caption: widget.verb,
                color: Styles.errorRed,
                foregroundColor: Styles.white,
                iconWidget: Icon(
                  widget.iconData,
                  size: _iconSize,
                ),
                onTap: _confirmRemoveItem,
              ),
            ],
            child: widget.child,
          ),
        ),
      ),
    );
    // return SizeTransition(
    //   sizeFactor: _scaleAnimation,
    //   child: SlideTransition(
    //     position: _slideAnimation,
    //     child: IconTheme(
    //       data: IconThemeData(color: Styles.white, size: _iconSize),
    //       child: Slidable(
    //         key: widget.key,
    //         startActionPane: ActionPane(
    //             extentRatio: 0.20,
    //             motion: const DrawerMotion(),
    //             children: <SlidableAction>[
    //               ...widget.secondaryActions,
    //               SlidableAction(
    //                 label: widget.verb,
    //                 backgroundColor: Styles.errorRed,
    //                 foregroundColor: Styles.white,
    //                 icon: widget.iconData,
    //                 onPressed: (_) => _confirmRemoveItem(),
    //               ),
    //             ]),
    //         enabled: widget.enabled,
    //         child: widget.child,
    //       ),
    //     ),
    //   ),
    // );
  }
}

class MySlidable extends StatelessWidget {
  @override
  final Key key;
  final int index;
  final Widget child;

  /// Remove is added by default - just provide a removeItem callback
  // final List<SlidableAction> secondaryActions;
  final List<IconSlideAction> secondaryActions;
  final Function(int index) removeItem;
  final bool enabled;
  final String itemType;
  final String? itemName;
  final String? confirmMessage;

  /// Before the type. Eg Delete Workout vs Remove Workout vs Archive Workout.
  /// [verb] [itemType] will display.
  /// [verb] will also display on the [IconSlideAction].
  final String? verb;

  /// For the delete action.
  final IconData iconData;

  const MySlidable({
    required this.key,
    required this.child,
    required this.removeItem,
    required this.secondaryActions,
    required this.index,
    this.enabled = true,
    required this.itemType,
    this.itemName,
    this.confirmMessage,
    this.verb = 'Delete',
    this.iconData = CupertinoIcons.delete,
  }) : super(key: key);

  Future<void> _confirmRemoveItem(BuildContext context) async {
    context.showConfirmDeleteDialog(
        itemType: itemType,
        itemName: itemName,
        verb: verb,
        message: confirmMessage,
        onConfirm: () => removeItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(color: Styles.white),
      child: Slidable(
        key: key,
        actionPane: const SlidableDrawerActionPane(),
        enabled: enabled,
        actionExtentRatio: 0.20,
        secondaryActions: <IconSlideAction>[
          ...secondaryActions,
          IconSlideAction(
            caption: verb,
            color: Styles.errorRed,
            foregroundColor: Styles.white,
            iconWidget: Icon(
              iconData,
              size: 20,
            ),
            onTap: () => _confirmRemoveItem(context),
          ),
        ],
        child: child,
      ),
    );
  }
}
