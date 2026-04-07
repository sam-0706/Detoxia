import 'package:detoxia/core/constants/enums.dart';

class ThoughtChallenger {
  static const distortionDescriptions = <CognitiveDistortion, String>{
    CognitiveDistortion.allOrNothing:
        'Seeing things as all good or all bad, with no middle ground.',
    CognitiveDistortion.catastrophizing:
        'Jumping to the worst possible outcome, even when unlikely.',
    CognitiveDistortion.mindReading:
        'Assuming you know what others are thinking about you.',
    CognitiveDistortion.fortuneTelling:
        'Predicting the future negatively without evidence.',
    CognitiveDistortion.emotionalReasoning:
        'Believing something is true because it feels true.',
    CognitiveDistortion.shouldStatements:
        'Rigid rules about how things "should" or "must" be.',
    CognitiveDistortion.labeling:
        'Attaching a fixed label to yourself or others based on one event.',
    CognitiveDistortion.overgeneralization:
        'Drawing broad conclusions from a single event.',
    CognitiveDistortion.discountingPositives:
        'Dismissing good things as if they don\'t count.',
    CognitiveDistortion.magnification:
        'Blowing negatives out of proportion or shrinking positives.',
  };

  static const _keywords = <CognitiveDistortion, List<String>>{
    CognitiveDistortion.allOrNothing: [
      'always', 'never', 'nothing', 'everything', 'completely', 'totally',
      'perfect', 'ruined', 'failure', 'worst', 'every time', 'impossible',
    ],
    CognitiveDistortion.catastrophizing: [
      'disaster', 'terrible', 'awful', 'worst', 'end of the world',
      'can\'t handle', 'unbearable', 'devastating', 'nightmare', 'horrible',
      'ruin', 'doomed',
    ],
    CognitiveDistortion.mindReading: [
      'they think', 'they must think', 'everyone thinks', 'people think',
      'probably thinks', 'judging me', 'laughing at', 'looking at me',
      'hates me', 'don\'t like me', 'thinks I\'m',
    ],
    CognitiveDistortion.fortuneTelling: [
      'will never', 'won\'t ever', 'going to fail', 'will always',
      'never going to', 'it\'s going to', 'bound to', 'guaranteed',
      'no point', 'what\'s the use',
    ],
    CognitiveDistortion.emotionalReasoning: [
      'I feel like', 'feels like', 'I feel so', 'I just feel',
      'because I feel', 'it feels', 'must be true', 'I know it',
    ],
    CognitiveDistortion.shouldStatements: [
      'should', 'shouldn\'t', 'must', 'have to', 'ought to', 'supposed to',
      'need to be', 'expected to',
    ],
    CognitiveDistortion.labeling: [
      'I\'m a', 'I am a', 'such a', 'I\'m just', 'he\'s a', 'she\'s a',
      'they\'re a', 'loser', 'idiot', 'stupid', 'worthless', 'useless',
      'pathetic',
    ],
    CognitiveDistortion.overgeneralization: [
      'always', 'never', 'everyone', 'nobody', 'no one', 'every time',
      'nothing ever', 'this always', 'typical', 'just my luck',
    ],
    CognitiveDistortion.discountingPositives: [
      'doesn\'t count', 'anyone could', 'not a big deal', 'just lucky',
      'but', 'yeah but', 'that doesn\'t matter', 'so what', 'whatever',
      'fluke', 'only because',
    ],
    CognitiveDistortion.magnification: [
      'huge', 'massive', 'enormous', 'the worst', 'can\'t believe',
      'unbelievable', 'such a big', 'way too', 'extremely', 'incredibly',
    ],
  };

  static CognitiveDistortion identifyDistortion(String thought) {
    final lower = thought.toLowerCase();

    var bestMatch = CognitiveDistortion.emotionalReasoning;
    var bestScore = 0;

    for (final entry in _keywords.entries) {
      var score = 0;
      for (final keyword in entry.value) {
        if (lower.contains(keyword.toLowerCase())) {
          score++;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        bestMatch = entry.key;
      }
    }

    return bestMatch;
  }

  static List<String> generateChallenge(CognitiveDistortion type) =>
      switch (type) {
        CognitiveDistortion.allOrNothing => [
            'Is there a middle ground between the two extremes?',
            'Can you think of a time when this wasn\'t 100% true?',
            'If a friend described this situation, would you see shades of gray?',
            'What percentage would be more accurate than "always" or "never"?',
          ],
        CognitiveDistortion.catastrophizing => [
            'What is the most likely outcome, not the worst?',
            'Have you survived similar situations before?',
            'On a scale of 1-10, how bad would this realistically be?',
            'What would you tell a friend who was catastrophizing like this?',
          ],
        CognitiveDistortion.mindReading => [
            'What evidence do you actually have for what they\'re thinking?',
            'Could there be another explanation for their behavior?',
            'Have you ever been wrong about what someone was thinking?',
            'Would you be willing to ask them directly?',
          ],
        CognitiveDistortion.fortuneTelling => [
            'Do you have a crystal ball? What facts support this prediction?',
            'How many of your past negative predictions actually came true?',
            'What is a more realistic outcome based on actual evidence?',
            'What steps could you take to influence a better outcome?',
          ],
        CognitiveDistortion.emotionalReasoning => [
            'Just because you feel it, does that make it a fact?',
            'Have your feelings ever misled you before?',
            'What would the evidence look like if you removed the feeling?',
            'Is there a difference between feeling like a failure and being one?',
          ],
        CognitiveDistortion.shouldStatements => [
            'Where does this rule come from? Is it realistic?',
            'What would happen if you replaced "should" with "I\'d prefer to"?',
            'Would you hold someone else to this same rigid standard?',
            'Is this expectation helping you or making you feel worse?',
          ],
        CognitiveDistortion.labeling => [
            'Are you defined by this one thing, or are you more complex?',
            'Would you label a friend this way based on one mistake?',
            'What evidence contradicts this label?',
            'Can you describe the behavior without using a label?',
          ],
        CognitiveDistortion.overgeneralization => [
            'Are you applying one experience to everything?',
            'Can you think of exceptions to this generalization?',
            'What would a more specific statement look like?',
            'Is "always" or "never" literally true here?',
          ],
        CognitiveDistortion.discountingPositives => [
            'If someone else achieved this, would you say it didn\'t count?',
            'What positive things have you dismissed recently?',
            'Can you name three genuine strengths or accomplishments?',
            'Why does the negative feel more "real" than the positive?',
          ],
        CognitiveDistortion.magnification => [
            'Are you making this bigger than it actually is?',
            'How important will this be in a week? A month? A year?',
            'What are you minimizing that deserves more weight?',
            'Can you describe this without emotionally charged language?',
          ],
      };
}
