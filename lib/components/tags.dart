import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/utils.dart';

class Tag extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final String tag;

  final FONTSIZE fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  const Tag(
      {Key? key,
      this.color,
      this.borderColor,
      this.textColor,
      required this.tag,
      this.padding = kDefaultTagPadding,
      this.fontWeight = FontWeight.normal,
      this.fontSize = FONTSIZE.two})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final background = color ?? context.theme.primary.withOpacity(0.95);
    final border =
        borderColor ?? color ?? context.theme.primary.withOpacity(0.95);
    final text = textColor ?? context.theme.background;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: background,
          border: Border.all(color: border)),
      child: MyText(
        tag,
        size: fontSize,
        weight: fontWeight,
        color: text,
      ),
    );
  }
}

class SelectableTag extends StatelessWidget {
  final bool isSelected;
  final void Function() onPressed;
  final String text;
  final Color selectedColor;
  final FONTSIZE fontSize;
  final EdgeInsets padding;

  const SelectableTag(
      {Key? key,
      required this.isSelected,
      required this.onPressed,
      required this.text,
      this.fontSize = FONTSIZE.three,
      this.selectedColor = Styles.primaryAccent,
      this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            border: isSelected
                ? Border.all(color: selectedColor)
                : Border.all(color: context.theme.primary.withOpacity(0.5)),
            color: isSelected ? selectedColor : context.theme.background,
            borderRadius: BorderRadius.circular(30)),
        padding: padding,
        child: MyText(
          text,
          size: fontSize,
          color: isSelected ? Styles.white : null,
          lineHeight: 1,
        ),
      ),
    );
  }
}

class MoveTypeTag extends StatelessWidget {
  final MoveType moveType;
  final FONTSIZE fontSize;
  const MoveTypeTag(this.moveType, {Key? key, this.fontSize = FONTSIZE.two})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.theme.cardBackground,
          borderRadius: BorderRadius.circular(60)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: MyText(
        moveType.name,
        size: fontSize,
      ),
    );
  }
}

class DifficultyLevelDot extends StatelessWidget {
  final DifficultyLevel difficultyLevel;
  final double size;
  const DifficultyLevelDot(
      {Key? key, required this.difficultyLevel, this.size = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isElite = difficultyLevel == DifficultyLevel.elite;
    final borderColor =
        isElite ? context.theme.primary : difficultyLevel.displayColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          shape: BoxShape.circle,
          color: difficultyLevel.displayColor),
    );
  }
}

class DifficultyLevelIcon extends StatelessWidget {
  final DifficultyLevel difficultyLevel;

  final FONTSIZE fontSize;
  final bool withBackground;

  const DifficultyLevelIcon(
      {Key? key,
      required this.difficultyLevel,
      this.fontSize = FONTSIZE.two,
      this.withBackground = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: withBackground
          ? const EdgeInsets.symmetric(vertical: 4, horizontal: 5)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: withBackground
              ? context.theme.background.withOpacity(0.85)
              : null),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
            5,
            (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.4),
                  height: 7 + (i * 2.7),
                  width: 5,
                  decoration: BoxDecoration(
                      color: difficultyLevel.numericValue >= i
                          ? context.theme.primary.withOpacity(0.85)
                          : context.theme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(1)),
                )),
      ),
    );
  }
}

class DifficultyLevelTag extends StatelessWidget {
  final DifficultyLevel difficultyLevel;
  final FONTSIZE fontSize;
  final Color? backgroundColor;
  final Color? textColor;

  const DifficultyLevelTag(
      {Key? key,
      required this.difficultyLevel,
      this.fontSize = FONTSIZE.two,
      this.backgroundColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isElite = difficultyLevel == DifficultyLevel.elite;
    final borderColor =
        isElite ? context.theme.primary : difficultyLevel.displayColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(3),
      ),
      child: MyText(
        difficultyLevel.display.toUpperCase(),
        size: fontSize,
        color: textColor ?? context.theme.primary,
        lineHeight: 1.2,
      ),
    );
  }
}

