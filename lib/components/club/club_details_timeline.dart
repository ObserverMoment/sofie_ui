import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/club_feed_post_card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:collection/collection.dart';
import 'package:stream_feed/stream_feed.dart';

/// NOTE: Logic in this widget is simlar to that in [AuthedUserTimeline] in [FeedsAndFollows]. Except there is no sharing of posts to club feeds - they are club specific. Plus we may add some additional functionality - such as comments / threads to timeline posts here.
class ClubDetailsTimeline extends StatefulWidget {
  final ClubSummary club;
  final bool isOwnerOrAdmin;
  final bool enableFeedPolling;
  const ClubDetailsTimeline({
    Key? key,
    required this.club,
    required this.isOwnerOrAdmin,
    required this.enableFeedPolling,
  }) : super(key: key);

  @override
  _ClubDetailsTimelineState createState() => _ClubDetailsTimelineState();
}

class _ClubDetailsTimelineState extends State<ClubDetailsTimeline> {
  late StreamFeedClient _streamFeedClient;
  bool _isLoading = true;
  late PagingController<int, StreamEnrichedActivity> _pagingController;
  late Timer _pollingTimer;

  /// GetStream uses integer offset for making api calls to get more activities when paginating.
  final int _postsPerPage = 10;

  /// Ids of posts and reactions that the authed user has previously liked.
  List<PostWithLikeReaction> _userLikedPosts = [];

  @override
  void initState() {
    super.initState();

    _streamFeedClient = context.streamFeedClient;

    _loadInitialData().then((_) => _initPollingForNewPosts());

    _pagingController = PagingController<int, StreamEnrichedActivity>(
        firstPageKey: 0, invisibleItemsThreshold: 5);

    _pagingController.addPageRequestListener((nextPageKey) {
      _getTimelinePosts(offset: nextPageKey);
    });
  }

