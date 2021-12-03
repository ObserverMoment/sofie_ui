import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/journal/progress_journal_entries.dart';
import 'package:sofie_ui/components/journal/progress_journal_goals.dart';
import 'package:sofie_ui/components/journal/progress_journal_summary.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';

class ProgressJournalDetailsPage extends StatefulWidget {
  final String id;
  const ProgressJournalDetailsPage(
      {Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _ProgressJournalDetailsPageState createState() =>
      _ProgressJournalDetailsPageState();
}

class _ProgressJournalDetailsPageState
    extends State<ProgressJournalDetailsPage> {
  int _activeTabIndex = 0;

  void _openEditJournalMeta(ProgressJournal journal) {
    context.navigateTo(ProgressJournalCreatorRoute(progressJournal: journal));
  }

  void _handleDeleteJournal() {
    context.showConfirmDeleteDialog(
        itemType: 'Journal',
        message:
            'The journal, all entries and all goals will be deleted. Are you sure?',
        onConfirm: _deleteJournal);
  }

  Future<void> _deleteJournal() async {
    final variables = DeleteProgressJournalByIdArguments(id: widget.id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteProgressJournalByIdMutation(variables: variables),
        objectId: widget.id,
        typename: kProgressJournalTypename,
        clearQueryDataAtKeys: [
          GQLVarParamKeys.progressJournalByIdQuery(widget.id)
        ],
        removeRefFromQueries: [
          GQLOpNames.userProgressJournalsQuery
        ]);

    if (result.hasErrors ||
        result.data?.deleteProgressJournalById != widget.id) {
      context.showToast(
          message:
              'Sorry, something went wrong, we were not able to delete this journal.',
          toastType: ToastType.destructive);
    } else {
      context.pop(); // Screen
    }
  }

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final query = ProgressJournalByIdQuery(
        variables: ProgressJournalByIdArguments(id: widget.id));

    return QueryObserver<ProgressJournalById$Query,
            ProgressJournalByIdArguments>(
        key: Key(
            'ProgressJournalDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final journal = data.progressJournalById;
          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarTitle(journal.name),
                trailing: NavBarEllipsisMenu(items: [
                  ContextMenuItem(
                      iconData: CupertinoIcons.info,
                      text: 'Edit Journal Meta',
                      onTap: () => _openEditJournalMeta(journal)),
                  ContextMenuItem(
                      iconData: CupertinoIcons.delete_simple,
                      destructive: true,
                      text: 'Delete Journal',
                      onTap: _handleDeleteJournal),
                ]),
              ),
              child: Column(
                children: [
                  MyTabBarNav(
                      titles: const ['Summary', 'Entries', 'Goals'],
                      handleTabChange: _changeTab,
                      activeTabIndex: _activeTabIndex),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 8.0),
                    child: IndexedStack(
                      index: _activeTabIndex,
                      children: [
                        ProgressJournalSummary(
                          journal: journal,
                        ),
                        ProgressJournalEntries(
                            parentJournal: journal,
                            entries: journal.progressJournalEntries),
                        ProgressJournalGoals(
                          goals: journal.progressJournalGoals,
                          parentJournalId: journal.id,
                        ),
                      ],
                    ),
                  ))
                ],
              ));
        });
  }
}
