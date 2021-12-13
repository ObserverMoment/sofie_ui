import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

enum FilterMenuType { tag, collection }

class TagsCollectionsFilterMenu extends StatelessWidget {
  final FilterMenuType filterMenuType;
  final List<String> allTags;
  final String? selectedTag;
  final void Function(String? tag) updateSelectedTag;
  final Collection? selectedCollection;
  final List<Collection> allCollections;
  final void Function(Collection? collection) updateSelectedCollection;
  const TagsCollectionsFilterMenu(
      {Key? key,
      required this.filterMenuType,
      required this.selectedTag,
      required this.selectedCollection,
      required this.allTags,
      required this.allCollections,
      required this.updateSelectedTag,
      required this.updateSelectedCollection})
      : super(key: key);

  List<PopoverMenuItem> get _buildMenuItems {
    if (filterMenuType == FilterMenuType.tag) {
      return [
        ...allTags
            .map((t) => PopoverMenuItem(
                  onTap: () => updateSelectedTag(t),
                  text: t,
                  isActive: selectedTag == t,
                ))
            .toList(),
        if (selectedTag != null)
          PopoverMenuItem(
            iconData: CupertinoIcons.clear,
            onTap: () => updateSelectedTag(null),
            text: 'Clear Filter',
            isActive: false,
          )
      ];
    } else {
      return [
        ...allCollections
            .map((c) => PopoverMenuItem(
                  onTap: () => updateSelectedCollection(c),
                  text: c.name,
                  isActive: selectedCollection == c,
                ))
            .toList(),
        if (selectedCollection != null)
          PopoverMenuItem(
            iconData: CupertinoIcons.clear,
            onTap: () => updateSelectedCollection(null),
            text: 'Clear Filter',
            isActive: false,
          )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return allTags.isEmpty && allCollections.isEmpty
        ? Container()
        : PopoverMenu(
            button: FABPageButtonContainer(
              child: Row(
                children: [
                  if (filterMenuType == FilterMenuType.tag)
                    AnimatedSwitcher(
                        duration: kStandardAnimationDuration,
                        child: selectedTag == null
                            ? Row(
                                children: const [
                                  MyText('Tags'),
                                  SizedBox(width: 8),
                                  Icon(
                                    CupertinoIcons.tag,
                                    size: 16,
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  MyText(selectedTag!,
                                      weight: FontWeight.bold,
                                      color: Styles.secondaryAccent),
                                ],
                              )),
                  if (filterMenuType == FilterMenuType.collection)
                    AnimatedSwitcher(
                        duration: kStandardAnimationDuration,
                        child: selectedCollection == null
                            ? Row(
                                children: const [
                                  MyText('Collections'),
                                  SizedBox(width: 8),
                                  Icon(
                                    CupertinoIcons.collections,
                                    size: 16,
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  MyText(selectedCollection!.name,
                                      weight: FontWeight.bold,
                                      color: Styles.secondaryAccent),
                                ],
                              )),
                ],
              ),
            ),
            items: _buildMenuItems);
  }
}

/// Same as above but just for tags [List<String>]
class TagsFilterMenu extends StatelessWidget {
  final List<String> allTags;
  final String? selectedTag;
  final void Function(String? tag) updateSelectedTag;
  const TagsFilterMenu({
    Key? key,
    required this.selectedTag,
    required this.allTags,
    required this.updateSelectedTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return allTags.isEmpty
        ? Container()
        : PopoverMenu(
            button: FABPageButtonContainer(
              child: Row(
                children: [
                  AnimatedSwitcher(
                      duration: kStandardAnimationDuration,
                      child: selectedTag == null
                          ? Row(
                              children: const [
                                MyText('Tags'),
                                SizedBox(width: 8),
                                Icon(
                                  CupertinoIcons.tag,
                                  size: 16,
                                )
                              ],
                            )
                          : Row(
                              children: [
                                MyText(selectedTag!,
                                    weight: FontWeight.bold,
                                    color: Styles.secondaryAccent),
                              ],
                            )),
                ],
              ),
            ),
            items: [
                ...allTags
                    .map((t) => PopoverMenuItem(
                          onTap: () => updateSelectedTag(t),
                          text: t,
                          isActive: selectedTag == t,
                        ))
                    .toList(),
                if (selectedTag != null)
                  PopoverMenuItem(
                    iconData: CupertinoIcons.clear,
                    onTap: () => updateSelectedTag(null),
                    isActive: false,
                    text: 'Clear Filter',
                  )
              ]);
  }
}
