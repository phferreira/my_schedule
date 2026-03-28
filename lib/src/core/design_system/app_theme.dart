import 'package:flutter/material.dart';
import 'package:my_schedule/src/core/design_system/app_colors.dart';
import 'package:my_schedule/src/core/design_system/app_radius.dart';
import 'package:my_schedule/src/core/design_system/app_spacing.dart';
import 'package:my_schedule/src/core/design_system/app_typography.dart';

class AppTheme {
  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onPrimary,
          error: AppColors.error,
          onError: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          outline: AppColors.outline,
        );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: AppColors.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.onSurface,
        contentTextStyle: TextStyle(color: AppColors.onPrimary),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: AppSpacing.lg,
      ),
    );
  }

  const AppTheme._();
}
