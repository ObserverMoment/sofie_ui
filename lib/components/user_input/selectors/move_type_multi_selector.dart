import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class MoveTypeMultiSelector extends StatelessWidget {
  final String name;
  final void Function(List<MoveType> types) updateSelectedTypes;
  final List<MoveType> selectedTypes;
  const MoveTypeMultiSelector({
    Key? key,
    required this.updateSelectedTypes,
    required this.selectedTypes,
    this.name = 'Move Types',
  }) : super(key: key);

  void _handleTap(MoveType type) {
    updateSelectedTypes(selectedTypes.toggleItem<MoveType>(type));
  }

  List<Widget> _buildChildren(List<MoveType> types) {
    return types
        .map((type) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: GestureDetector(
                onTap: () => _handleTap(type),
                child: SelectableBoxExpanded(
                  onPressed: () => _handleTap(type),
                  isSelected: selectedTypes.contains(type),
                  text: type.name,
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<MoveTypes$Query, json.JsonSerializable>(
        key: Key('MoveTypeSelector - ${MoveTypesQuery().operationName}'),
        query: MoveTypesQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyHeaderText(
                      name,
                    ),
                    MyText(
                      selectedTypes.isEmpty
                          ? 'All'
                          : '(${selectedTypes.length})',
                      subtext: true,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ..._buildChildren(data.moveTypes)
            ],
          );
        });
  }
}
