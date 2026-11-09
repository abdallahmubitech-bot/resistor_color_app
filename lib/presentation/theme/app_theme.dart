import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xff0b1018);
  static const panel = Color(0xff141d28);
  static const panelLight = Color(0xff192431);
  static const border = Color(0xff293746);
  static const muted = Color(0xff899aa9);
  static const cyan = Color(0xff64d9e8);
  static const gold = Color(0xffd9ad70);
  static const white = Color(0xffedf4f5);
}

abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(primary: AppColors.cyan, secondary: AppColors.gold, surface: AppColors.panel, error: Color(0xffff8585));
    return ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      textTheme: ThemeData.dark().textTheme.apply(bodyColor: AppColors.white, displayColor: AppColors.white),
      dividerColor: AppColors.border,
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
    );
  }
}
