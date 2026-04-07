enum EmotionCategory {
  happy,
  sad,
  angry,
  anxious,
  calm,
  confused,
  surprised,
}

class Emotion {
  final String name;
  final EmotionCategory category;
  final String emoji;

  const Emotion({
    required this.name,
    required this.category,
    required this.emoji,
  });
}

const allEmotions = <Emotion>[
  // ─── Happy ───
  Emotion(name: 'Happy', category: EmotionCategory.happy, emoji: '😊'),
  Emotion(name: 'Joyful', category: EmotionCategory.happy, emoji: '😁'),
  Emotion(name: 'Grateful', category: EmotionCategory.happy, emoji: '🙏'),
  Emotion(name: 'Proud', category: EmotionCategory.happy, emoji: '🏆'),
  Emotion(name: 'Hopeful', category: EmotionCategory.happy, emoji: '🌟'),
  Emotion(name: 'Excited', category: EmotionCategory.happy, emoji: '🤩'),
  Emotion(name: 'Loved', category: EmotionCategory.happy, emoji: '🥰'),
  Emotion(name: 'Content', category: EmotionCategory.happy, emoji: '😌'),

  // ─── Sad ───
  Emotion(name: 'Sad', category: EmotionCategory.sad, emoji: '😢'),
  Emotion(name: 'Lonely', category: EmotionCategory.sad, emoji: '😔'),
  Emotion(name: 'Disappointed', category: EmotionCategory.sad, emoji: '😞'),
  Emotion(name: 'Guilty', category: EmotionCategory.sad, emoji: '😣'),
  Emotion(name: 'Ashamed', category: EmotionCategory.sad, emoji: '😳'),
  Emotion(name: 'Heartbroken', category: EmotionCategory.sad, emoji: '💔'),
  Emotion(name: 'Empty', category: EmotionCategory.sad, emoji: '🫥'),
  Emotion(name: 'Hopeless', category: EmotionCategory.sad, emoji: '😩'),

  // ─── Angry ───
  Emotion(name: 'Angry', category: EmotionCategory.angry, emoji: '😠'),
  Emotion(name: 'Frustrated', category: EmotionCategory.angry, emoji: '😤'),
  Emotion(name: 'Irritated', category: EmotionCategory.angry, emoji: '😒'),
  Emotion(name: 'Resentful', category: EmotionCategory.angry, emoji: '😡'),
  Emotion(name: 'Jealous', category: EmotionCategory.angry, emoji: '💢'),
  Emotion(name: 'Bitter', category: EmotionCategory.angry, emoji: '🤬'),

  // ─── Anxious ───
  Emotion(name: 'Anxious', category: EmotionCategory.anxious, emoji: '😰'),
  Emotion(name: 'Worried', category: EmotionCategory.anxious, emoji: '😟'),
  Emotion(name: 'Stressed', category: EmotionCategory.anxious, emoji: '😫'),
  Emotion(name: 'Overwhelmed', category: EmotionCategory.anxious, emoji: '🤯'),
  Emotion(name: 'Nervous', category: EmotionCategory.anxious, emoji: '😬'),
  Emotion(name: 'Restless', category: EmotionCategory.anxious, emoji: '🫨'),
  Emotion(name: 'Panicked', category: EmotionCategory.anxious, emoji: '😱'),

  // ─── Calm ───
  Emotion(name: 'Calm', category: EmotionCategory.calm, emoji: '😇'),
  Emotion(name: 'Peaceful', category: EmotionCategory.calm, emoji: '☮️'),
  Emotion(name: 'Relaxed', category: EmotionCategory.calm, emoji: '😎'),
  Emotion(name: 'Focused', category: EmotionCategory.calm, emoji: '🎯'),
  Emotion(name: 'Mindful', category: EmotionCategory.calm, emoji: '🧘'),
  Emotion(name: 'Balanced', category: EmotionCategory.calm, emoji: '⚖️'),

  // ─── Confused ───
  Emotion(name: 'Confused', category: EmotionCategory.confused, emoji: '😕'),
  Emotion(name: 'Lost', category: EmotionCategory.confused, emoji: '🤷'),
  Emotion(name: 'Indecisive', category: EmotionCategory.confused, emoji: '🫤'),
  Emotion(name: 'Doubtful', category: EmotionCategory.confused, emoji: '🤔'),
  Emotion(name: 'Disconnected', category: EmotionCategory.confused, emoji: '🫠'),

  // ─── Surprised ───
  Emotion(name: 'Surprised', category: EmotionCategory.surprised, emoji: '😲'),
  Emotion(name: 'Amazed', category: EmotionCategory.surprised, emoji: '🤩'),
  Emotion(name: 'Shocked', category: EmotionCategory.surprised, emoji: '😧'),
  Emotion(name: 'Speechless', category: EmotionCategory.surprised, emoji: '😶'),
];

List<Emotion> emotionsByCategory(EmotionCategory category) =>
    allEmotions.where((e) => e.category == category).toList();

String categoryLabel(EmotionCategory c) => switch (c) {
      EmotionCategory.happy => 'Happy',
      EmotionCategory.sad => 'Sad',
      EmotionCategory.angry => 'Angry',
      EmotionCategory.anxious => 'Anxious',
      EmotionCategory.calm => 'Calm',
      EmotionCategory.confused => 'Confused',
      EmotionCategory.surprised => 'Surprised',
    };
