import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // Light Colors
  // ─────────────────────────────────────────────

  static const Color lightBackground = Color(0xFFF7F7F5);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF111111);
  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightBorder = Color(0xFFE5E5E5);

  // ─────────────────────────────────────────────
  // Dark Colors
  // ─────────────────────────────────────────────

  // ─────────────────────────────────────────────
  // Pure Dark Colors
  // ─────────────────────────────────────────────

  static const Color darkBackground = Colors.black;
  static const Color darkSurface = Color(0xFF0A0A0A);
  static const Color darkElevatedSurface = Color(0xFF111111);
  static const Color darkPrimary = Colors.white;
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFA1A1A1);
  static const Color darkBorder = Color(0xFF222222);

  static const Color error = Color(0xFFEF5350);

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      background: lightBackground,
      surface: lightSurface,
      primary: lightPrimary,
      textPrimary: lightTextPrimary,
      textSecondary: lightTextSecondary,
      border: lightBorder,
    );
  }

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: Colors.black,

      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,

        secondary: Colors.white,
        onSecondary: Colors.black,

        surface: Color(0xFF0A0A0A),
        onSurface: Colors.white,

        surfaceContainerHighest: Color(0xFF111111),
        onSurfaceVariant: Color(0xFFA1A1A1),

        error: Color(0xFFFF5252),
        onError: Colors.black,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
          height: 1.05,
          color: Colors.white,
        ),

        displayMedium: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.8,
          height: 1.05,
          color: Colors.white,
        ),

        displaySmall: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
          height: 1.05,
          color: Colors.white,
        ),

        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
          color: Colors.white,
        ),

        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: Colors.white,
        ),

        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),

        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),

        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFFA1A1A1),
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Color(0xFFA1A1A1),
        ),

        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFFA1A1A1),
        ),

        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0A0A0A),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),

        hintStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFF666666),
        ),

        labelStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFA1A1A1),
        ),

        prefixIconColor: const Color(0xFFA1A1A1),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF222222),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF222222),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFFF5252),
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFFF5252),
            width: 1.5,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF222222),
            ),
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF222222),
        thickness: 1,
        space: 1,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF0A0A0A),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF222222),
          ),
        ),
      ),
    );
  }
  // ─────────────────────────────────────────────
  // Theme Builder
  // ─────────────────────────────────────────────

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: primary,
        onSecondary: isDark ? Colors.black : Colors.white,
        surface: surface,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        error: error,
        onError: Colors.white,
      ),

      // ─────────────────────────────────────────
      // App Bar
      // ─────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      // ─────────────────────────────────────────
      // Typography
      // ─────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
          height: 1.05,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.8,
          height: 1.05,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
          height: 1.05,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // ─────────────────────────────────────────
      // Input Fields
      // ─────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),

        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary.withValues(alpha: 0.75),
        ),

        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),

        prefixIconColor: textSecondary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),

      // ─────────────────────────────────────────
      // Filled Button
      // ─────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ─────────────────────────────────────────
      // Text Button
      // ─────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Elevated Button
      // ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border),
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Divider
      // ─────────────────────────────────────────
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      // ─────────────────────────────────────────
      // Card
      // ─────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border),
        ),
      ),
    );
  }
}
