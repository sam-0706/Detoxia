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
    title: 'Your Personal Wellness Engine',
    subtitle:
        'This app is a self-learning system built around YOU — your '
        'schedule, patterns, triggers, and goals. Everything stays on your device.',
    bullets: [
      'Predicts challenges BEFORE they happen',
      'Learns from every interaction to get smarter',
      'Adapts daily tasks and notifications to your needs',
      'All your data stays 100% on your device',
    ],
  ),
  _GuideStep(
    icon: Icons.task_alt,
    color: Color(0xFF4ECDC4),
    title: 'Daily Tasks',
    subtitle:
        'Every day, you\'ll receive personalized tasks based on your '
        'active modules — breathing exercises, activities, focus sessions, and more.',
    bullets: [
      'Tasks adapt to your conditions and progress',
      'Mix of quick (2 min) and deeper (30 min) activities',
      'Different tasks each day to keep things fresh',
      'Rate effectiveness to help the system learn',
    ],
  ),
  _GuideStep(
    icon: Icons.timeline,
    color: Color(0xFFFF6B6B),
    title: 'Risk Timeline',
    subtitle:
        'For recovery, your home screen shows today\'s risk map — a '
        'visual timeline of when you\'re most vulnerable.',
    bullets: [
      'Color-coded blocks show risk levels throughout the day',
      'Countdown to your next high-risk window',
      'Tap "Prepare" to get ready before a tough moment',
    ],
  ),
  _GuideStep(
    icon: Icons.air,
    color: Color(0xFF4ECDC4),
    title: 'Anxiety & Breathing',
    subtitle:
        'Access 12 guided breathing techniques and 10 grounding exercises '
        'anytime you need them.',
    bullets: [
      'Animated breathing guide with visual circle',
      'Track anxiety before/after to see what works best',
      'Emergency button when anxiety strikes',
      'Grounding exercises with step-by-step instructions',
    ],
  ),
  _GuideStep(
    icon: Icons.emoji_emotions,
    color: Color(0xFF9B59B6),
    title: 'Mood Tracking',
    subtitle:
        'Log your mood in seconds and discover patterns you never noticed.',
    bullets: [
      'Quick 2-tap mood logging',
      'Choose from 40+ emotions with categories',
      'Year-in-pixels calendar view of your mood history',
      'Activity-mood correlation insights',
    ],
  ),
  _GuideStep(
    icon: Icons.wb_sunny_outlined,
    color: Color(0xFFFFB347),
    title: 'Depression Support',
    subtitle:
        'Behavioral activation, CBT thought records, and weekly self-check '
        'to help you build momentum.',
    bullets: [
      '100+ activities to schedule and track',
      'Step-by-step thought challenging guide',
      'Weekly self-assessments to monitor progress',
      'Activity-mood correlation insights',
    ],
  ),
  _GuideStep(
    icon: Icons.psychology,
    color: Color(0xFFFF6B6B),
    title: 'ADHD Tools',
    subtitle:
        'Focus timer, dopamine menu, and task decomposer to help you '
        'get things done.',
    bullets: [
      'Pomodoro-style timer with distraction tracking',
      '40+ healthy dopamine activities by time available',
      'Break overwhelming tasks into micro-steps',
      'Discover your most productive hours',
    ],
  ),
  _GuideStep(
    icon: Icons.favorite,
    color: Color(0xFFFF6B9D),
    title: 'Period Tracker',
    subtitle:
        'Track your cycle, understand your phases, and get '
        'phase-specific wellness recommendations.',
    bullets: [
      'Visual cycle day ring with phase colors',
      '50+ symptom tracking with emoji labels',
      'Phase-specific exercise, nutrition, and self-care tips',
      'Cycle calendar with predictions',
    ],
  ),
  _GuideStep(
    icon: Icons.nightlight_round,
    color: Color(0xFF4ECDC4),
    title: 'Daily Check-in',
    subtitle:
        'Every evening, complete a quick status report. '
        'This fuels your personalized plan.',
    bullets: [
      'Takes under 2 minutes',
      'Records your mood, sleep, stress, and confidence',
      'The app reminds you before bedtime',
      'Your plan adjusts based on what you report',
    ],
  ),
  _GuideStep(
    icon: Icons.emoji_events,
    color: Color(0xFFFF6B6B),
    title: 'Achievements & Streaks',
    subtitle:
        'Every effort counts. Track streaks, unlock milestones, '
        'and see your progress grow.',
    bullets: [
      'Unlock achievements as you progress',
      'Streak system that rewards consistency',
      'Complete daily tasks to build momentum',
      "See what you'll unlock next",
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
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 14),
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
