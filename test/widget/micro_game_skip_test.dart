import 'package:detoxia/presentation/questionnaire/games/breathing_orb_game.dart';
import 'package:detoxia/presentation/questionnaire/games/focus_tap_game.dart';
import 'package:detoxia/presentation/questionnaire/games/micro_game_host.dart';
import 'package:detoxia/presentation/questionnaire/games/pattern_match_game.dart';
import 'package:detoxia/presentation/questionnaire/games/shield_build_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MicroGameHost Skip fires onDone without rendering a game', (
    tester,
  ) async {
    var done = false;

    await tester.pumpWidget(
      MaterialApp(home: MicroGameHost(onDone: () => done = true)),
    );

    expect(find.text('Want a 15-second reset?'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(done, isTrue);
    expect(find.byType(FocusTapGame), findsNothing);
    expect(find.byType(BreathingOrbGame), findsNothing);
    expect(find.byType(PatternMatchGame), findsNothing);
    expect(find.byType(ShieldBuildGame), findsNothing);
  });
}
