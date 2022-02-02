import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// User content where [archived] = true
class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  int _activeTabIndex = 0;

  void _changeTab(int index) {
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: const MyNavBar(
          middle: NavBarLargeTitle('Archive'),
        ),
        child: Column(
          children: [
            MySlidingSegmentedControl(
                value: _activeTabIndex,
                children: const {
                  0: 'Workouts',
                  1: 'Plans',
                  2: 'Moves',
                },
                updateValue: _changeTab),
            const SizedBox(height: 16),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: IndexedStack(
                  index: _activeTabIndex,
                  children: const [
                    _ArchivedWorkouts(),
                    _ArchivedWorkoutPlans(),
                    _ArchivedCustomMoves(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class _ArchivedWorkouts extends StatelessWidget {
  const _ArchivedWorkouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserArchivedWorkoutsQuery();
    return QueryObserver<UserArchivedWorkouts$Query, json.JsonSerializable>(
        key: Key('_ArchivedWorkouts - ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerCardList(
          itemCount: 20,
          cardHeight: 80,
        ),
        builder: (data) {
          final archived = data.archivedWorkout;

          return archived.isEmpty
              ? const _NoContentPlaceholder()
              : ContentBox(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: archived.length,
                    separatorBuilder: (c, i) => const HorizontalLine(
                      verticalPadding: 0,
                    ),
                    itemBuilder: (c, i) => _ArchivedItemTile(
                      name: archived[i].name,
                      iconData: CupertinoIcons.chevron_right,
                      onTap: () => context
                          .navigateTo(WorkoutDetailsRoute(id: archived[i].id)),
                    ),
                  ),
                );
        });
  }
}

class _ArchivedWorkoutPlans extends StatelessWidget {
  const _ArchivedWorkoutPlans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserArchivedWorkoutPlansQuery();
    return QueryObserver<UserArchivedWorkoutPlans$Query, json.JsonSerializable>(
        key: Key('_ArchivedWorkoutPlans - ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerCardList(
          itemCount: 20,
          cardHeight: 80,
        ),
        builder: (data) {
          final archived = data.archivedWorkoutPlan;

          return archived.isEmpty
              ? const _NoContentPlaceholder()
              : ContentBox(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: archived.length,
                    separatorBuilder: (c, i) => const HorizontalLine(
                      verticalPadding: 0,
                    ),
                    itemBuilder: (c, i) => _ArchivedItemTile(
                      name: archived[i].name,
                      iconData: CupertinoIcons.chevron_right,
                      onTap: () => context.navigateTo(
                          WorkoutPlanDetailsRoute(id: archived[i].id)),
                    ),
                  ),
                );
        });
  }
}

class _ArchivedCustomMoves extends StatelessWidget {
  const _ArchivedCustomMoves({Key? key}) : super(key: key);

  Future<void> _unarchiveCustomMove(BuildContext context, String id) async {
    final result = await context.graphQLStore.mutate<
        UnarchiveCustomMoveById$Mutation, UnarchiveCustomMoveByIdArguments>(
      mutation: UnarchiveCustomMoveByIdMutation(
          variables: UnarchiveCustomMoveByIdArguments(id: id)),
      addRefToQueries: [GQLOpNames.customMoves],
      removeRefFromQueries: [GQLOpNames.userArchivedCustomMoves],
    );

    checkOperationResult(context, result,
        onSuccess: () => context.showToast(message: 'Custom move unarchived'),
        onFail: () => context.showErrorAlert(
            'Something went wrong, the move was not unarchived correctly'));
  }

  @override
  Widget build(BuildContext context) {
    final query = UserArchivedCustomMovesQuery();
    return QueryObserver<UserArchivedCustomMoves$Query, json.JsonSerializable>(
        key: Key('_ArchivedCustomMoves - ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerCardList(
          itemCount: 20,
          cardHeight: 80,
        ),
        builder: (data) {
          final archived = data.archivedMove;

          return archived.isEmpty
              ? const _NoContentPlaceholder()
              : ContentBox(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: archived.length,
                    separatorBuilder: (c, i) => const HorizontalLine(
                      verticalPadding: 0,
                    ),
                    itemBuilder: (c, i) => _ArchivedItemTile(
                      name: archived[i].name,
                      iconData: CupertinoIcons.refresh_bold,
                      onTap: () => context.showConfirmDialog(
                          title: 'Un-archive This Move?',
                          onConfirm: () =>
                              _unarchiveCustomMove(context, archived[i].id)),
                    ),
                  ),
                );
        });
  }
}

class _ArchivedItemTile extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final IconData iconData;
  const _ArchivedItemTile(
      {Key? key,
      required this.onTap,
      required this.name,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(name),
            Icon(
              iconData,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}

class _NoContentPlaceholder extends StatelessWidget {
  const _NoContentPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Padding(
            padding: EdgeInsets.all(32),
            child: MyText('No archived items',
                subtext: true, textAlign: TextAlign.center)),
      ],
    );
  }
}
