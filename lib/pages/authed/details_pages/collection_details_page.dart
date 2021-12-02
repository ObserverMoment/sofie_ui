import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/collections/collection_workout_plans_list.dart';
import 'package:sofie_ui/components/collections/collection_workouts_list.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class CollectionDetailsPage extends StatefulWidget {
  final String id;
  const CollectionDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _CollectionDetailsPageState createState() => _CollectionDetailsPageState();
}

class _CollectionDetailsPageState extends State<CollectionDetailsPage> {
  int _activeTabIndex = 0;

  void _changeTab(int index) {
    setState(() => _activeTabIndex = index);
  }

  void _confirmDeleteCollection(BuildContext context, Collection collection) {
    context.showConfirmDeleteDialog(
        itemType: 'Collection',
        itemName: collection.name,
        message: 'Everything will be removed from this collection. OK?',
        onConfirm: () => _deleteCollectionById(context));
  }

  Future<void> _deleteCollectionById(BuildContext context) async {
    final variables = DeleteCollectionByIdArguments(id: widget.id);

    final result = await context.graphQLStore
        .delete<DeleteCollectionById$Mutation, DeleteCollectionByIdArguments>(
            mutation: DeleteCollectionByIdMutation(variables: variables),
            objectId: widget.id,
            typename: kCollectionTypename,
            removeAllRefsToId: true,
            removeRefFromQueries: [UserCollectionsQuery().operationName]);

    if (result.hasErrors ||
        result.data == null ||
        result.data!.deleteCollectionById != widget.id) {
      context.showErrorAlert(
          'Sorry there was a problem, the collection was not deleted.');
    } else {
      context.pop(); // The CollectionDetailsPage.
    }
  }

  /// Top right of tabs to indicate how many of each type are in the list.
  Widget _buildNumberDisplay(int number) {
    return MyText(
      number.toString(),
      size: FONTSIZE.two,
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = UserCollectionByIdQuery(
        variables: UserCollectionByIdArguments(id: widget.id));

    return QueryObserver<UserCollectionById$Query, UserCollectionByIdArguments>(
        key: Key('CollectionDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final collection = data.userCollectionById;

          final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
          final bool isOwner = collection.user.id == authedUserId;

          /// Remove any archived content from the display;
          final activeWorkouts =
              collection.workouts.where((w) => !w.archived).toList();
          final activeWorkoutPlans =
              collection.workoutPlans.where((wp) => !wp.archived).toList();

          return MyPageScaffold(
            navigationBar: MyNavBar(
              middle: NavBarTitle(collection.name),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.ellipsis),
                onPressed: () => openBottomSheetMenu(
                    context: context,
                    child: BottomSheetMenu(
                        header: BottomSheetMenuHeader(
                          name: collection.name,
                          subtitle: 'Collection',
                        ),
                        items: [
                          if (isOwner)
                            BottomSheetMenuItem(
                                text: 'Edit',
                                icon: const Icon(CupertinoIcons.pencil),
                                onPressed: () => context.pushRoute(
                                    CollectionCreatorRoute(
                                        collection: collection))),
                          if (isOwner)
                            BottomSheetMenuItem(
                                text: 'Delete',
                                icon: const Icon(
                                  CupertinoIcons.delete_simple,
                                  color: Styles.errorRed,
                                ),
                                isDestructive: true,
                                onPressed: () => _confirmDeleteCollection(
                                    context, collection)),
                        ])),
              ),
            ),
            child: Column(
              children: [
                MyTabBarNav(
                    titles: const [
                      'Workouts',
                      'Plans'
                    ],
                    superscriptIcons: [
                      activeWorkouts.isEmpty
                          ? null
                          : _buildNumberDisplay(activeWorkouts.length),
                      activeWorkoutPlans.isEmpty
                          ? null
                          : _buildNumberDisplay(activeWorkoutPlans.length),
                    ],
                    handleTabChange: _changeTab,
                    activeTabIndex: _activeTabIndex),
                const SizedBox(height: 10),
                Expanded(
                  child: IndexedStack(
                    index: _activeTabIndex,
                    children: [
                      FilterableCollectionWorkouts(
                        collection: collection,
                      ),
                      FilterableCollectionWorkoutPlans(
                        collection: collection,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
