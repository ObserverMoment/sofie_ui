import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/body_tracking_entry_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/full_screen_image_gallery.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

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
              scrollDirection: Axis.horizontal,
              showProgressDots: true,
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
                          MySliverNavbar(
                            title: 'Body Tracking',
                            trailing: allPhotoUris.isNotEmpty
                                ? TertiaryButton(
                                    text: 'Viewer',
                                    onPressed: () =>
                                        _openEntryPhotosViewer(allPhotoUris))
                                : null,
                          ),
                        ],
                    body: FABPage(
                      rowButtons: [
                        if ((_activeTabIndex == 0 && entries.isNotEmpty) ||
                            (_activeTabIndex == 1 && allPhotoUris.isNotEmpty))
                          FloatingButton(
                              iconSize: 20,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 16),
                              icon: CupertinoIcons.add,
                              text: 'New Entry',
                              onTap: () => context
                                  .navigateTo(BodyTrackingEntryCreatorRoute())),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              width: double.infinity,
                              child: MySlidingSegmentedControl<int>(
                                  value: _activeTabIndex,
                                  children: const {0: 'Entries', 1: 'Photos'},
                                  updateValue: _updateTabIndex),
                            ),
                            Expanded(
                              child: IndexedStack(
                                index: _activeTabIndex,
                                children: [
                                  _Entries(
                                    entries: entries,
                                    openPhotoViewer: _openEntryPhotosViewer,
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
  final void Function(List<String> photosUris) openPhotoViewer;
  const _Entries(
      {Key? key, required this.entries, required this.openPhotoViewer})
      : super(key: key);

  Future<void> _deleteEntry(BuildContext context, String entryId) async {
    final mutation = DeleteBodyTrackingEntryByIdMutation(
        variables: DeleteBodyTrackingEntryByIdArguments(id: entryId));

    final result = await GraphQLStore.store.delete<
        DeleteBodyTrackingEntryById$Mutation,
        DeleteBodyTrackingEntryByIdArguments>(
      mutation: mutation,
      objectId: entryId,
      typename: kBodyTrackingEntryTypename,
    );

    checkOperationResult(result, onFail: () {
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
                          openEntryPhotosViewer: entry.photoUris.isEmpty
                              ? () {}
                              : () => openPhotoViewer(entry.photoUris),
                        ),
                      ),
                    ),
                  ),
                ),
            areItemsTheSame: (a, b) => a == b)
        : const _NoEntriesPlaceholder(title: 'No entries yet');
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
    return photoUris.isNotEmpty
        ? GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            padding: const EdgeInsets.only(top: 4, bottom: 80),
            children: photoUris
                .map((uri) => GestureDetector(
                    onTap: () => openEntryPhotosViewer(uri),
                    child: SizedUploadcareImage(uri)))
                .toList(),
          )
        : const _NoEntriesPlaceholder(
            title: 'No photos yet',
          );
  }
}

class _NoEntriesPlaceholder extends StatelessWidget {
  final String title;
  const _NoEntriesPlaceholder({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentEmptyPlaceholder(
        message: title,
        explainer:
            'Track your body health and aesthetics with our body tracking tools! Log your key stats and monitor physical aspects such as body weight and fat percentage. Plus record your physical transformation over time with a chronological photo series.',
        actions: [
          EmptyPlaceholderAction(
              action: () => context.navigateTo(BodyTrackingEntryCreatorRoute()),
              buttonIcon: CupertinoIcons.add,
              buttonText: 'Create Entry'),
        ]);
  }
}
