import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

/// Defines custom colors for Instagram-like dark mode.

/// Custom ShadColorScheme for dark mode.
class CustomShadColorScheme {
  static const ShadColorScheme dark = ShadColorScheme(
    background: AppColors.background,
    foreground: AppColors.white,
    card: AppColors.primaryDar,
    cardForeground: AppColors.white,
    popover: AppColors.primaryDar,
    popoverForeground: AppColors.white,
    primary: AppColors.deepBlue,
    primaryForeground: AppColors.white,
    secondary: AppColors.lightBlue,
    secondaryForeground: AppColors.white,
    muted: AppColors.grey,
    mutedForeground: AppColors.white,
    accent: AppColors.orangeAccent,
    accentForeground: AppColors.white,
    destructive: AppColors.red,
    destructiveForeground: AppColors.white,
    border: AppColors.borderOutline,
    input: AppColors.lightDark,
    ring: AppColors.deepBlue,
    selection: AppColors.deepBlue,
  );
}

/// Light Mode App [ShadThemeData].
class AppTheme {
  /// Defines the brightness of theme.
  Brightness get brightness => Brightness.light;

  /// Defines the primary color of theme.
  Color get primary => AppColors.deepBlue;

  /// Defines light [ShadThemeData].
  ShadThemeData get theme => ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadBlueColorScheme.light(primary: primary),
        textTheme: shadTextTheme,
        inputTheme: ShadInputTheme(
          placeholderStyle:
              textTheme.bodyMedium?.copyWith(color: AppColors.grey),
        ),
      );

  /// Defines ShadTextTheme.
  ShadTextTheme get shadTextTheme => ShadTextTheme(
        family: 'Inter',
        package: 'app_ui',
        h1Large: textTheme.displayMedium,
        h1: textTheme.displaySmall,
        h2: textTheme.headlineLarge,
        h3: textTheme.headlineSmall,
        h4: textTheme.titleLarge,
        p: textTheme.bodyLarge,
        table: textTheme.labelLarge,
        small: textTheme.bodyLarge,
        muted: textTheme.bodyMedium,
      );

  /// Text theme of the App theme.
  TextTheme get textTheme => uiTextTheme;

  /// The Content text theme based on [UITextStyle].
  static final uiTextTheme = TextTheme(
    displayLarge: UITextStyle.headline1,
    displayMedium: UITextStyle.headline2,
    displaySmall: UITextStyle.headline3,
    headlineLarge: UITextStyle.headline4,
    headlineMedium: UITextStyle.headline5,
    headlineSmall: UITextStyle.headline6,
    titleLarge: UITextStyle.headline7,
    titleMedium: UITextStyle.subtitle1,
    titleSmall: UITextStyle.subtitle2,
    bodyLarge: UITextStyle.bodyText1,
    bodyMedium: UITextStyle.bodyText2,
    labelLarge: UITextStyle.button,
    bodySmall: UITextStyle.caption,
    labelSmall: UITextStyle.overline,
  ).apply(
    bodyColor: AppColors.black,
    displayColor: AppColors.black,
    decorationColor: AppColors.black,
  );
}

/// Dark Mode App [ShadThemeData].
class AppDarkTheme extends AppTheme {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  TextTheme get textTheme {
    return AppTheme.uiTextTheme.apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
      decorationColor: AppColors.white,
    );
  }

  @override
  ShadThemeData get theme => ShadThemeData(
        brightness: brightness,
        colorScheme: CustomShadColorScheme.dark,
        textTheme: shadTextTheme,
        inputTheme: ShadInputTheme(
          placeholderStyle:
              textTheme.bodyMedium?.copyWith(color: AppColors.grey),
        ),
      );
}

/// Theme for the [SystemUiOverlayStyle].
class SystemUiOverlayTheme {
  /// iOS light SystemUiOverlayStyle.
  static const SystemUiOverlayStyle iOSLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// iOS dark SystemUiOverlayStyle.
  static const SystemUiOverlayStyle iOSDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Android light SystemUiOverlayStyle.
  static const SystemUiOverlayStyle androidLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppColors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// Android dark SystemUiOverlayStyle.
  static const SystemUiOverlayStyle androidDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppColors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Android transparent light SystemUiOverlayStyle.
  static const SystemUiOverlayStyle androidTransparentLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Android transparent dark SystemUiOverlayStyle.
  static const SystemUiOverlayStyle androidTransparentDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// Adaptive iOS SystemUiOverlayStyle.
  static SystemUiOverlayStyle adaptiveOSSystemBarTheme({
    required bool light,
    required bool persistLight,
  }) {
    return light
        ? iOSLightSystemBarTheme
        : persistLight
            ? iOSLightSystemBarTheme
            : iOSDarkSystemBarTheme;
  }

  /// Adaptive Android SystemUiOverlayStyle.
  static SystemUiOverlayStyle adaptiveAndroidTransparentSystemBarTheme({
    required bool light,
    required bool persistLight,
  }) {
    return light
        ? androidTransparentLightSystemBarTheme
        : persistLight
            ? androidTransparentLightSystemBarTheme
            : androidTransparentDarkSystemBarTheme;
  }

  /// Defines a portrait only orientation for any device.
  static void setPortraitOrientation() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
  }
}
