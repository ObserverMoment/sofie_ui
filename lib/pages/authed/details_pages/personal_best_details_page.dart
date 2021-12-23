import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/personal_best_entry_card.dart';
import 'package:sofie_ui/components/creators/personal_best_creator/personal_best_entry_creator.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class PersonalBestDetailsPage extends StatefulWidget {
  final String id;
  const PersonalBestDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _PersonalBestDetailsPageState createState() =>
      _PersonalBestDetailsPageState();
}

class _PersonalBestDetailsPageState extends State<PersonalBestDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _handleDeleteBenchmark() async {
    await context.showConfirmDeleteDialog(
        itemType: 'Personal Best',
        message: 'The PB and all its entries will be deleted. Are you sure?',
        onConfirm: _deleteBenchmark);
  }

  Future<void> _deleteBenchmark() async {
    final variables = DeleteUserBenchmarkArguments(id: widget.id);

    final result = await context.graphQLStore.delete(
      mutation: DeleteUserBenchmarkMutation(variables: variables),
      objectId: widget.id,
      typename: kUserBenchmarkTypename,
      clearQueryDataAtKeys: [
        getParameterizedQueryId(UserBenchmarkQuery(
            variables: UserBenchmarkArguments(id: widget.id)))
      ],
      removeRefFromQueries: [GQLOpNames.userBenchmarks],
    );

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: "Sorry, that didn't work",
            toastType: ToastType.destructive),
        onSuccess: context.pop);
  }

  @override
  Widget build(BuildContext context) {
    final query =
        UserBenchmarkQuery(variables: UserBenchmarkArguments(id: widget.id));

    return QueryObserver<UserBenchmark$Query, UserBenchmarkArguments>(
        key: Key(
            'PersonalBestDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final benchmark = data.userBenchmark;
          return MyPageScaffold(
            navigationBar: MyNavBar(
              middle: NavBarLargeTitle(benchmark.name),
            ),
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: MyHeaderText(
                                benchmark.benchmarkType.display,
                                size: FONTSIZE.three,
                              ),
                            ),
                            if (Utils.textNotNull(benchmark.description))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: MyText(
                                  benchmark.description!,
                                  maxLines: 10,
                                  textAlign: TextAlign.center,
                                  lineHeight: 1.4,
                                ),
                              ),
                            if (Utils.textNotNull(benchmark.equipmentInfo))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Icon(
                                        CupertinoIcons.cube,
                                        size: 16,
                                        color: Styles.primaryAccent,
                                      ),
                                    ),
                                    MyText(
                                      benchmark.equipmentInfo!,
                                      maxLines: 10,
                                      textAlign: TextAlign.center,
                                      lineHeight: 1,
                                      color: Styles.primaryAccent,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ]))
                    ],
                body: _PersonalBestEntrieslist(
                    userBenchmark: benchmark,
                    handleDeleteBenchmark: _handleDeleteBenchmark)),
          );
        });
  }
}

class _PersonalBestEntrieslist extends StatefulWidget {
  final UserBenchmark userBenchmark;
  final VoidCallback handleDeleteBenchmark;
  const _PersonalBestEntrieslist(
      {required this.userBenchmark, required this.handleDeleteBenchmark});

  @override
  __PersonalBestEntrieslistState createState() =>
      __PersonalBestEntrieslistState();
}

enum ScoreSortBy { best, newest, oldest, worst }

class __PersonalBestEntrieslistState extends State<_PersonalBestEntrieslist> {
  ScoreSortBy _sortBy = ScoreSortBy.best;

  Future<void> _deleteBenchmarkEntry(UserBenchmarkEntry entry) async {
    final variables = DeleteUserBenchmarkEntryArguments(id: entry.id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteUserBenchmarkEntryMutation(variables: variables),
        objectId: entry.id,
        typename: kUserBenchmarkEntryTypename,
        broadcastQueryIds: [
          GQLVarParamKeys.userBenchmark(widget.userBenchmark.id),
          GQLOpNames.userBenchmarks,
        ],
        removeAllRefsToId: true);

    checkOperationResult(
      context,
      result,
      onFail: () => context.showToast(
          message: 'Sorry, there was a problem deleting this entry.',
          toastType: ToastType.destructive),
    );
  }

