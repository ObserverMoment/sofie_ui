import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_page_view.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/media/audio/audio_player_controller.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/single_move_workout_set_display.dart';
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
        bottom: 8.0,
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
              if (workoutSection.rounds > 1)
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
        if (Utils.textNotNull(workoutSection.name))
          Padding(
            padding: headerSpacerPadding,
            child: MyHeaderText(
              workoutSection.name!,
              size: FONTSIZE.two,
              subtext: true,
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
                  onPressed: () => VideoSetupManager.openFullScreenVideoPlayer(
                      context: context,
                      videoUri: workoutSection.introVideoUri!,
                      videoThumbUri: workoutSection.introVideoThumbUri!,
                      autoPlay: true,
                      autoLoop: true,
                      title: workoutSection.nameOrTypeForDisplay),
                  icon: const Icon(CupertinoIcons.tv),
                ),
              if (Utils.textNotNull(workoutSection.classVideoUri))
                _ActionIconButton(
                  label: 'Class Video',
                  onPressed: () => VideoSetupManager.openFullScreenVideoPlayer(
                      context: context,
                      videoUri: workoutSection.classVideoUri!,
                      videoThumbUri: workoutSection.classVideoThumbUri!,
                      autoPlay: true,
                      autoLoop: true,
                      title: workoutSection.nameOrTypeForDisplay),
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
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: workoutSet.isMultiMoveSet ||
                                workoutSet.workoutMoves.length == 1
                            ? WorkoutSetDisplay(
                                workoutSet: workoutSet,
                                padding: const EdgeInsets.only(
                                    top: 6, bottom: 4, left: 10, right: 10),
                                workoutSectionType:
                                    workoutSection.workoutSectionType)
                            : SingleMoveWorkoutSetDisplay(
                                workoutSet: workoutSet,
                                padding: const EdgeInsets.only(
                                    top: 6, bottom: 4, left: 10, right: 10),
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
