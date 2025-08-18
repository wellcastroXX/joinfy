// lib/theme/app_theme.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData light(BuildContext context) {
    final mq = MediaQuery.of(context);
    final shortest = mq.size.shortestSide; // diferencia phone/tablet
    final textScale = mq.textScaleFactor.clamp(1.0, 1.3);

    // ---------- Inputs ----------
    double baseHeight;
    if (shortest >= 900) {
      baseHeight = 64; // tablets/grandes
    } else if (shortest >= 600) {
      baseHeight = 60; // telefones largos
    } else {
      baseHeight = 56; // telefones comuns
    }

    final double textApprox = 22 * textScale;
    final double vPad = ((baseHeight - textApprox) / 2).clamp(20, 50);

    // Padding horizontal fluido + limites
    final fluidHPad = mq.size.width * 0.04; // 4% da largura
    final double hPad = fluidHPad.clamp(12.0, 22.0);

    final contentPadding = EdgeInsets.symmetric(
      vertical: vPad,
      horizontal: hPad,
    );

    // ---------- Botões responsivos ----------
    final double btnHeight = ((baseHeight + 10) * (1 + (textScale - 1) * 0.3))
        .clamp(56.0, 80.0)
        .toDouble();

    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      fontFamily: 'CodePro',

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headingLC,
        headlineLarge: AppTextStyles.headingLC,
        titleLarge: AppTextStyles.headingLC,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.small,
        labelLarge: AppTextStyles.body,
        labelMedium: AppTextStyles.small,
        labelSmall: AppTextStyles.small,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          minimumSize: Size.fromHeight(btnHeight), // responsivo
        ),
      ),

      // FilledButton
      // FilledButton
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(AppTextStyles.boldLC),
          backgroundColor: const MaterialStatePropertyAll(AppColors.primary),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
          minimumSize: MaterialStatePropertyAll(
            Size.fromHeight(btnHeight), // responsivo
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        hintStyle: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
        contentPadding: contentPadding,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.headingLC.copyWith(fontSize: 20),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}
