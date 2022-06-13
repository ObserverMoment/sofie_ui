// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/my_custom_icons.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/pages/authed/circles/components/discover_clubs.dart';
// import 'package:sofie_ui/pages/authed/circles/components/discover_creators.dart';
// import 'package:sofie_ui/router.gr.dart';

// class CirclesPage extends StatelessWidget {
//   const CirclesPage({Key? key}) : super(key: key);

//   Widget _verticalPadding({required Widget child}) =>
//       Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: child);

//   @override
//   Widget build(BuildContext context) {
//     return MyPageScaffold(
//       child: ListView(
//         shrinkWrap: true,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // Expanded(
//               //   child: DiscoverPageTopButton(
//               //     iconData: MyCustomIcons.dumbbell,
//               //     onPressed: () =>
//               //         context.navigateTo(PublicWorkoutFinderRoute()),
//               //     text: 'Workouts',
//               //   ),
//               // ),
//               // Expanded(
//               //   child: DiscoverPageTopButton(
//               //     iconData: MyCustomIcons.plansIcon,
//               //     onPressed: () =>
//               //         context.navigateTo(PublicWorkoutPlanFinderRoute()),
//               //     text: 'Plans',
//               //   ),
//               // ),
//             ],
//           ),
//           _verticalPadding(child: const DiscoverCreators()),
//           _verticalPadding(child: const DiscoverClubs()),
//         ],
//       ),
//     );
//   }
// }

// class DiscoverPageTopButton extends StatelessWidget {
//   final String text;
//   final IconData iconData;
//   final VoidCallback onPressed;
//   const DiscoverPageTopButton(
//       {Key? key,
//       required this.text,
//       required this.iconData,
//       required this.onPressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: GestureDetector(
//         onTap: onPressed,
//         behavior: HitTestBehavior.opaque,
//         child: ContentBox(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(iconData, size: 16),
//                   const SizedBox(width: 8),
//                   MyText(
//                     text,
//                     weight: FontWeight.bold,
//                   )
//                 ],
//               ),
//               const Icon(CupertinoIcons.chevron_right, size: 18)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
