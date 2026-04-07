class HelplineEntry {
  final String name;
  final String number;
  final String description;

  const HelplineEntry({
    required this.name,
    required this.number,
    required this.description,
  });
}

const Map<String, List<HelplineEntry>> countryHelplines = {
  'India': [
    HelplineEntry(
      name: 'iCall',
      number: '9152987821',
      description: 'Psychosocial helpline by TISS',
    ),
    HelplineEntry(
      name: 'Vandrevala Foundation',
      number: '1860-2662-345',
      description: '24/7 mental health support',
    ),
    HelplineEntry(
      name: 'NIMHANS Helpline',
      number: '080-46110007',
      description: 'National mental health institute',
    ),
  ],
  'United States': [
    HelplineEntry(
      name: 'SAMHSA National Helpline',
      number: '1-800-662-4357',
      description: '24/7 free referral and information',
    ),
    HelplineEntry(
      name: 'Crisis Text Line',
      number: 'Text HOME to 741741',
      description: 'Free 24/7 text-based crisis support',
    ),
    HelplineEntry(
      name: '988 Suicide & Crisis Lifeline',
      number: '988',
      description: 'Call or text for mental health crisis',
    ),
  ],
  'United Kingdom': [
    HelplineEntry(
      name: 'Samaritans',
      number: '116 123',
      description: '24/7 confidential emotional support',
    ),
    HelplineEntry(
      name: 'Mind Infoline',
      number: '0300 123 3393',
      description: 'Mental health information and support',
    ),
  ],
  'Canada': [
    HelplineEntry(
      name: 'Crisis Services Canada',
      number: '1-833-456-4566',
      description: '24/7 crisis support',
    ),
    HelplineEntry(
      name: 'Kids Help Phone',
      number: '1-800-668-6868',
      description: 'Youth mental health support',
    ),
  ],
  'Australia': [
    HelplineEntry(
      name: 'Lifeline Australia',
      number: '13 11 14',
      description: '24/7 crisis support and prevention',
    ),
    HelplineEntry(
      name: 'Beyond Blue',
      number: '1300 22 4636',
      description: 'Anxiety and depression support',
    ),
  ],
  'Germany': [
    HelplineEntry(
      name: 'Telefonseelsorge',
      number: '0800 111 0 111',
      description: '24/7 free anonymous counseling',
    ),
  ],
  'France': [
    HelplineEntry(
      name: 'SOS Amitié',
      number: '09 72 39 40 50',
      description: '24/7 emotional support line',
    ),
  ],
  'Brazil': [
    HelplineEntry(
      name: 'CVV (Centro de Valorização da Vida)',
      number: '188',
      description: '24/7 emotional support',
    ),
  ],
  'Nigeria': [
    HelplineEntry(
      name: 'SURPIN',
      number: '+234 8062106493',
      description: 'Suicide prevention initiative',
    ),
  ],
  'South Africa': [
    HelplineEntry(
      name: 'SADAG',
      number: '0800 567 567',
      description: 'Depression and anxiety group',
    ),
  ],
  'UAE': [
    HelplineEntry(
      name: 'National Crisis Helpline',
      number: '800-HOPE (4673)',
      description: 'Mental health crisis support',
    ),
  ],
  'Saudi Arabia': [
    HelplineEntry(
      name: 'Mental Health Helpline',
      number: '920033360',
      description: 'MOH mental health support',
    ),
  ],
  'Pakistan': [
    HelplineEntry(
      name: 'Umang Helpline',
      number: '0317-4288665',
      description: 'Mental health support line',
    ),
  ],
  'Bangladesh': [
    HelplineEntry(
      name: 'Kaan Pete Roi',
      number: '01779-554391',
      description: 'Emotional support helpline',
    ),
  ],
  'Philippines': [
    HelplineEntry(
      name: 'National Center for Mental Health',
      number: '0966-351-4518',
      description: 'Crisis hotline 24/7',
    ),
  ],
  'Indonesia': [
    HelplineEntry(
      name: 'Into The Light',
      number: '021-7884-5555',
      description: 'Mental health crisis line',
    ),
  ],
  'Mexico': [
    HelplineEntry(
      name: 'SAPTEL',
      number: '55 5259-8121',
      description: '24/7 crisis intervention',
    ),
  ],
  'Japan': [
    HelplineEntry(
      name: 'TELL Lifeline',
      number: '03-5774-0992',
      description: 'Confidential English support',
    ),
  ],
  'South Korea': [
    HelplineEntry(
      name: 'Mental Health Crisis Line',
      number: '1577-0199',
      description: '24/7 mental health support',
    ),
  ],
  'Turkey': [
    HelplineEntry(
      name: 'Yaşam Hattı',
      number: '182',
      description: 'Crisis support line',
    ),
  ],
  'Egypt': [
    HelplineEntry(
      name: 'Befrienders Egypt',
      number: '762 0602',
      description: 'Emotional support line',
    ),
  ],
  'Kenya': [
    HelplineEntry(
      name: 'Befrienders Kenya',
      number: '+254 722 178 177',
      description: 'Crisis support',
    ),
  ],
};

List<HelplineEntry> getHelplines(String country) {
  if (countryHelplines.containsKey(country)) {
    return countryHelplines[country]!;
  }
  return const [
    HelplineEntry(
      name: 'International Association for Suicide Prevention',
      number: 'https://www.iasp.info/resources/Crisis_Centres/',
      description: 'Find a crisis center near you',
    ),
    HelplineEntry(
      name: 'Befrienders Worldwide',
      number: 'https://www.befrienders.org',
      description: 'Emotional support in 30+ countries',
    ),
  ];
}
