import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
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
  final Gradient? gradient;
  final bool border;
  final EdgeInsets? padding;
  const CircularBox(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.all(6),
      this.color,
      this.border = false,
      this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          color: color,
          gradient: gradient,
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
                  NavBarLargeTitle(title),
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
                          child: LoadingIndicator(
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
          padding: const EdgeInsets.only(left: 4, top: 8, right: 4),
          child: child,
        ));
  }
}

class MySliverNavbar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const MySliverNavbar({Key? key, required this.title, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
        leading: const NavBarBackButton(),
        largeTitle: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.87),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        trailing: trailing,
        border: null);
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
                      NavBarLoadingIndicator(),
                    ],
                  ),
                )
              : save != null && validToSave
                  ? FadeIn(child: NavBarTertiarySaveButton(save!))
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
