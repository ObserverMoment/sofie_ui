import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/color_picker.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';

/// Allows the user to CRUD their set of [ProgressJournalGoalTags]
/// Works via a [QueryObserver] and the [GraphQL store] directly to update state.
class ProgressJournalGoalTagsManager extends StatefulWidget {
  /// When accessing this widget during the flow of adding tags to some other object we do not need the user to be able to update / delete all of their tags.
  /// However, if being accessed from their profile or similar (i.e. they want to really manage their tags rather than just add a new tag to something) then this can be set false to give full functionality.
  final bool allowCreateTagOnly;
  const ProgressJournalGoalTagsManager(
      {Key? key, this.allowCreateTagOnly = true})
      : super(key: key);

  @override
  _ProgressJournalGoalTagsManagerState createState() =>
      _ProgressJournalGoalTagsManagerState();
}

class _ProgressJournalGoalTagsManagerState
    extends State<ProgressJournalGoalTagsManager> {
  late TextEditingController _tagNameController;
  Color? _newTagColor;
  bool _isLoading = false;

  final double kNewTagInputHeight = 240;

  @override
  void initState() {
    super.initState();
    _tagNameController = TextEditingController();
    _tagNameController.addListener(() {
      setState(() {});
    });
  }

  void _updateNewTagColor(Color newColor) {
    setState(() => _newTagColor = newColor);
  }

  bool get _canSaveNewTag =>
      _tagNameController.text.length > 2 && _newTagColor != null;

  Future<void> _createNewTag() async {
    setState(() => _isLoading = true);

    final variables = CreateProgressJournalGoalTagArguments(
        data: CreateProgressJournalGoalTagInput(
            tag: _tagNameController.text, hexColor: _newTagColor!.toHex()));

    final result = await context.graphQLStore.create(
        mutation: CreateProgressJournalGoalTagMutation(variables: variables),
        addRefToQueries: [ProgressJournalGoalTagsQuery().operationName]);

    setState(() => _isLoading = false);

    if (result.hasErrors || result.data == null) {
      context.showToast(
          message: 'Sorry, there was a problem creating the tag',
          toastType: ToastType.destructive);
    } else {
      /// When creating only it makes sense to leave as soon as this is done.
      if (widget.allowCreateTagOnly) {
        context.pop();
      } else {
        context.showToast(message: 'New tag created!');
        setState(() {
          _tagNameController.text = '';
          _newTagColor = null;
        });
      }
    }
  }

  Future<void> _updateTag(ProgressJournalGoalTag tag) async {
    setState(() => _isLoading = true);

    final variables = UpdateProgressJournalGoalTagArguments(
        data: UpdateProgressJournalGoalTagInput(
            id: tag.id, tag: tag.tag, hexColor: tag.hexColor));

    final result = await context.graphQLStore.mutate<
            UpdateProgressJournalGoalTag$Mutation,
            UpdateProgressJournalGoalTagArguments>(
        mutation: UpdateProgressJournalGoalTagMutation(variables: variables),
        broadcastQueryIds: [
          ProgressJournalGoalTagsQuery().operationName,
          GQLOpNames.progressJournalByIdQuery,
        ]);

    setState(() => _isLoading = false);

    if (result.hasErrors || result.data == null) {
      context.showToast(
          message: 'Sorry, there was a problem updating the tag',
          toastType: ToastType.destructive);
    } else {
      context.showToast(message: 'Tag updated');
    }
  }

  void _handleTagDelete(ProgressJournalGoalTag tag) {
    context.showConfirmDeleteDialog(
        itemType: 'Goal Tag',
        message: 'This cannot be undone and may affect your journal goals.',
        onConfirm: () => _deleteGoalTag(tag));
  }

  Future<void> _deleteGoalTag(ProgressJournalGoalTag tag) async {
    setState(() => _isLoading = true);

    final variables = DeleteProgressJournalGoalTagByIdArguments(id: tag.id);
    final result = await context.graphQLStore.delete(
        mutation:
            DeleteProgressJournalGoalTagByIdMutation(variables: variables),
        objectId: tag.id,
        typename: kProgressJournalGoalTagTypename,
        removeAllRefsToId: true,
        removeRefFromQueries: [
          ProgressJournalGoalTagsQuery().operationName
        ],
        broadcastQueryIds: [
          UserProgressJournalsQuery().operationName,
          GQLOpNames.progressJournalByIdQuery,
        ]);

    setState(() => _isLoading = false);
    if (result.hasErrors ||
        result.data?.deleteProgressJournalGoalTagById != tag.id) {
      context.showToast(
          message: 'Sorry, there was a problem deleting the tag',
          toastType: ToastType.destructive);
    } else {
      context.showToast(
        message: 'Tag Deleted',
      );
    }
  }

  @override
  void dispose() {
    _tagNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        automaticallyImplyLeading: !_isLoading,
        middle:
            NavBarTitle(widget.allowCreateTagOnly ? 'Create Tag' : 'Goal Tags'),
        trailing: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LoadingDots(
                    size: 12,
                  )
                ],
              )
            : null,
      ),
      child: QueryObserver<ProgressJournalGoalTags$Query,
              json.JsonSerializable>(
          key: Key(
              'ProgressJournalGoalTagsManager - ${ProgressJournalGoalTagsQuery().operationName}'),
          query: ProgressJournalGoalTagsQuery(),
          loadingIndicator: const ShimmerCardList(
            itemCount: 10,
            cardHeight: 80,
          ),
          builder: (data) {
            final tags = data.progressJournalGoalTags;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  MyTextFormFieldRow(
                    backgroundColor: context.theme.cardBackground,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    placeholder: 'Enter new tag',
                    controller: _tagNameController,
                    validationMessage: 'Min 3, max 30 characters',
                    validator: () =>
                        _tagNameController.text.length > 2 &&
                        _tagNameController.text.length < 31,
                  ),
                  GrowInOut(
                    show: _tagNameController.text.length > 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BorderButton(
                            prefix: _newTagColor != null
                                ? CircularBox(
                                    color: _newTagColor,
                                    child: const SizedBox(height: 9, width: 9))
                                : null,
                            text: _newTagColor != null
                                ? 'Change Color'
                                : 'Select Color',
                            onPressed: () async {
                              Utils.hideKeyboard(context);
                              await openColorPickerDialog(
                                  context: context,
                                  onSave: (color) => _updateNewTagColor(color));
                            },
                            loading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GrowInOut(
                      show: _canSaveNewTag,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BorderButton(
                              prefix: const Icon(
                                CupertinoIcons.add,
                                size: 20,
                              ),
                              loading: _isLoading,
                              disabled: !_canSaveNewTag,
                              text: 'Create Tag',
                              onPressed: _createNewTag),
                        ],
                      )),
                  if (!widget.allowCreateTagOnly)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          const HorizontalLine(),
                          _CurrentTagsList(
                            handleTagDelete: _handleTagDelete,
                            updateTag: _updateTag,
                            tags: tags,
                          ),
                        ],
                      ),
                    )
                ],
              ),
            );
          }),
    );
  }
}

class _CurrentTagsList extends StatelessWidget {
  final List<ProgressJournalGoalTag> tags;
  final void Function(ProgressJournalGoalTag tag) handleTagDelete;
  final void Function(ProgressJournalGoalTag updatedTag) updateTag;
  const _CurrentTagsList(
      {required this.tags,
      required this.handleTagDelete,
      required this.updateTag});
  @override
  Widget build(BuildContext context) {
    final sortedTags = tags.reversed.toList();
    return sortedTags.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: MyText(
              'No Tags yet. Create one above.',
              subtext: true,
            ),
          )
        : ImplicitlyAnimatedList<ProgressJournalGoalTag>(
            shrinkWrap: true,
            items: sortedTags,
            itemBuilder: (context, animation, tag, index) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOut,
                animation: animation,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              onPressed: () => context.push(
                                  child: FullScreenTextEditing(
                                      title: 'Update Tag',
                                      initialValue: tag.tag,
                                      onSave: (text) {
                                        tag.tag = text;
                                        updateTag(tag);
                                      },
                                      validationMessage:
                                          'Min 3, max 30 characters',
                                      inputValidation: (t) => t.length > 2)),
                              child: ContentBox(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  child: Row(
                                    children: [
                                      MyText(
                                        tag.tag,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        CupertinoIcons.pencil,
                                        size: 18,
                                      )
                                    ],
                                  ))),
                          CupertinoButton(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            onPressed: () async {
                              Utils.hideKeyboard(context);
                              await openColorPickerDialog(
                                  context: context,
                                  onSave: (color) {
                                    tag.hexColor = color.toHex();
                                    updateTag(tag);
                                  });
                            },
                            child: CircularBox(
                                color: HexColor.fromHex(tag.hexColor),
                                child: const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Icon(
                                    CupertinoIcons.pencil,
                                    size: 18,
                                  ),
                                )),
                          ),
                          TextButton(
                            text: 'Delete',
                            onPressed: () => handleTagDelete(tag),
                            destructive: true,
                            underline: false,
                          )
                        ],
                      ),
                    ),
                    const HorizontalLine()
                  ],
                ),
              );
            },
            areItemsTheSame: (a, b) => a == b);
  }
}
