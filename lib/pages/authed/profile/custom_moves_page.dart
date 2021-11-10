import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/cards/move_list_item.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ProfileCustomMovesPage extends StatelessWidget {
  const ProfileCustomMovesPage({Key? key}) : super(key: key);

  Future<void> _openCustomMoveCreator(
      {required BuildContext context, Move? moveToUpdate}) async {
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

  Future<void> _archiveCustomMove(BuildContext context, String id) async {
    final result = await context.graphQLStore
        .mutate<ArchiveCustomMoveById$Mutation, ArchiveCustomMoveByIdArguments>(
      mutation: ArchiveCustomMoveByIdMutation(
          variables: ArchiveCustomMoveByIdArguments(id: id)),
      addRefToQueries: [GQLOpNames.userArchivedCustomMovesQuery],
      removeRefFromQueries: [GQLOpNames.userCustomMovesQuery],
    );

    await checkOperationResult(context, result,
        onSuccess: () => context.showToast(message: 'Custom move archived'),
        onFail: () => context.showErrorAlert(
            'Something went wrong, the move was not archived correctly'));
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserCustomMoves$Query, json.JsonSerializable>(
        key: Key(
            'ProfileCustomMovesPage - ${UserCustomMovesQuery().operationName}'),
        query: UserCustomMovesQuery(),
        loadingIndicator: const ShimmerCardList(
          itemCount: 20,
          cardHeight: 80,
        ),
        builder: (customMovesData) {
          final customMoves = customMovesData.userCustomMoves
              .sortedBy<String>((move) => move.name);

          return StackAndFloatingButton(
            buttonText: 'Add Move',
            onPressed: () => _openCustomMoveCreator(context: context),
            child: customMoves.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: ListAvoidFAB(
                      itemCount: customMoves.length,
                      itemBuilder: (c, i) => GestureDetector(
                          onTap: () => _openCustomMoveCreator(
                              context: context, moveToUpdate: customMoves[i]),
                          child: AnimatedSlidable(
                            index: i,
                            itemType: 'Custom Move',
                            itemName: customMoves[i].name,
                            key: Key('${customMoves[i].id} - $i'),
                            removeItem: (_) =>
                                _archiveCustomMove(context, customMoves[i].id),
                            secondaryActions: const [],
                            verb: 'Archive',
                            iconData: CupertinoIcons.archivebox,
                            child: MoveListItem(
                              move: customMoves[i],
                            ),
                          )),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: MyText(
                      'No custom moves yet...',
                      textAlign: TextAlign.center,
                    ),
                  ),
          );
        });
  }
}
