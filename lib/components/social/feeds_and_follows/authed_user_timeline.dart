import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/club_feed_post_card.dart';
import 'package:sofie_ui/components/cards/feed_post_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
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

/// Timeline for the currently logged in User.
/// GetStream fees slug is [user_timeline].
/// A [user_timeline] follows many [user_feeds].
class AuthedUserTimeline extends StatefulWidget {
  /// So the user can re-post an activity, from their timeline, to their own feed.
  /// They can also delete a post that they own.
  final FlatFeed userFeed;
  final FlatFeed timelineFeed;
  final StreamFeedClient streamFeedClient;
  const AuthedUserTimeline({
    Key? key,
    required this.timelineFeed,
    required this.streamFeedClient,
    required this.userFeed,
  }) : super(key: key);

  @override
  _AuthedUserTimelineState createState() => _AuthedUserTimelineState();
}

class _AuthedUserTimelineState extends State<AuthedUserTimeline> {
  bool _isLoading = true;
  late PagingController<int, StreamEnrichedActivity> _pagingController;
  late ScrollController _scrollController;

  Subscription? _feedSubscription;

  /// GetStream uses integer offset for making api calls to get more activities when paginating.
  final int _postsPerPage = 10;

  /// New posts that have come in via the subscription.
  /// We let the user choose if they want to see these via a floating button at the top of the list.
  /// Ontap these activities get added to the top of the [_pagingController.itemList] and the user is scrolled back to the top of the page.
  List<StreamEnrichedActivity> _newActivities = [];

  /// Ids of posts and reactions that the authed user has previously liked.
  List<PostWithLikeReaction> _userLikedPosts = [];

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, StreamEnrichedActivity>(
        firstPageKey: 0, invisibleItemsThreshold: 5);

    _scrollController = ScrollController();

    _pagingController.addPageRequestListener((nextPageKey) {
      _getTimelinePosts(offset: nextPageKey);
    });

