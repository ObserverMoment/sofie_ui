import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/feed_post_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Feed for the currently logged in User.
/// GetStream feeds slug is [user_feed].
/// User posts go into this feed - other [user_timelines] can follow it.
class YourPostsPage extends StatefulWidget {
  const YourPostsPage({
    Key? key,
  }) : super(key: key);

  @override
  _YourPostsPageState createState() => _YourPostsPageState();
}

class _YourPostsPageState extends State<YourPostsPage> {
  late AuthedUser _authedUser;
  late StreamFeedClient _streamFeedClient;

  /// Feed - posts the user has made themselves.
  late FlatFeed _userFeed;

  bool _isLoading = true;

  late PagingController<int, StreamEnrichedActivity> _pagingController;
  late ScrollController _scrollController;

  Subscription? _feedSubscription;

  /// GetStream uses integer offset for making api calls to get more activities when paginating.
  final int _postsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamFeedClient = context.streamFeedClient;
    _userFeed = _streamFeedClient.flatFeed(kUserFeedName, _authedUser.id);

    _pagingController = PagingController<int, StreamEnrichedActivity>(
        firstPageKey: 0, invisibleItemsThreshold: 5);
    _scrollController = ScrollController();

    _pagingController.addPageRequestListener((nextPageKey) {
      _getFeedPosts(offset: nextPageKey);
    });

    _loadInitialData().then((_) => _subscribeToFeed());
  }

  Future<void> _loadInitialData() async {
    await _getFeedPosts(offset: 0);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getFeedPosts({required int offset}) async {
    try {
      final feedActivities =
          await _userFeed.getEnrichedActivities<User, String, String, String>(
        limit: _postsPerPage,
        offset: offset,
        flags: EnrichmentFlags().withReactionCounts(),
      );

      final int numPostsBefore = _pagingController.itemList?.length ?? 0;
      final int numNewPosts = feedActivities.length;

      final formattedActivities =
          FeedUtils.formatStreamAPIResponse(feedActivities);

      if (feedActivities.length < _postsPerPage) {
        _pagingController.appendLastPage(formattedActivities);
      } else {
        _pagingController.appendPage(
            formattedActivities, numPostsBefore + numNewPosts);
      }
    } catch (e) {
      printLog(e.toString());
      _pagingController.error = e.toString();
      context.showToast(
          message: 'Sorry there was a problem loading your posts.',
          toastType: ToastType.destructive);
    }
  }

  Future<void> _subscribeToFeed() async {
    try {
      _feedSubscription = await _userFeed
          .subscribe<User, String, String, String>(_updateNewFeedPosts);
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'There was a problem, updates will not be received.');
    } finally {
      setState(() {});
    }
  }

  Future<void> _updateNewFeedPosts(
      RealtimeMessage<User, String, String, String>? message) async {
    if (message?.newActivities != null && message!.newActivities!.isNotEmpty) {
      final sortedNewActivities =
          message.newActivities!.sortedBy<DateTime>((a) => a.time!);

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }

      final formattedActivities =
          FeedUtils.formatStreamAPIResponse(sortedNewActivities);

      _pagingController.itemList = [
        ...formattedActivities,
        ..._pagingController.itemList ?? []
      ];
    }

    if (message?.deleted != null &&
        message!.deleted.isNotEmpty &&
        _pagingController.itemList != null &&
        _pagingController.itemList!.isNotEmpty) {
      _pagingController.itemList = _pagingController.itemList!
          .where((i) => !message.deleted.contains(i.id))
          .toList();
    }
  }

  // https://support.getstream.io/hc/en-us/articles/4404359414551-Deleting-Activities-with-Stream-Feeds-API-
  // An activity explicitly added to a particular feed makes that feed the origin of the activity. An activity deleted from the origin is also deleted from all other feeds where it is found, either through fan-out or targeting. Deleting an activity from a feed that is not the origin of the activity, will delete it only from that feed.
  /// When the activity is owned by the authed user we can delete the activity from their own [user_feed] (i.e. the origin feed). This will also remove the post from all timeline_feeds that follow it.
  Future<void> _confirmDeleteActivity(String activityId) async {
    context.showConfirmDeleteDialog(
        itemType: 'Post',
        message: 'This will delete the post from all timelines.',
        onConfirm: () async {
          await _userFeed.removeActivityById(activityId);
        });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    _feedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Your Posts'),
      ),
      child: _isLoading
          ? const ShimmerCardList(
              itemCount: 10,
              cardHeight: 260,
            )
          : FABPage(
              rowButtons: [
                FloatingButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 16),
                    text: 'New Post',
                    onTap: () =>
                        context.navigateTo(const FeedPostCreatorRoute()),
                    icon: CupertinoIcons.pencil),
              ],
              child: _pagingController.itemList == null ||
                      _pagingController.itemList!.isEmpty
                  ? const YourContentEmptyPlaceholder(
                      message: 'No posts yet', actions: [])
                  : PagedListView<int, StreamEnrichedActivity>(
                      pagingController: _pagingController,
                      scrollController: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      builderDelegate:
                          PagedChildBuilderDelegate<StreamEnrichedActivity>(
                        itemBuilder: (context, activity, index) => FadeInUp(
                          duration: 50,
                          delay: index,
                          delayBasis: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: FeedPostCard(
                              activity: activity,
                              userFeed: _userFeed,
                              enableViewClubOption: false,
                              deleteActivity: () =>
                                  _confirmDeleteActivity(activity.id),
                            ),
                          ),
                        ),
                        firstPageErrorIndicatorBuilder: (context) => MyText(
                          'Oh dear, ${_pagingController.error.toString()}',
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        ),
                        newPageErrorIndicatorBuilder: (context) => MyText(
                          'Oh dear, ${_pagingController.error.toString()}',
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        ),
                        firstPageProgressIndicatorBuilder: (c) =>
                            const LoadingCircle(),
                        newPageProgressIndicatorBuilder: (c) =>
                            const LoadingCircle(),
                        noItemsFoundIndicatorBuilder: (c) =>
                            const Center(child: MyText('No results...')),
                      ),
                    ),
            ),
    );
  }
}
