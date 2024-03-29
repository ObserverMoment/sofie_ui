import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

const kStandardButtonBorderRadius = 30.0;

/// Base button class on which all other buttons are derived
class MyButton extends StatelessWidget {
  final Widget? prefix;
  final String text;
  final Widget? suffix;
  final void Function() onPressed;
  final Color contentColor;
  final Gradient? backgroundGradient;
  final Color? backgroundColor;
  final bool border;
  final bool disabled;
  final bool loading;
  final bool withMinWidth;
  final double height;

  const MyButton({
    Key? key,
    this.prefix,
    required this.onPressed,
    required this.text,
    this.suffix,
    required this.contentColor,
    this.backgroundColor,
    this.border = false,
    this.disabled = false,
    this.withMinWidth = true,
    this.loading = false,
    this.backgroundGradient,
    this.height = 54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: disabled ? 0.2 : 1,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: disabled
            ? null
            : () {
                Vibrate.feedback(FeedbackType.light);
                onPressed();
              },
        pressedOpacity: 0.9,
        child: Container(
          height: height,
          constraints:
              withMinWidth ? const BoxConstraints(minWidth: 300) : null,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
              gradient: backgroundGradient,
              border: border ? Border.all(color: contentColor, width: 2) : null,
              color: backgroundColor,
              borderRadius: BorderRadius.circular(kStandardButtonBorderRadius)),
          child: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: loading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingIndicator(color: contentColor, size: 10),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (prefix != null) prefix!,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyText(
                          text.toUpperCase(),
                          color: contentColor,
                          lineHeight: 1,
                        ),
                      ),
                      if (suffix != null) suffix!
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final IconData? prefixIconData;
  final String text;
  final IconData? suffixIconData;
  final void Function() onPressed;
  final bool disabled;
  final bool loading;
  final bool withMinWidth;

  const PrimaryButton(
      {Key? key,
      this.prefixIconData,
      required this.text,
      this.suffixIconData,
      required this.onPressed,
      this.disabled = false,
      this.withMinWidth = true,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyButton(
      text: text,
      onPressed: onPressed,
      prefix: prefixIconData != null
          ? Icon(
              prefixIconData,
              color: Styles.white,
              size: 20,
            )
          : null,
      suffix: suffixIconData != null
          ? Icon(suffixIconData, color: Styles.white, size: 20)
          : null,
      disabled: disabled,
      loading: loading,
      backgroundGradient: Styles.primaryAccentGradient,
      contentColor: Styles.white,
      withMinWidth: withMinWidth,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final IconData? prefixIconData;
  final String text;
  final IconData? suffixIconData;
  final void Function() onPressed;
  final bool loading;
  final bool withMinWidth;
  final bool disabled;
  final EdgeInsets? padding;

  const SecondaryButton(
      {Key? key,
      this.prefixIconData,
      required this.text,
      this.suffixIconData,
      required this.onPressed,
      this.withMinWidth = true,
      this.loading = false,
      this.disabled = false,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyButton(
      prefix: prefixIconData != null
          ? Icon(
              prefixIconData,
              color: Styles.white,
              size: 20,
            )
          : null,
      suffix: suffixIconData != null
          ? Icon(suffixIconData, color: Styles.white, size: 20)
          : null,
      text: text,
      disabled: disabled,
      onPressed: onPressed,
      // backgroundGradient: Styles.secondaryButtonGradient,
      contentColor: Styles.white,
      withMinWidth: withMinWidth,
      border: true,
    );
  }
}

/// Smaller rounded corners button.
class TertiaryButton extends StatelessWidget {
  final IconData? prefixIconData;
  final String text;
  final IconData? suffixIconData;
  final void Function() onPressed;
  final bool disabled;
  final EdgeInsets padding;
  final Color? textColor;
  final FONTSIZE fontSize;
  final FontWeight fontWeight;
  final double iconSize;
  final Color? backgroundColor;

  /// [backgroundGradient] will override [backgroundColor].
  final Gradient? backgroundGradient;

  const TertiaryButton(
      {Key? key,
      this.prefixIconData,
      required this.text,
      this.suffixIconData,
      required this.onPressed,
      this.disabled = false,
      this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      this.textColor,
      this.backgroundColor,
      this.fontSize = FONTSIZE.two,
      this.backgroundGradient,
      this.iconSize = 16,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: disabled ? 0.2 : 1,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: disabled ? null : onPressed,
        pressedOpacity: 0.9,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
              gradient: backgroundGradient,
              color: backgroundGradient != null
                  ? null
                  : backgroundColor ?? context.theme.cardBackground,
              borderRadius: BorderRadius.circular(kStandardButtonBorderRadius)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIconData != null)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2),
                  child: Icon(
                    prefixIconData,
                    color: textColor,
                    size: iconSize,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: MyText(
                  text.toUpperCase(),
                  color: textColor,
                  size: fontSize,
                  lineHeight: 1,
                  weight: fontWeight,
                ),
              ),
              if (suffixIconData != null)
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Icon(
                    suffixIconData,
                    color: textColor,
                    size: iconSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  final Widget? prefix;
  final String? text;
  final void Function() onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final bool withBorder;
  final bool mini;
  final bool loading;
  final bool disabled;
  const BorderButton(
      {Key? key,
      this.prefix,
      this.text,
      required this.onPressed,
      this.withBorder = true,
      this.loading = false,
      this.disabled = false,
      this.mini = false,
      this.textColor,
      this.backgroundColor})
      : assert(prefix != null || text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(4),
      pressedOpacity: 0.8,
      onPressed: disabled ? null : onPressed,
      child: AnimatedOpacity(
        opacity: disabled ? 0 : 1,
        duration: const Duration(milliseconds: 250),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(kStandardButtonBorderRadius),
              border: withBorder
                  ? Border.all(
                      color: backgroundColor != null
                          ? backgroundColor!.withOpacity(0.5)
                          : context.theme.primary.withOpacity(0.5))
                  : null),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: loading ? 0 : 1,
                duration: kStandardAnimationDuration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefix != null) prefix!,
                    if (text != null && prefix != null)
                      SizedBox(width: mini ? 6 : 8),
                    if (text != null)
                      MyText(
                        text!.toUpperCase(),
                        color: textColor,
                      )
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: loading ? 1 : 0,
                duration: kStandardAnimationDuration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [LoadingIndicator(size: 10)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestructiveButton extends StatelessWidget {
  final IconData? prefixIconData;
  final String text;
  final IconData? suffixIconData;
  final void Function() onPressed;
  final bool loading;
  final bool withMinWidth;

  const DestructiveButton(
      {Key? key,
      this.prefixIconData,
      required this.text,
      this.suffixIconData,
      required this.onPressed,
      this.withMinWidth = true,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyButton(
      prefix: prefixIconData != null
          ? Icon(
              prefixIconData,
              color: Styles.white,
              size: 20,
            )
          : null,
      text: text,
      suffix: suffixIconData != null
          ? Icon(
              prefixIconData,
              color: Styles.white,
              size: 20,
            )
          : null,
      loading: loading,
      onPressed: onPressed,
      backgroundColor: Styles.errorRed,
      contentColor: Styles.white,
      withMinWidth: withMinWidth,
    );
  }
}

class FloatingActionButtonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const FloatingActionButtonContainer(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
          boxShadow: kElevation[6],
          gradient: Styles.primaryAccentGradient,
          borderRadius: BorderRadius.circular(60)),
      child: child,
    );
  }
}

class SortFilterSearchFloatingButton extends StatelessWidget {
  final bool showFilter;
  final void Function()? onFilterPress;
  final bool showSort;
  final void Function()? onSortPress;
  final bool showSearch;
  final void Function()? onSearchPress;
  const SortFilterSearchFloatingButton(
      {Key? key,
      this.showFilter = true,
      this.onFilterPress,
      this.showSort = true,
      this.onSortPress,
      this.showSearch = true,
      this.onSearchPress})
      : assert((showFilter && onFilterPress != null) || !showFilter),
        assert((showSort && onSortPress != null) || !showSort),
        assert((showSearch && onSearchPress != null) || !showSearch),
        assert(showFilter || showSort || showSearch),
        super(key: key);

  EdgeInsets get kButtonPadding => const EdgeInsets.symmetric(horizontal: 16);

  List<Widget> _buttonsList() {
    final List<Widget> buttons = [];
    if (showFilter) {
      buttons.add(CupertinoButton(
          padding: kButtonPadding,
          onPressed: onFilterPress,
          child: const Icon(
            CupertinoIcons.slider_horizontal_3,
          )));
    }
    if (showSort) {
      buttons.add(CupertinoButton(
          padding: kButtonPadding,
          onPressed: onSortPress,
          child: const Icon(
            CupertinoIcons.arrow_up_arrow_down,
          )));
    }
    if (showSearch) {
      buttons.add(CupertinoButton(
          padding: kButtonPadding,
          onPressed: onSearchPress,
          child: const Icon(
            CupertinoIcons.search,
          )));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final buttons = _buttonsList();
    return FloatingActionButtonContainer(
        child: SizedBox(
      height: 40,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (c, i) => buttons[i],
          separatorBuilder: (c, i) => const ButtonSeparator(),
          itemCount: buttons.length),
    ));
  }
}

/// Like a secondary button but just an icon.
class IconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? iconColor;
  final double size;
  final EdgeInsetsGeometry padding;

  const IconButton(
      {Key? key,
      required this.iconData,
      required this.onPressed,
      this.disabled = false,
      this.size = 28,
      this.iconColor,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: disabled ? 0.2 : 1,
      child: CupertinoButton(
        padding: padding,
        pressedOpacity: 0.9,
        onPressed: disabled ? null : onPressed,
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              iconData,
              size: size,
              color: iconColor,
            )),
      ),
    );
  }
}

/// Clickable row which spans the width of parent
/// With title on left and right chevron on right.
class PageLink extends StatelessWidget {
  final void Function() onPress;
  final String linkText;
  final IconData? icon;
  final bool infoHighlight;
  final bool destructiveHighlight;
  final bool separator;
  final bool loading;
  final bool bold;

  const PageLink(
      {Key? key,
      required this.linkText,
      required this.onPress,
      this.icon,
      this.infoHighlight = false,
      this.destructiveHighlight = false,
      this.loading = false,
      this.bold = false,
      this.separator = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onPress,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 12, left: 8, bottom: 8, right: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(icon, size: 18),
                        ),
                      MyText(
                        linkText,
                        color: infoHighlight
                            ? Styles.infoBlue
                            : destructiveHighlight
                                ? Styles.errorRed
                                : null,
                        lineHeight: 1,
                        weight: bold ? FontWeight.bold : FontWeight.normal,
                      ),
                      if (loading)
                        const FadeIn(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: LoadingIndicator(
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Icon(CupertinoIcons.right_chevron, size: 18),
                ],
              ),
              if (separator)
                const Padding(
                  padding: EdgeInsets.only(left: 30.0, top: 8),
                  child: Opacity(opacity: 0.4, child: HorizontalLine()),
                )
            ],
          )),
    );
  }
}

