import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/skill_creator/skill_creator.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class SkillsManager extends StatefulWidget {
  const SkillsManager({Key? key}) : super(key: key);

  @override
  _SkillsManagerState createState() => _SkillsManagerState();
}

class _SkillsManagerState extends State<SkillsManager> {
  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final query = UserProfileByIdQuery(
        variables: UserProfileByIdArguments(userId: authedUserId));

    return QueryObserver<UserProfileById$Query, UserProfileByIdArguments>(
      key: Key('SkillsManager-${query.operationName}'),
      query: query,
      parameterizeQuery: true,
      fetchPolicy: QueryFetchPolicy.storeFirst,
      builder: (data) {
        final skills = data.userProfileById.skills;

        return MyPageScaffold(
            child: NestedScrollView(
          headerSliverBuilder: (c, i) =>
              [const MySliverNavbar(title: 'Skills Manager')],
          body: skills.isEmpty
              ? YourContentEmptyPlaceholder(
                  message: 'No skills added',
                  explainer:
                      'Add skills, qualifications, experience and areas of special interest to your profile. Help people looking for your skill to find you and check out what do!',
                  actions: [
                      EmptyPlaceholderAction(
                          action: () => context.push(
                              fullscreenDialog: true,
                              child: const SkillCreator()),
                          buttonIcon: CupertinoIcons.add,
                          buttonText: 'Add Skill'),
                    ])
              : FABPage(
                  rowButtons: [
                      FloatingButton(
                        icon: CupertinoIcons.add,
                        iconSize: 18,
                        gradient: Styles.primaryAccentGradient,
                        contentColor: Styles.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        text: 'Add Skill',
                        onTap: () => context.push(
                            fullscreenDialog: true,
                            child: const SkillCreator()),
                      )
                    ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: skills
                          .map((s) => GestureDetector(
                              onTap: () => context.push(
                                      child: SkillCreator(
                                    skill: s,
                                  )),
                              child: _SkillManagerListItem(skill: s)))
                          .toList(),
                    ),
                  )),
        ));
      },
    );
  }
}

class _SkillManagerListItem extends StatelessWidget {
  final Skill skill;
  const _SkillManagerListItem({Key? key, required this.skill})
      : super(key: key);

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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/graphics/award_icon.svg',
                            width: 24, color: Styles.secondaryAccent),
                        const SizedBox(width: 8),
                        MyText(
                          skill.name,
                          size: FONTSIZE.four,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (Utils.textNotNull(skill.certification))
                MyText(
                  'Certification: ${skill.certification!}',
                  lineHeight: 1.4,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (Utils.textNotNull(skill.documentUri))
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(CupertinoIcons.doc_checkmark),
                ),
              Utils.textNotNull(skill.documentUri)
                  ? TertiaryButton(
                      onPressed: () => print('remove doc'), text: 'Remove Doc')
                  : TertiaryButton(
                      prefixIconData: CupertinoIcons.cloud_upload,
                      onPressed: () => print('upload doc'),
                      text: 'Doc')
            ],
          )
        ],
      ),
    );
  }
}
