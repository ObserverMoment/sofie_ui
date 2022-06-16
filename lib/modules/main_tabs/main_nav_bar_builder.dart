import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/logo.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar_display.dart';
import 'package:sofie_ui/services/stream.dart';

buildMainNavBar(GlobalKey<material.ScaffoldState> scaffoldKey) => MyNavBar(
      customLeading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Logo(size: 24),
          SizedBox(width: 3),
          LogoText(
            fontSize: 18,
          )
        ],
      ),
      trailing: NavBarTrailingRow(
        children: [
          // const ChatsIconButton(),
          // const NotificationsIconButton(),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const AuthedUserAvatarDisplay(size: 40),
                onPressed: () => scaffoldKey.currentState!.openEndDrawer()),
          )
        ],
      ),
    );
