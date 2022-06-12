import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/move_list_item.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/move_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/move_filters_screen.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ExerciseLibraryPage extends StatefulWidget {
  final String? previousPageTitle;
  const ExerciseLibraryPage({Key? key, this.previousPageTitle})
      : super(key: key);

  @override
  State<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  /// 0 is standard moves, 1 is custom moves.
  int _activeTabIndex = 0;
  String _searchString = '';

  bool _filter(MoveData move) {
    return [move.name, move.searchTerms, move.moveType.name]
        .where((t) => Utils.textNotNull(t))
        .map((t) => t!.toLowerCase())
        .any((t) => t.contains(_searchString));
  }

  List<MoveData> _filterBySearchString(List<MoveData> moves) {
    return Utils.textNotNull(_searchString)
        ? moves.where((m) => _filter(m)).toList()
        : moves;
  }

  Future<void> _openCustomMoveCreator(MoveData? moveToUpdate) async {
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
    final moveDataRepo = context.watch<MoveDataRepo>();
    final standardMoves = moveDataRepo.standardMoves;
    final customMoves = moveDataRepo.customMoves;

    final displayMoves = _activeTabIndex == 0 ? standardMoves : customMoves;

    final moveFiltersBloc = context.watch<MoveFiltersBloc>();
    final filteredMoves =
        _filterBySearchString(moveFiltersBloc.filter(displayMoves));

    return MyPageScaffold(
        navigationBar: MyNavBar(
          previousPageTitle: widget.previousPageTitle,
          middle: const NavBarTitle('Exercise Library'),
        ),
        child: FABPage(
          rowButtonsAlignment: MainAxisAlignment.end,
          rowButtons: [
            if (moveFiltersBloc.hasActiveFilters)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: FadeInUp(
                  child: FloatingButton(
                      onTap: () =>
                          context.read<MoveFiltersBloc>().clearAllFilters(),
                      icon: CupertinoIcons.clear),
                ),
              ),
            FloatingButton(
                onTap: () => context.push(child: const MoveFiltersScreen()),
                text: moveFiltersBloc.numActiveFilters == 0
                    ? null
                    : '${moveFiltersBloc.numActiveFilters} ${moveFiltersBloc.numActiveFilters == 1 ? "filter" : "filters"}',
                icon: CupertinoIcons.slider_horizontal_3),
            const SizedBox(width: 12),
            FloatingButton(
                icon: CupertinoIcons.add,
                text: 'Create Move',
                onTap: () => context.navigateTo(CustomMoveCreatorRoute())),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: MyCupertinoSearchTextField(
                  placeholder: 'Search moves library',
                  onChanged: (value) =>
                      setState(() => _searchString = value.toLowerCase()),
                ),
              ),
              if (filteredMoves.isEmpty)
                const ContentEmptyPlaceholder(
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
                                  optionalButton: move.scope == MoveScope.custom
                                      ? CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child:
                                              const Icon(CupertinoIcons.pencil),
                                          onPressed: () =>
                                              _openCustomMoveCreator(move))
                                      : null)))
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
