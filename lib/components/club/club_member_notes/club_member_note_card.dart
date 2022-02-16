import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ClubMemberNoteCard extends StatelessWidget {
  final ClubMemberNote clubMemberNote;
  final VoidCallback openEdit;
  const ClubMemberNoteCard(
      {Key? key, required this.clubMemberNote, required this.openEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText('Last Edited ${clubMemberNote.updatedAt.dateAndTime}'),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: MyText(
                      'Created ${clubMemberNote.createdAt.compactDateString}',
                      subtext: true,
                      size: FONTSIZE.two,
                    ),
                  ),
                  MyText(
                    clubMemberNote.user?.displayName ?? '...',
                    subtext: true,
                    size: FONTSIZE.two,
                  ),
                ],
              ),
              IconButton(iconData: CupertinoIcons.pen, onPressed: openEdit)
            ],
          ),
          const SizedBox(height: 12),
          ReadMoreTextBlock(
            text: clubMemberNote.note,
            trimLines: 6,
            title: 'Last Edited ${clubMemberNote.updatedAt.dateAndTime}',
            fontSize: 19,
          ),
          if (clubMemberNote.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CommaSeparatedList(
                clubMemberNote.tags,
                textColor: Styles.primaryAccent,
                fontSize: FONTSIZE.three,
                withFullStop: true,
              ),
            )
        ],
      ),
    );
  }
}