  List<UserBenchmarkEntry> _sortEntries() {
    switch (_sortBy) {
      case ScoreSortBy.newest:
        return widget.userBenchmark.userBenchmarkEntries
            .sortedBy<DateTime>((e) => e.completedOn)
            .reversed
            .toList();
      case ScoreSortBy.oldest:
        return widget.userBenchmark.userBenchmarkEntries
            .sortedBy<DateTime>((e) => e.completedOn);
      case ScoreSortBy.best:
        final entries = widget.userBenchmark.userBenchmarkEntries
            .sortedBy<num>((e) => e.score);
        return widget.userBenchmark.benchmarkType == BenchmarkType.fastesttime
            ? entries
            : entries.reversed.toList();
      case ScoreSortBy.worst:
        final entries = widget.userBenchmark.userBenchmarkEntries
            .sortedBy<num>((e) => e.score);
        return widget.userBenchmark.benchmarkType != BenchmarkType.fastesttime
            ? entries
            : entries.reversed.toList();
      default:
        return widget.userBenchmark.userBenchmarkEntries;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = _sortEntries();

    return sortedEntries.isEmpty
        ? YourContentEmptyPlaceholder(
            message: 'No scores submitted yet',
            actions: [
                EmptyPlaceholderAction(
                    action: () => context.push(
                            child: PersonalBestEntryCreator(
                          userBenchmark: widget.userBenchmark,
                        )),
                    buttonIcon: CupertinoIcons.add,
                    buttonText: 'Submit a Score'),
              ])
        : FABPage(
            rowButtonsAlignment: MainAxisAlignment.end,
            rowButtons: [
              FloatingButton(
                  gradient: Styles.primaryAccentGradient,
                  contentColor: Styles.white,
                  icon: CupertinoIcons.add,
                  onTap: () => context.push(
                          child: PersonalBestEntryCreator(
                        userBenchmark: widget.userBenchmark,
                      ))),
              const SizedBox(width: 16),
              PopoverMenu(
                button: const FABPageButtonContainer(
                    child: Icon(CupertinoIcons.ellipsis)),
                items: [
                  PopoverMenuItem(
                      iconData: CupertinoIcons.pencil,
                      text: 'Edit PB Definition',
                      onTap: () => context.navigateTo(PersonalBestCreatorRoute(
                          userBenchmark: widget.userBenchmark)),
                      isActive: false),
                  PopoverMenuItem(
                      iconData: CupertinoIcons.delete_simple,
                      destructive: true,
                      text: 'Delete PB',
                      onTap: widget.handleDeleteBenchmark,
                      isActive: false),
                ],
              ),
            ],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: MySlidingSegmentedControl<ScoreSortBy>(
                      value: _sortBy,
                      updateValue: (sortBy) => setState(() => _sortBy = sortBy),
                      children: {
                        for (final v in ScoreSortBy.values)
                          v: describeEnum(v).capitalize
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 60),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sortedEntries.length,
                      itemBuilder: (c, i) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: GestureDetector(
                              onTap: () => context.push(
                                  child: PersonalBestEntryCreator(
                                userBenchmark: widget.userBenchmark,
                                userBenchmarkEntry: sortedEntries[i],
                              )),
                              child: AnimatedSlidable(
                                  key: Key('pb-entry-${sortedEntries[i].id}'),
                                  index: i,
                                  itemType: 'PB Entry',
                                  itemName:
                                      sortedEntries[i].completedOn.dateString,
                                  removeItem: (_) =>
                                      _deleteBenchmarkEntry(sortedEntries[i]),
                                  secondaryActions: const [],
                                  child: PersonalBestEntryCard(
                                      benchmark: widget.userBenchmark,
                                      entry: sortedEntries[i])),
                            ));
                      }),
                ),
              ],
            ),
          );
  }
}
