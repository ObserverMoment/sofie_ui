import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator_body.dart';
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator_equipment.dart';
import 'package:sofie_ui/components/creators/custom_move_creator/custom_move_creator_meta.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/move_type_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

/// Updates everything to DB when user saves and closes.
class CustomMoveCreatorPage extends StatefulWidget {
  /// For use when editing.
  final Move? move;
  const CustomMoveCreatorPage({Key? key, this.move}) : super(key: key);
  @override
  State<CustomMoveCreatorPage> createState() => _CustomMoveCreatorPageState();
}

class _CustomMoveCreatorPageState extends State<CustomMoveCreatorPage> {
  int _activeTabIndex = 0;
  late Move? _activeMove;
  bool _formIsDirty = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _activeMove =
        widget.move != null ? Move.fromJson(widget.move!.toJson()) : null;
  }

  Future<void> _updateMoveType(MoveType moveType) async {
    _formIsDirty = true;
    if (_activeMove == null) {
      final newMove = Move()
        ..$$typename = 'Move'
        ..id = 'temp'
        ..name = 'Custom Move'
        ..moveType = moveType
        ..validRepTypes = WorkoutMoveRepType.values
            .where((v) => v != WorkoutMoveRepType.artemisUnknown)
            .toList()
        ..scope = MoveScope.custom;

      setState(() => _activeMove = newMove);
    } else {
      setState(() => _activeMove!.moveType = moveType);
    }
  }

  /// Client only. Updates are sent to the DB when user saves and closes.
  void _updateMove(Map<String, dynamic> data) {
    setState(() {
      _formIsDirty = true;
      _activeMove = Move.fromJson({..._activeMove!.toJson(), ...data});
    });
  }

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  Future<void> _saveAndClose() async {
    setState(() => _loading = true);
    if (widget.move != null) {
      // Update.
      final variables = UpdateMoveArguments(
          data: UpdateMoveInput.fromJson(_activeMove!.toJson()));

      final result = await GraphQLStore.store.mutate(
          mutation: UpdateMoveMutation(variables: variables),
          broadcastQueryIds: [CustomMovesQuery().operationName]);

      if (result.hasErrors) {
        context.showToast(
            message: 'Sorry, it went wrong, changes not saved!',
            toastType: ToastType.destructive);
      } else {
        context.pop(result: true);
      }
    } else {
      // Create.
      final variables = CreateMoveArguments(
          data: CreateMoveInput.fromJson(_activeMove!.toJson()));

      final result = await GraphQLStore.store.create(
          mutation: CreateMoveMutation(variables: variables),
          addRefToQueries: [CustomMovesQuery().operationName]);

      if (result.hasErrors) {
        context.showToast(
            message: 'Sorry, it went wrong, changes not saved!',
            toastType: ToastType.destructive);
      } else {
        context.pop(result: true);
      }
    }

    setState(() => _loading = false);
  }

  Future<void> _handleCancel() async {
    if (_formIsDirty) {
      context.showConfirmDialog(
          title: 'Leave without Saving?',
          onConfirm: () async {
            /// Cleanup any demo video which was uploaded.
            if (_activeMove?.demoVideoUri != null) {
              await UploadcareService().deleteFiles(fileIds: [
                _activeMove!.demoVideoUri!,
                _activeMove!.demoVideoThumbUri!
              ]);
            }

            context.pop();
          });
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(_handleCancel),
          middle: NavBarTitle(widget.move == null ? 'New Move' : 'Edit Move'),
          trailing: _formIsDirty
              ? FadeIn(
                  child: NavBarTertiarySaveButton(
                    _saveAndClose,
                    loading: _loading,
                  ),
                )
              : null),
      child: Column(
        children: [
          UserInputContainer(
            child: TappableRow(
                onTap: () => context.push(
                    child: MoveTypeSelector(
                        moveType: _activeMove?.moveType,
                        updateMoveType: _updateMoveType)),
                title: 'Move Type',
                display: _activeMove?.moveType != null
                    ? MoveTypeTag(_activeMove!.moveType)
                    : null),
          ),
          if (_activeMove?.moveType != null)
            FadeIn(
              child: Container(
                padding: const EdgeInsets.only(top: 8),
                width: double.infinity,
                child: MySlidingSegmentedControl<int>(
                    value: _activeTabIndex,
                    children: const {0: 'Info', 1: 'Equipment', 2: 'Body'},
                    updateValue: _changeTab),
              ),
            ),
          if (_activeMove?.moveType != null)
            Expanded(
              child: FadeIn(
                child: IndexedStack(
                  index: _activeTabIndex,
                  children: [
                    CustomMoveCreatorMeta(
                      move: _activeMove!,
                      updateMove: _updateMove,
                    ),
                    // CustomMoveCreatorEquipment(
                    //   move: _activeMove!,
                    //   updateMove: _updateMove,
                    // ),
                    // CustomMoveCreatorBody(
                    //   move: _activeMove!,
                    //   updateMove: _updateMove,
                    // ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
