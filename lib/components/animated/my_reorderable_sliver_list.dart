// import 'package:flutter/cupertino.dart';
// import 'package:reorderables/reorderables.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';

// class MyReorderableSliverList extends StatelessWidget {
//   final Widget Function(int index) buildItem;
//   final int childCount;
//   final void Function(int oldIndex, int newIndex) onReorder;
//   MyReorderableSliverList(
//       {required this.buildItem,
//       required this.childCount,
//       required this.onReorder});
//   @override
//   Widget build(BuildContext context) {
//     return ReorderableSliverList(
//         delegate: ReorderableSliverChildBuilderDelegate(
//             (BuildContext context, int index) => buildItem(index),
//             childCount: childCount),
//         buildDraggableFeedback: (context, constraints, widget) => Container(
//             width: constraints.maxWidth,
//             decoration: BoxDecoration(color: Styles.primaryAccent, boxShadow: [
//               BoxShadow(
//                 color: context.theme.background.withOpacity(0.5),
//                 spreadRadius: 2,
//                 blurRadius: 3,
//                 offset: Offset(0, 3), // changes position of shadow
//               ),
//             ]),
//             child: widget),
//         onReorder: onReorder);
//   }
// }
