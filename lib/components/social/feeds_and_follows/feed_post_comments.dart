import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_post_comment_input.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

class FeedPostComments extends StatefulWidget {
  final StreamEnrichedActivity activity;
  const FeedPostComments({Key? key, required this.activity}) : super(key: key);

  @override
  State<FeedPostComments> createState() => _FeedPostCommentsState();
}

class _FeedPostCommentsState extends State<FeedPostComments> {
  late String _authedUserId;
  late StreamFeedClient _streamFeedClient;
  late PagingController<int, Reaction> _pagingController;

  /// GetStream uses integer offset for making api calls to get more activities when paginating.
  final int _commentsPerPage = 10;

  @override
  void initState() {
    super.initState();

    _authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    _streamFeedClient = context.streamFeedClient;

    _pagingController = PagingController<int, Reaction>(
        firstPageKey: 0, invisibleItemsThreshold: 10);

    _pagingController.addPageRequestListener((_) {
      _getActivityComments();
    });
  }

  Future<void> _getActivityComments() async {
    try {
      final latestComment = _pagingController.itemList?.last;
      final filter = latestComment?.id != null
          ? Filter().idLessThan(latestComment!.id!)
          : null;

      final comments = await _streamFeedClient.reactions.filter(
          LookupAttribute.activityId, widget.activity.id,
          kind: kCommentReactionName, limit: 20, filter: filter);

      final int numCommentsBefore = _pagingController.itemList?.length ?? 0;
      final int numNewComments = comments.length;

      if (comments.length < _commentsPerPage) {
        _pagingController.appendLastPage(comments);
      } else {
        _pagingController.appendPage(
            comments, numCommentsBefore + numNewComments);
      }
    } catch (e) {
      printLog(e.toString());
      _pagingController.error = e.toString();
      context.showToast(
          message: 'Sorry there was a problem loading the comments.',
          toastType: ToastType.destructive);
    }
  }

  Future<void> _postComment(String comment) async {
    final newComment = await _streamFeedClient.reactions
        .add(kCommentReactionName, widget.activity.id, data: {'text': comment});

    /// Add the comment to the top of the list.
    setState(() {
      _pagingController.itemList = [
        newComment,
        ..._pagingController.itemList ?? [],
      ];
    });
  }

  Future<void> _updateComment(Reaction comment) async {
    if (comment.id != null && comment.data?['text'] != null) {
      context.push(
          child: FullScreenTextEditing(
              title: 'Update Comment',
              initialValue: comment.data!['text']!.toString(),
              onSave: (text) async {
                final updatedComment = await _streamFeedClient.reactions
                    .update(comment.id!, data: {'text': text});

                final prevItems = _pagingController.itemList ?? [];

                /// Replace the old comment.
                setState(() {
                  _pagingController.itemList = prevItems
                      .map(
                          (c) => c.id == updatedComment.id ? updatedComment : c)
                      .toList();
                });
              },
              inputValidation: (t) => t.isNotEmpty));
    }
  }

  Future<void> _deleteComment(Reaction comment) async {
    if (comment.id != null) {
      context.showConfirmDeleteDialog(
          itemType: 'Comment',
          onConfirm: () async {
            await _streamFeedClient.reactions.delete(comment.id!);

            /// Remove the comment from the list.
            setState(() {
              _pagingController.itemList
                  ?.removeWhere((c) => c.id == comment.id);
            });
          });
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: const MyNavBar(
          middle: NavBarTitle('Comments'),
        ),
        child: Column(
          children: [
            Expanded(
              child: PagedListView<int, Reaction>(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Reaction>(
                  itemBuilder: (context, reaction, index) {
                    return FadeInUp(
                      duration: 50,
                      delay: index,
                      delayBasis: 10,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: FeedPostComment(
                              userIsOwner: _authedUserId == reaction.userId,
                              comment: reaction,
                              updateComment: _updateComment,
                              deleteComment: _deleteComment)),
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
                      const Center(child: MyText('No comments yet...')),
                ),
              ),
            ),
            FeedPostCommentInput(
              postComment: _postComment,
            )
          ],
        ));
  }
}

class FeedPostComment extends StatelessWidget {
  final bool userIsOwner;
  final Reaction comment;
  final void Function(Reaction comment) updateComment;
  final void Function(Reaction comment) deleteComment;
  const FeedPostComment(
      {Key? key,
      required this.comment,
      required this.updateComment,
      required this.deleteComment,
      required this.userIsOwner})
      : super(key: key);

  double get _avatarWidth => 36.0;
  double get _avatarPadding => 10.0;

  /// From combination of page and list.
  double get _estimatedPagePadding => 24.0;

  @override
  Widget build(BuildContext context) {
    final user = comment.user != null
        ? FeedUtils.formatStreamFeedUser(comment.user!)
        : null;

    final avatarUri = user?.data.image;
    final displayName = user?.data.name;

    final timePosted = comment.updatedAt ?? comment.createdAt;

    // Estimated padding from page and list.
    final screenWidth =
        MediaQuery.of(context).size.width - _estimatedPagePadding;

    final textWidth = screenWidth - _avatarWidth - _avatarPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserAvatar(
              avatarUri: avatarUri,
              size: _avatarWidth,
            ),
            SizedBox(width: _avatarPadding),
            SizedBox(
              width: textWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(displayName ?? '...',
                      weight: FontWeight.bold, size: FONTSIZE.two),
                  const SizedBox(height: 4),
                  ReadMoreTextBlock(
                    title: displayName ?? '...',
                    text: comment.data?['text'].toString() ??
                        'Could not load comment...',
                    fontSize: 12,
                    trimLines: 12,
                  ),
                  if (userIsOwner || timePosted != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (timePosted != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5, right: 8),
                            child: MyText(
                              timePosted.timeAgo,
                              subtext: true,
                              size: FONTSIZE.two,
                            ),
                          ),
                        if (userIsOwner)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FeedPostActionButton(
                                text: 'Update',
                                onTap: () => updateComment(comment),
                              ),
                              FeedPostActionButton(
                                text: 'Delete',
                                onTap: () => deleteComment(comment),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const HorizontalLine(),
      ],
    );
  }
}

class FeedPostActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const FeedPostActionButton(
      {Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: MyText(
          text,
          subtext: true,
          size: FONTSIZE.two,
        ),
      ),
    );
  }
}
