import 'package:flutter/material.dart';

import 'app_palette.dart';

/// A user-selectable theme.
@immutable
class ThemePreset {
  /// Stable key used for persistence — never change these strings.
  final String id;
  final String label;
  final String description;
  final AppPalette palette;

  const ThemePreset({
    required this.id,
    required this.label,
    required this.description,
    required this.palette,
  });

  bool get isDark => palette.isDark;
}

/// The palettes Detoxia ships with.
///
/// Dark ones lead because the app is most often opened late at night, but the
/// light ones are first-class — every screen reads its colours from
/// [AppPalette], so nothing is hardcoded to a dark canvas.
abstract final class ThemePresets {
  // ── Dark: Aurora (default) ───────────────────────────────────────────────
  static const aurora = ThemePreset(
    id: 'aurora',
    label: 'Aurora',
    description: 'Deep blue-black with a calm periwinkle.',
    palette: AppPalette(
      isDark: true,
      canvas: Color(0xFF0E1119),
      canvasRaised: Color(0xFF141826),
      surface: Color(0xFF191E2C),
      surfaceRaised: Color(0xFF212736),
      surfaceHigh: Color(0xFF2A3143),
      borderSubtle: Color(0xFF262D3E),
      borderStrong: Color(0xFF39415A),
      accent: Color(0xFF7C8AFF),
      accentBright: Color(0xFF9AA4FF),
      accentDeep: Color(0xFF5A67D8),
      calm: Color(0xFF4FD1C5),
      textPrimary: Color(0xFFF2F4FA),
      textSecondary: Color(0xFFA7AFC4),
      textTertiary: Color(0xFF6E7793),
      onAccent: Color(0xFFFFFFFF),
      success: Color(0xFF5FD48A),
      warning: Color(0xFFF2B25C),
      danger: Color(0xFFF0857D),
      supportNeeded: Color(0xFFF0A85C),
      protectMoment: Color(0xFF8B7BFF),
    ),
  );

  // ── Dark: Midnight ───────────────────────────────────────────────────────
  static const midnight = ThemePreset(
    id: 'midnight',
    label: 'Midnight',
    description: 'Near-black and quiet, with a cool teal.',
    palette: AppPalette(
      isDark: true,
      canvas: Color(0xFF07090C),
      canvasRaised: Color(0xFF0D1116),
      surface: Color(0xFF121820),
      surfaceRaised: Color(0xFF19212B),
      surfaceHigh: Color(0xFF222C38),
      borderSubtle: Color(0xFF1E2731),
      borderStrong: Color(0xFF33404E),
      accent: Color(0xFF4FD1C5),
      accentBright: Color(0xFF7BE3D9),
      accentDeep: Color(0xFF2C9D93),
      calm: Color(0xFF7C8AFF),
      textPrimary: Color(0xFFEDF2F5),
      textSecondary: Color(0xFF9AA7B4),
      textTertiary: Color(0xFF64727F),
      onAccent: Color(0xFF04120F),
      success: Color(0xFF57C98A),
      warning: Color(0xFFE8AE5F),
      danger: Color(0xFFE8827B),
      supportNeeded: Color(0xFFE8A45E),
      protectMoment: Color(0xFF6FA8FF),
    ),
  );

  // ── Dark: Moss ───────────────────────────────────────────────────────────
  static const moss = ThemePreset(
    id: 'moss',
    label: 'Moss',
    description: 'Warm, earthy dark green.',
    palette: AppPalette(
      isDark: true,
      canvas: Color(0xFF0B1210),
      canvasRaised: Color(0xFF101A16),
      surface: Color(0xFF15211C),
      surfaceRaised: Color(0xFF1C2B24),
      surfaceHigh: Color(0xFF25382F),
      borderSubtle: Color(0xFF1F3129),
      borderStrong: Color(0xFF354C41),
      accent: Color(0xFF6BCF9F),
      accentBright: Color(0xFF8FE3BA),
      accentDeep: Color(0xFF429B70),
      calm: Color(0xFFE0B978),
      textPrimary: Color(0xFFEFF4F0),
      textSecondary: Color(0xFFA2B3A9),
      textTertiary: Color(0xFF6C7F74),
      onAccent: Color(0xFF04160D),
      success: Color(0xFF6BCF9F),
      warning: Color(0xFFE0B978),
      danger: Color(0xFFE3897E),
      supportNeeded: Color(0xFFE0A96B),
      protectMoment: Color(0xFF7FBFA8),
    ),
  );

