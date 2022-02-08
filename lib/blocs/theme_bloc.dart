import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sofie_ui/constants.dart';

enum ThemeName { dark, light }

class ThemeBloc extends ChangeNotifier {
  ThemeBloc({Brightness deviceBrightness = Brightness.dark}) {
    // Check for saved setting in local Hive box.
    final themeNameFromSettings = Hive.box(kSettingsHiveBoxName)
        .get(kSettingsHiveBoxThemeKey, defaultValue: null);

    if (themeNameFromSettings != null) {
      if (themeNameFromSettings == kSettingsDarkThemeKey) {
        _setToDark();
      } else {
        _setToLight();
      }
    } else {
      // Initialise from device or default to dark.
      if (deviceBrightness == Brightness.dark) {
        _setToDark();
      } else {
        _setToLight();
      }
    }
  }

  Theme theme = ThemeData.darkTheme;
  ThemeName themeName = ThemeName.dark;

  /// Getters for regularly used attributes
  /// Context has been extended to allow for calling context.theme.[getter]
  /// Rather than context.watch<ThemeBloc>()
  CupertinoThemeData get cupertinoThemeData => theme.cupertinoThemeData;
  CustomThemeData get customThemeData => theme.customThemeData;
  Brightness get brightness =>
      themeName == ThemeName.dark ? Brightness.dark : Brightness.light;
  Color get primary => theme.cupertinoThemeData.primaryColor;
  Color get background => theme.cupertinoThemeData.scaffoldBackgroundColor;
  Color get cardBackground => theme.customThemeData.cardBackground;
  Color get modalBackground => theme.customThemeData.modalBackground;
  LinearGradient get fabBackground => Styles.primaryAccentGradient;
  Color get barBackground => theme.cupertinoThemeData.barBackgroundColor;
  Color get navbarBottomBorder => theme.customThemeData.navbarBottomBorder;

  Future<void> switchToTheme(ThemeName switchToTheme) async {
    if (switchToTheme == ThemeName.dark && themeName != ThemeName.dark) {
      _setToDark();
      await Hive.box(kSettingsHiveBoxName)
          .put(kSettingsHiveBoxThemeKey, kSettingsDarkThemeKey);
    } else if (switchToTheme == ThemeName.light &&
        themeName != ThemeName.light) {
      _setToLight();
      await Hive.box(kSettingsHiveBoxName)
          .put(kSettingsHiveBoxThemeKey, kSettingsLightThemeKey);
    }
  }

  void _setToDark() {
    theme = ThemeData.darkTheme;
    themeName = ThemeName.dark;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    notifyListeners();
  }

  void _setToLight() {
    theme = ThemeData.lightTheme;
    themeName = ThemeName.light;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    notifyListeners();
  }
}

class Theme {
  final CupertinoThemeData cupertinoThemeData;
  final CustomThemeData customThemeData;
  Theme(this.cupertinoThemeData, this.customThemeData);
}

class CustomThemeData {
  final Color greyOne;
  final Color greyTwo;
  final Color greyThree;
  final Color greyFour;
  final Color bottomNavigationBackground;
  final Color cardBackground;
  final Color modalBackground;
  final Color navbarBottomBorder;
  CustomThemeData(
      {required this.greyOne,
      required this.greyTwo,
      required this.greyThree,
      required this.greyFour,
      required this.bottomNavigationBackground,
      required this.cardBackground,
      required this.modalBackground,
      required this.navbarBottomBorder});
}

abstract class ThemeData {
  static Theme darkTheme = Theme(cupertinoDarkData, customDarkData);
  static Theme lightTheme = Theme(cupertinoLightData, customLightData);

  static CustomThemeData customDarkData = CustomThemeData(
      greyOne: Styles.greyOne,
      greyTwo: Styles.greyTwo,
      greyThree: Styles.greyThree,
      greyFour: Styles.greyFour,
      cardBackground: const Color(0xff1a1a1c),
      modalBackground: const Color(0xff111112),
      bottomNavigationBackground: const Color(0xff434343),
      navbarBottomBorder: Styles.white.withOpacity(0.1));

  static CustomThemeData customLightData = CustomThemeData(
      greyOne: Styles.greyFour,
      greyTwo: Styles.greyThree,
      greyThree: Styles.greyTwo,
      greyFour: Styles.greyOne,
      cardBackground: CupertinoColors.white,
      modalBackground: CupertinoColors.white,
      bottomNavigationBackground: const Color(0xffffffff),
      navbarBottomBorder: Styles.black.withOpacity(0.1));

  static CupertinoThemeData cupertinoDarkData = CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: const Color(0xff050505),
      scaffoldBackgroundColor: const Color(0xff050505),
      primaryColor: CupertinoColors.white,
      primaryContrastingColor: Styles.primaryAccent,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.white,
        textStyle: GoogleFonts.sourceSansPro(
            textStyle: const TextStyle(color: CupertinoColors.white)),
      ));

  static CupertinoThemeData cupertinoLightData = CupertinoThemeData(
      brightness: Brightness.light,
      barBackgroundColor: CupertinoColors.systemGroupedBackground,
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      primaryColor: CupertinoColors.black,
      primaryContrastingColor: Styles.primaryAccent,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.black,
        textStyle: GoogleFonts.sourceSansPro(
            textStyle: const TextStyle(color: CupertinoColors.black)),
      ));
}

//// Values which stay constant across both themes ////
abstract class Styles {
  // Functional Theme colors
  static const Color black = CupertinoColors.black;
  static const Color white = CupertinoColors.white;
  static const Color errorRed = CupertinoColors.destructiveRed;
  static const Color infoBlue = CupertinoColors.activeBlue;
  static const Color heartRed = Color(0xffA8294B);

  // Button gradients.
  static const secondaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff232526), Color(0xff272b33), Color(0xff232526)],
    stops: [0, 0.5, 1],
  );

  // Shades of grey
  static const Color greyOne = Color(0xff383838);
  static const Color greyTwo = Color(0xff595959);
  static const Color greyThree = Color(0xff9c9c9c);
  static const Color greyFour = Color(0xffc9c9c9);

  // Difficulty Level Colours
  static const difficultyLevelOne = Color(0xff226F54); // Green
  static const difficultyLevelTwo = Color(0xff005AA7); // Blue
  static const difficultyLevelThree = Color(0xffFFA62B); // Orange
  static const difficultyLevelFour = Color(0xff990133); // Red
  static const difficultyLevelFive = CupertinoColors.black; // Black

  // Design / Accent colors.
  static const Color primaryAccent = Color(0xff2c8a8a);
  // static const Color primaryAccent = Color(0xfff24c2b);
  // static const Color primaryAccent = Color(0xfffe7743);
  // static const Color primaryAccent = Color(0xff079767);

  static const LinearGradient primaryAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryAccent,
      // Color(0xff3aa1a1),
      // Color(0xfff4532c),
      // Color(0xffF09819),
      Color(0xff34e7ab),
    ],
    stops: [0.0, 1.0],
  );

  static const Color secondaryAccent = Color(0xffF97D5B);
  // static const Color secondaryAccent = Color(0xfffe7743);

  static const LinearGradient secondaryAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryAccent, Color(0xffF9A87B)],
    stops: [0.0, 1.0],
  );

  /// For use in nav bars, headers and buttons.
  static const double buttonIconSize = 25.0;
}
