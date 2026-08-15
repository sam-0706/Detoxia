import 'package:detoxia/domain/scoring/models/support_profile.dart';

class ProgramModuleItem {
  final String title;
  final String description;
  final bool complete;

  const ProgramModuleItem({
    required this.title,
    required this.description,
    required this.complete,
  });
}

class ProgramPhasePlan {
  final String title;
  final String weeks;
  final List<ProgramModuleItem> modules;

  const ProgramPhasePlan({
    required this.title,
    required this.weeks,
    required this.modules,
  });
}

class AdaptiveProgramPlan {
  final bool isLocked;
  final String weekLabel;
  final String phaseLabel;
  final String subtitle;
  final List<ProgramPhasePlan> phases;
  final String starterGuidance;

  const AdaptiveProgramPlan({
    required this.isLocked,
    required this.weekLabel,
    required this.phaseLabel,
    required this.subtitle,
    required this.phases,
    required this.starterGuidance,
  });
}

class AdaptiveProgramResolver {
  const AdaptiveProgramResolver();

  AdaptiveProgramPlan resolve({
    required SupportProfile? supportProfile,
  }) {
    if (supportProfile == null) {
      return AdaptiveProgramPlan(
        isLocked: true,
        weekLabel: 'Adaptive 12-week roadmap',
        phaseLabel: 'Still learning from local records',
        subtitle: 'Baseline + Map: understanding your local pattern.',
        phases: _buildDefaultPhases(),
        starterGuidance:
            'Complete your support map and check-ins to unlock a goal-adaptive 12-week program.',
      );
    }

    final families = _goalFamilies(supportProfile.selectedGoals);
    final primary = families.isEmpty ? 'general' : families.first;
    final language = _language(primary);

    return AdaptiveProgramPlan(
      isLocked: false,
      weekLabel: 'Adaptive 12-week roadmap',
      phaseLabel: 'Current focus: Phase 1',
      subtitle: 'Baseline + Map: calibrating your ${language.focusNoun}.',
      phases: [
        ProgramPhasePlan(
          title: 'Phase 1: Baseline + Map',
          weeks: 'Weeks 1-2',
          modules: [
            ProgramModuleItem(
              title: 'Establish check-in habit',
              description: 'Build daily signal quality for your support map.',
              complete: false,
            ),
            ProgramModuleItem(
              title: language.mapTitle,
              description: language.mapDescription,
              complete: false,
            ),
            ProgramModuleItem(
              title: 'Pick one anchor boundary',
              description: language.boundaryDescription,
              complete: false,
            ),
          ],
        ),
        ProgramPhasePlan(
          title: 'Phase 2: Interrupt + Stabilize',
          weeks: 'Weeks 3-5',
          modules: [
            ProgramModuleItem(
              title: language.interruptTitle,
              description: language.interruptDescription,
              complete: false,
            ),
            ProgramModuleItem(
              title: language.shortResetTitle,
              description: language.shortResetDescription,
              complete: false,
            ),
            ProgramModuleItem(
              title: 'Support-task consistency',
              description:
                  'Complete 1-2 short support tasks daily using your current task plan.',
              complete: false,
            ),
          ],
        ),
        ProgramPhasePlan(
          title: 'Phase 3: Rebuild Control',
          weeks: 'Weeks 6-8',
          modules: [
            ProgramModuleItem(
              title: language.rebuildTitle,
              description: language.rebuildDescription,
              complete: false,
            ),
            ProgramModuleItem(
              title: 'Routine reinforcement',
              description:
                  'Protect your highest-leverage windows with repeatable routines.',
              complete: false,
            ),
            ProgramModuleItem(
              title: 'Driver-by-driver practice',
              description: 'Apply one targeted intervention per top driver.',
              complete: false,
            ),
          ],
        ),
        ProgramPhasePlan(
          title: 'Phase 4: Maintain + Prevent',
          weeks: 'Weeks 9-12',
          modules: [
            ProgramModuleItem(
              title: language.preventTitle,
              description: language.preventDescription,
              complete: false,
            ),
            ProgramModuleItem(
              title: 'Weekly review ritual',
              description:
                  'Use Weekly Review and adjust plan details from real local outcomes.',
              complete: false,
            ),
            ProgramModuleItem(
              title: 'Maintenance playbook',
              description:
                  'Keep a small, sustainable routine for long-term stability.',
              complete: false,
            ),
          ],
        ),
      ],
      starterGuidance:
          'This program adapts by selected goals and local progress. No fixed outcome guarantees are shown.',
    );
  }

