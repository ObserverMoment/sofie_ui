import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/dialog_menu.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/stream_feed.dart';

extension BuildContextExtension on BuildContext {
  ///////////////////
  //// Providers ////
  ///////////////////
  ThemeBloc get theme {
    return watch<ThemeBloc>();
  }

  ThemeBloc get readTheme {
    return read<ThemeBloc>();
  }

  StreamChatClient get streamChatClient {
    return read<StreamChatClient>();
  }

  OwnUser get streamChatUser {
    return read<OwnUser>();
  }

  StreamFeedClient get streamFeedClient {
    return read<StreamFeedClient>();
  }

  NotificationFeed get notificationFeed {
    return read<NotificationFeed>();
  }

  ////////////////////////////////////
  //// Routes, Dialogs and Alerts ////
  ////////////////////////////////////
  Future<T?> push<T>(
      {required Widget child,
      bool fullscreenDialog = false,
      bool rootNavigator = false}) async {
    final BuildContext context = this;
    final T? res = await Navigator.of(context, rootNavigator: rootNavigator)
        .push(CupertinoPageRoute(
            fullscreenDialog: fullscreenDialog, builder: (context) => child));
    return res;
  }

  dynamic pop({dynamic result, bool rootNavigator = false}) =>
      Navigator.of(this, rootNavigator: rootNavigator).pop(result);

