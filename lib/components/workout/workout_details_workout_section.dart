import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_page_view.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/workout_set_display.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutDetailsWorkoutSection extends StatelessWidget {
  final WorkoutSection workoutSection;
  const WorkoutDetailsWorkoutSection(this.workoutSection, {Key? key})
      : super(key: key);

  List<BodyAreaMoveScore> bodyAreaMoveScoresFromSection() {
    return workoutSection.workoutSets.fold(
        <BodyAreaMoveScore>[],
        (acum1, workoutSet) => [
              ...acum1,
              ...workoutSet.workoutMoves.fold(
                  <BodyAreaMoveScore>[],
                  (acum2, workoutMove) =>
                      [...acum2, ...workoutMove.move.bodyAreaMoveScores])
            ]);
  }

  EdgeInsets get headerSpacerPadding => const EdgeInsets.only(
        bottom: 12.0,
        left: 8,
        right: 8,
      );

  @override
  Widget build(BuildContext context) {
    final sortedSets =
        workoutSection.workoutSets.sortedBy<num>((ws) => ws.sortPosition);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (Utils.textNotNull(workoutSection.name))
          Padding(
            padding: headerSpacerPadding,
            child: MyHeaderText(workoutSection.name!),
          ),
        Padding(
          padding: headerSpacerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WorkoutSectionTypeTag(
                workoutSection: workoutSection,
                fontSize: FONTSIZE.four,
                withBackground: false,
                elevation: 0,
                uppercase: true,
                showMediaIcons: false,
              ),
              if (!workoutSection.isAMRAP)
                NumberRoundsIcon(
                  rounds: workoutSection.rounds,
                  alignment: Axis.vertical,
                ),
              if (workoutSection.isAMRAP)
                CompactTimerIcon(
                    duration: Duration(seconds: workoutSection.timecap)),
            ],
          ),
        ),
        if (Utils.textNotNull(workoutSection.note))
          Padding(
            padding: headerSpacerPadding,
            child: ReadMoreTextBlock(
              text: workoutSection.note!,
              fontSize: 15,
              title: 'Section Note',
            ),
          ),
        Padding(
          padding: headerSpacerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionIconButton(
                icon: SvgPicture.asset(
                  'assets/body_areas/body_button.svg',
                  width: 30,
                  alignment: Alignment.topCenter,
                  color: context.theme.primary.withOpacity(0.7),
                ),
                label: 'Body Areas',
                onPressed: () => context.push(
                    child: TargetedBodyAreasPageView(
                      bodyAreaMoveScores: bodyAreaMoveScoresFromSection(),
                    ),
                    fullscreenDialog: true),
              ),
              if (Utils.textNotNull(workoutSection.introVideoUri))
                _ActionIconButton(
                  label: 'Intro Video',
                  onPressed: () => VideoSetupManager.openFullScreenBetterPlayer(
                      context: context,
                      videoUri: workoutSection.introVideoUri!,
                      videoThumbUri: workoutSection.introVideoThumbUri!,
                      autoPlay: true,
                      autoLoop: true),
                  icon: const Icon(CupertinoIcons.tv),
                ),
              if (Utils.textNotNull(workoutSection.classVideoUri))
                _ActionIconButton(
                  label: 'Class Video',
                  onPressed: () => VideoSetupManager.openFullScreenBetterPlayer(
                      context: context,
                      videoUri: workoutSection.classVideoUri!,
                      videoThumbUri: workoutSection.classVideoThumbUri!,
                      autoPlay: true,
                      autoLoop: true),
                  icon: const Icon(CupertinoIcons.tv),
                ),
              if (Utils.textNotNull(workoutSection.introAudioUri))
                _ActionIconButton(
                  label: 'Intro Audio',
                  onPressed: () => AudioPlayerController.openAudioPlayer(
                      context: context,
                      audioUri: workoutSection.introAudioUri!,
                      pageTitle: 'Intro Audio',
                      audioTitle: workoutSection.nameOrTypeForDisplay,
                      autoPlay: true),
                  icon: const Icon(CupertinoIcons.headphones),
                ),
              if (Utils.textNotNull(workoutSection.classAudioUri))
                _ActionIconButton(
                  label: 'Class Audio',
                  onPressed: () => AudioPlayerController.openAudioPlayer(
                      context: context,
                      audioUri: workoutSection.classAudioUri!,
                      pageTitle: 'Class Audio',
                      audioTitle: workoutSection.nameOrTypeForDisplay,
                      autoPlay: true),
                  icon: const Icon(CupertinoIcons.headphones),
                ),
            ],
          ),
        ),
        if (sortedSets.isNotEmpty)
          Flexible(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: sortedSets
                  .map((workoutSet) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: WorkoutSetDisplay(
                            workoutSet: workoutSet,
                            workoutSectionType:
                                workoutSection.workoutSectionType),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  const _ActionIconButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 3),
          MyText(
            label,
            size: FONTSIZE.one,
          ),
        ],
      ),
    );
  }
}