  List<ProgramPhasePlan> _buildDefaultPhases() {
    return const [
      ProgramPhasePlan(
        title: 'Phase 1: Baseline + Map',
        weeks: 'Weeks 1-2',
        modules: [
          ProgramModuleItem(
            title: 'Establish check-in habit',
            description: 'Complete local check-ins daily.',
            complete: false,
          ),
        ],
      ),
      ProgramPhasePlan(
        title: 'Phase 2: Interrupt + Stabilize',
        weeks: 'Weeks 3-5',
        modules: [
          ProgramModuleItem(
            title: 'Practice short resets',
            description: 'Use short support actions during difficult windows.',
            complete: false,
          ),
        ],
      ),
      ProgramPhasePlan(
        title: 'Phase 3: Rebuild Control',
        weeks: 'Weeks 6-8',
        modules: [
          ProgramModuleItem(
            title: 'Rebuild routines',
            description: 'Strengthen repeatable daily structure.',
            complete: false,
          ),
        ],
      ),
      ProgramPhasePlan(
        title: 'Phase 4: Maintain + Prevent',
        weeks: 'Weeks 9-12',
        modules: [
          ProgramModuleItem(
            title: 'Maintain gains',
            description: 'Keep a weekly maintenance rhythm.',
            complete: false,
          ),
        ],
      ),
    ];
  }

  List<String> _goalFamilies(List<String> goals) {
    final normalized = goals.map((goal) => goal.toLowerCase().replaceAll('_', '')).toList();
    final families = <String>[];
    void add(String id) {
      if (!families.contains(id)) families.add(id);
    }

    for (final goal in normalized) {
      if (goal.contains('anxiety')) add('anxiety');
      if (goal.contains('focus') || goal.contains('adhd')) add('focus');
      if (goal.contains('sleep')) add('sleep');
      if (goal.contains('scroll')) add('scrolling');
      if (goal.contains('sexual') || goal.contains('porn')) add('sexual');
      if (goal.contains('lowmood') || goal.contains('mood')) add('lowMood');
    }
    return families;
  }

