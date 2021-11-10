import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Box with rounded corners. No elevation. Card background color.
class ContentBox extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  const ContentBox(
      {Key? key,
      required this.child,
      this.backgroundColor,
      this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      this.borderRadius = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: backgroundColor ?? context.theme.cardBackground,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: child,
    );
  }
}

/// Clipping box with rounded corners. No elevation.
class RoundedBox extends StatelessWidget {
  final Widget child;
  final bool border;
  final Color? color;
  final EdgeInsets margin;
  final EdgeInsets padding;
  const RoundedBox(
      {Key? key,
      required this.child,
      this.border = false,
      this.color,
      this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: border ? Border.all(color: context.theme.primary) : null),
      child: child,
    );
  }
}

/// Box with rounded corners. No elevation.
class CircularBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool border;
  final EdgeInsets? padding;
  const CircularBox(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.all(6),
      this.color,
      this.border = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border ? Border.all(color: context.theme.primary) : null),
      child: child,
    );
  }
}

/// Handles padding and adds a faint line separator on the bottom of the container.
class UserInputContainer extends StatelessWidget {
  final Widget child;
  const UserInputContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: context.theme.cardBackground))),
      child: child,
    );
  }
}

class HorizontalLine extends StatelessWidget {
  final double thickness;
  final Color? color;
  final double verticalPadding;
  const HorizontalLine(
      {Key? key, this.thickness = 1, this.color, this.verticalPadding = 4.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        children: [
          Expanded(
            child: Container(
                height: thickness,
                color: color ?? context.theme.primary.withOpacity(0.15)),
          ),
        ],
      ),
    );
  }
}

/// A stack which expands to fill available space with a floating action button in the bottom right.
/// Receives a single child and specs for the button.
/// At least one of [buttonIcon] and [buttonText] must not be null.
class StackAndFloatingButton extends StatelessWidget {
  final Widget child;
  final bool pageHasBottomNavBar;
  final IconData buttonIconData;
  final String buttonText;
  final void Function() onPressed;
  final EdgeInsets? buttonInternalPadding;
  final bool loading;
  const StackAndFloatingButton(
      {Key? key,
      required this.child,
      this.pageHasBottomNavBar = true,
      this.buttonIconData = CupertinoIcons.plus,
      required this.onPressed,
      required this.buttonText,
      this.buttonInternalPadding,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
            bottom:
                pageHasBottomNavBar ? EnvironmentConfig.bottomNavBarHeight : 12,
            child: FloatingIconButton(
                text: buttonText,
                iconData: buttonIconData,
                onPressed: onPressed,
                padding: buttonInternalPadding,
                loading: loading))
      ],
    );
  }
}

/// Extends CupertinoNavigationBar with some defaults and extra options.
// For use on pages where user is either creating or editing an object.
class CreateEditPageNavBar extends CupertinoNavigationBar {
  final String title;
  final bool formIsDirty;
  final Function()? handleUndo;
  final Function() handleSave;
  final String saveText;
  final Function() handleClose;
  final bool inputValid;
  final bool loading;
  CreateEditPageNavBar(
      {Key? key,
      required this.title,
      required this.formIsDirty,
      this.saveText = 'Save',
      this.handleUndo,
      required this.handleSave,
      required this.handleClose,
      required this.inputValid,
      this.loading = false})
      : super(
          key: key,
          border: null,
          automaticallyImplyLeading: false,
          middle: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  NavBarTitle(title),
                ],
              )),
          trailing: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: loading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: LoadingDots(
                            size: 12,
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (formIsDirty && handleUndo != null)
                          FadeIn(
                            child: TextButton(
                                destructive: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                text: 'Undo all',
                                underline: false,
                                onPressed: handleUndo),
                          ),
                        if (inputValid)
                          FadeIn(
                            child: TextButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                underline: false,
                                text: saveText,
                                onPressed: handleSave),
                          ),
                        if (!formIsDirty)
                          TextButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              underline: false,
                              text: 'Close',
                              onPressed: handleClose),
                      ],
                    )),
        );
}

class MyPageScaffold extends StatelessWidget {
  final CupertinoNavigationBar? navigationBar;
  final Widget child;
  const MyPageScaffold({Key? key, this.navigationBar, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: navigationBar,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ));
  }
}

class MyNavBar extends CupertinoNavigationBar {
  @override
  final Key? key;
  @override
  final bool automaticallyImplyLeading;
  final Widget? customLeading;
  @override
  final Widget? middle;
  @override
  final Widget? trailing;
  @override
  final Color? backgroundColor;
  final bool withoutLeading;
  const MyNavBar({
    this.key,
    this.automaticallyImplyLeading = false,
    this.customLeading,
    this.middle,
    this.trailing,
    this.backgroundColor,
    this.withoutLeading = false,
  }) : super(
          key: key,
          border: null,
          automaticallyImplyLeading: automaticallyImplyLeading,
          leading:
              withoutLeading ? null : customLeading ?? const NavBarBackButton(),
        );
}

class NavBarBackButton extends StatelessWidget {
  final Alignment alignment;
  const NavBarBackButton({
    Key? key,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      alignment: alignment,
      onPressed: () {
        Navigator.maybePop(context);
      },
      child: Icon(
        CupertinoIcons.arrow_left,
        size: 22,
        color: context.theme.primary,
      ),
    );
  }
}

class NavBarBackButtonStandalone extends StatelessWidget {
  final VoidCallback onPressed;
  final Alignment alignment;
  const NavBarBackButtonStandalone({
    Key? key,
    this.alignment = Alignment.centerLeft,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      alignment: alignment,
      onPressed: onPressed,
      child: Icon(
        CupertinoIcons.arrow_left,
        size: 22,
        color: context.theme.primary,
      ),
    );
  }
}

class NavBarTrailingRow extends StatelessWidget {
  final List<Widget> children;
  const NavBarTrailingRow({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: children,
    );
  }
}

class ModalPageScaffold extends StatelessWidget {
  /// Used for both the nav bar and the main modal.
  final Widget child;
  final String title;
  final void Function()? cancel;
  final void Function()? save;
  final bool validToSave;
  final bool loading;
  final bool resizeToAvoidBottomInset;
  const ModalPageScaffold(
      {Key? key,
      required this.child,
      required this.title,
      this.cancel,
      this.save,
      this.loading = false,
      this.validToSave = false,
      this.resizeToAvoidBottomInset = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: context.theme.modalBackground,
        navigationBar: MyNavBar(
          customLeading: cancel != null ? NavBarCancelButton(cancel!) : null,
          backgroundColor: context.theme.modalBackground,
          middle: NavBarTitle(title),
          trailing: loading
              ? const FadeIn(
                  child: NavBarTrailingRow(
                    children: [
                      NavBarLoadingDots(),
                    ],
                  ),
                )
              : save != null && validToSave
                  ? FadeIn(child: NavBarSaveButton(save!))
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 12),
          child: child,
        ),
      ),
    );
  }
}

/// Use for dialog popups built via [showCupertinoDialog]
class DialogContainer extends StatelessWidget {
  final Widget child;
  const DialogContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ContentBox(
            backgroundColor: context.theme.modalBackground,
            child: child,
          ),
        ],
      ),
    );
  }
}
