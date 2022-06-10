import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_creator.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/active_settings_and_benchmarks_container.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmark_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/drop_down_menu.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmark_details.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';

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
    final categories = CoreDataRepo.fitnessBenchmarkCategories;

    final filteredBenchmarkCategories = _activeCategory == null
        ? categories
        : categories.where((c) => c == _activeCategory);

    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: const NavBarTitle('Fitness Benchmarks'),
        trailing: TertiaryButton(
            text: 'New',
            prefixIconData: CupertinoIcons.plus,
            onPressed: () =>
                context.push(child: const FitnessBenchmarkCreator())),
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
          ActiveSettingsAndBenchmarksContainer(
            builder: (activeBenchmarkIds, benchmarks) {
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
                                      b.fitnessBenchmarkCategory == category &&
                                      (_activeScope == null ||
                                          b.scope == _activeScope))
                                  .toList(),
                              activeBenchmarkIds: activeBenchmarkIds,
                            ),
                          ))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FitnessBenchmarkCategoryUI extends StatelessWidget {
  final FitnessBenchmarkCategory fitnessBenchmarkCategory;
  final List<FitnessBenchmark> fitnessBenchmarks;
  final List<String> activeBenchmarkIds;
  const _FitnessBenchmarkCategoryUI(
      {Key? key,
      required this.fitnessBenchmarkCategory,
      required this.fitnessBenchmarks,
      required this.activeBenchmarkIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedBenchmarks = fitnessBenchmarks.sorted((a, b) {
      final aIsActive = activeBenchmarkIds.contains(a.id);
      final bIsActive = activeBenchmarkIds.contains(b.id);
      if (aIsActive && !bIsActive) {
        return -1;
      } else if (bIsActive && !aIsActive) {
        return 1;
      } else {
        return a.name.compareTo(b.name);
      }
    });

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
              ? const MyText(
                  'No benchmarks...',
                  subtext: true,
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fitnessBenchmarks.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const HorizontalLine(),
                  itemBuilder: (c, i) {
                    final benchmark = sortedBenchmarks[i];

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.push(
                          child: UserFitnessBenchmarkDetails(id: benchmark.id)),
                      child: FitnessBenchmarkCard(
                        benchmark: benchmark,
                        activeBenchmarkIds: activeBenchmarkIds,
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
