import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DoWorkoutSectionNav extends StatelessWidget {
  final int activePageIndex;
  final void Function(int pageIndex) goToPage;
  final bool showVideoTab;
  final bool showAudioTab;
  final bool muteAudio;
  final void Function() toggleMuteAudio;
  const DoWorkoutSectionNav({
    Key? key,
    required this.showAudioTab,
    required this.goToPage,
    required this.muteAudio,
    required this.activePageIndex,
    required this.toggleMuteAudio,
    required this.showVideoTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kDoWorkoutWorkoutSectionTopNavHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavItem(
            inactiveIconData: CupertinoIcons.list_bullet,
            activeIconData: CupertinoIcons.list_bullet,
            onTap: () => goToPage(0),
            isActive: activePageIndex == 0,
          ),
          NavItem(
            inactiveIconData: CupertinoIcons.timer,
            activeIconData: CupertinoIcons.timer_fill,
            onTap: () => goToPage(1),
            isActive: activePageIndex == 1,
          ),
          if (showVideoTab)
            NavItem(
              inactiveIconData: CupertinoIcons.tv,
              activeIconData: CupertinoIcons.tv_fill,
              onTap: () => goToPage(2),
              isActive: activePageIndex == 2,
            ),
          if (showAudioTab)
            NavItem(
              inactiveIconData: CupertinoIcons.volume_mute,
              activeIconData: CupertinoIcons.volume_up,
              onTap: toggleMuteAudio,
              isActive: !muteAudio,
            ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData activeIconData;
  final IconData inactiveIconData;
  final bool isActive;
  final void Function() onTap;
  const NavItem(
      {Key? key,
      required this.activeIconData,
      required this.inactiveIconData,
      required this.isActive,
      required this.onTap})
      : super(key: key);

  double get iconSize => 23.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ClipOval(
        child: Container(
          color: context.theme.primary,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            pressedOpacity: 0.9,
            onPressed: onTap,
            child: AnimatedOpacity(
              duration: kStandardAnimationDuration,
              opacity: isActive ? 1 : 0.6,
              child: AnimatedSwitcher(
                  duration: kStandardAnimationDuration,
                  child: isActive
                      ? Icon(
                          activeIconData,
                          size: iconSize,
                          color: context.theme.background,
                        )
                      : Icon(
                          inactiveIconData,
                          size: iconSize,
                          color: context.theme.background.withOpacity(0.8),
                        )),
            ),
          ),
        ),
      ),
    );
  }
}
