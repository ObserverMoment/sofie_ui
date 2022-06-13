import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class MyTabBarView extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> pages;
  final Widget? leading;
  final Alignment alignment;
  const MyTabBarView(
      {Key? key,
      required this.tabs,
      required this.pages,
      this.leading,
      this.alignment = Alignment.centerLeft})
      : assert(tabs.length == pages.length,
            '[must supply the same number of tabs and pages]'),
        super(key: key);

  @override
  State<MyTabBarView> createState() => _MyTabBarViewState();
}

class _MyTabBarViewState extends State<MyTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.background,
      child: Column(
        children: [
          Container(
            height: 46,
            alignment: widget.alignment,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                if (widget.leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: widget.leading!,
                  ),
                ...widget.tabs
                    .mapIndexed((i, t) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SelectableTag(
                            isSelected: _tabController.index == i,
                            onPressed: () => _tabController.animateTo(i),
                            text: widget.tabs[i],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          const HorizontalLine(
            verticalPadding: 8,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.pages,
            ),
          ),
        ],
      ),
    );
  }
}
