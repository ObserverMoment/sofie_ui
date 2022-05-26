import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class MyTabBarView extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> pages;
  const MyTabBarView({Key? key, required this.tabs, required this.pages})
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
      color: context.theme.barBackground,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicatorWeight: 3,
              tabs: widget.tabs
                  .mapIndexed((i, t) => Tab(
                      height: 40,
                      child: Text(
                        t,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )))
                  .toList(),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Styles.primaryAccent,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.pages,
            ),
          ),
        ],
      ),
    );
  }
}
