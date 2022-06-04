import 'package:flutter/material.dart';
import 'package:sofie_ui/components/animated/dragged_item.dart';

class MyReorderableList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final void Function(List<T> reordered) reorderItems;
  const MyReorderableList(
      {Key? key,
      required this.items,
      required this.itemBuilder,
      required this.reorderItems})
      : super(key: key);

  @override
  State<MyReorderableList<T>> createState() => _MyReorderableListState<T>();
}

class _MyReorderableListState<T> extends State<MyReorderableList<T>> {
  late List<T> _items;

  @override
  void initState() {
    // print('initState');
    _items = List.from(widget.items);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // print('didChangeDependencies');
    _items = List.from(widget.items);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MyReorderableList<T> oldWidget) {
    // print('didUpdateWidget');
    _items = List.from(widget.items);
    super.didUpdateWidget(oldWidget);
  }

  void _handleReorder(int from, int to) {
    // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
    // // Necessary because of how flutters reorderable list calculates drop position...I think.
    final moveTo = from < to ? to - 1 : to;
    final i = _items.removeAt(from);

    setState(() {
      _items.insert(moveTo, i);
    });

    widget.reorderItems(_items);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        proxyDecorator: (child, index, animation) => DraggedItem(child: child),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (context, index) =>
            widget.itemBuilder(context, index, _items[index]),
        onReorder: _handleReorder);
  }
}
