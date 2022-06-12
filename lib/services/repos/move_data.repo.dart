import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class MoveDataRepo extends ChangeNotifier {
  /// For displaying lists.
  List<MoveData> standardMoves = [];
  List<MoveData> customMoves = [];

  /// For easy access to full MovaData by ID.
  Map<String, MoveData> standardMovesById = {};
  Map<String, MoveData> customMovesById = {};

  Future<void> initMoveData(BuildContext context) async {
    final result = await GraphQLStore.store
        .networkOnlyOperation(operation: MoveDataQuery());

    checkOperationResult(result,
        onFail: () => throw Exception('Could not load move data!'),
        onSuccess: () {
          final moveData = result.data!.moveData;
          standardMoves = moveData.standardMoves;
          customMoves = moveData.customMoves;

          standardMovesById = standardMoves.fold({}, (acum, next) {
            acum[next.id] = next;
            return acum;
          });

          customMovesById = customMoves.fold({}, (acum, next) {
            acum[next.id] = next;
            return acum;
          });
        });
  }

  MoveData? moveDataById(String id) =>
      standardMovesById[id] ?? customMovesById[id];
}
