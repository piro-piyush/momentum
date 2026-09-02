import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // Shared
  // ─────────────────────────────────────────────

  static const Color error = Color(0xFFEF4444);

  // ─────────────────────────────────────────────
  // Light Colors
  // ─────────────────────────────────────────────

  static const Color lightBackground = Color(0xFFF7F7F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSecondary = Color(0xFFF1F1EF);

  static const Color lightPrimary = Color(0xFF111111);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightTextTertiary = Color(0xFF999999);

  static const Color lightBorder = Color(0xFFE2E2E0);

  // ─────────────────────────────────────────────
  // Dark Colors
  // ─────────────────────────────────────────────

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF0A0A0A);
  static const Color darkSurfaceSecondary = Color(0xFF111111);

  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkOnPrimary = Color(0xFF000000);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA1A1A1);
  static const Color darkTextTertiary = Color(0xFF666666);

  static const Color darkBorder = Color(0xFF222222);

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      background: lightBackground,
      surface: lightSurface,
      surfaceSecondary: lightSurfaceSecondary,
      primary: lightPrimary,
      onPrimary: lightOnPrimary,
      textPrimary: lightTextPrimary,
      textSecondary: lightTextSecondary,
      textTertiary: lightTextTertiary,
      border: lightBorder,
    );
  }

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────

  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      background: darkBackground,
      surface: darkSurface,
      surfaceSecondary: darkSurfaceSecondary,
      primary: darkPrimary,
      onPrimary: darkOnPrimary,
      textPrimary: darkTextPrimary,
      textSecondary: darkTextSecondary,
      textTertiary: darkTextTertiary,
      border: darkBorder,
    );
  }

  // ─────────────────────────────────────────────
  // Theme Builder
  // ─────────────────────────────────────────────

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceSecondary,
    required Color primary,
    required Color onPrimary,
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
    required Color border,
  }) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,

      primary: primary,
      onPrimary: onPrimary,

      secondary: primary,
      onSecondary: onPrimary,

      surface: surface,
      onSurface: textPrimary,

      surfaceContainerHighest: surfaceSecondary,
      onSurfaceVariant: textSecondary,

      outline: border,
      outlineVariant: border,

      error: error,
      onError: Colors.white,

      // Material 3 additional surfaces
      surfaceContainer: surface,
      surfaceContainerLow: background,
      surfaceContainerHigh: surfaceSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: background,

      // ─────────────────────────────────────────
      // App Bar
      // ─────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary, size: 24),
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
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: textSecondary),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, height: 1.4, color: textTertiary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
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

        hintStyle: TextStyle(fontSize: 15, color: textTertiary),

        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),

        floatingLabelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
        ),

        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,

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

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border.withValues(alpha: 0.5)),
        ),

        errorStyle: const TextStyle(fontSize: 12, color: error),
      ),

      // ─────────────────────────────────────────
      // Filled Button
      // Primary Action
      // ─────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,

          disabledBackgroundColor: textTertiary.withValues(
            alpha: isDark ? 0.2 : 0.15,
          ),
          disabledForegroundColor: textTertiary,

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
      // Elevated Button
      // Secondary Action
      // ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: textPrimary,

          disabledBackgroundColor: surfaceSecondary,
          disabledForegroundColor: textTertiary,

          elevation: 0,

          minimumSize: const Size.fromHeight(56),

          padding: const EdgeInsets.symmetric(horizontal: 24),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border),
          ),

          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ─────────────────────────────────────────
      // Outlined Button
      // ─────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,

          minimumSize: const Size.fromHeight(56),

          padding: const EdgeInsets.symmetric(horizontal: 24),

          side: BorderSide(color: border),

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

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Icon Button
      // ─────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: Colors.transparent,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Cards
      // ─────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,

        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border),
        ),
      ),

      // ─────────────────────────────────────────
      // Divider
      // ─────────────────────────────────────────
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      // ─────────────────────────────────────────
      // Progress Indicator
      // ─────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: border,
        circularTrackColor: border,
        linearMinHeight: 8,
      ),

      // ─────────────────────────────────────────
      // Floating Action Button
      // ─────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // ─────────────────────────────────────────
      // Dialog
      // ─────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: border),
        ),

        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),

        contentTextStyle: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: textSecondary,
        ),
      ),

      // ─────────────────────────────────────────
      // Snack Bar
      // ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? darkSurfaceSecondary : lightPrimary,

        contentTextStyle: TextStyle(
          color: isDark ? darkTextPrimary : lightOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

        elevation: 0,
      ),

      // ─────────────────────────────────────────
      // Bottom Sheet
      // ─────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // ─────────────────────────────────────────
      // Checkbox
      // ─────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

        side: BorderSide(color: border, width: 1.5),

        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }

          return Colors.transparent;
        }),

        checkColor: WidgetStatePropertyAll(onPrimary),
      ),

      // ─────────────────────────────────────────
      // Switch
      // ─────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return onPrimary;
          }

          return textSecondary;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }

          return surfaceSecondary;
        }),

        trackOutlineColor: WidgetStatePropertyAll(border),
      ),

      // ─────────────────────────────────────────
      // List Tiles
      // ─────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
