import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  COLOR TOKENS
// ─────────────────────────────────────────────

class _LightColors {
  static const scaffold = Color(0xFFF5FAF4);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEDF7EE);
  static const primary = Color(0xFF2ECF93);
  static const primaryDark = Color(0xFF1FAF7A);
  static const text = Color(0xFF003D10);
  static const textSecondary = Color(0xFF4A7055);
  static const textMuted = Color(0xFF9AAA9A);
  static const border = Color(0xFFD6EDD9);
  static const divider = Color(0xFFEAF3EB);
  static const error = Color(0xFFE53935);
  static const shadow = Color(0x0F003D10);
}

class _DarkColors {
  static const scaffold = Color(0xFF0F1411);
  static const surface = Color(0xFF1A211C);
  static const surfaceVariant = Color(0xFF232B25);
  static const primary = Color(0xFF2ECF93);
  static const primaryDark = Color(0xFF1FAF7A);
  static const text = Color(0xFFE8F5EA);
  static const textSecondary = Color(0xFF8BAF92);
  static const textMuted = Color(0xFF4A6B50);
  static const border = Color(0xFF2A3B2D);
  static const divider = Color(0xFF1F2B21);
  static const error = Color(0xFFEF5350);
  static const shadow = Color(0x1F000000);
}

// ─────────────────────────────────────────────
//  LIGHT THEME
// ─────────────────────────────────────────────

class LightTheme {
  final ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // ── colors ───────────────────────────────
    scaffoldBackgroundColor: _LightColors.scaffold,
    primaryColor: _LightColors.primary,
    colorScheme: ColorScheme.light(
      primary: _LightColors.primary,
      onPrimary: Colors.white,
      primaryContainer: _LightColors.surfaceVariant,
      onPrimaryContainer: _LightColors.text,
      secondary: _LightColors.primaryDark,
      onSecondary: Colors.white,
      surface: _LightColors.surface,
      onSurface: _LightColors.text,
      onSurfaceVariant: _LightColors.textSecondary,
      outline: _LightColors.border,
      outlineVariant: _LightColors.divider,
      error: _LightColors.error,
      onError: Colors.white,
      shadow: _LightColors.shadow,
    ),

    // ── typography ───────────────────────────
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: _LightColors.text,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: _LightColors.text,
        height: 1.2,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _LightColors.text,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _LightColors.text,
        height: 1.3,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _LightColors.text,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: _LightColors.text,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _LightColors.text,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _LightColors.textSecondary,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _LightColors.text,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _LightColors.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: _LightColors.textMuted,
        letterSpacing: 0.8,
      ),
    ),

    // ── app bar ──────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: _LightColors.scaffold,
      foregroundColor: _LightColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _LightColors.text,
      ),
      iconTheme: const IconThemeData(color: _LightColors.text, size: 24),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // ── bottom nav bar ───────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _LightColors.surface,
      selectedItemColor: _LightColors.primary,
      unselectedItemColor: _LightColors.textMuted,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    // ── navigation bar (M3) ──────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _LightColors.surface,
      indicatorColor: _LightColors.primary.withOpacity(0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _LightColors.primary, size: 24);
        }
        return const IconThemeData(color: _LightColors.textMuted, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _LightColors.primary,
          );
        }
        return GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: _LightColors.textMuted,
        );
      }),
      elevation: 0,
    ),

    // ── cards ────────────────────────────────
    cardTheme: CardThemeData(
      color: _LightColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _LightColors.divider),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── elevated button ──────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 90, 167, 203),
        foregroundColor: Colors.white,
        disabledBackgroundColor: _LightColors.border,
        disabledForegroundColor: _LightColors.textMuted,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── outlined button ──────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _LightColors.primary,
        side: const BorderSide(color: _LightColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── text button ──────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _LightColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── input decoration ─────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _LightColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: GoogleFonts.poppins(
        color: _LightColors.textMuted,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.poppins(
        color: _LightColors.textSecondary,
        fontSize: 14,
      ),
      floatingLabelStyle: GoogleFonts.poppins(
        color: _LightColors.primary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      prefixIconColor: _LightColors.textMuted,
      suffixIconColor: _LightColors.textMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _LightColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _LightColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _LightColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _LightColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _LightColors.error, width: 2),
      ),
    ),

    // ── switch ───────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _LightColors.primary;
        }
        return _LightColors.border;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // ── checkbox ─────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _LightColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: _LightColors.border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),

    // ── divider ──────────────────────────────
    dividerTheme: const DividerThemeData(
      color: _LightColors.divider,
      thickness: 0.5,
      space: 0,
    ),

    // ── chip ─────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: _LightColors.surfaceVariant,
      selectedColor: _LightColors.primary.withOpacity(0.15),
      labelStyle: GoogleFonts.poppins(fontSize: 13, color: _LightColors.text),
      side: const BorderSide(color: _LightColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // ── dialog ───────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: _LightColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _LightColors.text,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: _LightColors.textSecondary,
        height: 1.5,
      ),
    ),

    // ── snack bar ────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _LightColors.text,
      contentTextStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
      actionTextColor: _LightColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── list tile ────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _LightColors.text,
      ),
      subtitleTextStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: _LightColors.textSecondary,
      ),
      iconColor: _LightColors.textSecondary,
    ),

    // ── icon ─────────────────────────────────
    iconTheme: const IconThemeData(color: _LightColors.textSecondary, size: 24),

    // ── progress indicator ───────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _LightColors.primary,
      linearTrackColor: _LightColors.surfaceVariant,
      circularTrackColor: _LightColors.surfaceVariant,
    ),

    // ── floating action button ───────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _LightColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

