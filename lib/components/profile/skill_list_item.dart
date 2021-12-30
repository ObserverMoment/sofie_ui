import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class SkillListItem extends StatelessWidget {
  final Skill skill;
  const SkillListItem({Key? key, required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: context.theme.cardBackground.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/graphics/award_icon.svg',
                          width: 24, color: Styles.primaryAccent),
                      const SizedBox(width: 8),
                      MyText(
                        skill.name,
                        size: FONTSIZE.four,
                      ),
                    ],
                  ),
                ],
              ),
              if (Utils.textNotNull(skill.certification))
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: MyText(
                    'Certification: ${skill.certification!}',
                    lineHeight: 1.4,
                  ),
                ),
              if (Utils.textNotNull(skill.awardingBody))
                MyText(
                  'From: ${skill.awardingBody!}',
                  lineHeight: 1.4,
                ),
              if (Utils.textNotNull(skill.certificateRef))
                MyText(
                  'Reference: ${skill.certificateRef!}',
                  lineHeight: 1.4,
                ),
            ],
          ),
          if (Utils.textNotNull(skill.documentUri))
            const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(CupertinoIcons.doc_checkmark),
            ),
        ],
      ),
    );
  }
}