  /// Just one action. 'OK', dialog pops itself on tap, no callback.
  /// [barrierDismissible] is true so can dismiss by clicking anywhere on background.
  Future<void> showAlertDialog({
    required String title,
    String? message,
  }) async {
    final BuildContext context = this;
    await showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => DialogContainer(
              child: DialogMenu(
                title: title,
                message: message,
                actions: [
                  DialogMenuItem(
                    text: 'OK',
                    // Just pop, which is handled by [DialogMenu].
                    onPressed: () {},
                  )
                ],
              ),
            ));
  }

  BuildContext showLoadingAlert(
    String message, {
    Widget? icon,
  }) {
    final BuildContext parentContext = this;
    BuildContext? dialogContext;
    showCupertinoDialog(
        context: parentContext,
        builder: (context) {
          dialogContext = context;
          return DialogContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: icon,
                  ),
                MyText(message, textAlign: TextAlign.center),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: LoadingIndicator(
                    size: 14,
                  ),
                )
              ],
            ),
          );
        });
    return dialogContext ?? parentContext;
  }

  Future<T?> showDialogMenu<T>(
      {required String title,
      String? message,
      List<DialogMenuItem> actions = const []}) async {
    final BuildContext parentContext = this;
    final T? res = await showCupertinoDialog(
        context: parentContext,
        barrierDismissible: true,
        builder: (context) {
          return DialogContainer(
            child: DialogMenu(
              title: title,
              message: message,
              actions: actions,
            ),
          );
        });
    return res;
  }

  /// Standardise dialog with two options - Confirm or Cancel.
  Future<T?> showConfirmDialog<T>({
    required String title,
    String? subtitle,
    String? message,
    String? verb,
    bool isDestructive = false,
    required void Function() onConfirm,
    void Function()? onCancel,
  }) async {
    final BuildContext parentContext = this;
    final T? res = await showCupertinoDialog(
        context: parentContext,
        barrierDismissible: true,
        builder: (context) {
          final BuildContext dialogContext = context;
          return DialogContainer(
            child: DialogMenu(
              title: title,
              subtitle: subtitle,
              message: message,
              actions: [
                DialogMenuItem(
                  text: verb ?? 'Confirm',
                  onPressed: onConfirm,
                  isDestructive: isDestructive,
                )
              ],
              onCancel: () {
                onCancel?.call();
                Navigator.of(dialogContext).pop();
              },
            ),
          );
        });
    return res;
  }

  /// Dialog checking if the user wants to delete the item. Includes the Item type
  // and the item name.
  Future<T?> showConfirmDeleteDialog<T>({
    required String itemType,
    String? itemName,
    String? message,
    String? verb,
    required void Function() onConfirm,
  }) async {
    final BuildContext parentContext = this;
    final T? res = await showCupertinoDialog(
        context: parentContext,
        barrierDismissible: true,
        builder: (context) {
          final BuildContext dialogContext = context;
          return DialogContainer(
            child: DialogMenu(
              title: '${verb ?? "Delete"} $itemType',
              message: message,
              subtitle: itemName,
              actions: [
                DialogMenuItem(
                  isDestructive: true,
                  text: verb ?? 'Delete',
                  onPressed: onConfirm,
                )
              ],
              onCancel: () => Navigator.of(dialogContext).pop(),
            ),
          );
        });
    return res;
  }

  Future<void> showSuccessAlert(
      {required String title, String? message}) async {
    final BuildContext context = this;
    await showCupertinoDialog(
        context: context,
        builder: (context) => DialogContainer(
              child: DialogMenu(
                title: title,
                message: message,
                actions: [
                  DialogMenuItem(
                    text: 'OK',
                    // Just pop, which is handled by [DialogMenu].
                    onPressed: () {},
                  )
                ],
              ),
            ));
  }

  Future<void> showErrorAlert(
    String message,
  ) async {
    final BuildContext context = this;
    await showCupertinoDialog(
        context: context,
        builder: (context) => DialogContainer(
              child: DialogMenu(
                title: 'Sorry, something went wrong...',
                message: message,
                actions: [
                  DialogMenuItem(
                    text: 'OK',
                    // Just pop, which is handled by [DialogMenu].
                    onPressed: () {},
                  )
                ],
              ),
            ));
  }

  //////////////////////////////////////////
  //// Bottom sheets, menus and Actions ////
  //////////////////////////////////////////
  /// https://stackoverflow.com/questions/53311553/how-to-set-showmodalbottomsheet-to-full-height
  Future<T?> showBottomSheet<T>({
    required Widget child,
  }) async {
    final T? res = await material.showModalBottomSheet<T>(
        backgroundColor: material.Colors.transparent,
        isScrollControlled: true,
        context: this,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                decoration: BoxDecoration(
                    color: context.readTheme.background,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                child: Wrap(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: child,
                  )
                ]),
              ),
            ));
    return res;
  }

  /// Classic iOS action sheet with a cancel button underneath.
  /// Being used for some pickers (wheel style pickers for example)
  Future<void> showActionSheetPopup({
    required Widget child,
    String cancelCloseText = 'Cancel',
    bool useRootNavigator = false,
  }) async {
    final BuildContext context = this;

    await showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (context) => CupertinoActionSheet(
              actions: [child],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: context.pop,
                  child: MyText(
                    cancelCloseText,
                    color: context.theme.primary,
                  )),
            ));
  }

  //////////////////////////////////
  //// Toasts and Notifications ////
  //////////////////////////////////
  void showToast({
    required String message,
    Widget? icon,
    ToastType toastType = ToastType.standard,
    TextAlign textAlign = TextAlign.center,
    FlushbarPosition flushbarPosition = FlushbarPosition.TOP,
    VoidCallback? onComplete,
  }) {
    final contentColor = toastType == ToastType.destructive
        ? Styles.errorRed
        : readTheme.primary;

    Flushbar(
            backgroundColor: readTheme.cardBackground,
            flushbarPosition: flushbarPosition,
            flushbarStyle: FlushbarStyle.FLOATING,
            animationDuration: const Duration(milliseconds: 300),
            messageText:
                MyText(message, color: contentColor, textAlign: textAlign),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            duration: const Duration(seconds: 3),
            blockBackgroundInteraction: false,
            isDismissible: true,
            borderRadius: BorderRadius.circular(16))
        .show(this)
        .then((_) => onComplete?.call());
  }

  /// Toast + more text and a button for interactivity.
  void showNotification({
    required String title,
    required Widget content,
    String? buttonText,
    VoidCallback? onPressed,
    TextAlign textAlign = TextAlign.start,
    FlushbarPosition flushbarPosition = FlushbarPosition.TOP,
  }) =>
      Flushbar(
        backgroundColor: readTheme.cardBackground,
        flushbarPosition: flushbarPosition,
        animationDuration: const Duration(milliseconds: 300),
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        borderRadius: BorderRadius.circular(16),
        title: title,
        titleSize: 14,
        messageText: content,
        mainButton: onPressed != null
            ? TextButton(
                text: buttonText ?? 'View',
                onPressed: onPressed,
                color: Styles.white,
                underline: false,
              )
            : null,
        duration: const Duration(seconds: 4),
        blockBackgroundInteraction: false,
        isDismissible: true,
      )..show(this);
}
