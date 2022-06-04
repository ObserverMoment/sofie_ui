import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ResistanceSetDisplay extends StatelessWidget {
  final int setPosition;
  final ResistanceSet resistanceSet;
  const ResistanceSetDisplay(
      {Key? key, required this.resistanceSet, required this.setPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 8),
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: context.theme.primary.withOpacity(0.3)))),
                child: MyText(
                  '${setPosition + 1}',
                  size: FONTSIZE.one,
                  subtext: true,
                ),
              ),
              MyText(
                resistanceSet.move.name,
              ),
            ],
          ),
          if (resistanceSet.equipment != null)
            MyText(
              resistanceSet.equipment!.name,
              size: FONTSIZE.two,
              subtext: true,
            ),
          MyText(
            'x ${resistanceSet.reps.toString()}',
            size: FONTSIZE.four,
          ),
        ],
      ),
    );
  }
}
