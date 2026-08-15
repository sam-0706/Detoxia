import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_palette.dart';
import 'theme_presets.dart';

export 'app_palette.dart';
export 'theme_presets.dart';

class AppTheme {
  AppTheme._();

  /// Semantic tokens for the active theme.
  ///
  /// Falls back to the default palette so widgets rendered outside a themed
  /// subtree (and older widget tests) keep working.
  static AppPalette palette(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? ThemePresets.fallback.palette;

  static ThemeData themeFor(ThemePreset preset) => _build(preset.palette);

  static ThemeData fromId(String? id) => themeFor(ThemePresets.byId(id));

  static ThemeData _build(AppPalette p) {
    final scheme = p.isDark
        ? ColorScheme.dark(
            primary: p.accent,
            onPrimary: p.onAccent,
            secondary: p.calm,
            surface: p.surface,
            onSurface: p.textPrimary,
            error: p.danger,
          )
        : ColorScheme.light(
            primary: p.accent,
            onPrimary: p.onAccent,
            secondary: p.calm,
            surface: p.surface,
            onSurface: p.textPrimary,
            error: p.danger,
          );

    return ThemeData(
      brightness: p.isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: p.canvas,
      canvasColor: p.canvas,
      primaryColor: p.accent,
      splashFactory: InkSparkle.splashFactory,
      extensions: <ThemeExtension<dynamic>>[p],
      colorScheme: scheme,
      cardTheme: CardThemeData(
        color: p.surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.borderSubtle),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.canvas,
        foregroundColor: p.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: p.textPrimary,
        ),
      ),
      iconTheme: IconThemeData(color: p.textSecondary),
      dividerTheme: DividerThemeData(color: p.borderSubtle, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: p.onAccent,
          disabledBackgroundColor: p.surfaceHigh,
          disabledForegroundColor: p.textTertiary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.textSecondary,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.textPrimary,
          side: BorderSide(color: p.borderSubtle),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        elevation: 0,
        extendedTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.canvasRaised,
        selectedItemColor: p.accent,
        unselectedItemColor: p.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? p.accent
              : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(p.onAccent),
        side: BorderSide(color: p.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? p.onAccent
              : p.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? p.accent
              : p.surfaceHigh,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.canvasRaised,
        surfaceTintColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.textSecondary,
        textColor: p.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        labelStyle: TextStyle(color: p.textSecondary),
        floatingLabelStyle: TextStyle(color: p.accent),
        hintStyle: TextStyle(color: p.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.danger, width: 1.6),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.accent,
        linearTrackColor: p.surfaceHigh,
        circularTrackColor: p.surfaceHigh,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.isDark ? p.surfaceHigh : p.textPrimary,
        contentTextStyle: TextStyle(color: p.isDark ? p.textPrimary : p.canvas),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
          height: 1.15,
          color: p.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          height: 1.2,
          color: p.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.25,
          color: p.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: p.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.35,
          color: p.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: p.textSecondary),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: p.textSecondary),
        bodySmall: TextStyle(fontSize: 12.5, height: 1.4, color: p.textTertiary),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: p.textTertiary,
        ),
      ),
    );
  }

  // ── Legacy static accessors ────────────────────────────────────────────
  //
  // Context-free, so they cannot follow the user's theme — they always return
  // the default dark palette. Prefer `AppTheme.palette(context).<token>`;
  // these remain only for call sites that have no BuildContext.
  static AppPalette get _d => ThemePresets.fallback.palette;

  static Color get success => _d.success;
  static Color get warning => _d.warning;
  static Color get danger => _d.danger;
  static Color get supportNeeded => _d.supportNeeded;
  static Color get protectMoment => _d.protectMoment;
  static Color get accent => _d.accent;
  static Color get calm => _d.calm;
  static Color get pinkAccent => ThemePresets.rose.palette.accent;
  static Color get card => _d.surfaceRaised;
  static Color get surface => _d.surface;

  static Color riskColor(double score) => _d.riskColor(score);

  static ThemeData get darkTheme => themeFor(ThemePresets.aurora);
  static ThemeData get pinkTheme => themeFor(ThemePresets.rose);
}

// ── Active theme, persisted across launches ────────────────────────────────

const _themePrefsKey = 'detoxia.theme.preset';

class ActiveThemeNotifier extends Notifier<ThemeData> {
  ThemePreset _preset = ThemePresets.fallback;

  ThemePreset get preset => _preset;

  @override
  ThemeData build() {
    _restore();
    return AppTheme.themeFor(_preset);
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_themePrefsKey);
      if (saved == null) return;
      final preset = ThemePresets.byId(saved);
      if (preset.id == _preset.id) return;
      _preset = preset;
      state = AppTheme.themeFor(preset);
    } catch (_) {
      // A missing preference store is not worth failing app start over.
    }
  }

  /// Switches theme and remembers the choice.
  Future<void> selectPreset(ThemePreset preset) async {
    _preset = preset;
    state = AppTheme.themeFor(preset);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefsKey, preset.id);
    } catch (_) {}
  }

  /// Applies a theme without persisting — used for the cycle-tracking default,
  /// which should never overwrite a theme the user picked themselves.
  void applyDefault(ThemePreset preset) {
    _preset = preset;
    state = AppTheme.themeFor(preset);
  }

  /// True once the user has explicitly chosen a theme.
  static Future<bool> hasUserChoice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_themePrefsKey) != null;
    } catch (_) {
      return false;
    }
  }

  void setTheme(ThemeData theme) => state = theme;
}

final activeThemeProvider =
    NotifierProvider<ActiveThemeNotifier, ThemeData>(ActiveThemeNotifier.new);
