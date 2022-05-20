import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementUpdateCard extends StatelessWidget {
  final AnnouncementUpdate announcement;
  const AnnouncementUpdateCard({Key? key, required this.announcement})
      : super(key: key);

  /// TODO: Uncomment this when you want people to be able to dismiss messages.
  // Future<void> _markAnnouncementAsSeen(BuildContext context) async {
  //   final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
  //   final variables = MarkAnnouncementUpdateAsSeenArguments(
  //       data: MarkAnnouncementUpdateAsSeenInput(
  //           announcementUpdateId: announcement.id, userId: authedUserId));

  //   await context.graphQLStore.delete(
  //       mutation: MarkAnnouncementUpdateAsSeenMutation(variables: variables),
  //       objectId: announcement.id,
  //       typename: kAnnouncementUpdateTypename,
  //       removeRefFromQueries: [GQLOpNames.announcementUpdates]);
  // }

  double get _borderRadius => 12.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(_borderRadius),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          if (Utils.textNotNull(announcement.imageUri))
            ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadius - 2),
              child: SizedUploadcareImage(
                announcement.imageUri!,
                displaySize: const Size(800, 400),
              ),
            ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius - 2),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Styles.black.withOpacity(0.6),
                      Styles.black.withOpacity(0.05),
                    ])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            announcement.title,
                            size: FONTSIZE.five,
                            color: Styles.white,
                            weight: FontWeight.bold,
                          ),

                          /// TODO: Uncomment this when you want people to be able to dismiss messages.
                          // TertiaryButton(
                          //     text: 'Got It',
                          //     iconSize: 14,
                          //     backgroundColor: context.theme.modalBackground,
                          //     suffixIconData: CupertinoIcons.clear_thick,
                          //     onPressed: () => _markAnnouncementAsSeen(context))
                        ]),
                    if (Utils.textNotNull(announcement.subtitle))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: MyText(
                          announcement.subtitle!,
                          maxLines: 2,
                          lineHeight: 1.4,
                          color: Styles.white,
                          weight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                if (Utils.textNotNull(announcement.bodyOne))
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: MyText(
                      announcement.bodyOne!,
                      maxLines: 3,
                      color: Styles.white,
                    ),
                  ),
                if (Utils.textNotNull(announcement.bodyTwo))
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: MyText(
                      announcement.bodyTwo!,
                      maxLines: 3,
                      color: Styles.white,
                    ),
                  ),
                if (Utils.textNotNull(announcement.articleUrl))
                  UpdateAnnouncementArticleLink(
                      text: 'Read about it here',
                      url: announcement.articleUrl!),
                if (announcement.actions.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.end,
                      children: announcement.actions
                          .map((a) => UpdateAnnouncementActionLink(action: a))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateAnnouncementArticleLink extends StatefulWidget {
  final String text;
  final String url;
  const UpdateAnnouncementArticleLink({
    Key? key,
    required this.text,
    required this.url,
  }) : super(key: key);

  @override
  State<UpdateAnnouncementArticleLink> createState() =>
      _UpdateAnnouncementArticleLinkState();
}

class _UpdateAnnouncementArticleLinkState
    extends State<UpdateAnnouncementArticleLink> {
  void _openLink() async {
    final success = await launchUrl(Uri(path: widget.url));
    if (!success && mounted) {
      context.showToast(
          message: "Sorry, we can't open this link",
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLink,
      child: ContentBox(
        backgroundColor: context.theme.cardBackground,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(widget.text),
            const SizedBox(width: 6),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}

class UpdateAnnouncementActionLink extends StatelessWidget {
  final AnnouncementUpdateAction action;
  const UpdateAnnouncementActionLink({Key? key, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.navigateNamedTo(action.routeTo),
      child: ContentBox(
        backgroundColor: context.theme.cardBackground,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(action.text),
            const SizedBox(width: 6),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
