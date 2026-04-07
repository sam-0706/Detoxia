import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramScreen extends ConsumerWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('12-Week Program')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProgressHeader(context),
          const SizedBox(height: 24),
          ..._buildPhases(context),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Week 1 of 12',
                    style: Theme.of(context).textTheme.titleLarge),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Phase 1',
                      style: TextStyle(
                          color: AppTheme.accent, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 1 / 12,
              backgroundColor: Colors.white12,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            const Text(
              'Baseline + Map: Understanding your patterns',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPhases(BuildContext context) {
    return [
      _PhaseCard(
        phase: ProgramPhase.baseline,
        title: 'Phase 1: Baseline + Map',
        weeks: 'Weeks 1-2',
        isActive: true,
        modules: const [
          _Module(
            title: 'Establish check-in habit',
            description: 'Complete daily check-ins to build your data.',
            complete: false,
          ),
          _Module(
            title: 'Identify top triggers',
            description:
                'The system is learning your top 3 triggers and risk windows.',
            complete: false,
          ),
          _Module(
            title: 'Set one boundary',
            description:
                'Choose one non-negotiable: phone outside bedroom.',
            complete: false,
          ),
          _Module(
            title: 'How habit loops work',
            description:
                'Understand cue-behavior-reward and the scrolling connection.',
            complete: false,
          ),
        ],
      ),
      _PhaseCard(
        phase: ProgramPhase.interrupt,
        title: 'Phase 2: Interrupt + Stabilize',
        weeks: 'Weeks 3-5',
        isActive: false,
        modules: const [
          _Module(
            title: 'Target late-night exposure',
            description: 'The strongest evidence-supported surface.',
            complete: false,
          ),
          _Module(
            title: 'Build urge surfing skill',
            description: '10-minute delay timer, breathing exercises.',
            complete: false,
          ),
          _Module(
            title: 'Replacement routines',
            description: 'Build alternatives for your top 2 triggers.',
            complete: false,
          ),
          _Module(
            title: 'Sleep boundary enforcement',
            description: 'Phone away 30 minutes before sleep.',
            complete: false,
          ),
        ],
      ),
      _PhaseCard(
        phase: ProgramPhase.rebuild,
        title: 'Phase 3: Rebuild Control',
        weeks: 'Weeks 6-8',
        isActive: false,
        modules: const [
          _Module(
            title: 'CBT chain analysis',
            description: 'Break down recurring slip patterns.',
            complete: false,
          ),
          _Module(
            title: 'ACT values clarification',
            description: 'Define who you want to become.',
            complete: false,
          ),
          _Module(
            title: 'Weekend defense mode',
            description: 'Structured blocks for unstructured days.',
            complete: false,
          ),
          _Module(
            title: 'Stress coping alternatives',
            description: 'Exercise, journaling, social connection.',
            complete: false,
          ),
        ],
      ),
      _PhaseCard(
        phase: ProgramPhase.maintain,
        title: 'Phase 4: Maintain + Prevent',
        weeks: 'Weeks 9-12',
        isActive: false,
        modules: const [
          _Module(
            title: 'Relapse prevention drills',
            description: '"If X happens, I do Y" plans.',
            complete: false,
          ),
          _Module(
            title: 'Self-compassion module',
            description: 'Prevent shame spirals after slips.',
            complete: false,
          ),
          _Module(
            title: 'Maintenance plan',
            description: 'Weekly self-audits, quarterly rescreening.',
            complete: false,
          ),
          _Module(
            title: 'Escalation guidance',
            description: 'When to seek professional help.',
            complete: false,
          ),
        ],
      ),
    ];
  }
}

class _Module {
  final String title;
  final String description;
  final bool complete;

  const _Module({
    required this.title,
    required this.description,
    required this.complete,
  });
}

class _PhaseCard extends StatelessWidget {
  final ProgramPhase phase;
  final String title;
  final String weeks;
  final bool isActive;
  final List<_Module> modules;

  const _PhaseCard({
    required this.phase,
    required this.title,
    required this.weeks,
    required this.isActive,
    required this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: isActive ? null : AppTheme.card.withValues(alpha: 0.5),
        child: ExpansionTile(
          initiallyExpanded: isActive,
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(
            isActive ? Icons.play_circle_fill : Icons.lock_outline,
            color: isActive ? AppTheme.accent : Colors.white24,
          ),
          title: Text(title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w600,
              )),
          subtitle: Text(weeks,
              style: TextStyle(
                color: isActive ? Colors.white54 : Colors.white24,
                fontSize: 12,
              )),
          children: modules
              .map((m) => ListTile(
                    leading: Icon(
                      m.complete
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          m.complete ? AppTheme.success : Colors.white24,
                      size: 20,
                    ),
                    title: Text(m.title,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.white38,
                          fontSize: 14,
                        )),
                    subtitle: Text(m.description,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white54
                              : Colors.white24,
                          fontSize: 12,
                        )),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
