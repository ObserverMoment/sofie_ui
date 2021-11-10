// import 'package:flutter/cupertino.dart';
// import 'package:reorderables/reorderables.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';

// /// Wrapper around reorderables widget with some defaults pre-set for easy re-use.
// class MyReorderableColumn extends StatelessWidget {
//   final void Function(int oldIndex, int newIndex) onReorder;
//   final List<Widget> children;
//   MyReorderableColumn({required this.onReorder, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return ReorderableColumn(
//       scrollController: ScrollController(),
//       crossAxisAlignment: CrossAxisAlignment.start,
//       needsLongPressDraggable: true,
//       onReorder: onReorder,
//       children: children,
//       buildDraggableFeedback: (context, constraints, widget) => Container(
//           width: constraints.maxWidth,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               color: Styles.primaryAccent,
//               boxShadow: [
//                 BoxShadow(
//                   color: context.theme.background.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 3,
//                   offset: Offset(0, 3), // changes position of shadow
//                 ),
//               ]),
//           child: widget),
//     );
//   }
// }
