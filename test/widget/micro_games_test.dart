import 'package:detoxia/presentation/questionnaire/games/breathing_orb_game.dart';
import 'package:detoxia/presentation/questionnaire/games/focus_tap_game.dart';
import 'package:detoxia/presentation/questionnaire/games/micro_game_host.dart';
import 'package:detoxia/presentation/questionnaire/games/pattern_match_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('1. MicroGameHost shows Play and Skip buttons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MicroGameHost(onDone: () {}),
      ),
    );

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.textContaining('15-second reset'), findsOneWidget);
  });

  testWidgets('2. Tapping Skip calls onDone without playing a game', (
    tester,
  ) async {
    var done = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MicroGameHost(onDone: () => done = true),
      ),
    );

    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(done, isTrue);
    expect(find.byType(FocusTapGame), findsNothing);
  });

  testWidgets('3. Tapping Play opens one of the four games', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MicroGameHost(
          onDone: () {},
          seed: 0,
        ),
      ),
    );

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.textContaining('glowing dots'), findsOneWidget);
  });

  testWidgets('4. FocusTapGame onDone fires after roughly 10 s', (
    tester,
  ) async {
    var done = false;

    await tester.pumpWidget(
      MaterialApp(
        home: FocusTapGame(
          onDone: () => done = true,
          dotLifetime: const Duration(milliseconds: 1500),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 8500));

    expect(done, isTrue);
  });

  testWidgets('5. BreathingOrbGame onDone fires after 2 cycles in tap-only mode', (
    tester,
  ) async {
    var done = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BreathingOrbGame(
          onDone: () => done = true,
          tapOnlyMode: true,
        ),
      ),
    );

    await tester.pump();

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
    }

    await tester.pump(const Duration(milliseconds: 700));

    expect(done, isTrue);
  });

  testWidgets('6. PatternMatchGame completes when all 3 pairs matched', (
    tester,
  ) async {
    var done = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PatternMatchGame(onDone: () => done = true),
      ),
    );

    await tester.pump();

    Future<void> matchPair(String left, String right) async {
      await tester.tap(find.text(left));
      await tester.pump();
      await tester.tap(find.text(right));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    await matchPair('Stress', 'Scrolling');
    await matchPair('Poor sleep', 'Low control');
    await matchPair('Boredom', 'Reels → Urge');

    await tester.pump(const Duration(milliseconds: 800));

    expect(done, isTrue);
    expect(find.textContaining('Pattern detected'), findsOneWidget);
  });
}