class WorkoutSectionTypeTag extends StatelessWidget {
  final WorkoutSection workoutSection;
  final FONTSIZE fontSize;
  final Color? fontColor;
  final bool uppercase;
  final int? elevation;
  final bool withBackground;
  final bool showMediaIcons;
  const WorkoutSectionTypeTag(
      {Key? key,
      required this.workoutSection,
      this.fontSize = FONTSIZE.two,
      this.fontColor,
      this.uppercase = false,
      this.elevation = 1,
      this.withBackground = true,
      this.showMediaIcons = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timecapOrTotalDuration = workoutSection.timecapIfValid;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: withBackground
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 5)
              : null,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: withBackground ? kElevation[elevation] : null,
            color: withBackground ? context.theme.background : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                uppercase
                    ? workoutSection.workoutSectionType.name.toUpperCase()
                    : workoutSection.workoutSectionType.name,
                size: fontSize,
                textAlign: TextAlign.center,
                color: fontColor,
              ),
              if (timecapOrTotalDuration != null)
                MyText(
                  ' - ${Duration(seconds: timecapOrTotalDuration).displayString}',
                  size: fontSize,
                  textAlign: TextAlign.center,
                  color: fontColor,
                ),
              if (showMediaIcons &&
                  Utils.textNotNull(workoutSection.classVideoUri))
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    CupertinoIcons.tv,
                    size: withBackground ? 14 : 17,
                    color: fontColor,
                  ),
                ),
              if (showMediaIcons &&
                  Utils.textNotNull(workoutSection.classAudioUri))
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    CupertinoIcons.headphones,
                    size: withBackground ? 14 : 17,
                    color: fontColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoggedWorkoutSectionSummaryTag extends StatelessWidget {
  final LoggedWorkoutSection section;
  final FONTSIZE fontSize;
  final FontWeight fontWeight;
  const LoggedWorkoutSectionSummaryTag(
    this.section, {
    Key? key,
    this.fontSize = FONTSIZE.two,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  int? get _repsScore => section.repScore;

  Widget _text(String t) => MyText(t, size: fontSize, weight: fontWeight);

  List<Widget> _build() {
    final time = section.timeTakenSeconds;

    /// User does not have to enter a rep score for timed workouts - so it may be null.
    /// If it is null then just display the length of the workout section.
    if (section.workoutSectionType.isTimed) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: _text(Duration(seconds: time).compactDisplay),
        )
      ];
    } else if (section.workoutSectionType.isScored) {
      return [
        const SizedBox(width: 4),
        _text('${_repsScore ?? 0} reps'),
        _text(' in '),
        _text(Duration(seconds: time).compactDisplay)
      ];
    } else {
      return [
        const SizedBox(width: 4),
        _text('for '),
        _text(Duration(seconds: time).compactDisplay)
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: kStandardCardPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.theme.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(section.workoutSectionType.name,
                    size: fontSize, weight: fontWeight),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _build(),
                )
              ],
            )),
      ],
    );
  }
}

class DurationTag extends StatelessWidget {
  final Duration duration;
  final FONTSIZE fontSize;
  final double iconSize;
  final Color? backgroundColor;
  final Color? textColor;
  const DurationTag(
      {Key? key,
      required this.duration,
      this.fontSize = FONTSIZE.two,
      this.iconSize = 13,
      this.backgroundColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
        backgroundColor: backgroundColor,
        borderRadius: 4,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.timer, size: iconSize, color: textColor),
            const SizedBox(width: 4),
            MyText(duration.displayString, size: fontSize, color: textColor),
          ],
        ));
  }
}

class ProgressJournalGoalAndTagsTag extends StatelessWidget {
  final JournalGoal progressJournalGoal;
  const ProgressJournalGoalAndTagsTag(this.progressJournalGoal, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.theme.primary)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            progressJournalGoal.name,
            size: FONTSIZE.two,
            decoration: progressJournalGoal.completedDate != null
                ? TextDecoration.lineThrough
                : null,
          ),
        ],
      ),
    );
  }
}
