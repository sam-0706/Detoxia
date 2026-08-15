import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/presentation/questionnaire/games/breathing_orb_game.dart';
import 'package:detoxia/presentation/questionnaire/games/calm_collector_game.dart';
import 'package:detoxia/presentation/questionnaire/games/focus_tap_game.dart';
import 'package:detoxia/presentation/questionnaire/games/mood_wave_game.dart';
import 'package:detoxia/presentation/questionnaire/games/pattern_match_game.dart';
import 'package:detoxia/presentation/questionnaire/games/shield_build_game.dart';
import 'package:flutter/material.dart';

/// Offers an optional micro-game reset between questionnaire sections.
class MicroGameHost extends StatelessWidget {
  final VoidCallback onDone;

  /// When set, selects the game deterministically (0–3) for tests.
  final int? seed;

  /// Number of sections completed — used to rotate games when [seed] is null.
  final int sectionsCompleted;

  const MicroGameHost({
    super.key,
    required this.onDone,
    this.seed,
    this.sectionsCompleted = 0,
  });

  int _gameIndex() {
    if (seed != null) return seed! % 6;
    return sectionsCompleted % 6;
  }

  void _playGame(BuildContext context) {
    final index = _gameIndex();
    final Widget game;
    switch (index) {
      case 0:
        game = FocusTapGame(onDone: () => _finishGame(context));
      case 1:
        game = BreathingOrbGame(onDone: () => _finishGame(context));
      case 2:
        game = PatternMatchGame(onDone: () => _finishGame(context));
      case 3:
        game = ShieldBuildGame(onDone: () => _finishGame(context));
      case 4:
        game = CalmCollectorGame(onDone: () => _finishGame(context));
      case 5:
        game = MoodWaveGame(onDone: () => _finishGame(context));
      default:
        game = FocusTapGame(onDone: () => _finishGame(context));
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => game),
    );
  }

  void _finishGame(BuildContext context) {
    Navigator.of(context).pop();
    onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.92),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Card(
              color: AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.9),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sports_esports_outlined,
                      size: 48,
                      color: AppTheme.palette(context).accent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Want a 15-second reset?',
                      style: TextStyle(
                        color: AppTheme.palette(context).textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You can also skip.',
                      style: TextStyle(
                        color: AppTheme.palette(context).textSecondary,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _playGame(context),
                        child: const Text('Play'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onDone,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.palette(context).textSecondary,
                          side:  BorderSide(color: AppTheme.palette(context).borderStrong),
                        ),
                        child: const Text('Skip'),
                      ),
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
