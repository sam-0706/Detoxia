import 'package:detoxia/core/constants/enums.dart';

class BreathingStep {
  final String action; // 'inhale', 'hold', 'exhale'
  final int seconds;

  const BreathingStep({required this.action, required this.seconds});
}

class BreathingTechniqueData {
  final BreathingTechnique id;
  final String name;
  final String description;
  final List<BreathingStep> steps;
  final int totalDurationSeconds;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'

  const BreathingTechniqueData({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.totalDurationSeconds,
    required this.difficulty,
  });
}

const breathingTechniques = <BreathingTechniqueData>[
  BreathingTechniqueData(
    id: BreathingTechnique.boxBreathing,
    name: 'Box Breathing',
    description:
        'Equal-length inhale, hold, exhale, and hold. Used by Navy SEALs '
        'to stay calm under pressure.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'hold', seconds: 4),
      BreathingStep(action: 'exhale', seconds: 4),
      BreathingStep(action: 'hold', seconds: 4),
    ],
    totalDurationSeconds: 240,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.breathing478,
    name: '4-7-8 Breathing',
    description:
        'A relaxation technique that activates the parasympathetic nervous '
        'system. Excellent for falling asleep or calming acute anxiety.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'hold', seconds: 7),
      BreathingStep(action: 'exhale', seconds: 8),
    ],
    totalDurationSeconds: 228,
    difficulty: 'intermediate',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.physiologicalSigh,
    name: 'Physiological Sigh',
    description:
        'A double inhale through the nose followed by a long exhale. '
        'The fastest known method to reduce real-time stress.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 2),
      BreathingStep(action: 'inhale', seconds: 1),
      BreathingStep(action: 'exhale', seconds: 6),
    ],
    totalDurationSeconds: 180,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.cyclicSighing,
    name: 'Cyclic Sighing',
    description:
        'Repeated physiological sighs for 5 minutes. Stanford research '
        'shows this reduces anxiety more effectively than meditation.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 2),
      BreathingStep(action: 'inhale', seconds: 1),
      BreathingStep(action: 'exhale', seconds: 6),
    ],
    totalDurationSeconds: 300,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.extendedExhale,
    name: 'Extended Exhale',
    description:
        'Inhale for 4 seconds, exhale for 8. The longer exhale activates '
        'the vagus nerve and signals your body to relax.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'exhale', seconds: 8),
    ],
    totalDurationSeconds: 240,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.bellyBreathing,
    name: 'Belly Breathing',
    description:
        'Deep diaphragmatic breathing. Place one hand on your chest and '
        'one on your belly — only the belly hand should rise.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'exhale', seconds: 6),
    ],
    totalDurationSeconds: 300,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.alternateNostril,
    name: 'Alternate Nostril Breathing',
    description:
        'Breathe in through one nostril, out through the other. Balances '
        'the autonomic nervous system and quiets racing thoughts.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'hold', seconds: 2),
      BreathingStep(action: 'exhale', seconds: 4),
    ],
    totalDurationSeconds: 300,
    difficulty: 'intermediate',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.resonanceBreathing,
    name: 'Resonance Breathing',
    description:
        'Breathe at ~5.5-second inhale and exhale cycles (about 5.5 '
        'breaths per minute). Optimises heart-rate variability.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 6),
      BreathingStep(action: 'exhale', seconds: 6),
    ],
    totalDurationSeconds: 360,
    difficulty: 'intermediate',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.starfishBreathing,
    name: 'Starfish Breathing',
    description:
        'Trace the outline of your hand with your finger — breathe in '
        'going up each finger, breathe out going down. Great for kids '
        'and beginners.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 3),
      BreathingStep(action: 'exhale', seconds: 3),
    ],
    totalDurationSeconds: 150,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.squareBreathing,
    name: 'Square Breathing',
    description:
        'A variation of box breathing with slightly longer phases. '
        'Visualise drawing a square as you breathe through each side.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 5),
      BreathingStep(action: 'hold', seconds: 5),
      BreathingStep(action: 'exhale', seconds: 5),
      BreathingStep(action: 'hold', seconds: 5),
    ],
    totalDurationSeconds: 300,
    difficulty: 'intermediate',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.lionsBreath,
    name: "Lion's Breath",
    description:
        'Inhale deeply through the nose, then exhale forcefully with '
        'mouth wide open and tongue out. Releases jaw tension and stress.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'exhale', seconds: 3),
    ],
    totalDurationSeconds: 180,
    difficulty: 'beginner',
  ),
  BreathingTechniqueData(
    id: BreathingTechnique.hummingBeeBreath,
    name: 'Humming Bee Breath',
    description:
        'Inhale deeply, then hum on the exhale with lips closed. The '
        'vibration stimulates the vagus nerve and calms the mind.',
    steps: [
      BreathingStep(action: 'inhale', seconds: 4),
      BreathingStep(action: 'exhale', seconds: 8),
    ],
    totalDurationSeconds: 240,
    difficulty: 'intermediate',
  ),
];
