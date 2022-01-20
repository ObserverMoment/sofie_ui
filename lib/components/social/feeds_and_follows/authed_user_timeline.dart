import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/feed_post_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/indicators.dart';
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

/// Timeline for the currently logged in User.
/// GetStream fees slug is [user_timeline].
/// A [user_timeline] follows many [user_feeds].
class AuthedUserTimeline extends StatefulWidget {
  /// So the user can re-post and activity, from their timeline, to their own feed.
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
  late PagingController<int, EnrichedActivity> _pagingController;
  late ScrollController _scrollController;

  Subscription? _feedSubscription;

  /// GetStream uses integer offset for making api calls to get more activities when paginating.
  final int _postsPerPage = 10;

  /// New posts that have come in via the subscription.
  /// We let the user choose if they want to see these via a floating button at the top of the list.
  /// Ontap these activities get added to the top of the [_pagingController.itemList] and the user is scrolled back to the top of the page.
  List<EnrichedActivity> _newActivities = [];

  /// List of activities which the current user has marked as liked.
  List<PostWithLikeReaction> _postsWithLikeReactions = [];
  List<PostWithShareReaction> _postsWithShareReactions = [];

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, EnrichedActivity>(
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
        flags: EnrichmentFlags().withOwnReactions(),
      );

      final feedActivitiesWithOwnLikeReactions = feedActivities.where((a) =>
          a.ownReactions?[kLikeReactionName] != null &&
          a.ownReactions![kLikeReactionName]!.isNotEmpty);

      final feedActivitiesWithOwnShareReactions = feedActivities.where((a) =>
          a.ownReactions?[kShareReactionName] != null &&
          a.ownReactions![kShareReactionName]!.isNotEmpty);

      _postsWithLikeReactions = [
        ..._postsWithLikeReactions,
        ...feedActivitiesWithOwnLikeReactions
            .map((a) => PostWithLikeReaction(
                activityId: a.id!,
                reaction: a.ownReactions![kLikeReactionName]![0]))
            .toList()
      ];

      _postsWithShareReactions = [
        ..._postsWithShareReactions,
        ...feedActivitiesWithOwnShareReactions
            .map((a) => PostWithShareReaction(
                activityId: a.id!,
                reaction: a.ownReactions![kShareReactionName]![0]))
            .toList()
      ];

      final int numPostsBefore = _pagingController.itemList?.length ?? 0;
      final int numNewPosts = feedActivities.length;

      if (feedActivities.length < _postsPerPage) {
        _pagingController.appendLastPage(feedActivities);
      } else {
        _pagingController.appendPage(
            feedActivities, numPostsBefore + numNewPosts);
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
          .subscribe<User, String, String, String>(_handleNewPosts);
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'There was a problem, updates will not be received.');
    } finally {
      setState(() {});
    }
  }

  Future<void> _handleNewPosts(
      RealtimeMessage<User, String, String, String>? message) async {
    if (message?.newActivities != null && message!.newActivities!.isNotEmpty) {
      final sortedNewActivities =
          message.newActivities!.sortedBy<DateTime>((a) => a.time!);

      setState(() {
        _newActivities = [...sortedNewActivities, ..._newActivities];
      });
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
    final postWithReaction = _postsWithLikeReactions
        .firstWhereOrNull((p) => p.activityId == activityId);

    if (postWithReaction != null) {
      await widget.streamFeedClient.reactions
          .delete(postWithReaction.reaction.id!);
      _postsWithLikeReactions.removeWhere((p) => p.activityId == activityId);
    } else {
      final reaction = await widget.streamFeedClient.reactions
          .add(kLikeReactionName, activityId);
      _postsWithLikeReactions.add(
          PostWithLikeReaction(activityId: activityId, reaction: reaction));
    }
    setState(() {});
  }

  /// If the user has already shared this post, they cannot share it again.
  /// In this case just show an alert.
  Future<void> _sharePost(
      EnrichedActivity activity, ActivityExtraData extraData) async {
    final postWithShare = _postsWithShareReactions
        .firstWhereOrNull((p) => p.activityId == activity.id);

    if (postWithShare != null) {
      context.showAlertDialog(
          title: 'Already shared',
          message:
              "You can only share other people's posts to your own feed once.");
    } else {
      try {
        await context.showConfirmDialog(
            title: 'Re-Post',
            verb: 'Re-Post',
            message:
                'Send this post to your feed and all your followers timelines?',
            onConfirm: () async {
              /// Add the id of the activity we are re-posting.
              extraData.originalPostId = activity.id;

              final Activity newActivityForRepost = Activity(
                  actor: widget.streamFeedClient.currentUser!.ref,
                  verb: kDefaultFeedPostVerb,
                  object: activity.object,
                  extraData: extraData.toJson);

              /// Repost the original activity to the users own [user_feed].
              await widget.userFeed.addActivity(newActivityForRepost);

              /// On success - add the reaction to the API and then save locally.
              final reaction = await widget.streamFeedClient.reactions
                  .add(kShareReactionName, activity.id!);

              _postsWithShareReactions.add(PostWithShareReaction(
                  activityId: activity.id!, reaction: reaction));

              setState(() {});

              context.showToast(
                  icon: const Icon(CupertinoIcons.paperplane),
                  message: 'Post shared');
            });
      } catch (e) {
        printLog(e.toString());
        context.showToast(message: 'Sorry, there was a problem re-posting!');
      }
    }
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
    final likedPostIds =
        _postsWithLikeReactions.map((p) => p.activityId).toList();
    final sharedPostIds =
        _postsWithShareReactions.map((p) => p.activityId).toList();

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
              : PagedListView<int, EnrichedActivity>(
                  pagingController: _pagingController,
                  scrollController: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  builderDelegate: PagedChildBuilderDelegate<EnrichedActivity>(
                    itemBuilder: (context, activity, index) {
                      final extraData =
                          ActivityExtraData.fromJson(activity.extraData!);

                      return SizeFadeIn(
                        duration: 50,
                        delay: index,
                        delayBasis: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: FeedPostCard(
                            likeUnlikePost: () => _likeUnlikePost(activity.id!),
                            userHasLiked: likedPostIds.contains(activity.id),
                            sharePost: () => _sharePost(activity, extraData),
                            userHasShared: sharedPostIds.contains(activity.id),
                            activity: activity,
                            activityExtraData: extraData,
                          ),
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
                        const LoadingCircle(),
                    newPageProgressIndicatorBuilder: (c) =>
                        const LoadingCircle(),
                    noItemsFoundIndicatorBuilder: (c) =>
                        const Center(child: MyText('No results...')),
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

class PostWithLikeReaction {
  final String activityId;
  final Reaction reaction;
  const PostWithLikeReaction({
    required this.activityId,
    required this.reaction,
  });
}

class PostWithShareReaction {
  final String activityId;
  final Reaction reaction;
  const PostWithShareReaction(
      {required this.activityId, required this.reaction});
}
