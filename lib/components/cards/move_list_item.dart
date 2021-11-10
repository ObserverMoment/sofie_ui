import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class MoveListItem extends StatelessWidget {
  final Move move;

  /// Optional icon style button on far right of column. Eg. Info / Edit.
  final Widget? optionalButton;

  const MoveListItem({Key? key, required this.move, this.optionalButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: context.theme.customThemeData.greyOne))),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: MyText(
                    move.name,
                  ),
                ),
                const SizedBox(width: 8),
                MoveTypeTag(move.moveType, fontSize: FONTSIZE.one)
              ],
            ),
          ),
          if (optionalButton != null) optionalButton!
        ],
      ),
    );
  }
}
