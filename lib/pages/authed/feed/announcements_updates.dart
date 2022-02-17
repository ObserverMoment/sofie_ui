import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';

/// Use this widget to display news and updates from the app admins to users on their home / feed page.
/// Users can mark read so that they no longer display on their feed page.
/// Displays as  horizontal swipeable list.
class AnnouncementsUpdates extends StatelessWidget {
  const AnnouncementsUpdates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = AnnouncementUpdatesQuery();

    return QueryObserver<AnnouncementUpdates$Query, json.JsonSerializable>(
        key: Key('AnnouncementsUpdates- ${query.operationName}'),
        query: query,
        loadingIndicator: Container(),
        builder: (data) {
          return GrowInOut(
              show: data.announcementUpdates.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                height: 200,
                child: AnnouncementUpdatesList(
                  announcements: data.announcementUpdates
                      .sortedBy<DateTime>((a) => a.createdAt),
                ),
              ));
        });
  }
}

class AnnouncementUpdatesList extends StatefulWidget {
  final List<AnnouncementUpdate> announcements;
  const AnnouncementUpdatesList({Key? key, required this.announcements})
      : super(key: key);

  @override
  State<AnnouncementUpdatesList> createState() =>
      _AnnouncementUpdatesListState();
}

class _AnnouncementUpdatesListState extends State<AnnouncementUpdatesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onlyOne = widget.announcements.length == 1;

    return Padding(
      padding:
          EdgeInsets.only(left: onlyOne ? 10.0 : 0, right: onlyOne ? 10 : 0),
      child: PageView(
        controller: PageController(viewportFraction: onlyOne ? 1 : 0.95),
        children: widget.announcements
            .map((a) => Padding(
                  padding: EdgeInsets.only(
                      left: onlyOne ? 0 : 5, right: onlyOne ? 0 : 5.0),
                  child: AnnouncementUpdateCard(announcement: a),
                ))
            .toList(),
      ),
    );
  }
}

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
                      Styles.black.withOpacity(0.65),
                      Styles.black.withOpacity(0.1),
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
                        child: MyHeaderText(
                          announcement.subtitle!,
                          maxLines: 2,
                          lineHeight: 1.4,
                          color: Styles.white,
                          size: FONTSIZE.two,
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

class UpdateAnnouncementArticleLink extends StatelessWidget {
  final String text;
  final String url;
  const UpdateAnnouncementArticleLink({
    Key? key,
    required this.text,
    required this.url,
  }) : super(key: key);

  void _openLink(BuildContext context) async {
    final success = await launch(url);
    if (!success) {
      context.showToast(
          message: "Sorry, we can't open this link",
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openLink(context),
      child: ContentBox(
        backgroundColor: context.theme.modalBackground,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(text),
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
        backgroundColor: context.theme.modalBackground,
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