class TextButton extends StatelessWidget {
  final String text;
  final bool destructive;
  final Widget? prefix;
  final Widget? suffix;
  final bool confirm;
  final void Function() onPressed;
  final bool loading;
  final EdgeInsets? padding;
  final bool? underline;
  final FONTSIZE fontSize;
  final Color? color;

  const TextButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.prefix,
      this.suffix,
      this.destructive = false,
      this.confirm = false,
      this.loading = false,
      this.padding,
      this.color,
      this.fontSize = FONTSIZE.three,
      this.underline = false})
      : assert(!(confirm && destructive)),
        super(key: key);

  Color? get _textolor {
    if (color != null) {
      return color!;
    }
    if (confirm) {
      return Styles.infoBlue;
    }
    if (destructive) {
      return Styles.errorRed;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: padding,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: loading
            ? const LoadingIndicator(size: 10)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefix != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: prefix,
                    ),
                  MyText(text,
                      size: fontSize,
                      weight: FontWeight.bold,
                      decoration: underline! ? TextDecoration.underline : null,
                      color: _textolor),
                  if (suffix != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: suffix,
                    ),
                ],
              ),
      ),
    );
  }
}

/// Vertical line used for separating buttons in a multi button widget. E.g floating button.
class ButtonSeparator extends StatelessWidget {
  final Color? color;
  const ButtonSeparator({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 30,
        width: 1,
        color: color ?? context.theme.primary.withOpacity(0.3),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final void Function() onPressed;
  final bool hasActiveFilters;
  const FilterButton(
      {Key? key, required this.onPressed, this.hasActiveFilters = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: const Icon(
            material.Icons.filter_alt_rounded,
            size: kMiniButtonIconSize,
          ),
        ),
        if (hasActiveFilters)
          const Positioned(
            top: -1,
            right: 0,
            child: Icon(
              CupertinoIcons.checkmark_alt_circle_fill,
              color: Styles.primaryAccent,
              size: 16,
            ),
          )
      ],
    );
  }
}

