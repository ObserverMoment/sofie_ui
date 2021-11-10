import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class ProgressJournalCard extends StatelessWidget {
  final ProgressJournal progressJournal;
  const ProgressJournalCard({Key? key, required this.progressJournal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 110,
                    height: 170,
                    child: progressJournal.coverImageUri == null
                        ? ContentBox(
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                                'assets/category_icons/journal.svg',
                                fit: BoxFit.fitWidth,
                                color: context.theme.primary),
                          )
                        : ImageViewer(
                            uri: progressJournal.coverImageUri!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, top: 8, bottom: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyHeaderText(
                              progressJournal.name,
                              maxLines: 2,
                            ),
                            if (Utils.textNotNull(progressJournal.description))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: MyText(
                                  progressJournal.description!,
                                  maxLines: 4,
                                  lineHeight: 1.4,
                                  size: FONTSIZE.two,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MyText(
                                  '${progressJournal.progressJournalEntries.length} entries',
                                  size: FONTSIZE.two,
                                ),
                                const SizedBox(height: 4),
                                MyText(
                                  'Since ${progressJournal.createdAt.compactDateString}',
                                  size: FONTSIZE.two,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (progressJournal.progressJournalGoals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: progressJournal.progressJournalGoals
                    .map((g) => ProgressJournalGoalAndTagsTag(g))
                    .toList(),
              ),
            ),
          const HorizontalLine(
            verticalPadding: 6,
          )
        ],
      ),
    );
  }
}
