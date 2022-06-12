// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/cards/card.dart';
// import 'package:sofie_ui/components/do_workout/do_workout_section/components/start_resume_button.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/extensions/data_type_extensions.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';

// class PausedWorkoutOverlay extends StatelessWidget {
//   final WorkoutSection workoutSection;
//   const PausedWorkoutOverlay({Key? key, required this.workoutSection})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Styles.black.withOpacity(0.5),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               StartResumeButton(
//                 sectionIndex: workoutSection.sortPosition,
//               ),
//             ],
//           ),
//           if (workoutSection.isLifting || workoutSection.isCustomSession)
//             const _InstructionsCard(child: _LiftingSectionInstructions()),
//           if (workoutSection.isScored)
//             const _InstructionsCard(child: _ScoredSectionInstructions())
//         ],
//       ),
//     );
//   }
// }

// class _InstructionsCard extends StatelessWidget {
//   final Widget child;
//   const _InstructionsCard({Key? key, required this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
//       child: Card(
//         padding: const EdgeInsets.all(16.0),
//         child: child,
//       ),
//     );
//   }
// }

// /// AMRAP and ForTime
// class _ScoredSectionInstructions extends StatelessWidget {
//   const _ScoredSectionInstructions({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const MyHeaderText(
//           'Tap "SET COMPLETE" button each time you finish a set.',
//           maxLines: 6,
//           lineHeight: 1.5,
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 8),
//         const MyText(
//           'This will record your progress, split times and lap times as you go!',
//           maxLines: 6,
//           lineHeight: 1.5,
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             MyText(
//               'It looks like this',
//               textAlign: TextAlign.center,
//               size: FONTSIZE.one,
//               subtext: true,
//             ),
//             SizedBox(width: 4),
//             Icon(
//               CupertinoIcons.arrow_down,
//               size: 10,
//             )
//           ],
//         ),
//         const SizedBox(height: 3),
//         Container(
//             height: 40,
//             width: 160,
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 gradient: Styles.primaryAccentGradient),
//             child: const MyHeaderText('Set Complete',
//                 size: FONTSIZE.two, color: Styles.white)),
//       ],
//     );
//   }
// }

// /// Lifting and Custom.
// class _LiftingSectionInstructions extends StatelessWidget {
//   const _LiftingSectionInstructions({Key? key}) : super(key: key);

//   Widget _buildRepsIndicator(BuildContext context) => SizedBox(
//         height: 50,
//         width: 50,
//         child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: context.theme.background.withOpacity(0.3),
//                 border: Border.all(color: context.theme.primary)),
//             child: MyText('12',
//                 color: context.theme.primary, size: FONTSIZE.four)),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _InstructionRow(
//           icon: Container(
//             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: context.theme.background)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 MyText('Back Squat'),
//                 MyText(
//                   'Barbell',
//                   color: Styles.primaryAccent,
//                   lineHeight: 1.4,
//                   size: FONTSIZE.two,
//                 ),
//               ],
//             ),
//           ),
//           title: 'Tap For Move Info',
//           text: 'Tap the move name for information about the move.',
//         ),
//         _InstructionRow(
//           icon: _buildRepsIndicator(context),
//           title: 'Tap When Set Complete',
//           text:
//               'Tap rep indicator to mark a set as complete. Tap it again to reverse this.',
//         ),
//         _InstructionRow(
//           icon: _buildRepsIndicator(context),
//           title: 'Long Press to Modify Move',
//           text:
//               'Long press the reps indicator to modify an exercise. You cannot modify a move which is marked complete.',
//         ),
//       ],
//     );
//   }
// }

// class _InstructionRow extends StatelessWidget {
//   final String title;
//   final String text;
//   final Widget icon;
//   const _InstructionRow(
//       {Key? key, required this.text, required this.icon, required this.title})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Column(
//         children: [
//           MyHeaderText(
//             title,
//             size: FONTSIZE.four,
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               icon,
//               const SizedBox(width: 12),
//               Expanded(
//                 child: MyText(
//                   text,
//                   maxLines: 4,
//                   lineHeight: 1.5,
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
