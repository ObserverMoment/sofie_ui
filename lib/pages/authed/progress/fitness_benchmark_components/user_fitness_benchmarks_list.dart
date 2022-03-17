import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/fitness_benchmark_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/drop_down_menu.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmark_details.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';

/// A list of all standard (in app) and custom (user generated) fitness benchmarks, broken down into categories.
/// User can browse and then 'activate' benchmarks.
/// Active benchmarks will display on the main scorebook page.
class UserFitnessBenchmarksList extends StatefulWidget {
  const UserFitnessBenchmarksList({Key? key}) : super(key: key);

  @override
  State<UserFitnessBenchmarksList> createState() =>
      _UserFitnessBenchmarksListState();
}

class _UserFitnessBenchmarksListState extends State<UserFitnessBenchmarksList> {
  FitnessBenchmarkCategory? _activeCategory;
  FitnessBenchmarkScope? _activeScope;

  @override
  Widget build(BuildContext context) {
    final userFitnessBenchmarksQuery = UserFitnessBenchmarksQuery();

    final categories = CoreDataRepo.fitnessBenchmarkCategories;

    final filteredBenchmarkCategories = _activeCategory == null
        ? categories
        : categories.where((c) => c == _activeCategory);

    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Fitness Benchmarks'),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownMenu<FitnessBenchmarkCategory>(
                  selected: _activeCategory,
                  clearInput: () => setState(() => _activeCategory = null),
                  options: {
                    for (final category in categories)
                      PopoverMenuItem(
                              text: category.name,
                              onTap: () =>
                                  setState(() => _activeCategory = category)):
                          category
                  },
                  placeholder: 'All',
                  title: 'Category',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownMenu<FitnessBenchmarkScope>(
                  selected: _activeScope,
                  clearInput: () => setState(() => _activeScope = null),
                  options: {
                    PopoverMenuItem(
                        text: FitnessBenchmarkScope.standard.name.capitalize,
                        onTap: () => setState(() => _activeScope =
                            FitnessBenchmarkScope
                                .standard)): FitnessBenchmarkScope.standard,
                    PopoverMenuItem(
                            text: FitnessBenchmarkScope.custom.name.capitalize,
                            onTap: () => setState(() =>
                                _activeScope = FitnessBenchmarkScope.custom)):
                        FitnessBenchmarkScope.custom
                  },
                  placeholder: 'All',
                  title: 'Standard / Custom',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          QueryObserver<UserFitnessBenchmarks$Query, json.JsonSerializable>(
              key: Key(
                  'UserFitnessBenchmarksList - ${userFitnessBenchmarksQuery.operationName}'),
              query: userFitnessBenchmarksQuery,
              builder: (data) {
                final benchmarks =
                    data.userFitnessBenchmarks.sortedBy<String>((b) => b.name);

                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: filteredBenchmarkCategories
                        .map((category) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _FitnessBenchmarkCategoryUI(
                                fitnessBenchmarkCategory: category,
                                fitnessBenchmarks: benchmarks
                                    .where((b) =>
                                        b.fitnessBenchmarkCategory ==
                                            category &&
                                        (_activeScope == null ||
                                            b.scope == _activeScope))
                                    .toList(),
                              ),
                            ))
                        .toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class _FitnessBenchmarkCategoryUI extends StatelessWidget {
  final FitnessBenchmarkCategory fitnessBenchmarkCategory;
  final List<FitnessBenchmark> fitnessBenchmarks;
  const _FitnessBenchmarkCategoryUI(
      {Key? key,
      required this.fitnessBenchmarkCategory,
      required this.fitnessBenchmarks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            fitnessBenchmarkCategory.name,
            weight: FontWeight.bold,
            size: FONTSIZE.five,
          ),
          const SizedBox(height: 12),
          fitnessBenchmarks.isEmpty
              ? const MyText('No benchmarks...')
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fitnessBenchmarks.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const HorizontalLine(),
                  itemBuilder: (c, i) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.push(
                        child: UserFitnessBenchmarkDetails(
                            id: fitnessBenchmarks[i].id)),
                    child: FitnessBenchmarkCard(
                        fitnessBenchmark: fitnessBenchmarks[i]),
                  ),
                )
        ],
      ),
    );
  }
}
