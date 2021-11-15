import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/move_list_item.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/move_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/move_filters_screen.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class YourMovesLibraryPage extends StatefulWidget {
  const YourMovesLibraryPage({Key? key}) : super(key: key);

  @override
  State<YourMovesLibraryPage> createState() => _YourMovesLibraryPageState();
}

class _YourMovesLibraryPageState extends State<YourMovesLibraryPage> {
  /// 0 is standard moves, 1 is custom moves.
  int _activeTabIndex = 0;
  String _searchString = '';

  bool _filter(Move move) {
    return [move.name, move.searchTerms, move.moveType.name]
        .where((t) => Utils.textNotNull(t))
        .map((t) => t!.toLowerCase())
        .any((t) => t.contains(_searchString));
  }

  List<Move> _filterBySearchString(List<Move> moves) {
    return Utils.textNotNull(_searchString)
        ? moves.where((m) => _filter(m)).toList()
        : moves;
  }

  Future<void> _openCustomMoveCreator(Move? moveToUpdate) async {
    Utils.unfocusAny();
    final success =
        await context.pushRoute(CustomMoveCreatorRoute(move: moveToUpdate));
    if (success == true) {
      if (moveToUpdate == null) {
        // Created
        context.showToast(message: 'New move created!');
      } else {
        // Updated
        context.showToast(message: 'Move updates saved!');
      }
    }
  }

  Widget get _loadingPage => const ShimmerListPage(
        title: 'Move Library',
        cardHeight: 70,
      );

  @override
  Widget build(BuildContext context) {
    /// Also used in WorkoutMoveCreator, hence [onCancel] which is not needed here.
    return QueryObserver<StandardMoves$Query, json.JsonSerializable>(
        key:
            Key('YourMovesLibraryPage - ${StandardMovesQuery().operationName}'),
        query: StandardMovesQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: _loadingPage,
        builder: (standardMovesData) {
          return QueryObserver<UserCustomMoves$Query, json.JsonSerializable>(
              key: Key(
                  'YourMovesLibraryPage - ${UserCustomMovesQuery().operationName}'),
              query: UserCustomMovesQuery(),
              loadingIndicator: _loadingPage,
              builder: (customMovesData) {
                final standardMoves = standardMovesData.standardMoves;

                final customMoves = customMovesData.userCustomMoves;

                final displayMoves =
                    _activeTabIndex == 0 ? standardMoves : customMoves;

                final moveFiltersBloc = context.watch<MoveFiltersBloc>();
                final filteredMoves =
                    _filterBySearchString(moveFiltersBloc.filter(displayMoves));

                return MyPageScaffold(
                    navigationBar: MyNavBar(
                      middle: const NavBarTitle('Move Library'),
                      trailing: NavBarTrailingRow(children: [
                        FilterButton(
                          hasActiveFilters: moveFiltersBloc.hasActiveFilters,
                          onPressed: () => context.push(
                              fullscreenDialog: true,
                              child: const MoveFiltersScreen()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CreateIconButton(
                              onPressed: () => _openCustomMoveCreator(null)),
                        ),
                      ]),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SlidingSelect<int>(
                                      value: _activeTabIndex,
                                      children: const {
                                        0: MyText('Standard'),
                                        1: MyText('Custom')
                                      },
                                      updateValue: (i) =>
                                          setState(() => _activeTabIndex = i)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: MyCupertinoSearchTextField(
                            onChanged: (value) => setState(
                                () => _searchString = value.toLowerCase()),
                          ),
                        ),
                        GrowInOut(
                            show: moveFiltersBloc.hasActiveFilters,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TertiaryButton(
                                  onPressed: () => context.push(
                                      child: const MoveFiltersScreen()),
                                  text: 'Update Filters',
                                ),
                                const SizedBox(width: 8),
                                TertiaryButton(
                                  onPressed: () => context
                                      .read<MoveFiltersBloc>()
                                      .clearAllFilters(),
                                  text: 'Clear Filters',
                                ),
                              ],
                            )),
                        if (filteredMoves.isEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MyText(
                                  _activeTabIndex == 0
                                      ? 'No moves found. Create a custom move?'
                                      : 'No moves found',
                                  maxLines: 3,
                                  subtext: true,
                                ),
                              ),
                            ],
                          )
                        else
                          Expanded(
                            child: FadeIn(
                              child: ListView(
                                shrinkWrap: true,
                                children: filteredMoves
                                    .sortedBy<String>((move) => move.name)
                                    .map((move) => GestureDetector(
                                        onTap: () {
                                          Utils.hideKeyboard(context);
                                          context.push(
                                              fullscreenDialog: true,
                                              child: MoveDetails(move));
                                        },
                                        child: MoveListItem(
                                            move: move,
                                            optionalButton: move.scope ==
                                                    MoveScope.custom
                                                ? CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: const Icon(
                                                        CupertinoIcons
                                                            .pencil_circle),
                                                    onPressed: () =>
                                                        _openCustomMoveCreator(
                                                            move))
                                                : null)))
                                    .toList(),
                              ),
                            ),
                          ),
                      ],
                    ));
              });
        });
  }
}
