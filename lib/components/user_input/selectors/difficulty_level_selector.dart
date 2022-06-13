import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

class DifficultyLevelSelectorRow extends StatelessWidget {
  final DifficultyLevel? difficultyLevel;
  final void Function(DifficultyLevel? level) updateDifficultyLevel;
  final String unselectedLabel;
  const DifficultyLevelSelectorRow(
      {Key? key,
      this.difficultyLevel,
      required this.updateDifficultyLevel,
      this.unselectedLabel = ' - '})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInputContainer(
      child: CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 8),
          onPressed: () => context.push(
                  child: DifficultyLevelSelector(
                difficultyLevel: difficultyLevel,
                updateDifficultyLevel: updateDifficultyLevel,
                unselectedLabel: unselectedLabel,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  MyText(
                    'Difficulty',
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Icon(
                    CupertinoIcons.chart_bar,
                    size: 18,
                  ),
                ],
              ),
              if (difficultyLevel != null)
                Container(
                  padding: kStandardCardPadding,
                  decoration: BoxDecoration(
                    borderRadius: kStandardCardBorderRadius,
                  ),
                  child: Row(
                    children: [
                      DifficultyLevelDot(
                          difficultyLevel: difficultyLevel!, size: 10),
                      const SizedBox(width: 6),
                      MyText(
                        difficultyLevel!.display.toUpperCase(),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        size: 16,
                      )
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: MyText('Select (optional)', subtext: true),
                ),
            ],
          )),
    );
  }
}

class DifficultyLevelSelector extends StatefulWidget {
  final DifficultyLevel? difficultyLevel;
  final void Function(DifficultyLevel? updated) updateDifficultyLevel;
  final String unselectedLabel;
  const DifficultyLevelSelector(
      {Key? key,
      this.difficultyLevel,
      required this.updateDifficultyLevel,
      this.unselectedLabel = ' - '})
      : super(key: key);
  @override
  _DifficultyLevelSelectorState createState() =>
      _DifficultyLevelSelectorState();
}

class _DifficultyLevelSelectorState extends State<DifficultyLevelSelector> {
  DifficultyLevel? _activeDifficultyLevel;

  @override
  void initState() {
    super.initState();
    _activeDifficultyLevel = widget.difficultyLevel;
  }

  void _handleUpdateSelected(DifficultyLevel? tapped) {
    setState(() {
      _activeDifficultyLevel = tapped;
    });
    widget.updateDifficultyLevel(_activeDifficultyLevel);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        automaticallyImplyLeading: false,
        trailing: TertiaryButton(
            backgroundGradient: Styles.primaryAccentGradient,
            textColor: Styles.white,
            text: 'Done',
            onPressed: context.pop),
        middle: const LeadingNavBarTitle('Difficulty Level'),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SelectableBoxExpanded(
                isSelected: _activeDifficultyLevel == null,
                onPressed: () => _handleUpdateSelected(null),
                text: widget.unselectedLabel),
          ),
          ...DifficultyLevel.values
              .where((d) => d != DifficultyLevel.artemisUnknown)
              .sortedBy<num>((v) => v.numericValue)
              .map((l) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SelectableBoxExpanded(
                        isSelected: _activeDifficultyLevel == l,
                        onPressed: () => _handleUpdateSelected(l),
                        text: l.display),
                  ))
              .toList()
        ],
      ),
    );
  }
}
