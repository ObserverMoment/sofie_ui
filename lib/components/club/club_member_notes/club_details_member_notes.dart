import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/club/club_member_notes/club_member_note_card.dart';
import 'package:sofie_ui/components/club/club_member_notes/create_edit_club_member_notes.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

/// Members notes are not persisted to the store but just handled in local state within the widget.
class ClubDetailsMemberNotes extends StatefulWidget {
  final String clubId;
  final ClubMemberSummary clubMemberSummary;
  const ClubDetailsMemberNotes(
      {Key? key, required this.clubId, required this.clubMemberSummary})
      : super(key: key);

  @override
  _ClubDetailsMemberNotesState createState() => _ClubDetailsMemberNotesState();
}

class _ClubDetailsMemberNotesState extends State<ClubDetailsMemberNotes> {
  /// Cursor for MemberNotes pagination. The id of the last retrieved MemberNote.
  String? _cursor;

  /// For inifinite scroll / pagination of notes from the network.
  int get _notesPerPage => 25;

  final PagingController<int, ClubMemberNote> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 15);

  @override
  void initState() {
    /// [nextPageKey] will be zero when the filters are refreshed. This means no cursor should be passed to the query args.
    /// Any other number for the pageKey causes this function to look up the [_cursor] from state.
    /// To standardize, we pass pageKey as [1] whenever a page is appended to the list.
    _pagingController.addPageRequestListener((nextPageKey) {
      _fetchMemberNotes(nextPageKey);
    });

    super.initState();
  }

  Future<void> _fetchMemberNotes(int nextPageKey) async {
    try {
      /// [nextPageKey] defaults to 0 when [_pagingController] is initialised.
      /// For every subsequent call for a page [nextPageKey] will be [NOT 0]
      /// Use as a boolean. If [not 0] then pass [_cursor] to the query args.
      final memberNotes = await _executeClubMemberNotesQuery(
          cursor: nextPageKey == 0 ? null : _cursor);

      final isLastPage = memberNotes.length < _notesPerPage;
      if (isLastPage) {
        _pagingController.appendLastPage(memberNotes);
      } else {
        _cursor = memberNotes.last.id;

        /// Pass nextPageKey as 1. Acts like a boolean to tell future fetch calls to get the _[cursor] from local state.
        _pagingController.appendPage(memberNotes, 1);
      }
    } catch (error) {
      printLog(error.toString());
      if (mounted) _pagingController.error = error;
    }

    setState(() {});
  }

  Future<List<ClubMemberNote>> _executeClubMemberNotesQuery(
      {String? cursor}) async {
    final variables = ClubMemberNotesArguments(
      clubId: widget.clubId,
      memberId: widget.clubMemberSummary.id,
      take: _notesPerPage,
      cursor: cursor,
    );

    final query = ClubMemberNotesQuery(variables: variables);
    final response = await context.graphQLStore.execute(query);

    if ((response.errors != null && response.errors!.isNotEmpty) ||
        response.data == null) {
      throw Exception(
          'Sorry, something went wrong!: ${response.errors != null ? response.errors!.join(',') : ''}');
    }

    return query.parse(response.data ?? {}).clubMemberNotes;
  }

  void _addNewNoteToList(ClubMemberNote note) {
    _pagingController.itemList = [note, ..._pagingController.itemList ?? []];
  }

  void _addUpdatedNoteToList(ClubMemberNote note) {
    /// Updated notes go to the top.
    /// Remove the old note.
    _pagingController.itemList?.removeWhere((n) => n.id == note.id);

    /// Add the new one to the top.
    _pagingController.itemList = [note, ..._pagingController.itemList ?? []];
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
          middle:
              NavBarTitle('Notes - ${widget.clubMemberSummary.displayName}'),
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.push(
                  fullscreenDialog: true,
                  child: CreateEditMemberNote(
                    clubId: widget.clubId,
                    memberId: widget.clubMemberSummary.id,
                    onCreate: _addNewNoteToList,
                  )),
              child: const Icon(CupertinoIcons.add))),
      child: PagedListView<int, ClubMemberNote>.separated(
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ClubMemberNote>(
            itemBuilder: (context, memberNote, index) => FadeInUp(
              key: Key(memberNote.id),
              delay: 5,
              delayBasis: 20,
              duration: 100,
              child: ClubMemberNoteCard(
                clubMemberNote: memberNote,
                openEdit: () => context.push(
                    fullscreenDialog: true,
                    child: CreateEditMemberNote(
                      clubMemberNote: memberNote,
                      clubId: widget.clubId,
                      memberId: widget.clubMemberSummary.id,
                      onUpdate: _addUpdatedNoteToList,
                    )),
              ),
            ),
            firstPageProgressIndicatorBuilder: (c) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(),
            ),
            newPageProgressIndicatorBuilder: (c) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(),
            ),
            noItemsFoundIndicatorBuilder: (c) => Padding(
              padding: const EdgeInsets.all(8.0),
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
                    'No notes yet...',
                    subtext: true,
                  ),
                ],
              ),
            ),
          ),
          separatorBuilder: (c, i) => const HorizontalLine(verticalPadding: 8)),
    );
  }
}