/// Create button with no background or border.
class CreateTextIconButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool loading;
  const CreateTextIconButton(
      {Key? key,
      required this.onPressed,
      this.text = 'Create',
      this.loading = false})
      : super(key: key);

  List<Widget> _buildChildren() {
    return loading
        ? [
            const LoadingIndicator(size: 10),
          ]
        : [
            const Icon(
              CupertinoIcons.add,
              size: 22,
            ),
            const SizedBox(width: 2),
            MyText(
              text.toUpperCase(),
              weight: FontWeight.bold,
            )
          ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: loading ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildChildren(),
      ),
    );
  }
}

/// Has no padding which allows it to act as 'Leading' / 'trailing' widget in the nav bar.
class NavBarCancelButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color? color;
  final FontWeight weight;
  const NavBarCancelButton(this.onPressed,
      {Key? key,
      this.text = 'Cancel',
      this.color,
      this.weight = FontWeight.normal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: MyText(
          text,
          color: color,
          weight: weight,
        ));
  }
}

/// Has no padding which allows it to act as 'Leading' / 'trailing' widget in the nav bar.
class NavBarChevronDownButton extends StatelessWidget {
  final void Function() onPressed;
  const NavBarChevronDownButton(this.onPressed, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: const Icon(CupertinoIcons.chevron_down));
  }
}

