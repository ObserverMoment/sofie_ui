import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/body_tracking_entry_card.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/full_screen_image_gallery.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class BodyTrackingPage extends StatefulWidget {
  const BodyTrackingPage({Key? key}) : super(key: key);

  @override
  State<BodyTrackingPage> createState() => _BodyTrackingPageState();
}

class _BodyTrackingPageState extends State<BodyTrackingPage> {
  int _activeTabIndex = 0;

  void _updateTabIndex(int i) {
    setState(() => _activeTabIndex = i);
  }

  void _openEntryPhotosViewer(List<String> photoUris) {
    context.push(
        child: Stack(
          children: [
            FullScreenImageGallery(
              photoUris,
              withTopNavBar: false,
            ),
            SafeArea(
              child: CupertinoButton(
                child: CircularBox(
                    padding: const EdgeInsets.all(10),
                    color: context.readTheme.background.withOpacity(0.5),
                    child: Icon(
                      CupertinoIcons.clear_thick,
                      color: context.readTheme.primary.withOpacity(0.8),
                    )),
                onPressed: () => context.pop(rootNavigator: true),
              ),
            )
          ],
        ),
        rootNavigator: true);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      child: QueryObserver<BodyTrackingEntries$Query, json.JsonSerializable>(
          key: Key(
              'BodyTrackingPage - ${BodyTrackingEntriesQuery().operationName}'),
          query: BodyTrackingEntriesQuery(),
          loadingIndicator: const ShimmerCardList(
            itemCount: 12,
          ),
          builder: (data) {
            final entries = data.bodyTrackingEntries
                .sortedBy<DateTime>((e) => e.createdAt)
                .reversed
                .toList();

            final allPhotoUris = entries.fold<List<String>>(
                <String>[], (acum, next) => [...acum, ...next.photoUris]);

            return CupertinoPageScaffold(
                child: NestedScrollView(
                    headerSliverBuilder: (c, i) => [
                          const CupertinoSliverNavigationBar(
                              leading: NavBarBackButton(),
                              largeTitle: Text('Body Tracking'),
                              border: null)
                        ],
                    body: FABPage(
                      rowButtons: [
                        FloatingButton(
                            gradient: Styles.primaryAccentGradient,
                            contentColor: Styles.white,
                            iconSize: 20,
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 16),
                            icon: CupertinoIcons.add,
                            text: 'New Entry',
                            onTap: () => context
                                .navigateTo(BodyTrackingEntryCreatorRoute())),
                        const SizedBox(width: 16),
                        FloatingButton(
                            iconSize: 20,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            icon: CupertinoIcons.fullscreen,
                            text: 'Viewer',
                            onTap: () => _openEntryPhotosViewer(allPhotoUris)),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            MyTabBarNav(
                                titles: const ['Entries', 'Photos'],
                                handleTabChange: _updateTabIndex,
                                activeTabIndex: _activeTabIndex),
                            Expanded(
                              child: IndexedStack(
                                index: _activeTabIndex,
                                children: [
                                  _Entries(
                                    entries: entries,
                                  ),
                                  _Photos(
                                      photoUris: allPhotoUris,
                                      openEntryPhotosViewer: (uri) =>
                                          _openEntryPhotosViewer([uri])),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )));
          }),
    );
  }
}

class _Entries extends StatelessWidget {
  final List<BodyTrackingEntry> entries;
  const _Entries({Key? key, required this.entries}) : super(key: key);

  Future<void> _deleteEntry(BuildContext context, String entryId) async {
    final mutation = DeleteBodyTrackingEntryByIdMutation(
        variables: DeleteBodyTrackingEntryByIdArguments(id: entryId));

    final result = await context.graphQLStore.delete<
            DeleteBodyTrackingEntryById$Mutation,
            DeleteBodyTrackingEntryByIdArguments>(
        mutation: mutation,
        objectId: entryId,
        typename: kBodyTrackingEntryTypename,
        removeRefFromQueries: [GQLOpNames.bodyTrackingEntries],
        removeAllRefsToId: true);

    await checkOperationResult(context, result, onFail: () {
      context.showToast(
          message: 'Sorry, there was a problem',
          toastType: ToastType.destructive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return entries.isNotEmpty
        ? ImplicitlyAnimatedList<BodyTrackingEntry>(
            padding: const EdgeInsets.only(top: 12),
            items: entries,
            itemBuilder: (context, animation, entry, index) =>
                SizeFadeTransition(
                  animation: animation,
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.navigateTo(
                          BodyTrackingEntryCreatorRoute(
                              bodyTrackingEntry: entry)),
                      child: MySlidable(
                        key: Key(entry.id),
                        index: index,
                        itemType: 'Body Tracking Entry',
                        removeItem: (_) => _deleteEntry(context, entry.id),
                        secondaryActions: const [],
                        child: BodyTrackingEntryCard(
                          bodyTrackingEntry: entry,
                        ),
                      ),
                    ),
                  ),
                ),
            areItemsTheSame: (a, b) => a == b)
        : const _NoEntriesPlaceholder();
  }
}

class _Photos extends StatelessWidget {
  final List<String> photoUris;
  final void Function(String uri) openEntryPhotosViewer;
  const _Photos(
      {Key? key,
      this.photoUris = const [],
      required this.openEntryPhotosViewer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3 / 4,
      padding: const EdgeInsets.only(top: 4, bottom: 80),
      children: photoUris
          .map((uri) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => openEntryPhotosViewer(uri),
                  child: Card(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedUploadcareImage(uri),
                      )))))
          .toList(),
    );
  }
}

class _NoEntriesPlaceholder extends StatelessWidget {
  const _NoEntriesPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: MyText(
                  'Track your body health and aesthetics with our body tracking tools! Log your key stats and monitor physical aspects such as body weight and fat percentage. Plus record your physical transformation over time with a chronological photo series.',
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  lineHeight: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SecondaryButton(
              prefixIconData: CupertinoIcons.add,
              text: 'Add Your First Entry',
              onPressed: () =>
                  context.navigateTo(BodyTrackingEntryCreatorRoute())),
        ],
      ),
    );
  }
}
