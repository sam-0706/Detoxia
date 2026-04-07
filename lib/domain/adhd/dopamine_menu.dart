enum DopamineCategory { quick, physical, creative, social, sensory }

class DopamineActivity {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final DopamineCategory category;

  const DopamineActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
  });
}

const dopamineActivities = <DopamineActivity>[
  // ─── 2-Minute Activities ───
  DopamineActivity(
    id: 'splash_cold_water',
    title: 'Splash Cold Water',
    description: 'Run cold water over your face and wrists for a quick reset.',
    durationMinutes: 2,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'jumping_jacks_10',
    title: '10 Jumping Jacks',
    description: 'Quick burst of movement to wake up your body and brain.',
    durationMinutes: 2,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'hum_a_song',
    title: 'Hum a Song',
    description: 'Pick your favorite tune and hum it through. Engages vagus nerve.',
    durationMinutes: 2,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'smell_something_strong',
    title: 'Smell Something Strong',
    description: 'Sniff coffee beans, citrus peel, or essential oil for a sensory jolt.',
    durationMinutes: 2,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'power_pose',
    title: 'Power Pose',
    description: 'Stand tall, hands on hips, chest open for 2 minutes. Shifts your state.',
    durationMinutes: 2,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'eye_palming',
    title: 'Eye Palming',
    description: 'Warm your palms and cup them over closed eyes. Deep darkness reset.',
    durationMinutes: 2,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'tongue_twisters',
    title: 'Tongue Twisters',
    description: 'Say three tongue twisters as fast as you can. Engages focus instantly.',
    durationMinutes: 2,
    category: DopamineCategory.quick,
  ),
  DopamineActivity(
    id: 'count_backwards',
    title: 'Count Backwards from 100 by 7s',
    description: 'Mental math challenge that forces present-moment focus.',
    durationMinutes: 2,
    category: DopamineCategory.quick,
  ),
  DopamineActivity(
    id: 'squeeze_ice',
    title: 'Squeeze an Ice Cube',
    description: 'Hold ice in your palm. The sharp sensation resets wandering attention.',
    durationMinutes: 2,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'balance_challenge',
    title: 'One-Leg Balance',
    description: 'Stand on one leg, eyes closed. Demands total body-brain coordination.',
    durationMinutes: 2,
    category: DopamineCategory.physical,
  ),

  // ─── 5-Minute Activities ───
  DopamineActivity(
    id: 'dance_to_song',
    title: 'Dance to a Song',
    description: 'Put on your favorite track and move however your body wants.',
    durationMinutes: 5,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'quick_sketch',
    title: 'Quick Sketch',
    description: 'Draw whatever comes to mind. No rules, no erasing.',
    durationMinutes: 5,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'solve_puzzle',
    title: 'Solve a Puzzle',
    description: 'Grab a Rubik\'s cube, crossword, or brain teaser. Novelty engages dopamine.',
    durationMinutes: 5,
    category: DopamineCategory.quick,
  ),
  DopamineActivity(
    id: 'juggle',
    title: 'Juggle',
    description: 'Try juggling anything - socks, oranges, balls. Learning = dopamine.',
    durationMinutes: 5,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'stretch_routine',
    title: 'Quick Stretch',
    description: 'Full body stretch. Neck, shoulders, hips, hamstrings.',
    durationMinutes: 5,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'sing_loudly',
    title: 'Sing Loudly',
    description: 'Belt out a song at full volume. Releases endorphins and shifts mood.',
    durationMinutes: 5,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'organize_shelf',
    title: 'Organize One Shelf',
    description: 'Pick one messy shelf, drawer, or surface. Instant visible progress.',
    durationMinutes: 5,
    category: DopamineCategory.quick,
  ),
  DopamineActivity(
    id: 'cold_face_wash',
    title: 'Cold Face Wash Ritual',
    description: 'Wash face with cold water, apply something that smells good. Multi-sensory.',
    durationMinutes: 5,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'paper_airplane',
    title: 'Make a Paper Airplane',
    description: 'Fold and test-fly different designs. Quick creative engineering.',
    durationMinutes: 5,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'text_someone',
    title: 'Send a Nice Text',
    description: 'Message someone you care about. Connection = natural dopamine.',
    durationMinutes: 5,
    category: DopamineCategory.social,
  ),
  DopamineActivity(
    id: 'speed_tidy',
    title: 'Speed Tidy Challenge',
    description: 'Set a 5-min timer and tidy as much as possible. Race yourself.',
    durationMinutes: 5,
    category: DopamineCategory.quick,
  ),
  DopamineActivity(
    id: 'hand_massage',
    title: 'Hand Self-Massage',
    description: 'Press and knead your palms and fingers. Surprisingly calming and grounding.',
    durationMinutes: 5,
    category: DopamineCategory.sensory,
  ),

  // ─── 15-Minute Activities ───
  DopamineActivity(
    id: 'short_walk',
    title: 'Short Walk',
    description: 'Walk around the block. Sunlight + movement is the ultimate ADHD reset.',
    durationMinutes: 15,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'cook_snack',
    title: 'Cook a Snack',
    description: 'Make something simple from scratch - toast, smoothie, eggs. Hands-on reward.',
    durationMinutes: 15,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'call_someone',
    title: 'Call Someone',
    description: 'Voice call a friend or family member. Real connection over screen time.',
    durationMinutes: 15,
    category: DopamineCategory.social,
  ),
  DopamineActivity(
    id: 'play_instrument',
    title: 'Play an Instrument',
    description: 'Pick up any instrument and play. Even badly - the act matters.',
    durationMinutes: 15,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'garden',
    title: 'Garden',
    description: 'Water plants, pull weeds, repot something. Grounding and rewarding.',
    durationMinutes: 15,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'cold_shower',
    title: 'Cold Shower',
    description: 'Even 3 minutes of cold water boosts dopamine by 250%. Science-backed.',
    durationMinutes: 15,
    category: DopamineCategory.sensory,
  ),
  DopamineActivity(
    id: 'write_letter',
    title: 'Write a Letter',
    description: 'Pen a quick note or letter to someone. Analog creativity.',
    durationMinutes: 15,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'photography_walk',
    title: 'Photography Walk',
    description: 'Walk around and take 10 interesting photos. Trains attention to detail.',
    durationMinutes: 15,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'play_with_pet',
    title: 'Play with a Pet',
    description: 'If you have a pet, give them your full attention. Mutual dopamine.',
    durationMinutes: 15,
    category: DopamineCategory.social,
  ),
  DopamineActivity(
    id: 'listen_new_music',
    title: 'Discover New Music',
    description: 'Put on a genre you never listen to. Novelty drives dopamine release.',
    durationMinutes: 15,
    category: DopamineCategory.sensory,
  ),

  // ─── 30-Minute Activities ───
  DopamineActivity(
    id: 'workout',
    title: 'Workout',
    description: 'Any structured exercise. Bodyweight, weights, yoga - your choice.',
    durationMinutes: 30,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'hike',
    title: 'Hike',
    description: 'Hit a trail nearby. Nature + exercise = sustained dopamine baseline.',
    durationMinutes: 30,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'build_something',
    title: 'Build Something',
    description: 'LEGO, model kit, or improvise. Building activates focus and reward circuits.',
    durationMinutes: 30,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'deep_clean_area',
    title: 'Deep Clean One Area',
    description: 'Pick one zone and make it spotless. Visible transformation = satisfaction.',
    durationMinutes: 30,
    category: DopamineCategory.quick,
  ),
  DopamineActivity(
    id: 'bike_ride',
    title: 'Bike Ride',
    description: 'Ride around your neighborhood. Speed + wind + movement = brain food.',
    durationMinutes: 30,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'cook_meal',
    title: 'Cook a Full Meal',
    description: 'Follow a new recipe start to finish. Multi-step reward with a tasty result.',
    durationMinutes: 30,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'board_game',
    title: 'Play a Board Game',
    description: 'Grab someone for a quick game. Social + strategic engagement.',
    durationMinutes: 30,
    category: DopamineCategory.social,
  ),
  DopamineActivity(
    id: 'swim',
    title: 'Go Swimming',
    description: 'Full body exercise in water. Uniquely calming and dopamine-rich.',
    durationMinutes: 30,
    category: DopamineCategory.physical,
  ),
  DopamineActivity(
    id: 'art_project',
    title: 'Start an Art Project',
    description: 'Painting, collage, pottery - any hands-on creative work.',
    durationMinutes: 30,
    category: DopamineCategory.creative,
  ),
  DopamineActivity(
    id: 'volunteer_task',
    title: 'Do Something for Someone',
    description: 'Help a neighbor, run an errand for a friend. Prosocial dopamine.',
    durationMinutes: 30,
    category: DopamineCategory.social,
  ),
];
