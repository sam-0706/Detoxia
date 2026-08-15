import 'package:flutter/material.dart';

/// Semantic colour tokens for Detoxia.
///
/// Widgets read these via `AppTheme.palette(context)` rather than hardcoding
/// a literal colour, so that every screen follows the theme the user picked —
/// including the light ones, where a hardcoded white text colour would be
/// invisible.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Whether this palette sits on a dark canvas. Drives things a colour token
  /// can't express on its own — scrim opacity, elevation shadows, the status
  /// bar icon brightness.
  final bool isDark;

  // ── Canvas ──────────────────────────────────────────────────────────────
  /// Scaffold background — the base layer.
  final Color canvas;

  /// Slightly shifted background used behind grouped content.
  final Color canvasRaised;

  /// Default card / panel fill.
  final Color surface;

  /// Elevated card fill (sits on top of [surface]).
  final Color surfaceRaised;

  /// Selected / pressed fill.
  final Color surfaceHigh;

  // ── Lines ───────────────────────────────────────────────────────────────
  final Color borderSubtle;
  final Color borderStrong;

  // ── Brand ───────────────────────────────────────────────────────────────
  final Color accent;
  final Color accentBright;
  final Color accentDeep;

  /// Calm / progress hue — breathing, grounding, "you're on track".
  final Color calm;

  // ── Text ────────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  /// Text that sits on top of [accent] (filled buttons, badges).
  final Color onAccent;

  // ── Semantic ────────────────────────────────────────────────────────────
  //
  // Tuned per palette rather than shared: mint that reads well on a near-black
  // canvas is far too pale on white.
  final Color success;
  final Color warning;
  final Color danger;
  final Color supportNeeded;
  final Color protectMoment;

  const AppPalette({
    required this.isDark,
    required this.canvas,
    required this.canvasRaised,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceHigh,
    required this.borderSubtle,
    required this.borderStrong,
    required this.accent,
    required this.accentBright,
    required this.accentDeep,
    required this.calm,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.onAccent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.supportNeeded,
    required this.protectMoment,
  });

  /// Translucent accent wash used for selected option fills.
  Color get accentSoft => accent.withValues(alpha: isDark ? 0.16 : 0.10);

  /// Even fainter accent wash for large surfaces.
  Color get accentWhisper => accent.withValues(alpha: isDark ? 0.08 : 0.05);

  /// Full-screen dimmer behind modals and overlays.
  Color get scrim => canvas.withValues(alpha: isDark ? 0.90 : 0.75);

  /// Soft tint of a semantic colour, for card fills behind status text.
  Color tintOf(Color color) =>
      color.withValues(alpha: isDark ? 0.16 : 0.12);

  /// Risk colour ramp — calm through to the softened alert tone. Deliberately
  /// never a clinical red: this app asks people to be honest about how badly
  /// things are going, and colouring the honest answer as danger discourages it.
  Color riskColor(double score) {
    if (score < 0.3) return success;
    if (score < 0.5) return Color.lerp(success, warning, 0.5)!;
    if (score < 0.7) return warning;
    if (score < 0.85) return Color.lerp(warning, danger, 0.5)!;
    return danger;
  }

  @override
  AppPalette copyWith({
    bool? isDark,
    Color? canvas,
    Color? canvasRaised,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceHigh,
    Color? borderSubtle,
    Color? borderStrong,
    Color? accent,
    Color? accentBright,
    Color? accentDeep,
    Color? calm,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? onAccent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? supportNeeded,
    Color? protectMoment,
  }) {
    return AppPalette(
      isDark: isDark ?? this.isDark,
      canvas: canvas ?? this.canvas,
      canvasRaised: canvasRaised ?? this.canvasRaised,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      accent: accent ?? this.accent,
      accentBright: accentBright ?? this.accentBright,
      accentDeep: accentDeep ?? this.accentDeep,
      calm: calm ?? this.calm,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      supportNeeded: supportNeeded ?? this.supportNeeded,
      protectMoment: protectMoment ?? this.protectMoment,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      isDark: t < 0.5 ? isDark : other.isDark,
      canvas: c(canvas, other.canvas),
      canvasRaised: c(canvasRaised, other.canvasRaised),
      surface: c(surface, other.surface),
      surfaceRaised: c(surfaceRaised, other.surfaceRaised),
      surfaceHigh: c(surfaceHigh, other.surfaceHigh),
      borderSubtle: c(borderSubtle, other.borderSubtle),
      borderStrong: c(borderStrong, other.borderStrong),
      accent: c(accent, other.accent),
      accentBright: c(accentBright, other.accentBright),
      accentDeep: c(accentDeep, other.accentDeep),
      calm: c(calm, other.calm),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      onAccent: c(onAccent, other.onAccent),
      success: c(success, other.success),
      warning: c(warning, other.warning),
      danger: c(danger, other.danger),
      supportNeeded: c(supportNeeded, other.supportNeeded),
      protectMoment: c(protectMoment, other.protectMoment),
    );
  }
}
