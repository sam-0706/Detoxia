enum SymptomCategory { physical, emotional, other }

class SymptomDef {
  final String id;
  final String name;
  final SymptomCategory category;
  final String emoji;

  const SymptomDef({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
  });
}

const allSymptoms = <SymptomDef>[
  // ─── Physical ───
  SymptomDef(id: 'cramps', name: 'Cramps', category: SymptomCategory.physical, emoji: '🤕'),
  SymptomDef(id: 'bloating', name: 'Bloating', category: SymptomCategory.physical, emoji: '🎈'),
  SymptomDef(id: 'headache', name: 'Headache', category: SymptomCategory.physical, emoji: '🤯'),
  SymptomDef(id: 'backache', name: 'Backache', category: SymptomCategory.physical, emoji: '🔙'),
  SymptomDef(id: 'breast_tenderness', name: 'Breast Tenderness', category: SymptomCategory.physical, emoji: '💗'),
  SymptomDef(id: 'fatigue', name: 'Fatigue', category: SymptomCategory.physical, emoji: '😴'),
  SymptomDef(id: 'nausea', name: 'Nausea', category: SymptomCategory.physical, emoji: '🤢'),
  SymptomDef(id: 'dizziness', name: 'Dizziness', category: SymptomCategory.physical, emoji: '💫'),
  SymptomDef(id: 'hot_flashes', name: 'Hot Flashes', category: SymptomCategory.physical, emoji: '🔥'),
  SymptomDef(id: 'joint_pain', name: 'Joint Pain', category: SymptomCategory.physical, emoji: '🦴'),
  SymptomDef(id: 'acne', name: 'Acne', category: SymptomCategory.physical, emoji: '😖'),
  SymptomDef(id: 'constipation', name: 'Constipation', category: SymptomCategory.physical, emoji: '🚫'),
  SymptomDef(id: 'diarrhea', name: 'Diarrhea', category: SymptomCategory.physical, emoji: '💨'),
  SymptomDef(id: 'appetite_increase', name: 'Appetite Increase', category: SymptomCategory.physical, emoji: '🍽️'),
  SymptomDef(id: 'appetite_decrease', name: 'Appetite Decrease', category: SymptomCategory.physical, emoji: '🤐'),
  SymptomDef(id: 'weight_gain', name: 'Weight Gain', category: SymptomCategory.physical, emoji: '⚖️'),
  SymptomDef(id: 'insomnia', name: 'Insomnia', category: SymptomCategory.physical, emoji: '🌙'),
  SymptomDef(id: 'heavy_bleeding', name: 'Heavy Bleeding', category: SymptomCategory.physical, emoji: '🩸'),
  SymptomDef(id: 'spotting', name: 'Spotting', category: SymptomCategory.physical, emoji: '🔴'),
  SymptomDef(id: 'discharge_changes', name: 'Discharge Changes', category: SymptomCategory.physical, emoji: '💧'),
  SymptomDef(id: 'pelvic_pain', name: 'Pelvic Pain', category: SymptomCategory.physical, emoji: '⚡'),
  SymptomDef(id: 'leg_pain', name: 'Leg Pain', category: SymptomCategory.physical, emoji: '🦵'),
  SymptomDef(id: 'chills', name: 'Chills', category: SymptomCategory.physical, emoji: '🥶'),
  SymptomDef(id: 'muscle_aches', name: 'Muscle Aches', category: SymptomCategory.physical, emoji: '💪'),

  // ─── Emotional ───
  SymptomDef(id: 'mood_swings', name: 'Mood Swings', category: SymptomCategory.emotional, emoji: '🎭'),
  SymptomDef(id: 'irritability', name: 'Irritability', category: SymptomCategory.emotional, emoji: '😤'),
  SymptomDef(id: 'anxiety', name: 'Anxiety', category: SymptomCategory.emotional, emoji: '😰'),
  SymptomDef(id: 'sadness', name: 'Sadness', category: SymptomCategory.emotional, emoji: '😢'),
  SymptomDef(id: 'crying_spells', name: 'Crying Spells', category: SymptomCategory.emotional, emoji: '😭'),
  SymptomDef(id: 'anger', name: 'Anger', category: SymptomCategory.emotional, emoji: '😡'),
  SymptomDef(id: 'sensitivity', name: 'Sensitivity', category: SymptomCategory.emotional, emoji: '🥺'),
  SymptomDef(id: 'low_motivation', name: 'Low Motivation', category: SymptomCategory.emotional, emoji: '😔'),
  SymptomDef(id: 'brain_fog', name: 'Brain Fog', category: SymptomCategory.emotional, emoji: '🌫️'),
  SymptomDef(id: 'restlessness', name: 'Restlessness', category: SymptomCategory.emotional, emoji: '🔄'),
  SymptomDef(id: 'overwhelmed', name: 'Feeling Overwhelmed', category: SymptomCategory.emotional, emoji: '😵‍💫'),
  SymptomDef(id: 'loneliness', name: 'Loneliness', category: SymptomCategory.emotional, emoji: '🫥'),
  SymptomDef(id: 'confidence_drop', name: 'Confidence Drop', category: SymptomCategory.emotional, emoji: '📉'),
  SymptomDef(id: 'emotional_eating', name: 'Emotional Eating', category: SymptomCategory.emotional, emoji: '🍫'),

  // ─── Other ───
  SymptomDef(id: 'cravings_sweet', name: 'Sweet Cravings', category: SymptomCategory.other, emoji: '🍩'),
  SymptomDef(id: 'cravings_salty', name: 'Salty Cravings', category: SymptomCategory.other, emoji: '🧂'),
  SymptomDef(id: 'cravings_carbs', name: 'Carb Cravings', category: SymptomCategory.other, emoji: '🍞'),
  SymptomDef(id: 'cravings_chocolate', name: 'Chocolate Cravings', category: SymptomCategory.other, emoji: '🍫'),
  SymptomDef(id: 'libido_increase', name: 'Libido Increase', category: SymptomCategory.other, emoji: '🔥'),
  SymptomDef(id: 'libido_decrease', name: 'Libido Decrease', category: SymptomCategory.other, emoji: '❄️'),
  SymptomDef(id: 'skin_dry', name: 'Dry Skin', category: SymptomCategory.other, emoji: '🏜️'),
  SymptomDef(id: 'skin_oily', name: 'Oily Skin', category: SymptomCategory.other, emoji: '✨'),
  SymptomDef(id: 'skin_glow', name: 'Skin Glow', category: SymptomCategory.other, emoji: '🌟'),
  SymptomDef(id: 'hair_oily', name: 'Oily Hair', category: SymptomCategory.other, emoji: '💇'),
  SymptomDef(id: 'hair_dry', name: 'Dry Hair', category: SymptomCategory.other, emoji: '🌾'),
  SymptomDef(id: 'hair_loss', name: 'Hair Shedding', category: SymptomCategory.other, emoji: '💇‍♀️'),
  SymptomDef(id: 'water_retention', name: 'Water Retention', category: SymptomCategory.other, emoji: '💦'),
  SymptomDef(id: 'frequent_urination', name: 'Frequent Urination', category: SymptomCategory.other, emoji: '🚽'),
];
