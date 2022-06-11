import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class MoveDataRepo extends ChangeNotifier {
  List<Move> standardMoves = [];
  List<Move> customMoves = [];

  Future<void> initMoveData(BuildContext context) async {
    final result = await GraphQLStore.store
        .networkOnlyOperation(operation: MoveDataQuery());

    checkOperationResult(result,
        onFail: () => throw Exception('Could not load move data!'),
        onSuccess: () {
          final moveData = result.data!.moveData;
          standardMoves = moveData.standardMoves;
          customMoves = moveData.customMoves;
        });
  }

  Move moveById(String id) => [...standardMoves, ...customMoves].firstWhere(
        (m) => id == m.id,
      );
}