/// Has no padding which allows it to act as 'Leading' / 'trailing' widget in the nav bar.
class NavBarTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final FontWeight fontWeight;
  const NavBarTextButton(this.onPressed, this.text,
      {Key? key, this.fontWeight = FontWeight.normal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: MyText(
          text,
          weight: fontWeight,
        ));
  }
}

/// Has no padding which allows it to act as 'Leading' / 'trailing' widget in the nav bar.
class NavBarSaveButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool loading;
  const NavBarSaveButton(this.onPressed,
      {Key? key, this.text = 'Save', this.loading = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: loading ? null : onPressed,
            child: loading
                ? const LoadingIndicator(
                    size: 10,
                  )
                : MyText(
                    text,
                  )),
      ],
    );
  }
}

class NavBarTertiarySaveButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool loading;
  const NavBarTertiarySaveButton(
    this.onPressed, {
    Key? key,
    this.text = 'Save',
    this.loading = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kStandardAnimationDuration,
      child: loading
          ? const CupertinoActivityIndicator(radius: 9)
          : TertiaryButton(
              backgroundColor: Styles.primaryAccent,
              textColor: Styles.white,
              onPressed: onPressed,
              text: text,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            ),
    );
  }
}

/// Icon buttons
class InfoPopupButton extends StatelessWidget {
  final String pageTitle;
  final Widget infoWidget;

  /// Defaults to displaying a nav bar but can be removed if the info widget being displayed already has one.
  final bool withoutNavBar;
  const InfoPopupButton(
      {Key? key,
      required this.infoWidget,
      this.pageTitle = 'Info',
      this.withoutNavBar = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push(
          rootNavigator: true,
          fullscreenDialog: true,
          child: CupertinoPageScaffold(
            navigationBar: withoutNavBar
                ? null
                : MyNavBar(
                    customLeading: NavBarChevronDownButton(
                        () => context.pop(rootNavigator: true)),
                    middle: NavBarTitle(pageTitle)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [infoWidget],
                ),
              ),
            ),
          )),
      child: const Icon(CupertinoIcons.info),
    );
  }
}

/// Shows a notes icon and opens the note up full screen onpress.
class NoteIconViewerButton extends StatelessWidget {
  final String note;
  final String modalTitle;
  final bool useRootNavigator;
  const NoteIconViewerButton(this.note,
      {Key? key, this.modalTitle = 'Note', this.useRootNavigator = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: const NotesIcon(),
        onPressed: () =>
            context.showBottomSheet(child: TextViewer(note, modalTitle)));
  }
}

/// Primarily for use in the nav bar.
class CreateIconButton extends StatelessWidget {
  final void Function() onPressed;
  const CreateIconButton({Key? key, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      onPressed: onPressed,
      child: SizedBox(
        width: 40,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // shape: BoxShape.circle,
              boxShadow: kElevation[3],
              gradient: Styles.primaryAccentGradient,
              borderRadius: BorderRadius.circular(4)),
          child: const Icon(
            CupertinoIcons.plus,
            color: Styles.white,
          ),
        ),
      ),
    );
  }
}

class CircularCheckbox extends StatelessWidget {
  final void Function(bool v) onPressed;
  final bool isSelected;
  const CircularCheckbox(
      {Key? key, required this.onPressed, required this.isSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isSelected
                ? const Icon(CupertinoIcons.checkmark_alt_circle_fill)
                : const Icon(CupertinoIcons.circle)),
        onPressed: () => onPressed(!isSelected));
  }
}

class ShowHideDetailsButton extends StatelessWidget {
  final void Function() onPressed;
  final bool showDetails;
  final String showText;
  final String hideText;
  const ShowHideDetailsButton(
      {Key? key,
      required this.onPressed,
      required this.showDetails,
      this.showText = 'Show Details',
      this.hideText = 'Hide Details'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: MyText(
        showDetails ? hideText : showText,
        size: FONTSIZE.two,
        weight: FontWeight.bold,
      ),
    );
  }
}
