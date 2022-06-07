import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/move_list_item.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/move_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/move_filters_screen.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';

/// The user is required to select a move before moving on to the workoutMove creator.
/// Unlike some other selectors this runs callback immediately on press.
class MoveSelector extends StatefulWidget {
  final void Function(Move move) selectMove;
  final VoidCallback onCancel;
  final String pageTitle;

  /// Removes the option to switch to custom moves tab. Also removes filtering option.
  final bool includeCustomMoves;
  final bool showCreateCustomMoveButton;

  /// Optional move filter. E.g only show yoga moves if user is programming a yoga session.
  /// Only show moves with REPS as a valid rep type if programming a lifting session.
  final List<Move> Function(List<Move> moves)? customFilter;

  const MoveSelector(
      {Key? key,
      required this.selectMove,
      this.includeCustomMoves = true,
      this.showCreateCustomMoveButton = true,
      required this.onCancel,
      this.pageTitle = 'Select Move',
      this.customFilter})
      : super(key: key);

  @override
  State<MoveSelector> createState() => _MoveSelectorState();
}

class _MoveSelectorState extends State<MoveSelector> {
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

  Widget _buildButton(Move move) {
    return move.scope == MoveScope.custom
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.pencil_circle),
            onPressed: () => _openCustomMoveCreator(move))
        : InfoPopupButton(withoutNavBar: true, infoWidget: MoveDetails(move));
  }

  Widget get _loadingPage => ShimmerListPage(
        title: widget.pageTitle,
        cardHeight: 70,
      );

  @override
  Widget build(BuildContext context) {
    return QueryObserver<CustomMoves$Query, json.JsonSerializable>(
        key: Key('MoveSelector - ${CustomMovesQuery().operationName}'),
        query: CustomMovesQuery(),
        loadingIndicator: _loadingPage,
        builder: (customMovesData) {
          final standardMoves = CoreDataRepo.standardMoves;

          final customMoves = customMovesData.customMoves;

          final displayMoves =
              _activeTabIndex == 0 ? standardMoves : customMoves;

          final moveFiltersBloc = context.watch<MoveFiltersBloc>();
          final customFiltered =
              widget.customFilter?.call(displayMoves) ?? displayMoves;

          final filteredMoves =
              _filterBySearchString(moveFiltersBloc.filter(customFiltered));

          return MyPageScaffold(
              navigationBar: CupertinoNavigationBar(
                /// Required because in [WorkoutMoveCreator] this [MoveSelecter] sits as a sibling to another widget which also has a [CupertinoNavBar] - which was causing an 'identical hero tags in tree error'.
                transitionBetweenRoutes: false,
                leading: NavBarCancelButton(widget.onCancel),
                middle: NavBarTitle(widget.pageTitle),
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
                      onTap: () =>
                          context.navigateTo(CustomMoveCreatorRoute())),
                ],
                child: Column(
                  children: [
                    if (widget.includeCustomMoves)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: MySlidingSegmentedControl<int>(
                                    value: _activeTabIndex,
                                    children: const {
                                      0: 'Standard',
                                      1: 'Custom'
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
                        placeholder: 'Search moves library',
                        onChanged: (value) =>
                            setState(() => _searchString = value.toLowerCase()),
                      ),
                    ),
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
                                      widget.selectMove(move);
                                    },
                                    child: MoveListItem(
                                        move: move,
                                        optionalButton: _buildButton(move))))
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