  _ProgramLanguage _language(String family) {
    return switch (family) {
      'anxiety' => const _ProgramLanguage(
          focusNoun: 'rough-window recovery',
          mapTitle: 'Map rough windows',
          mapDescription: 'Identify stress spikes, contexts, and calming opportunities.',
          boundaryDescription: 'Protect one calming boundary around your highest-stress period.',
          interruptTitle: 'Interrupt worry loops',
          interruptDescription: 'Use short grounding resets before escalation.',
          shortResetTitle: 'Calm-reset drills',
          shortResetDescription: '2-5 minute breathing or grounding actions.',
          rebuildTitle: 'Rebuild calm control',
          rebuildDescription: 'Practice return-to-calm routines in real contexts.',
          preventTitle: 'Prevent overwhelm loops',
          preventDescription: 'Use pre-planned calm responses for known triggers.',
        ),
      'focus' => const _ProgramLanguage(
          focusNoun: 'focus control',
          mapTitle: 'Map focus disruptions',
          mapDescription: 'Identify missed focus blocks and attention drift windows.',
          boundaryDescription: 'Protect one daily focus block as non-negotiable.',
          interruptTitle: 'Interrupt task avoidance',
          interruptDescription: 'Use tiny-start methods to break procrastination loops.',
          shortResetTitle: 'Focus sprint resets',
          shortResetDescription: 'Short reset + single-task sprint sequence.',
          rebuildTitle: 'Rebuild task initiation',
          rebuildDescription: 'Stack reliable task-start cues into your routine.',
          preventTitle: 'Prevent focus drift',
          preventDescription: 'Use fallback plans for high-distraction windows.',
        ),
      'sleep' => const _ProgramLanguage(
          focusNoun: 'sleep stability',
          mapTitle: 'Map sleep disruptions',
          mapDescription: 'Track late-night support windows and wind-down friction.',
          boundaryDescription: 'Set one pre-sleep boundary and keep it nightly.',
          interruptTitle: 'Interrupt late-night loops',
          interruptDescription: 'Use shutdown routines before late-night windows.',
          shortResetTitle: 'Sleep reset drills',
          shortResetDescription: '2-5 minute downshift actions at night.',
          rebuildTitle: 'Rebuild sleep consistency',
          rebuildDescription: 'Stabilize sleep/wake anchors and night routines.',
          preventTitle: 'Prevent sleep disruptions',
          preventDescription: 'Use recovery plans after disrupted nights.',
        ),
      'scrolling' => const _ProgramLanguage(
          focusNoun: 'loop interruption',
          mapTitle: 'Map scrolling loops',
          mapDescription: 'Identify loop triggers and lost-time episodes.',
          boundaryDescription: 'Set one no-scroll boundary in your most vulnerable window.',
          interruptTitle: 'Interrupt scrolling loops',
          interruptDescription: 'Use friction and replacement actions before escalation.',
          shortResetTitle: 'Loop-break resets',
          shortResetDescription: '2-minute interruption plans for loop onset.',
          rebuildTitle: 'Rebuild intentional use',
          rebuildDescription: 'Shift from autopilot scrolling to intentional behavior.',
          preventTitle: 'Prevent lost-time episodes',
          preventDescription: 'Use pre-commitment rules in vulnerable contexts.',
        ),
      'sexual' => const _ProgramLanguage(
          focusNoun: 'urge recovery',
          mapTitle: 'Map urge triggers',
          mapDescription: 'Identify top urge and reset-moment pathways.',
          boundaryDescription: 'Set one protective boundary in your most vulnerable window.',
          interruptTitle: 'Interrupt urge cycles',
          interruptDescription: 'Use short resets before escalation.',
          shortResetTitle: 'Urge-reset drills',
          shortResetDescription: 'Delay + grounding + redirect sequence.',
          rebuildTitle: 'Rebuild awareness',
          rebuildDescription: 'Strengthen routine defenses and recovery habits.',
          preventTitle: 'Prevent reset moments',
          preventDescription: 'Use if-then plans for known trigger combinations.',
        ),
      'lowMood' => const _ProgramLanguage(
          focusNoun: 'activation momentum',
          mapTitle: 'Map low-energy windows',
          mapDescription: 'Identify protection gaps and low-activation periods.',
          boundaryDescription: 'Set one tiny activation anchor for difficult periods.',
          interruptTitle: 'Interrupt shutdown cycles',
          interruptDescription: 'Use low-pressure activation before deep avoidance.',
          shortResetTitle: 'Activation resets',
          shortResetDescription: 'Small action first, then momentum build.',
          rebuildTitle: 'Rebuild daily activation',
          rebuildDescription: 'Stack meaningful micro-actions into daily rhythm.',
          preventTitle: 'Prevent avoidance spirals',
          preventDescription: 'Use early-warning responses for low-energy days.',
        ),
      _ => const _ProgramLanguage(
          focusNoun: 'support momentum',
          mapTitle: 'Map support patterns',
          mapDescription: 'Identify where support actions help most.',
          boundaryDescription: 'Set one dependable daily support boundary.',
          interruptTitle: 'Interrupt difficult loops',
          interruptDescription: 'Use short, repeatable support resets.',
          shortResetTitle: 'Short reset drills',
          shortResetDescription: 'Practice brief, dependable support actions.',
          rebuildTitle: 'Rebuild consistency',
          rebuildDescription: 'Create repeatable routines around your top drivers.',
          preventTitle: 'Prevent slipping back',
          preventDescription: 'Use simple maintenance rules for support windows.',
        ),
    };
  }
}

class _ProgramLanguage {
  final String focusNoun;
  final String mapTitle;
  final String mapDescription;
  final String boundaryDescription;
  final String interruptTitle;
  final String interruptDescription;
  final String shortResetTitle;
  final String shortResetDescription;
  final String rebuildTitle;
  final String rebuildDescription;
  final String preventTitle;
  final String preventDescription;

  const _ProgramLanguage({
    required this.focusNoun,
    required this.mapTitle,
    required this.mapDescription,
    required this.boundaryDescription,
    required this.interruptTitle,
    required this.interruptDescription,
    required this.shortResetTitle,
    required this.shortResetDescription,
    required this.rebuildTitle,
    required this.rebuildDescription,
    required this.preventTitle,
    required this.preventDescription,
  });
}
