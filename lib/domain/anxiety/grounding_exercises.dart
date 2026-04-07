import 'package:detoxia/core/constants/enums.dart';

class GroundingExerciseData {
  final GroundingExercise id;
  final String name;
  final String description;
  final List<String> steps;
  final int durationMinutes;

  const GroundingExerciseData({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.durationMinutes,
  });
}

const groundingExercises = <GroundingExerciseData>[
  GroundingExerciseData(
    id: GroundingExercise.sensory54321,
    name: '5-4-3-2-1 Sensory',
    description:
        'Anchor yourself in the present by systematically engaging each '
        'of your five senses.',
    steps: [
      'Look around and name 5 things you can SEE. Say each one out loud or in your mind.',
      'Touch 4 things near you. Notice their texture, temperature, and weight.',
      'Close your eyes and identify 3 things you can HEAR right now.',
      'Notice 2 things you can SMELL. If nothing is obvious, smell your hands or clothes.',
      'Notice 1 thing you can TASTE. Take a sip of water if needed.',
      'Take a slow breath. You are here, you are safe, you are present.',
    ],
    durationMinutes: 5,
  ),
  GroundingExerciseData(
    id: GroundingExercise.bodyScan,
    name: 'Body Scan',
    description:
        'Slowly move your attention through your body from head to toe, '
        'noticing sensations without judgement.',
    steps: [
      'Sit or lie down comfortably. Close your eyes and take 3 deep breaths.',
      'Bring your attention to the top of your head. Notice any tension, warmth, or tingling.',
      'Move your attention to your face — forehead, eyes, jaw. Let each area soften.',
      'Notice your neck and shoulders. If you find tension, imagine breathing into that spot.',
      'Scan down through your arms, hands, and fingertips. Notice what you feel.',
      'Bring awareness to your chest and stomach. Feel them rise and fall with each breath.',
      'Move attention to your lower back, hips, and legs.',
      'Finally, notice your feet and toes. Feel the connection to the ground beneath you.',
      'Take 3 slow breaths, then gently open your eyes.',
    ],
    durationMinutes: 8,
  ),
  GroundingExerciseData(
    id: GroundingExercise.progressiveMuscleRelaxation,
    name: 'Progressive Muscle Relaxation',
    description:
        'Tense each muscle group for 5 seconds, then release. The '
        'contrast teaches your body the difference between tension and calm.',
    steps: [
      'Sit comfortably with feet flat on the floor. Take 3 slow breaths.',
      'HANDS: Make tight fists for 5 seconds… then release. Notice the difference.',
      'ARMS: Bend your arms and flex your biceps hard for 5 seconds… release.',
      'SHOULDERS: Raise your shoulders to your ears for 5 seconds… let them drop.',
      'FACE: Scrunch your whole face tightly for 5 seconds… release and smooth.',
      'CHEST: Take a deep breath in, hold for 5 seconds… exhale slowly.',
      'STOMACH: Tighten your abdominal muscles for 5 seconds… release.',
      'LEGS: Press your thighs together and point toes for 5 seconds… release.',
      'FEET: Curl your toes tightly for 5 seconds… release.',
      'Sit quietly for a moment. Notice how your body feels compared to when you started.',
    ],
    durationMinutes: 10,
  ),
  GroundingExerciseData(
    id: GroundingExercise.iceCubeTechnique,
    name: 'Ice Cube Technique',
    description:
        'Hold an ice cube in your hand. The intense cold redirects your '
        'nervous system away from anxious thought loops.',
    steps: [
      'Get an ice cube (or run very cold water over your hands).',
      'Hold the ice in one hand. Focus entirely on the sensation.',
      'Notice: Is it sharp? Burning? Melting? Describe the feeling to yourself.',
      'When the sensation becomes too intense, switch hands.',
      'Continue for 1-2 minutes, or until you feel a mental shift.',
      'Dry your hands and take 3 slow breaths. Notice how your anxiety has changed.',
    ],
    durationMinutes: 3,
  ),
  GroundingExerciseData(
    id: GroundingExercise.butterflyHug,
    name: 'Butterfly Hug',
    description:
        'Cross your arms over your chest and alternate gentle taps. This '
        'bilateral stimulation calms the amygdala.',
    steps: [
      'Cross your arms over your chest so each hand rests on the opposite shoulder.',
      'Close your eyes or soften your gaze.',
      'Begin alternating gentle taps — left, right, left, right — at a slow, steady pace.',
      'As you tap, think of a place where you feel safe and calm.',
      'Continue tapping for 1-2 minutes. Match the rhythm to slow breathing.',
      'Pause. Notice how your body feels. Repeat if you need another round.',
    ],
    durationMinutes: 3,
  ),
  GroundingExerciseData(
    id: GroundingExercise.safePlaceVisualization,
    name: 'Safe Place Visualization',
    description:
        'Create a detailed mental image of a place where you feel '
        'completely safe and at peace.',
    steps: [
      'Close your eyes and take 3 slow, deep breaths.',
      'Picture a place where you feel completely safe. It can be real or imaginary.',
      'Look around your safe place. What do you see? Notice the colours, light, and shapes.',
      'What do you hear there? Maybe waves, wind, birds, or complete silence.',
      'What do you feel? The warmth of the sun, soft ground, a gentle breeze.',
      'What can you smell? Fresh air, flowers, the ocean, rain on warm earth.',
      'Stay in this place for a few minutes. Let yourself feel completely at ease.',
      'When you are ready, slowly open your eyes. Remember: you can return here any time.',
    ],
    durationMinutes: 5,
  ),
  GroundingExerciseData(
    id: GroundingExercise.countingBackwards,
    name: 'Counting Backwards',
    description:
        'Count backwards from 100 by 7s. The mental effort required '
        'interrupts anxious rumination.',
    steps: [
      'Find a comfortable position and take a deep breath.',
      'Start at 100 and subtract 7: 100, 93, 86, 79…',
      'Say each number to yourself (or out loud). Focus only on the math.',
      'If you lose your place, just pick the last number you remember and continue.',
      'Continue until you reach a number below 10 — or until you feel calmer.',
      'Take a slow breath in and out. Notice whether the anxious thoughts have quieted.',
    ],
    durationMinutes: 3,
  ),
  GroundingExerciseData(
    id: GroundingExercise.colorFinding,
    name: 'Colour Finding',
    description:
        'Pick a colour and find every object of that colour in your '
        'surroundings. This redirects focus outward.',
    steps: [
      'Choose a colour — blue, red, green, or whatever catches your eye.',
      'Look around the room (or wherever you are) and find everything that matches.',
      'Count each item as you find it. Try to find at least 10.',
      'When you finish one colour, choose another and repeat.',
      'Notice how searching shifts your attention away from inner anxiety.',
      'Take a slow breath. You are present and grounded.',
    ],
    durationMinutes: 3,
  ),
  GroundingExerciseData(
    id: GroundingExercise.textureTouching,
    name: 'Texture Touching',
    description:
        'Touch different surfaces around you and describe each texture '
        'in detail. Physical sensation anchors you to the present.',
    steps: [
      'Reach out and touch the nearest surface. Describe its texture — smooth, rough, cool, warm.',
      'Find something soft — fabric, a cushion, your own hair. Notice how it feels.',
      'Find something hard or rigid — a table, phone, wall. Press your fingers against it.',
      'Find something textured — a zipper, keyring, bark, or rough fabric.',
      'Find something warm, then something cool. Compare how each temperature feels.',
      'Rub your palms together quickly for 10 seconds, then press them against your face. Breathe.',
    ],
    durationMinutes: 4,
  ),
  GroundingExerciseData(
    id: GroundingExercise.mindfulWalking,
    name: 'Mindful Walking',
    description:
        'Walk slowly and deliberately, paying attention to each step. '
        'Movement plus mindfulness is deeply regulating.',
    steps: [
      'Stand still. Feel both feet on the ground. Notice the weight and balance.',
      'Begin walking very slowly. Feel your heel lift, then your toes push off.',
      'As your foot moves forward, notice the sensation of the air around your ankle.',
      'Place your foot down heel-first. Feel the ground meet your foot.',
      'Continue this deliberate pace for 2-3 minutes. Match each step to a slow breath.',
      'If your mind wanders, gently bring attention back to the feeling of your feet.',
      'Gradually return to a normal pace. Notice how different your body feels.',
    ],
    durationMinutes: 5,
  ),
];
