import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/tag_managers/user_benchmark_tags_manager.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class UserBenchmarkTagsSelectorRow extends StatelessWidget {
  final List<UserBenchmarkTag> selectedTags;
  final void Function(List<UserBenchmarkTag> tags) updateTags;
  final int? max;
  const UserBenchmarkTagsSelectorRow(
      {Key? key,
      required this.selectedTags,
      required this.updateTags,
      this.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInputContainer(
        child: CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPressed: () => context.push(
          child: UserBenchmarkTagsSelector(
        selectedTags: selectedTags,
        updateTags: updateTags,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  MyText(
                    'Tags',
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Icon(
                    CupertinoIcons.tag,
                    size: 18,
                  ),
                ],
              ),
              Row(
                children: [
                  MyText(
                    selectedTags.isEmpty ? 'Add' : 'Edit',
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    selectedTags.isEmpty
                        ? CupertinoIcons.add
                        : CupertinoIcons.pencil,
                    size: 18,
                  )
                ],
              )
            ],
          ),
          GrowInOut(
              show: selectedTags.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 2),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 4,
                  runSpacing: 4,
                  children: selectedTags.map((g) => Tag(tag: g.name)).toList(),
                ),
              ))
        ],
      ),
    ));
  }
}

/// Also lets you create a new tag and then select it via tag manager.
class UserBenchmarkTagsSelector extends StatefulWidget {
  final List<UserBenchmarkTag> selectedTags;
  final void Function(List<UserBenchmarkTag> updated) updateTags;
  const UserBenchmarkTagsSelector(
      {Key? key, required this.selectedTags, required this.updateTags})
      : super(key: key);

  @override
  _UserBenchmarkTagsSelectorState createState() =>
      _UserBenchmarkTagsSelectorState();
}

class _UserBenchmarkTagsSelectorState extends State<UserBenchmarkTagsSelector> {
  List<UserBenchmarkTag> _activeSelectedUserBenchmarkTags = [];

  @override
  void initState() {
    super.initState();
    _activeSelectedUserBenchmarkTags = [...widget.selectedTags];
  }

  void _updateSelected(UserBenchmarkTag tapped) {
    setState(() {
      _activeSelectedUserBenchmarkTags =
          _activeSelectedUserBenchmarkTags.toggleItem<UserBenchmarkTag>(tapped);
    });
    widget.updateTags(_activeSelectedUserBenchmarkTags);
  }

  void _openCreateNewTag() {
    context.push(child: const UserBenchmarkTagsManager());
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const MyText(
                'Done',
                weight: FontWeight.bold,
              ),
              onPressed: () => Navigator.pop(context)),
          middle: const NavBarTitle('Personal Best - Tags'),
        ),
        child: QueryObserver<UserBenchmarkTags$Query, json.JsonSerializable>(
            key: Key(
                'UserBenchmarkTagsSelector - ${UserBenchmarkTagsQuery().operationName}'),
            query: UserBenchmarkTagsQuery(),
            fetchPolicy: QueryFetchPolicy.storeFirst,
            builder: (data) {
              final userBenchmarkTags =
                  data.userBenchmarkTags.reversed.toList();
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (userBenchmarkTags.isEmpty)
                          const MyText('No tags created yet...')
                        else
                          const MyText(
                            'Click to select / deselect.',
                            size: FONTSIZE.two,
                          ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: userBenchmarkTags
                              .map((tag) => GestureDetector(
                                    onTap: () => _updateSelected(tag),
                                    child: FadeIn(
                                      child: _SelectableUserBenchmarkTag(
                                        tag: tag,
                                        isSelected:
                                            _activeSelectedUserBenchmarkTags
                                                .contains(tag),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        CreateTextIconButton(
                            text: 'New Tag', onPressed: _openCreateNewTag),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}

class _SelectableUserBenchmarkTag extends StatelessWidget {
  final UserBenchmarkTag tag;
  final bool isSelected;
  const _SelectableUserBenchmarkTag(
      {required this.tag, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? Styles.primaryAccent : null,
          border: Border.all(
              width: 2,
              color: isSelected
                  ? Styles.primaryAccent
                  : context.theme.primary.withOpacity(0.65))),
      child: MyText(
        tag.name,
        color: isSelected ? Styles.white : null,
      ),
    );
  }
}