  Future<void> _loadInitialData() async {
    final posts = await _getTimelinePosts(offset: 0);
    _appendNewposts(posts);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initPollingForNewPosts() {
    _pollingTimer =
        Timer.periodic(const Duration(seconds: 30), (Timer t) async {
      if (!widget.enableFeedPolling) {
        _pollingTimer.cancel();
      } else {
        _pollForNewPosts();
      }
    });
  }

  Future<void> _pollForNewPosts() async {
    if (mounted) {
      final posts = await _getTimelinePosts(offset: 0);
      if (posts.isNotEmpty) {
        final shouldGetMore = _prependNewPosts(posts);
        if (shouldGetMore) {
          _pollForNewPosts();
        }
      }
    }
  }

  Future<List<StreamEnrichedActivity>> _getTimelinePosts({
    required int offset,
  }) async {
    if (mounted) {
      try {
        final result = await context.graphQLStore.networkOnlyOperation<
                ClubMembersFeedPosts$Query, ClubMembersFeedPostsArguments>(
            operation: ClubMembersFeedPostsQuery(
                variables: ClubMembersFeedPostsArguments(
                    clubId: widget.club.id,
                    limit: _postsPerPage,
                    offset: offset)));

        checkOperationResult(context, result,
            onFail: () => throw Exception(result.errors));

        final feedActivities = result.data!.clubMembersFeedPosts;

        final feedActivitiesWithOwnLikeReactions = feedActivities
            .where((a) => a.userLikeReactionId != null)
            .map((a) => PostWithLikeReaction(
                activityId: a.id, reactionId: a.userLikeReactionId!))
            .toList();

        _userLikedPosts = [
          ..._userLikedPosts,
          ...feedActivitiesWithOwnLikeReactions
        ];

        return feedActivities;
      } catch (e) {
        printLog(e.toString());
        _pagingController.error = e.toString();
        context.showToast(
            message: 'Sorry there was a problem loading the timeline.',
            toastType: ToastType.destructive);
        return [];
      }
    } else {
      return [];
    }
  }

  /// When [polling] for new posts we need to check if those that get returned are new or not.
  /// New posts are posts that are not already contained within [_pagingController.itemList].
  /// If they are then we prepend them.
  /// If ALL these posts are new then we need to call again as this means there may be more new posts. Return [true].
  /// If any of these posts are not new then we have all the new posts. Return [false].
  bool _prependNewPosts(List<StreamEnrichedActivity> posts) {
    /// Check for new posts.
    final prevPosts = _pagingController.itemList ?? [];
    final prevPostIds = prevPosts.map((p) => p.id).toList();
    final newPosts = posts.where((p) => !prevPostIds.contains(p.id));

    /// Prepend new posts.
    _pagingController.itemList = [...newPosts, ...prevPosts];

    setState(() {});

    /// Advise caller if they should get more.
    return newPosts.length == posts.length;
  }

  /// When initializing or when scrolling we are adding new posts to the end of the list.
  void _appendNewposts(List<StreamEnrichedActivity> posts) {
    final int numPostsBefore = _pagingController.itemList?.length ?? 0;
    final int numNewPosts = posts.length;

    if (posts.length < _postsPerPage) {
      _pagingController.appendLastPage(posts);
    } else {
      _pagingController.appendPage(posts, numPostsBefore + numNewPosts);
    }
  }

  Future<void> _likeUnlikePost(String activityId) async {
    final postWithReaction =
        _userLikedPosts.firstWhereOrNull((p) => p.activityId == activityId);

    if (postWithReaction != null) {
      await _streamFeedClient.reactions.delete(postWithReaction.reactionId);
      _userLikedPosts.removeWhere((p) => p.activityId == activityId);
    } else {
      final reaction =
          await _streamFeedClient.reactions.add(kLikeReactionName, activityId);

      if (reaction.id != null) {
        _userLikedPosts.add(PostWithLikeReaction(
            activityId: activityId, reactionId: reaction.id!));
      }
    }
    setState(() {});
  }

  Future<void> _deleteActivityById(
      BuildContext context, StreamEnrichedActivity post) async {
    context.showConfirmDeleteDialog(
        itemType: 'Post',
        message: 'This cannot be undone, are you sure?',
        onConfirm: () async {
          final result = await context.graphQLStore.networkOnlyOperation<
                  DeleteClubMembersFeedPost$Mutation,
                  DeleteClubMembersFeedPostArguments>(
              operation: DeleteClubMembersFeedPostMutation(
                  variables:
                      DeleteClubMembersFeedPostArguments(activityId: post.id)));

          checkOperationResult(context, result,
              onSuccess: () => context.showToast(message: 'Post deleted'),
              onFail: () => context.showToast(
                  message: 'Sorry, there was a problem deleting the post',
                  toastType: ToastType.destructive));

          setState(() {
            _pagingController.itemList =
                _pagingController.itemList!.where((i) => i != post).toList();
          });
        });
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final likedPostIds = _userLikedPosts.map((p) => p.activityId).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: MyHeaderText(
            'Activity',
            size: FONTSIZE.four,
          ),
        ),
        _isLoading
            ? const ShimmerCardList(
                itemCount: 10,
                cardHeight: 260,
              )
            : _pagingController.itemList == null ||
                    _pagingController.itemList!.isEmpty
                ? Center(
                    child: Column(
                      children: const [
                        Opacity(
                            opacity: 0.5,
                            child: Icon(
                              CupertinoIcons.square_list,
                              size: 50,
                            )),
                        SizedBox(height: 12),
                        MyText(
                          'Nothing here yet...',
                          subtext: true,
                        ),
                      ],
                    ),
                  )
                : PagedListView<int, StreamEnrichedActivity>(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    pagingController: _pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<StreamEnrichedActivity>(
                      itemBuilder: (context, activity, index) => SizeFadeIn(
                        duration: 50,
                        delay: index,
                        delayBasis: 10,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ClubFeedPostCard(
                              activity: activity,
                              likeUnlikePost: () =>
                                  _likeUnlikePost(activity.id),
                              userHasLiked: likedPostIds.contains(activity.id),
                              deletePost: widget.isOwnerOrAdmin
                                  ? () => _deleteActivityById(context, activity)
                                  : null,
                            )),
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
      ],
    );
  }
}
