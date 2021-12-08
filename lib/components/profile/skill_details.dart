import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/utils.dart';

class SkillDetails extends StatelessWidget {
  final Skill skill;
  const SkillDetails({Key? key, required this.skill}) : super(key: key);

  EdgeInsets get _spacerPadding =>
      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20);

  @override
  Widget build(BuildContext context) {
    final noInfo = !Utils.textNotNull(skill.experience) &&
        !Utils.textNotNull(skill.certification) &&
        !Utils.textNotNull(skill.awardingBody) &&
        !Utils.textNotNull(skill.certificateRef) &&
        !Utils.textNotNull(skill.documentUri);

    return MyPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (c, i) => [MySliverNavbar(title: skill.name)],
        body: noInfo
            ? const YourContentEmptyPlaceholder(
                message: 'No details provided', actions: [])
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  if (Utils.textNotNull(skill.experience))
                    Padding(
                      padding: _spacerPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyHeaderText('Experience'),
                          const SizedBox(height: 8),
                          ReadMoreTextBlock(
                            text: skill.experience!,
                            title: 'Experience',
                            trimLines: 8,
                          ),
                        ],
                      ),
                    ),
                  if (Utils.textNotNull(skill.certification))
                    Padding(
                      padding: _spacerPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyHeaderText('Certification'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    'Title: ${skill.certification!}',
                                    lineHeight: 1.6,
                                  ),
                                  if (Utils.textNotNull(skill.awardingBody))
                                    MyText(
                                      'From: ${skill.awardingBody!}',
                                      lineHeight: 1.6,
                                    ),
                                  if (Utils.textNotNull(skill.certificateRef))
                                    MyText(
                                      'Reference: ${skill.certificateRef!}',
                                      lineHeight: 1.6,
                                    ),
                                ],
                              ),
                              if (Utils.textNotNull(skill.documentUri))
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => print('view doc'),
                                    child: const Icon(
                                        CupertinoIcons.doc_text_viewfinder,
                                        size: 40))
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
