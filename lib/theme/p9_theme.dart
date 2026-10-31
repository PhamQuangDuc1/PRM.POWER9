import 'package:flutter/material.dart';

abstract final class P9Colors {
  static const surface = Color(0xFFF8F9FF);
  static const card = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFEFF4FF);
  static const surfaceContainer = Color(0xFFE5EEFF);
  static const primaryStrong = Color(0xFF004287);
  static const primary = Color(0xFF1E5AA8);
  static const text = Color(0xFF031C36);
  static const secondaryText = Color(0xFF424751);
  static const outline = Color(0xFF737782);
  static const outlineVariant = Color(0xFFC2C6D3);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
}

abstract final class P9Space {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class P9Size {
  static const buttonHeight = 52.0;
  static const controlRadius = 12.0;
  static const cardRadius = 16.0;
  static const logo = 96.0;
  static const headerLogo = 40.0;
  static const appBarHeight = 64.0;
  static const navigationHeight = 72.0;
  static const minTarget = 48.0;
  static const contentMaxWidth = 440.0;
  static const progressStroke = 2.0;
}

abstract final class P9Theme {
  static final light = ThemeData(
    useMaterial3: true,
    // Lab 2 explicitly allows Roboto as a fallback.
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: P9Colors.surface,
    colorScheme: const ColorScheme.light(
      primary: P9Colors.primary,
      onPrimary: P9Colors.card,
      primaryContainer: P9Colors.surfaceContainer,
      onPrimaryContainer: P9Colors.primaryStrong,
      secondary: P9Colors.primaryStrong,
      onSecondary: P9Colors.card,
      secondaryContainer: P9Colors.surfaceContainer,
      onSecondaryContainer: P9Colors.primaryStrong,
      surface: P9Colors.surface,
      surfaceContainerLowest: P9Colors.card,
      surfaceContainerLow: P9Colors.surfaceLow,
      surfaceContainer: P9Colors.surfaceContainer,
      onSurface: P9Colors.text,
      onSurfaceVariant: P9Colors.secondaryText,
      outline: P9Colors.outline,
      outlineVariant: P9Colors.outlineVariant,
      error: P9Colors.error,
      errorContainer: P9Colors.errorContainer,
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 48,
        height: 64 / 48,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 24 / 16),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(fontSize: 14, height: 20 / 14),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
      ),
    ).apply(bodyColor: P9Colors.text, displayColor: P9Colors.text),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, P9Size.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: P9Space.lg,
          vertical: P9Space.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(P9Size.controlRadius),
        ),
      ),
    ),
  );
}
