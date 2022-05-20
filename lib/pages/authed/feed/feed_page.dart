import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/club_feed_post_card.dart';
import 'package:sofie_ui/components/cards/feed_post_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/schedule/coming_up_list.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/feed/announcements_updates.dart';
import 'package:sofie_ui/pages/authed/feed/followers_following.dart';
import 'package:sofie_ui/pages/authed/feed/welcome_todo_items.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late AuthedUser _authedUser;
  late StreamFeedClient _streamFeedClient;

  /// Timeline - activities from feeds the users timeline is following.
  late FlatFeed _timelineFeed;

  /// Feed - posts the user has made themselves.
  late FlatFeed _userFeed;

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

  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();

    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamFeedClient = context.streamFeedClient;
    _timelineFeed =
        _streamFeedClient.flatFeed(kUserTimelineName, _authedUser.id);
    _userFeed = _streamFeedClient.flatFeed(kUserFeedName, _authedUser.id);

    _pagingController = PagingController<int, StreamEnrichedActivity>(
        firstPageKey: 0, invisibleItemsThreshold: 5);

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (!_showBackToTopButton &&
          _scrollController.positions.isNotEmpty &&
          _scrollController.position.pixels > 2000) {
        setState(() => _showBackToTopButton = true);
      }
      if (_showBackToTopButton &&
          _scrollController.positions.isNotEmpty &&
          _scrollController.position.pixels <= 2000) {
        setState(() => _showBackToTopButton = false);
      }
    });

    _pagingController.addPageRequestListener((nextPageKey) {
      _getTimelinePosts(offset: nextPageKey);
    });

    _subscribeToFeed();
  }

  Future<void> _getTimelinePosts({required int offset}) async {
    try {
      final feedActivities = await _timelineFeed
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
      _feedSubscription = await _timelineFeed
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

  /// A non owner can still remove a post from their own timeline if they want.
  Future<void> _confirmRemoveActivityFromFeed(String activityId) async {
    context.showConfirmDeleteDialog(
        verb: 'Remove',
        itemType: 'Post',
        message: 'This will remove the post from your timeline.',
        onConfirm: () async {
          await _timelineFeed.removeActivityById(activityId);
        });
  }

  void _scrollToTopOfScreen() => _scrollController.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );

  Widget _buildNavIconButton(
          VoidCallback onPressed, IconData iconData, String label) =>
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData),
            const SizedBox(height: 2),
            MyText(
              label,
              size: FONTSIZE.one,
            )
          ],
        ),
      );

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

    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavIconButton(
                () => context.navigateTo(FeedPostCreatorRoute()),
                CupertinoIcons.plus_circle,
                'Post'),
            _buildNavIconButton(
                () => context.push(
                        child: FollowersFollowing(
                      userId: _authedUser.id,
                    )),
                CupertinoIcons.person_2,
                'Friends'),
            const ChatsIconButton(),
            const NotificationsIconButton(),
            _buildNavIconButton(
                () => context.navigateTo(const YourPostsRoute()),
                CupertinoIcons.tray_full,
                'History'),
            _buildNavIconButton(() => context.navigateTo(const SettingsRoute()),
                CupertinoIcons.gear, 'Settings'),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding:
                EdgeInsets.only(bottom: EnvironmentConfig.bottomNavBarHeight),
            child: CustomScrollView(
              controller: _scrollController,
              cacheExtent: 2000,
              slivers: [
                const SliverToBoxAdapter(
                  child: AnnouncementsUpdates(),
                ),
                const SliverToBoxAdapter(
                  child: WelcomeTodoItems(),
                ),
                const SliverToBoxAdapter(
                  child: ComingUpList(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 16, bottom: 8),
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.square_list,
                        ),
                        SizedBox(width: 6),
                        MyHeaderText('Activity'),
                      ],
                    ),
                  ),
                ),
                PagedSliverList<int, StreamEnrichedActivity>(
                    pagingController: _pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<StreamEnrichedActivity>(
                      itemBuilder: (context, activity, index) {
                        return FadeInUp(
                          duration: 50,
                          delay: index,
                          delayBasis: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    timelineFeed: _timelineFeed,
                                    userFeed: _userFeed,
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
                      noItemsFoundIndicatorBuilder: (context) =>
                          YourContentEmptyPlaceholder(
                              message: 'No posts yet',
                              explainer:
                                  'Posts from anyone you are following will show up here. Keep up with all the latest fitness news and content from your friends and fans!',
                              actions: [
                            EmptyPlaceholderAction(
                                action: () => context
                                    .navigateTo(const DiscoverPeopleRoute()),
                                buttonIcon: CupertinoIcons.compass,
                                buttonText: 'Discover People'),
                          ]),
                    )),
              ],
            ),
          ),
          if (_newActivities.isNotEmpty)
            Positioned(
                top: 40,
                child: SizeFadeIn(
                    child: FloatingButton(
                  icon: CupertinoIcons.news,
                  onTap: _prependNewPosts,
                  text:
                      '${_newActivities.length} new ${_newActivities.length == 1 ? "post" : "posts"}',
                ))),
          if (_showBackToTopButton)
            Positioned(
                right: 10,
                bottom: EnvironmentConfig.bottomNavBarHeight + 20,
                child: FadeInUp(
                  child: ContentBox(
                    padding: const EdgeInsets.all(4),
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _scrollToTopOfScreen,
                        child: const Icon(
                          CupertinoIcons.chevron_up_circle,
                          size: 30,
                        )),
                  ),
                )),
        ],
      ),
    );
  }
}