// ─────────────────────────────────────────────
//  DARK THEME
// ─────────────────────────────────────────────

class DarkTheme {
  final ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ── colors ───────────────────────────────
    scaffoldBackgroundColor: _DarkColors.scaffold,
    primaryColor: _DarkColors.primary,
    colorScheme: ColorScheme.dark(
      primary: _DarkColors.primary,
      onPrimary: Colors.black,
      primaryContainer: _DarkColors.surfaceVariant,
      onPrimaryContainer: _DarkColors.text,
      secondary: _DarkColors.primaryDark,
      onSecondary: Colors.white,
      surface: _DarkColors.surface,
      onSurface: _DarkColors.text,
      onSurfaceVariant: _DarkColors.textSecondary,
      outline: _DarkColors.border,
      outlineVariant: _DarkColors.divider,
      error: _DarkColors.error,
      onError: Colors.white,
      shadow: _DarkColors.shadow,
    ),

    // ── typography ───────────────────────────
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: _DarkColors.text,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: _DarkColors.text,
        height: 1.2,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _DarkColors.text,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _DarkColors.text,
        height: 1.3,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _DarkColors.text,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: _DarkColors.text,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _DarkColors.text,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _DarkColors.textSecondary,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _DarkColors.text,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _DarkColors.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: _DarkColors.textMuted,
        letterSpacing: 0.8,
      ),
    ),

    // ── app bar ──────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: _DarkColors.scaffold,
      foregroundColor: _DarkColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _DarkColors.text,
      ),
      iconTheme: const IconThemeData(color: _DarkColors.text, size: 24),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // ── bottom nav bar ───────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _DarkColors.surface,
      selectedItemColor: _DarkColors.primary,
      unselectedItemColor: _DarkColors.textMuted,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    // ── navigation bar (M3) ──────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _DarkColors.surface,
      indicatorColor: _DarkColors.primary.withOpacity(0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _DarkColors.primary, size: 24);
        }
        return const IconThemeData(color: _DarkColors.textMuted, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _DarkColors.primary,
          );
        }
        return GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: _DarkColors.textMuted,
        );
      }),
      elevation: 0,
    ),

    // ── cards ────────────────────────────────
    cardTheme: CardThemeData(
      color: _DarkColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _DarkColors.border),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── elevated button ──────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _DarkColors.primary,
        foregroundColor: Colors.black,
        disabledBackgroundColor: _DarkColors.border,
        disabledForegroundColor: _DarkColors.textMuted,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── outlined button ──────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _DarkColors.primary,
        side: const BorderSide(color: _DarkColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── text button ──────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _DarkColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── input decoration ─────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _DarkColors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: GoogleFonts.poppins(
        color: _DarkColors.textMuted,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.poppins(
        color: _DarkColors.textSecondary,
        fontSize: 14,
      ),
      floatingLabelStyle: GoogleFonts.poppins(
        color: _DarkColors.primary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      prefixIconColor: _DarkColors.textMuted,
      suffixIconColor: _DarkColors.textMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _DarkColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _DarkColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _DarkColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _DarkColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _DarkColors.error, width: 2),
      ),
    ),

    // ── switch ───────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.black;
        return _DarkColors.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _DarkColors.primary;
        }
        return _DarkColors.border;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // ── checkbox ─────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _DarkColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.black),
      side: const BorderSide(color: _DarkColors.border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),

    // ── divider ──────────────────────────────
    dividerTheme: const DividerThemeData(
      color: _DarkColors.divider,
      thickness: 0.5,
      space: 0,
    ),

    // ── chip ─────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: _DarkColors.surfaceVariant,
      selectedColor: _DarkColors.primary.withOpacity(0.2),
      labelStyle: GoogleFonts.poppins(fontSize: 13, color: _DarkColors.text),
      side: const BorderSide(color: _DarkColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // ── dialog ───────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: _DarkColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _DarkColors.text,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: _DarkColors.textSecondary,
        height: 1.5,
      ),
    ),

    // ── snack bar ────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _DarkColors.surface,
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: _DarkColors.text,
      ),
      actionTextColor: _DarkColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _DarkColors.border),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ── list tile ────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _DarkColors.text,
      ),
      subtitleTextStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: _DarkColors.textSecondary,
      ),
      iconColor: _DarkColors.textSecondary,
    ),

    // ── icon ─────────────────────────────────
    iconTheme: const IconThemeData(color: _DarkColors.textSecondary, size: 24),

    // ── progress indicator ───────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _DarkColors.primary,
      linearTrackColor: _DarkColors.surfaceVariant,
      circularTrackColor: _DarkColors.surfaceVariant,
    ),

    // ── floating action button ───────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _DarkColors.primary,
      foregroundColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
