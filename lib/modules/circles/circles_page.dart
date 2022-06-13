import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/components/my_tab_bar_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/modules/circles/your_circles.dart';
import 'package:sofie_ui/modules/main_tabs/main_nav_bar_builder.dart';
import 'package:sofie_ui/modules/main_tabs/profile_settings_drawer.dart';

class CirclesPage extends StatefulWidget {
  const CirclesPage({Key? key}) : super(key: key);

  @override
  State<CirclesPage> createState() => _CirclesPageState();
}

class _CirclesPageState extends State<CirclesPage> {
  final GlobalKey<material.ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      key: _key,
      appBar: buildMainNavBar(_key),
      endDrawer: const ProfileSettingsDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: MyTabBarView(
          tabs: const ['Your Circles', 'Discover'],
          pages: const [YourCircles(), MyText('Discover Circles')],
        ),
      ),
    );
  }
}