  // ── Light: Sky (default) ─────────────────────────────────────────────────
  //
  // Detoxia's own look: white paper with a sky blue that reads as open and
  // unhurried rather than clinical. The accent is sky-600 rather than the
  // brighter sky-400 you'd reach for first — on white, 400 fails contrast for
  // button labels and small text.
  static const sky = ThemePreset(
    id: 'sky',
    label: 'Sky',
    description: 'White and open, with Detoxia blue.',
    palette: AppPalette(
      isDark: false,
      canvas: Color(0xFFFFFFFF),
      canvasRaised: Color(0xFFF5FAFD),
      surface: Color(0xFFF1F7FC),
      surfaceRaised: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFE1EFF9),
      borderSubtle: Color(0xFFDCEAF4),
      borderStrong: Color(0xFFB4D2E6),
      accent: Color(0xFF0284C7),
      accentBright: Color(0xFF38BDF8),
      accentDeep: Color(0xFF075985),
      calm: Color(0xFF0D9488),
      textPrimary: Color(0xFF0F1B24),
      textSecondary: Color(0xFF47606F),
      textTertiary: Color(0xFF7A93A3),
      onAccent: Color(0xFFFFFFFF),
      success: Color(0xFF12855A),
      warning: Color(0xFFB0741A),
      danger: Color(0xFFC64B45),
      supportNeeded: Color(0xFFB8701F),
      protectMoment: Color(0xFF4F46E5),
    ),
  );

  // ── Light: Paper ─────────────────────────────────────────────────────────
  static const paper = ThemePreset(
    id: 'paper',
    label: 'Paper',
    description: 'White background, near-black text.',
    palette: AppPalette(
      isDark: false,
      canvas: Color(0xFFFFFFFF),
      canvasRaised: Color(0xFFF7F8FA),
      surface: Color(0xFFF5F6F9),
      surfaceRaised: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFE9ECF2),
      borderSubtle: Color(0xFFE2E6EC),
      borderStrong: Color(0xFFC3CAD4),
      accent: Color(0xFF4F5BD5),
      accentBright: Color(0xFF6B76E8),
      accentDeep: Color(0xFF3A44A8),
      calm: Color(0xFF13897E),
      textPrimary: Color(0xFF12141A),
      textSecondary: Color(0xFF4C5462),
      textTertiary: Color(0xFF79818F),
      onAccent: Color(0xFFFFFFFF),
      success: Color(0xFF1E8A55),
      warning: Color(0xFFB0741A),
      danger: Color(0xFFC64B45),
      supportNeeded: Color(0xFFB8701F),
      protectMoment: Color(0xFF6355C8),
    ),
  );

  // ── Light: Linen ─────────────────────────────────────────────────────────
  static const linen = ThemePreset(
    id: 'linen',
    label: 'Linen',
    description: 'Warm off-white, easy on the eyes.',
    palette: AppPalette(
      isDark: false,
      canvas: Color(0xFFFBF9F5),
      canvasRaised: Color(0xFFF5F2EC),
      surface: Color(0xFFF3EFE8),
      surfaceRaised: Color(0xFFFFFDFA),
      surfaceHigh: Color(0xFFE8E2D8),
      borderSubtle: Color(0xFFE5DFD4),
      borderStrong: Color(0xFFC8BFB0),
      accent: Color(0xFF9A5B3D),
      accentBright: Color(0xFFB87352),
      accentDeep: Color(0xFF77432B),
      calm: Color(0xFF4A7C6B),
      textPrimary: Color(0xFF1C1917),
      textSecondary: Color(0xFF57504A),
      textTertiary: Color(0xFF877F76),
      onAccent: Color(0xFFFFFFFF),
      success: Color(0xFF3E7A52),
      warning: Color(0xFFA9761D),
      danger: Color(0xFFB55247),
      supportNeeded: Color(0xFFA9711F),
      protectMoment: Color(0xFF7A5CA8),
    ),
  );

  // ── Light: Mist ──────────────────────────────────────────────────────────
  static const mist = ThemePreset(
    id: 'mist',
    label: 'Mist',
    description: 'Cool, soft grey-blue daylight.',
    palette: AppPalette(
      isDark: false,
      canvas: Color(0xFFF7F9FC),
      canvasRaised: Color(0xFFEFF3F8),
      surface: Color(0xFFECF1F7),
      surfaceRaised: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFDDE5EF),
      borderSubtle: Color(0xFFDCE3EC),
      borderStrong: Color(0xFFB6C2D2),
      accent: Color(0xFF2F6BD8),
      accentBright: Color(0xFF4C85EE),
      accentDeep: Color(0xFF1F4E9E),
      calm: Color(0xFF0F8C86),
      textPrimary: Color(0xFF101724),
      textSecondary: Color(0xFF48566B),
      textTertiary: Color(0xFF75839A),
      onAccent: Color(0xFFFFFFFF),
      success: Color(0xFF18804F),
      warning: Color(0xFFA96F16),
      danger: Color(0xFFC0473F),
      supportNeeded: Color(0xFFAF6A1B),
      protectMoment: Color(0xFF5052C4),
    ),
  );

  // ── Rose (cycle tracking) ────────────────────────────────────────────────
  static const rose = ThemePreset(
    id: 'rose',
    label: 'Rose',
    description: 'Soft plum — the cycle-tracking look.',
    palette: AppPalette(
      isDark: true,
      canvas: Color(0xFF17101A),
      canvasRaised: Color(0xFF1F1624),
      surface: Color(0xFF271B2D),
      surfaceRaised: Color(0xFF322038),
      surfaceHigh: Color(0xFF3E2847),
      borderSubtle: Color(0xFF352340),
      borderStrong: Color(0xFF4C3356),
      accent: Color(0xFFFF8FB1),
      accentBright: Color(0xFFFFA9C4),
      accentDeep: Color(0xFFD96A8C),
      calm: Color(0xFF4FD1C5),
      textPrimary: Color(0xFFF7F0F4),
      textSecondary: Color(0xFFBCA8B6),
      textTertiary: Color(0xFF8A7686),
      onAccent: Color(0xFF2A0F1B),
      success: Color(0xFF5FD48A),
      warning: Color(0xFFF2B25C),
      danger: Color(0xFFF0857D),
      supportNeeded: Color(0xFFF0A85C),
      protectMoment: Color(0xFFC08BE8),
    ),
  );

  static const List<ThemePreset> all = [
    sky,
    paper,
    linen,
    mist,
    aurora,
    midnight,
    moss,
    rose,
  ];

  /// Detoxia's default look, and what `AppTheme.palette` returns for any
  /// widget rendered outside a themed subtree.
  static const ThemePreset fallback = sky;

  static List<ThemePreset> get dark =>
      all.where((preset) => preset.isDark).toList(growable: false);

  static List<ThemePreset> get light =>
      all.where((preset) => !preset.isDark).toList(growable: false);

  static ThemePreset byId(String? id) {
    for (final preset in all) {
      if (preset.id == id) return preset;
    }
    return fallback;
  }
}