    _loadInitialData().then((_) => _subscribeToFeed());
  }

  Future<void> _loadInitialData() async {
    await _getTimelinePosts(offset: 0);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getTimelinePosts({required int offset}) async {
    try {
      final feedActivities = await widget.timelineFeed
          .getEnrichedActivities<User, String, String, String>(
        limit: _postsPerPage,
        offset: offset,
        // On the timeline we dont show like counts or share counts
        // But we do want to know if the user has liked or shared a post already
        flags: EnrichmentFlags().withOwnReactions().withReactionCounts(),
      );

      final feedActivitiesWithOwnLikeReactions = feedActivities
          .where((a) =>
              a.id != null &&
              a.ownReactions?[kLikeReactionName] != null &&
              a.ownReactions![kLikeReactionName]!.isNotEmpty)
          .map((a) => PostWithLikeReaction(
              activityId: a.id!,
              reactionId: a.ownReactions![kLikeReactionName]![0].id!))
          .toList();

      _userLikedPosts = [
        ..._userLikedPosts,
        ...feedActivitiesWithOwnLikeReactions
      ];

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
      _feedSubscription = await widget.timelineFeed
          .subscribe<User, String, String, String>(_handleFeedUpdates);
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'There was a problem, updates will not be received.');
    } finally {
      setState(() {});
    }
  }

  Future<void> _handleFeedUpdates(
      RealtimeMessage<User, String, String, String>? message) async {
    if (message == null) return;

    if (message.newActivities != null && message.newActivities!.isNotEmpty) {
      final sortedNewActivities =
          message.newActivities!.sortedBy<DateTime>((a) => a.time!);

      final formattedActivities =
          FeedUtils.formatStreamAPIResponse(sortedNewActivities);

      setState(() {
        _newActivities = [...formattedActivities, ..._newActivities];
      });
    }

    if (_pagingController.itemList == null) return;

    if (message.deleted.isNotEmpty) {
      /// Remove all deleted messages from the list.
      _pagingController.itemList = _pagingController.itemList!
          .where((a) => !message.deleted.contains(a.id))
          .toList();
    }
  }

  void _prependNewPosts() {
    /// Animate the user back to the top of the list.
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: kStandardAnimationDuration, curve: Curves.easeOut);
    }

    /// Add the new items to the paging controller.
    _pagingController.itemList = [
      ..._newActivities,
      ..._pagingController.itemList ?? []
    ];

    /// Clear the [_newActivities] to remove the floating button.
    setState(() {
      _newActivities = [];
    });
  }

  Future<void> _likeUnlikePost(String activityId) async {
    final postWithReaction =
        _userLikedPosts.firstWhereOrNull((p) => p.activityId == activityId);

    if (postWithReaction != null) {
      await widget.streamFeedClient.reactions
          .delete(postWithReaction.reactionId);
      _userLikedPosts.removeWhere((p) => p.activityId == activityId);
    } else {
      final reaction = await widget.streamFeedClient.reactions
          .add(kLikeReactionName, activityId);

      if (reaction.id != null) {
        _userLikedPosts.add(PostWithLikeReaction(
            activityId: activityId, reactionId: reaction.id!));
      }
    }
    setState(() {});
  }

  // https://support.getstream.io/hc/en-us/articles/4404359414551-Deleting-Activities-with-Stream-Feeds-API-
  // An activity explicitly added to a particular feed makes that feed the origin of the activity. An activity deleted from the origin is also deleted from all other feeds where it is found, either through fan-out or targeting. Deleting an activity from a feed that is not the origin of the activity, will delete it only from that feed.
  /// When the activity is owned by the authed user we can delete the activity from their own [user_feed] (i.e. the origin feed). This will also remove the post from all timeline_feeds that follow it.
  Future<void> _confirmDeleteActivity(String activityId) async {
    context.showConfirmDeleteDialog(
        itemType: 'Post',
        message: 'This will delete the post from all timelines.',
        onConfirm: () async {
          await widget.userFeed.removeActivityById(activityId);
        });
  }

  /// A non owner can still remove a post from their own timeline if they want.
  Future<void> _confirmRemoveActivityFromFeed(String activityId) async {
    context.showConfirmDeleteDialog(
        verb: 'Remove',
        itemType: 'Post',
        message: 'This will remove the post from your timeline.',
        onConfirm: () async {
          await widget.timelineFeed.removeActivityById(activityId);
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
    final likedPostIds = _userLikedPosts.map((p) => p.activityId).toList();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (_isLoading)
          const ShimmerCardList(
            itemCount: 10,
            cardHeight: 260,
          )
        else
          _pagingController.itemList == null ||
                  _pagingController.itemList!.isEmpty
              ? YourContentEmptyPlaceholder(
                  message: 'No posts yet',
                  explainer:
                      'Posts from anyone you are following will show up here. Keep up with all the latest fitness news and content from your friends and fans!',
                  actions: [
                      EmptyPlaceholderAction(
                          action: () =>
                              context.navigateTo(const DiscoverPeopleRoute()),
                          buttonIcon: CupertinoIcons.compass,
                          buttonText: 'Discover People'),
                    ])
              : PagedListView<int, StreamEnrichedActivity>(
                  pagingController: _pagingController,
                  scrollController: _scrollController,
                  cacheExtent: 1000,
                  physics: const AlwaysScrollableScrollPhysics(),
                  builderDelegate:
                      PagedChildBuilderDelegate<StreamEnrichedActivity>(
                    itemBuilder: (context, activity, index) {
                      return FadeInUp(
                        duration: 50,
                        delay: index,
                        delayBasis: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: activity.extraData.club != null
                              ? ClubFeedPostCard(
                                  activity: activity,
                                  showClubIcon: true,
                                  likeUnlikePost: () =>
                                      _likeUnlikePost(activity.id),
                                  userHasLiked:
                                      likedPostIds.contains(activity.id),
                                  removeActivityFromTimeline: () =>
                                      _confirmRemoveActivityFromFeed(
                                          activity.id),
                                  enableViewClubOption: true)
                              : FeedPostCard(
                                  likeUnlikePost: () =>
                                      _likeUnlikePost(activity.id),
                                  userHasLiked:
                                      likedPostIds.contains(activity.id),
                                  activity: activity,
                                  timelineFeed: widget.timelineFeed,
                                  userFeed: widget.userFeed,
                                  deleteActivity: () =>
                                      _confirmDeleteActivity(activity.id),
                                  removeActivityFromTimeline: () =>
                                      _confirmRemoveActivityFromFeed(
                                          activity.id),
                                  enableViewClubOption: true),
                        ),
                      );
                    },
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
                        const CupertinoActivityIndicator(),
                    newPageProgressIndicatorBuilder: (c) =>
                        const CupertinoActivityIndicator(),
                    noItemsFoundIndicatorBuilder: (c) =>
                        const Center(child: MyText('No notifications...')),
                  ),
                ),
        if (_newActivities.isNotEmpty)
          Positioned(
              top: 8,
              child: SizeFadeIn(
                  child: FloatingButton(
                icon: CupertinoIcons.news,
                onTap: _prependNewPosts,
                text:
                    '${_newActivities.length} new ${_newActivities.length == 1 ? "post" : "posts"}',
              )))
      ],
    );
  }
}
