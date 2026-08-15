import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme chooser.
///
/// Selecting a palette applies it immediately to the whole app rather than
/// on a Save button — the surrounding screen *is* the preview, which is the
/// only honest way to judge a colour scheme.
class ThemePickerScreen extends ConsumerWidget {
  const ThemePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = AppTheme.palette(context);
    final current = ref.watch(activeThemeProvider.notifier).preset;

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text(
            'Pick what feels easiest to look at. Sky is the Detoxia default, '
            'but the dark palettes are worth a look if you mostly open the '
            'app late at night.',
            style: TextStyle(
              color: p.textSecondary,
              fontSize: 14.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),
          _GroupLabel('Light', palette: p),
          const SizedBox(height: 12),
          for (final preset in ThemePresets.light) ...[
            _PresetCard(
              preset: preset,
              selected: preset.id == current.id,
              onTap: () => ref
                  .read(activeThemeProvider.notifier)
                  .selectPreset(preset),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 14),
          _GroupLabel('Dark', palette: p),
          const SizedBox(height: 12),
          for (final preset in ThemePresets.dark) ...[
            _PresetCard(
              preset: preset,
              selected: preset.id == current.id,
              onTap: () => ref
                  .read(activeThemeProvider.notifier)
                  .selectPreset(preset),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  final AppPalette palette;

  const _GroupLabel(this.label, {required this.palette});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: palette.textTertiary,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}

/// One selectable palette, rendered in its *own* colours so the row shows
/// what it will actually look like rather than describing it in words.
class _PresetCard extends StatelessWidget {
  final ThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  const _PresetCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = AppTheme.palette(context);
    final p = preset.palette;

    return Semantics(
      selected: selected,
      button: true,
      label: '${preset.label} theme',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? active.accent : active.borderSubtle,
                width: selected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: p.canvas,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            preset.label,
                            style: TextStyle(
                              color: p.textPrimary,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (selected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: p.accent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'In use',
                              style: TextStyle(
                                color: p.onAccent,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preset.description,
                      style: TextStyle(
                        color: p.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Miniature of a real Detoxia card, in this palette.
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: p.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: p.accentSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.bolt_rounded,
                              size: 18,
                              color: p.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 8,
                                  width: 96,
                                  decoration: BoxDecoration(
                                    color: p.textPrimary.withValues(alpha: .82),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 7,
                                  width: 148,
                                  decoration: BoxDecoration(
                                    color: p.textTertiary.withValues(alpha: .6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Swatch(color: p.accent, label: 'Accent'),
                        _Swatch(color: p.calm, label: 'Calm'),
                        _Swatch(color: p.success, label: 'Good'),
                        _Swatch(color: p.warning, label: 'Watch'),
                        _Swatch(color: p.danger, label: 'Alert'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final String label;

  const _Swatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        label: label,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
