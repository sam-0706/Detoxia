import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/presentation/settings/theme_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _scrollTo(WidgetTester tester, String label) async {
  // Rewind to the top first — the search below only walks downward, and the
  // caller may already be scrolled past the target from a previous step.
  for (var i = 0; i < 20; i++) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 400));
    await tester.pumpAndSettle();
  }

  for (var i = 0; i < 20; i++) {
    if (find.text(label).evaluate().isNotEmpty) {
      // Present in the tree isn't the same as tappable — it may be clipped at
      // the edge of the viewport, which makes tap() miss.
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      return;
    }
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -260));
    await tester.pumpAndSettle();
  }
  fail('never scrolled "$label" into view');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Widget host() => ProviderScope(
    child: Consumer(
      builder: (context, ref, _) => MaterialApp(
        theme: ref.watch(activeThemeProvider),
        home: const ThemePickerScreen(),
      ),
    ),
  );

  testWidgets('lists every preset, grouped by brightness', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    // Light leads now that Sky is the default look.
    expect(find.text('LIGHT'), findsOneWidget);

    // The preview cards run well past one screen. Step through in fixed
    // drags collecting what's on screen, rather than scrollUntilVisible —
    // that helper throws once a target scrolls out the far side.
    final seen = <String>{};
    void collect() {
      for (final preset in ThemePresets.all) {
        if (find.text(preset.label).evaluate().isNotEmpty) {
          seen.add(preset.label);
        }
      }
      for (final group in const ['LIGHT', 'DARK']) {
        if (find.text(group).evaluate().isNotEmpty) seen.add(group);
      }
    }

    collect();
    for (var i = 0; i < 20 && seen.length < ThemePresets.all.length + 2; i++) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -260));
      await tester.pumpAndSettle();
      collect();
    }

    for (final preset in ThemePresets.all) {
      expect(seen, contains(preset.label),
          reason: '${preset.label} should be offered');
    }
    expect(seen, containsAll(<String>['LIGHT', 'DARK']));
  });

  testWidgets('choosing a light palette rethemes the app', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    // Sky (light) is the default, so prove the switch by starting from a dark
    // palette and confirming the picker moves us to a light one.
    await _scrollTo(tester, 'Aurora');
    await tester.tap(find.text('Aurora'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.brightness,
      Brightness.dark,
    );

    await _scrollTo(tester, 'Paper');
    await tester.tap(find.text('Paper'));
    await tester.pumpAndSettle();

    final after = tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;
    expect(after.brightness, Brightness.light);
    expect(
      after.extension<AppPalette>()!.canvas,
      ThemePresets.paper.palette.canvas,
    );
    expect(find.text('In use'), findsOneWidget);
  });

  testWidgets('the choice is persisted', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    await _scrollTo(tester, 'Mist');
    await tester.tap(find.text('Mist'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('detoxia.theme.preset'), 'mist');
    expect(await ActiveThemeNotifier.hasUserChoice(), isTrue);
  });

  test('every palette keeps text readable against its own canvas', () {
    // A light palette that kept a dark palette's text colour would compile
    // and look broken, so assert the contrast direction explicitly.
    for (final preset in ThemePresets.all) {
      final p = preset.palette;
      final canvasLum = p.canvas.computeLuminance();
      final textLum = p.textPrimary.computeLuminance();
      final contrast = (textLum > canvasLum)
          ? (textLum + 0.05) / (canvasLum + 0.05)
          : (canvasLum + 0.05) / (textLum + 0.05);

      expect(
        p.isDark,
        canvasLum < 0.5,
        reason: '${preset.label}: isDark disagrees with its canvas',
      );
      expect(
        contrast,
        greaterThan(7.0),
        reason: '${preset.label}: primary text contrast is only '
            '${contrast.toStringAsFixed(1)}:1',
      );
    }
  });

  test('secondary text and accents stay legible too', () {
    for (final preset in ThemePresets.all) {
      final p = preset.palette;
      final canvasLum = p.canvas.computeLuminance();

      double ratio(Color c) {
        final l = c.computeLuminance();
        return l > canvasLum
            ? (l + 0.05) / (canvasLum + 0.05)
            : (canvasLum + 0.05) / (l + 0.05);
      }

      expect(
        ratio(p.textSecondary),
        greaterThan(4.5),
        reason: '${preset.label}: secondary text too faint',
      );
      // Accent carries buttons and links, so it needs to clear large-text AA.
      expect(
        ratio(p.accent),
        greaterThan(3.0),
        reason: '${preset.label}: accent too close to the canvas',
      );
      // Text sitting *on* the accent must read as well.
      final onAccentLum = p.onAccent.computeLuminance();
      final accentLum = p.accent.computeLuminance();
      final onAccentRatio = onAccentLum > accentLum
          ? (onAccentLum + 0.05) / (accentLum + 0.05)
          : (accentLum + 0.05) / (onAccentLum + 0.05);
      expect(
        onAccentRatio,
        greaterThan(3.0),
        reason: '${preset.label}: onAccent unreadable on accent',
      );
    }
  });
}
