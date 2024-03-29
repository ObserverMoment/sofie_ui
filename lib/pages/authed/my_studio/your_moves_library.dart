import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/move_list_item.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/move_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/move_filters_screen.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
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
    Utils.hideKeyboard(context);
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

  @override
  Widget build(BuildContext context) {
    final standardMoves = CoreDataRepo.standardMoves;

    /// Also used in WorkoutMoveCreator, hence [onCancel] which is not needed here.
    return QueryObserver<CustomMoves$Query, json.JsonSerializable>(
        key: Key('YourMovesLibraryPage - ${CustomMovesQuery().operationName}'),
        query: CustomMovesQuery(),
        builder: (customMovesData) {
          final customMoves = customMovesData.customMoves;

          final displayMoves =
              _activeTabIndex == 0 ? standardMoves : customMoves;

          final moveFiltersBloc = context.watch<MoveFiltersBloc>();
          final filteredMoves =
              _filterBySearchString(moveFiltersBloc.filter(displayMoves));

          return MyPageScaffold(
              navigationBar: const MyNavBar(
                middle: NavBarLargeTitle('Move Library'),
              ),
              child: FABPage(
                rowButtonsAlignment: MainAxisAlignment.end,
                rowButtons: [
                  if (moveFiltersBloc.hasActiveFilters)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: FadeInUp(
                        child: FloatingButton(
                            onTap: () => context
                                .read<MoveFiltersBloc>()
                                .clearAllFilters(),
                            icon: CupertinoIcons.clear),
                      ),
                    ),
                  FloatingButton(
                      onTap: () =>
                          context.push(child: const MoveFiltersScreen()),
                      text: moveFiltersBloc.numActiveFilters == 0
                          ? null
                          : '${moveFiltersBloc.numActiveFilters} ${moveFiltersBloc.numActiveFilters == 1 ? "filter" : "filters"}',
                      icon: CupertinoIcons.slider_horizontal_3),
                  const SizedBox(width: 12),
                  FloatingButton(
                      icon: CupertinoIcons.add,
                      text: 'Create Move',
                      onTap: () =>
                          context.navigateTo(CustomMoveCreatorRoute())),
                ],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MySlidingSegmentedControl<int>(
                                  value: _activeTabIndex,
                                  children: const {0: 'Standard', 1: 'Custom'},
                                  updateValue: (i) =>
                                      setState(() => _activeTabIndex = i)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: MyCupertinoSearchTextField(
                        placeholder: 'Search moves library',
                        onChanged: (value) =>
                            setState(() => _searchString = value.toLowerCase()),
                      ),
                    ),
                    if (filteredMoves.isEmpty)
                      const YourContentEmptyPlaceholder(
                          message: 'No moves to display',
                          explainer:
                              'If there is a move that you think we have missed then please let us know! Or you can always make your own custom moves, especially useful for unusual, compound or adapted moves.',
                          actions: [])
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
                                        optionalButton:
                                            move.scope == MoveScope.custom
                                                ? CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: const Icon(
                                                        CupertinoIcons.pencil),
                                                    onPressed: () =>
                                                        _openCustomMoveCreator(
                                                            move))
                                                : null)))
                                .toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ));
        });
  }
}
