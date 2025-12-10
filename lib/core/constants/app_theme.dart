import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_colors_dark.dart';
import 'app_text_styles.dart';

// Light Theme
final ThemeData appTheme = ThemeData(
  brightness:  Brightness.light,
  primarySwatch: Colors.blue,
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    onError: Colors.grey.shade800,
    surface: Colors.white,
    background: AppColors.backgroundColor,
  ),
  hintColor: AppColors.secondaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  cardColor: Colors.white,
  dividerColor: AppColors.borderColor,
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.headline1,
    displayMedium:  AppTextStyles.headline2,
    displaySmall: TextStyle(fontSize: 18, fontWeight:  FontWeight.bold, color: AppColors.textColor),
    titleLarge: TextStyle(fontSize:  20, fontWeight: FontWeight.w600, color: AppColors.textColor),
    titleMedium: TextStyle(fontSize:  16, fontWeight: FontWeight.w500, color: AppColors.textColor),
    bodyLarge: AppTextStyles.bodyText,
    bodyMedium:  AppTextStyles.secondaryText,
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textColor),
    headlineSmall: TextStyle(fontSize:  18, fontWeight: FontWeight.bold, color: AppColors.textColor),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primaryColor,
    selectionColor: AppColors.primaryColor,
    selectionHandleColor: AppColors.primaryColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme:  IconThemeData(color: AppColors.primaryColor),
    titleTextStyle: TextStyle(color:  AppColors.textColor, fontSize: 20, fontWeight: FontWeight.bold),
  ),
);

// Dark Theme
final ThemeData appThemeDark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  primaryColor: AppColorsDark.primaryColor,
  colorScheme: ColorScheme. dark(
    primary: AppColorsDark.primaryColor,
    secondary: AppColorsDark.secondaryColor,
    onError:  Colors.grey.shade300,
    surface: AppColorsDark. surfaceColor,
    background:  AppColorsDark.backgroundColor,
  ),
  hintColor: AppColorsDark.secondaryColor,
  scaffoldBackgroundColor: AppColorsDark.backgroundColor,
  cardColor: AppColorsDark.surfaceColor,
  dividerColor: AppColorsDark.borderColor,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight:  FontWeight.bold, color: AppColorsDark. textColor),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight. bold, color: AppColorsDark.textColor),
    displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight. bold, color: AppColorsDark.textColor),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight. w600, color: AppColorsDark.textColor),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColorsDark.textColor),
    bodyLarge: TextStyle(fontSize: 16, color: AppColorsDark.textColor),
    bodyMedium: TextStyle(fontSize: 14, color:  AppColorsDark.secondaryTextColor),
    headlineLarge: TextStyle(fontSize: 28, fontWeight:  FontWeight.bold, color: AppColorsDark.textColor),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColorsDark.textColor),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColorsDark.primaryColor,
    selectionColor: AppColorsDark.primaryColor,
    selectionHandleColor: AppColorsDark.primaryColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColorsDark.surfaceColor,
    elevation:  0,
    iconTheme: IconThemeData(color:  AppColorsDark.primaryColor),
    titleTextStyle: TextStyle(color: AppColorsDark. textColor, fontSize: 20, fontWeight: FontWeight.bold),
  ),
);