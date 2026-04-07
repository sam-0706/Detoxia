import 'package:detoxia/core/constants/enums.dart';

class PhaseRecommendations {
  final String exercise;
  final String nutrition;
  final String selfCare;
  final String social;
  final String energy;

  const PhaseRecommendations({
    required this.exercise,
    required this.nutrition,
    required this.selfCare,
    required this.social,
    required this.energy,
  });
}

class PhaseEngine {
  const PhaseEngine._();

  static PhaseRecommendations recommendations(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => const PhaseRecommendations(
          exercise:
              'Gentle yoga, light stretching, or leisurely walks. '
              'Honor your body\'s need for rest — avoid intense workouts.',
          nutrition:
              'Iron-rich foods (spinach, lentils, red meat), vitamin C to aid '
              'absorption, warm soups, and anti-inflammatory turmeric or ginger tea.',
          selfCare:
              'Prioritize rest and sleep. Use a heating pad for cramps, '
              'take warm baths, journal, and give yourself permission to slow down.',
          social:
              'Cozy activities with close friends — movie nights, low-key '
              'hangouts, or phone calls. Skip large social gatherings if drained.',
          energy:
              'Energy is at its lowest. This is your inner winter — rest is '
              'productive. Listen to your body and conserve energy.',
        ),
      CyclePhase.follicular => const PhaseRecommendations(
          exercise:
              'Try new workouts! Cardio, dance, HIIT, or hiking. Your body '
              'is primed for endurance and learning new movement patterns.',
          nutrition:
              'Fresh, light meals: salads, lean proteins, fermented foods. '
              'Estrogen is rising — support gut health and metabolism.',
          selfCare:
              'Start creative projects, plan ahead, brainstorm. Your brain '
              'is sharper and more open to novelty during this phase.',
          social:
              'Great time for social events, networking, and meeting new people. '
              'Your communication skills and confidence are on the rise.',
          energy:
              'Energy is rising steadily. This is your inner spring — take '
              'advantage of growing motivation and optimism.',
        ),
      CyclePhase.ovulation => const PhaseRecommendations(
          exercise:
              'High-intensity interval training, spin classes, competitive '
              'sports. Peak strength and endurance — push yourself.',
          nutrition:
              'Antioxidant-rich foods (berries, leafy greens), lighter carbs, '
              'and raw vegetables. Support your liver with cruciferous veggies.',
          selfCare:
              'Schedule important meetings, difficult conversations, and '
              'presentations. Your verbal fluency and charisma peak here.',
          social:
              'Communication peak — ideal for date nights, job interviews, '
              'team collaboration, and deepening connections.',
          energy:
              'Peak energy and confidence. This is your inner summer — '
              'you\'re magnetic and at your most expressive.',
        ),
      CyclePhase.luteal => const PhaseRecommendations(
          exercise:
              'Strength training, Pilates, moderate steady-state cardio. '
              'In the second half, transition to gentler movement.',
          nutrition:
              'Complex carbs (sweet potatoes, whole grains), magnesium-rich '
              'foods (dark chocolate, nuts, seeds), and B6 (bananas, chickpeas).',
          selfCare:
              'Nesting activities — organize your space, batch-cook meals, '
              'do detail-oriented tasks. Prioritize sleep hygiene.',
          social:
              'Smaller gatherings and quality one-on-one time. You may feel '
              'more introspective — honor the need for solitude.',
          energy:
              'Energy gradually declines. This is your inner autumn — '
              'focus on wrapping things up and preparing for rest.',
        ),
    };
  }
}
