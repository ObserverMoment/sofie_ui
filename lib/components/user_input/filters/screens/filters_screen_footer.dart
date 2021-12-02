import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class FiltersScreenFooter extends StatelessWidget {
  final int numActiveFilters;
  final VoidCallback clearFilters;
  final VoidCallback showResults;
  const FiltersScreenFooter(
      {Key? key,
      required this.numActiveFilters,
      required this.clearFilters,
      required this.showResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: context.theme.cardBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeIn(
              key: Key(numActiveFilters.toString()),
              child: MyHeaderText(
                '$numActiveFilters active',
                size: FONTSIZE.two,
              )),
          Row(
            children: [
              if (numActiveFilters > 0)
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TertiaryButton(
                        text: 'Clear All', onPressed: clearFilters),
                  ),
                ),
              TertiaryButton(
                  backgroundGradient: Styles.primaryAccentGradient,
                  textColor: Styles.white,
                  fontSize: FONTSIZE.three,
                  padding: const EdgeInsets.all(10),
                  text: 'Show Results',
                  onPressed: showResults),
            ],
          )
        ],
      ),
    );
  }
}
