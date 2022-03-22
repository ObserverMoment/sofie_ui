import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

void printLog(String message) {
  GetIt.I<Logger>().d(message);
}

abstract class Utils {
  static void openUserFeedbackPage(BuildContext context) {
    BetterFeedback.of(context)
        .show((feedback) => submitUserFeedbackToSentry(context, feedback));
  }

  static Future<void> submitUserFeedbackToSentry(
      BuildContext context, UserFeedback feedback) async {
    final userId = GetIt.I<AuthBloc>().authedUser!.id;
    final attachment = SentryAttachment.fromUint8List(
        feedback.screenshot, 'screenshot.png',
        contentType: 'image/png');

    SentryId sentryId = await Sentry.captureMessage(
      "User Feedback",
      withScope: (scope) {
        scope.addAttachment(attachment);
        scope.level = SentryLevel.info;
      },
    );

    final sentryFeedback = SentryUserFeedback(
      eventId: sentryId,
      comments: feedback.text,
      name: userId,
    );

    await Sentry.captureUserFeedback(sentryFeedback);

    context.showToast(message: 'Feedback received, thanks!');
  }

  static void unfocusAny() => FocusManager.instance.primaryFocus?.unfocus();
  // https://stackoverflow.com/questions/47776045/is-there-a-good-way-to-write-wait-for-variables-to-change-in-darts-async-meth
  /// Completes the future when async test() return true
  /// Or bails out after maxAttempts with an error.
  /// Optional linear backoff as number of attempts increase.
  static Future waitWhile(Future<bool> Function() test,
      {int pollIntervalMs = 1000, int backoffMs = 1000, int? maxAttempts}) {
    final completer = Completer();
    int attempt = 0;
    Future<void> check() async {
      if (await test()) {
        completer.complete();
      } else {
        attempt++;
        if (maxAttempts != null && attempt > maxAttempts) {
          completer.completeError(Exception(
              'waitWhile: Max attempts reached without receiving a valid response'));
        } else {
          Timer(Duration(milliseconds: pollIntervalMs + (backoffMs * attempt)),
              check);
        }
      }
    }

    check();
    return completer.future;
  }

  static Widget getEquipmentIcon(BuildContext context, String name,
      {Color? color, bool isSelected = false}) {
    return SvgPicture.asset(
      'assets/equipment_icons/${getSvgAssetUriFromEquipmentName(name)}.svg',
      color: color ?? context.theme.primary,
    );
  }

  /// Assets should be snake case versions of the equipment name.
  static String getSvgAssetUriFromEquipmentName(String name) {
    return name.toLowerCase().split(' ').join('_');
  }

  /// Assets should be snake case versions of the body area name in the db.
  static String getSvgAssetUriFromBodyAreaName(String name) {
    return name.toLowerCase().split(' ').join('_');
  }

  static void hideKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static bool exclusiveOr(bool a, bool b) => a ^ b;

  /// Checks that text is not null and not an empty string.
  static bool textNotNull(String? text) => text != null && text.isNotEmpty;

  /// returns true if any items in the list exist (are not null).
  static bool anyNotNull(List list) => list.any((e) => e != null);

  /// Checks that reps is not null and not zero.
  static bool hasReps(double? reps) => reps != null && reps != 0;

  /// Checks that load is not null and not zero.
  static bool hasLoad(double? load) => load != null && load != 0;

  /// Checks that load is not null and not zero.
  static bool notNullNotEmpty(List? list) => list != null && list.isNotEmpty;
}
