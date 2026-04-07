import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';

class _GuideStep {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final List<String> bullets;

  const _GuideStep({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.bullets,
  });
}

const _steps = [
  _GuideStep(
    icon: Icons.shield_outlined,
    color: Color(0xFF6C63FF),
    title: 'Your Personal Recovery Engine',
    subtitle:
        'Detoxia isn\'t a generic habit tracker. It\'s a self-learning '
        'system built around YOUR schedule, triggers, and patterns.',
    bullets: [
      'Predicts risky moments BEFORE they happen',
      'Learns from every interaction to get smarter',
      'All your data stays 100% on your device',
    ],
  ),
  _GuideStep(
    icon: Icons.timeline,
    color: Color(0xFFFF6B6B),
    title: 'Risk Timeline',
    subtitle:
        'Your home screen shows today\'s risk map — a visual timeline '
        'of when you\'re most vulnerable.',
    bullets: [
      'Color-coded blocks show risk levels throughout the day',
      'Countdown to your next high-risk window',
      'Tap "Prepare" to get ready before a tough moment',
    ],
  ),
  _GuideStep(
    icon: Icons.flash_on,
    color: Color(0xFFFFB347),
    title: 'Urge Rescue',
    subtitle:
        'When an urge hits, tap the Report button. The app will '
        'guide you through a quick intervention.',
    bullets: [
      'Rate your urge intensity',
      'Get a personalized diversion activity',
      'Track what works best for YOUR urges',
    ],
  ),
  _GuideStep(
    icon: Icons.nightlight_round,
    color: Color(0xFF4ECDC4),
    title: 'Daily Check-in',
    subtitle:
        'Every evening before bed, you\'ll complete a quick status '
        'report. This is mandatory — it\'s what fuels your recovery.',
    bullets: [
      'Takes under 2 minutes',
      'Records your mood, sleep, stress, and confidence',
      'The app reminds you 1 hour before bedtime',
      'Your plan adjusts based on what you report',
    ],
  ),
  _GuideStep(
    icon: Icons.psychology,
    color: Color(0xFF6C63FF),
    title: 'Where You Stand',
    subtitle:
        'See a real-time analysis of your mental state — confidence, '
        'self-control, vulnerability, and momentum.',
    bullets: [
      'Radar chart shows your recovery profile',
      'See how setbacks affect your mood, sleep, and stress',
      'Track which triggers hit you hardest',
    ],
  ),
  _GuideStep(
    icon: Icons.trending_up,
    color: Color(0xFF4ECDC4),
    title: 'Your Recovery Journey',
    subtitle:
        'See where you are now vs. where you\'ll be after following '
        'the plan. Real numbers, not motivational fluff.',
    bullets: [
      'Week-by-week improvement projections',
      'Based on YOUR actual data, recalibrated weekly',
      'Watch the curve bend as your consistency grows',
    ],
  ),
  _GuideStep(
    icon: Icons.school,
    color: Color(0xFFFFB347),
    title: '12-Week Recovery Program',
    subtitle:
        'A structured, science-backed program with CBT & ACT techniques '
        'that adapts to your pace.',
    bullets: [
      'Phase 1: Awareness & pattern interruption',
      'Phase 2: Building new habits & coping skills',
      'Phase 3: Deep rewiring & lifestyle integration',
      'Pace adjusts if you need more time on any phase',
    ],
  ),
  _GuideStep(
    icon: Icons.emoji_events,
    color: Color(0xFFFF6B6B),
    title: 'Achievements & Streaks',
    subtitle:
        'Every clean day, every resisted urge, every check-in earns '
        'you real milestones.',
    bullets: [
      'Unlock achievements as you progress',
      'Streak system that rewards consistency',
      'See what you\'ll unlock next to stay motivated',
    ],
  ),
];

class FeatureGuideScreen extends StatefulWidget {
  const FeatureGuideScreen({super.key});

  @override
  State<FeatureGuideScreen> createState() => _FeatureGuideScreenState();
}

class _FeatureGuideScreenState extends State<FeatureGuideScreen> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < _steps.length - 1) {
      _controller.animateToPage(
        _current + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    '${_current + 1}/${_steps.length}',
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const Spacer(),
                  if (_current < _steps.length - 1)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                        );
                      },
                      child: const Text('Skip',
                          style: TextStyle(color: Colors.white38)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: (_current + 1) / _steps.length,
                backgroundColor: Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) => _GuidePage(step: _steps[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _steps[_current].color,
                  ),
                  child: Text(
                    _current == _steps.length - 1
                        ? "Let's begin"
                        : 'Next',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidePage extends StatelessWidget {
  final _GuideStep step;

  const _GuidePage({required this.step});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, color: step.color, size: 40),
          ),
          const SizedBox(height: 28),
          Text(
            step.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            step.subtitle,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ...step.bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: step.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
