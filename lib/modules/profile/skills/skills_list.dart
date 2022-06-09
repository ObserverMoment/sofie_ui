import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/skills/skill_details.dart';
import 'package:sofie_ui/modules/profile/skills/skill_list_item.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Retrieves and displays all the skills of a user in a list.
class SkillsList extends StatelessWidget {
  final List<Skill> skills;
  const SkillsList({Key? key, required this.skills}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return skills.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ContentEmptyPlaceholder(
                  message: 'No skills registered', actions: []),
            ],
          )
        : ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: skills
                .map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            context.push(child: SkillDetails(skill: s)),
                        child: SkillListItem(skill: s),
                      ),
                    ))
                .toList(),
          );
  }
}