// class WorkoutDetailsWorkoutSection extends StatelessWidget {
//   final WorkoutSection workoutSection;
//   final bool scrollable;
//   final bool showMediaThumbs;
//   final bool showSectionTypeTag;
//   const WorkoutDetailsWorkoutSection(this.workoutSection,
//       {Key? key,
//       this.scrollable = false,
//       this.showMediaThumbs = true,
//       this.showSectionTypeTag = true})
//       : super(key: key);

//   Size get _kthumbDisplaySize => const Size(64, 64);

//   List<BodyAreaMoveScore> bodyAreaMoveScoresFromSection() {
//     return workoutSection.workoutSets.fold(
//         <BodyAreaMoveScore>[],
//         (acum1, workoutSet) => [
//               ...acum1,
//               ...workoutSet.workoutMoves.fold(
//                   <BodyAreaMoveScore>[],
//                   (acum2, workoutMove) =>
//                       [...acum2, ...workoutMove.move.bodyAreaMoveScores])
//             ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sortedSets =
//         workoutSection.workoutSets.sortedBy<num>((ws) => ws.sortPosition);

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               if (showSectionTypeTag)
//                 WorkoutSectionTypeTag(
//                   workoutSection: workoutSection,
//                   fontSize: FONTSIZE.three,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           if (showMediaThumbs &&
//               Utils.anyNotNull([
//                 workoutSection.introAudioUri,
//                 workoutSection.introVideoUri,
//                 workoutSection.classAudioUri,
//                 workoutSection.classVideoUri
//               ]))
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0, bottom: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (workoutSection.introVideoUri != null)
//                     VideoThumbnailPlayer(
//                         videoUri: workoutSection.introVideoUri,
//                         videoThumbUri: workoutSection.introVideoThumbUri,
//                         displaySize: _kthumbDisplaySize,
//                         tag: 'Intro'),
//                   if (workoutSection.classVideoUri != null)
//                     VideoThumbnailPlayer(
//                         videoUri: workoutSection.classVideoUri,
//                         videoThumbUri: workoutSection.classVideoThumbUri,
//                         displaySize: _kthumbDisplaySize,
//                         tag: 'Class'),
//                   if (workoutSection.introAudioUri != null)
//                     AudioThumbnailPlayer(
//                         audioUri: workoutSection.introAudioUri!,
//                         displaySize: _kthumbDisplaySize,
//                         tag: 'Intro'),
//                   if (workoutSection.classAudioUri != null)
//                     AudioThumbnailPlayer(
//                         audioUri: workoutSection.classAudioUri!,
//                         displaySize: _kthumbDisplaySize,
//                         tag: 'Class'),
//                 ],
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 6.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 if (workoutSection.rounds > 1)
//                   ContentBox(
//                     child: NumberRoundsIcon(
//                       rounds: workoutSection.rounds,
//                       alignment: Axis.vertical,
//                     ),
//                   ),
//                 if (workoutSection.isAMRAP)
//                   ContentBox(
//                       child: CompactTimerIcon(
//                           duration: Duration(seconds: workoutSection.timecap))),
//                 BorderButton(
//                   mini: true,
//                   prefix: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/body_areas/body_button.svg',
//                         width: 54,
//                         alignment: Alignment.topCenter,
//                         color: context.theme.primary.withOpacity(0.3),
//                       ),
//                       const Icon(
//                         CupertinoIcons.smallcircle_circle_fill,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                   withBorder: false,
//                   onPressed: () => context.push(
//                       child: TargetedBodyAreasPageView(
//                         bodyAreaMoveScores: bodyAreaMoveScoresFromSection(),
//                       ),
//                       fullscreenDialog: true),
//                 ),
//               ],
//             ),
//           ),
//           if (Utils.textNotNull(workoutSection.note))
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ReadMoreTextBlock(
//                 text: workoutSection.note!,
//                 title: 'Section Note',
//               ),
//             ),
//           if (sortedSets.isNotEmpty)
//             Flexible(
//               child: ListView(
//                 physics:
//                     scrollable ? null : const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 children: sortedSets
//                     .map((workoutSet) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: WorkoutSetDisplay(
//                               workoutSet: workoutSet,
//                               workoutSectionType:
//                                   workoutSection.workoutSectionType),
//                         ))
//                     .toList(),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }
