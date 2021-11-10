import 'package:collection/collection.dart';
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
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

/// Allows the user to CRUD their set of [UserBenchmarkTags]
/// Works via a [QueryObserver] and the [GraphQL store] directly to update state.
class UserBenchmarkTagsManager extends StatefulWidget {
  /// When accessing this widget during the flow of adding tags to some other object we do not need the user to be able to update / delete all of their tags.
  /// However, if being accessed from their profile or similar (i.e. they want to really manage their tags rather than just add a new tag to something) then this can be set false to give full functionality.
  final bool allowCreateTagOnly;
  const UserBenchmarkTagsManager({Key? key, this.allowCreateTagOnly = true})
      : super(key: key);

  @override
  UserBenchmarkTagsManagerState createState() =>
      UserBenchmarkTagsManagerState();
}

class UserBenchmarkTagsManagerState extends State<UserBenchmarkTagsManager> {
  late TextEditingController _tagNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tagNameController = TextEditingController();
    _tagNameController.addListener(() {
      setState(() {});
    });
  }

  bool get _canSaveNewTag => _tagNameController.text.length > 2;

  Future<void> _createNewTag() async {
    setState(() => _isLoading = true);

    final variables = CreateUserBenchmarkTagArguments(
        data: CreateUserBenchmarkTagInput(name: _tagNameController.text));

    final result = await context.graphQLStore.create(
        mutation: CreateUserBenchmarkTagMutation(variables: variables),
        addRefToQueries: [UserBenchmarkTagsQuery().operationName]);

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
        context.showToast(
            message: 'New tag created!', toastType: ToastType.success);
        setState(() {
          _tagNameController.text = '';
        });
      }
    }
  }

  Future<void> _updateTag(UserBenchmarkTag tag) async {
    setState(() => _isLoading = true);

    final variables = UpdateUserBenchmarkTagArguments(
        data: UpdateUserBenchmarkTagInput(id: tag.id, name: tag.name));

    final result = await context.graphQLStore.mutate(
        mutation: UpdateUserBenchmarkTagMutation(variables: variables),
        broadcastQueryIds: [
          UserBenchmarkTagsQuery().operationName,
          UserBenchmarksQuery().operationName,

          /// TODO:  Is this updating all [userBenchmarkById] queries?
          GQLOpNames.userBenchmarkByIdQuery,
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

  void _handleTagDelete(UserBenchmarkTag tag) {
    context.showConfirmDeleteDialog(
        itemType: 'Personal Best Tag',
        message:
            'This tag will be removed from anything it has been assigned to. OK?',
        onConfirm: () => _deleteUserBenchmarkTag(tag));
  }

  Future<void> _deleteUserBenchmarkTag(UserBenchmarkTag tag) async {
    setState(() => _isLoading = true);

    final variables = DeleteUserBenchmarkTagByIdArguments(id: tag.id);
    final result = await context.graphQLStore.delete(
        mutation: DeleteUserBenchmarkTagByIdMutation(variables: variables),
        objectId: tag.id,
        typename: kUserBenchmarkTagTypename,
        removeAllRefsToId: true,
        removeRefFromQueries: [
          UserBenchmarkTagsQuery().operationName
        ],
        broadcastQueryIds: [
          UserBenchmarksQuery().operationName,
        ]);

    setState(() => _isLoading = false);

    if (result.hasErrors || result.data?.deleteUserBenchmarkTagById != tag.id) {
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
        middle: NavBarTitle(
            widget.allowCreateTagOnly ? 'Create Tag' : 'Personal Best Tags'),
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
      child: QueryObserver<UserBenchmarkTags$Query, json.JsonSerializable>(
          key: Key(
              'UserBenchmarkTagsManager - ${UserBenchmarkTagsQuery().operationName}'),
          query: UserBenchmarkTagsQuery(),
          loadingIndicator: const ShimmerCardList(
            itemCount: 10,
            cardHeight: 80,
          ),
          builder: (data) {
            final tags = data.userBenchmarkTags;

            return Column(
              children: [
                const SizedBox(height: 4),
                MyTextFormFieldRow(
                  backgroundColor: context.theme.cardBackground,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  placeholder: 'Enter new tag',
                  controller: _tagNameController,
                  validationMessage: 'Min 3, max 30 characters',
                  validator: () =>
                      _tagNameController.text.length > 2 &&
                      _tagNameController.text.length < 31,
                ),
                GrowInOut(
                  show: _canSaveNewTag,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BorderButton(
                            prefix: const Icon(
                              CupertinoIcons.add,
                              size: 20,
                            ),
                            loading: _isLoading,
                            text: 'Create Tag',
                            onPressed: _createNewTag),
                      ],
                    ),
                  ),
                ),
                if (!widget.allowCreateTagOnly)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          const HorizontalLine(),
                          Expanded(
                            child: _CurrentTagsList(
                              handleTagDelete: _handleTagDelete,
                              tags: tags,
                              updateTag: _updateTag,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
    );
  }
}

class _CurrentTagsList extends StatelessWidget {
  final List<UserBenchmarkTag> tags;
  final void Function(UserBenchmarkTag tag) handleTagDelete;
  final void Function(UserBenchmarkTag updatedTag) updateTag;
  const _CurrentTagsList(
      {required this.tags,
      required this.handleTagDelete,
      required this.updateTag});
  @override
  Widget build(BuildContext context) {
    final sortedTags = tags.sortedBy<String>((t) => t.name).toList();

    return sortedTags.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: MyText(
              'No Tags yet. Create one above.',
              subtext: true,
            ),
          )
        : ImplicitlyAnimatedList<UserBenchmarkTag>(
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
                          Row(
                            children: [
                              CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  onPressed: () => context.push(
                                      child: FullScreenTextEditing(
                                          title: 'Update Tag',
                                          initialValue: tag.name,
                                          onSave: (text) {
                                            tag.name = text;
                                            updateTag(tag);
                                          },
                                          validationMessage:
                                              'Min 3, max 30 characters',
                                          inputValidation: (t) =>
                                              t.length > 2)),
                                  child: ContentBox(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MyText(
                                            tag.name,
                                            weight: FontWeight.bold,
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            CupertinoIcons.pencil,
                                            size: 18,
                                          )
                                        ],
                                      ))),
                            ],
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
