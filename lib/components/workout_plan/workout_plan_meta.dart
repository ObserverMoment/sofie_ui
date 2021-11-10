import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_like_heart.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/collections/collection_manager.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class WorkoutPlanMeta extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  final List<Equipment> allEquipment;
  final List<Collection> collections;
  final bool hasEnrolled;
  final bool showSaveIcon;
  const WorkoutPlanMeta({
    Key? key,
    required this.workoutPlan,
    required this.allEquipment,
    required this.collections,
    required this.hasEnrolled,
    this.showSaveIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (workoutPlan.archived)
              const FadeIn(
                child: _InfoIcon(
                  icon: Icon(
                    CupertinoIcons.archivebox_fill,
                    color: Styles.errorRed,
                  ),
                  label: 'Archived',
                ),
              ),
            _InfoIcon(
              icon: MyText(
                workoutPlan.lengthWeeks.toString(),
                size: FONTSIZE.seven,
                lineHeight: 1,
              ),
              label: 'Weeks',
            ),
            _InfoIcon(
              icon: MyText(
                workoutPlan.workoutsInPlan.length.toString(),
                size: FONTSIZE.seven,
                lineHeight: 1,
              ),
              label: 'Workouts',
            ),
            if (workoutPlan.workoutPlanReviews.isNotEmpty)
              _InfoIcon(
                icon: MyText(
                  workoutPlan.reviewAverage.stringMyDouble(),
                  size: FONTSIZE.seven,
                  lineHeight: 1,
                ),
                label: 'Avg Review',
              ),
            if (Utils.textNotNull(workoutPlan.introVideoUri))
              _ActionIconButton(
                  icon: const Icon(CupertinoIcons.tv),
                  label: 'Video',
                  onPressed: () => VideoSetupManager.openFullScreenBetterPlayer(
                      context: context,
                      videoUri: workoutPlan.introVideoUri!,
                      videoThumbUri: workoutPlan.introVideoThumbUri!,
                      autoPlay: true,
                      autoLoop: true)),
            if (Utils.textNotNull(workoutPlan.introAudioUri))
              _ActionIconButton(
                  icon: const Icon(CupertinoIcons.headphones),
                  label: 'Audio',
                  onPressed: () => AudioPlayerController.openAudioPlayer(
                      context: context,
                      audioUri: workoutPlan.introAudioUri!,
                      pageTitle: 'Intro Audio',
                      audioTitle: workoutPlan.name,
                      autoPlay: true)),

            /// The heart is appearing smaller than other items for some reason - so manually making it larger and removing gap underneath between text.
            if (showSaveIcon)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () =>
                    CollectionManager.addOrRemoveObjectFromCollection(
                        context, workoutPlan,
                        alreadyInCollections: collections),
                child: Column(
                  children: [
                    AnimatedLikeHeart(active: collections.isNotEmpty, size: 26),
                    const MyText(
                      'SAVE',
                      size: FONTSIZE.one,
                    ),
                  ],
                ),
              ),
          ]),
        ),
        const HorizontalLine(verticalPadding: 0),
        if (hasEnrolled)
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: kDefaultTagPadding,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Styles.secondaryAccent)),
                  child: Row(
                    children: const [
                      MyText(
                        'You have joined this plan!',
                        color: Styles.secondaryAccent,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.checkmark_alt,
                        color: Styles.secondaryAccent,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (workoutPlan.workoutPlanDays.isNotEmpty)
          _InfoSection(
            header: 'Goals',
            icon: CupertinoIcons.scope,
            content: PercentageBarChartSingle(
              inputs: workoutPlan.waffleChartInputs,
              barHeight: 4,
            ),
          ),
        if (Utils.textNotNull(workoutPlan.description))
          _InfoSection(
            content: ReadMoreTextBlock(
                text: workoutPlan.description!, title: workoutPlan.name),
            header: 'Description',
            icon: CupertinoIcons.doc_text,
          ),
        if (workoutPlan.workoutTags.isNotEmpty)
          _InfoSection(
            content: CommaSeparatedList(
                workoutPlan.workoutTags.map((t) => t.tag).toList(),
                fontSize: FONTSIZE.three),
            header: 'Tags',
            icon: CupertinoIcons.tag,
          ),
        _InfoSection(
          content: allEquipment.isEmpty
              ? const MyText(
                  'No equipment required',
                  subtext: true,
                )
              : CommaSeparatedList(allEquipment.map((e) => e.name).toList(),
                  fontSize: FONTSIZE.three),
          header: 'Equipment',
          icon: CupertinoIcons.cube,
        ),
        const SizedBox(height: kAssumedFloatingButtonHeight),
      ],
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final Widget icon;
  final String label;
  const _InfoIcon({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        MyText(
          label,
          size: FONTSIZE.one,
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
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 2),
          MyText(
            label.toUpperCase(),
            size: FONTSIZE.one,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String header;
  final IconData icon;
  final Widget content;
  const _InfoSection(
      {Key? key,
      required this.header,
      required this.icon,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: context.theme.primary.withOpacity(0.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyHeaderText(
                  header,
                  weight: FontWeight.normal,
                  size: FONTSIZE.two,
                ),
                const SizedBox(width: 4),
                Icon(icon, size: 12),
              ],
            ),
          ),
          const SizedBox(height: 12),
          content
        ],
      ),
    );
  }
}
