const List<String> dailyInsights = [
  'Your brain rewires itself every day you stay committed. Even small wins matter.',
  'Urges peak and fade in 15-20 minutes. If you ride it out, you win.',
  'Sleep quality improves dramatically within the first 2 weeks of recovery.',
  'The strongest predictor of long-term success is how you respond after a setback, not avoiding them entirely.',
  'Boredom is the #1 trigger for most people. Having a go-to activity ready cuts risk by 60%.',
  'Your dopamine receptors start healing within 2 weeks. Real pleasure from real activities returns.',
  'People who check in daily are 3x more likely to reach their 90-day goal.',
  'Stress doesn\'t cause setbacks. How you cope with stress does. You\'re building better coping skills.',
  'Morning routines that skip the phone for 20 minutes reduce daily urges by 40%.',
  'Confidence isn\'t about never struggling. It\'s about knowing you can handle the struggle.',
  'Each time you resist an urge, your prefrontal cortex literally gets stronger.',
  'Social connection is the opposite of addiction. Reach out to someone today.',
  'Your recovery momentum builds like compound interest — slow at first, then exponential.',
  'The scrolling-to-relapse chain has a weak link. Breaking it once makes it easier every time.',
  'Late-night phone use is the single biggest risk factor. Charge your phone outside the bedroom.',
  'Physical exercise for just 20 minutes reduces urge intensity by up to 50%.',
  'Writing down how you feel after a clean day strengthens your motivation for tomorrow.',
  'Trigger awareness alone reduces relapse probability by 30%. You\'re already doing this.',
  'Most people overestimate how hard the first week is and underestimate how good week 4 feels.',
  'Your self-control is like a muscle. Every day you exercise it, it gets stronger.',
  'People who identify their top 3 triggers have 2.5x better recovery outcomes.',
  'Cold water on your face activates the dive reflex and can break an urge cycle in 30 seconds.',
  'Gratitude journaling before bed reduces next-day stress and urge frequency.',
  'Recovery isn\'t linear. A tough day doesn\'t erase a good week.',
  'The hardest part isn\'t quitting. It\'s building a life where you don\'t need to escape.',
  'Deep breathing for 2 minutes shifts your nervous system from fight-or-flight to calm.',
  'Your brain is literally forming new neural pathways right now. Every clean hour counts.',
  'Accountability increases success rates by 65%. You\'re already being accountable with this app.',
  'Forgiveness after a setback leads to faster recovery than self-punishment.',
  'The version of you at 90 days will thank the version of you choosing right now.',
  'Mindful awareness of an urge without acting on it is the single most powerful recovery skill.',
];

String getTodayInsight() {
  final dayOfYear = DateTime.now().difference(
    DateTime(DateTime.now().year, 1, 1),
  ).inDays;
  return dailyInsights[dayOfYear % dailyInsights.length];
}
