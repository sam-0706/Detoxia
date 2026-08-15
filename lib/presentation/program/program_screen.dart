import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/support_profile_repository.dart';
import 'package:detoxia/domain/program/adaptive_program_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramScreen extends ConsumerStatefulWidget {
  final AdaptiveProgramPlan? planOverride;

  const ProgramScreen({super.key, this.planOverride});

  @override
  ConsumerState<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends ConsumerState<ProgramScreen> {
  final AdaptiveProgramResolver _resolver = const AdaptiveProgramResolver();
  AdaptiveProgramPlan? _plan;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final override = widget.planOverride;
    if (override != null) {
      setState(() => _plan = override);
      return;
    }

    final registration = await ref.read(registrationRepositoryProvider).getProfile();
    final supportProfile = registration == null
        ? null
        : await ref
              .read(supportProfileRepositoryProvider)
              .getLatestProfile(registration.id);
    final plan = _resolver.resolve(supportProfile: supportProfile);
    if (!mounted) return;
    setState(() => _plan = plan);
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    if (plan == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('12-Week Program')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProgressHeader(context, plan),
          const SizedBox(height: 12),
          if (plan.isLocked)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  plan.starterGuidance,
                  style:  TextStyle(color: AppTheme.palette(context).textSecondary, height: 1.3),
                ),
              ),
            )
          else
            Text(
              plan.starterGuidance,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary),
            ),
          const SizedBox(height: 24),
          ..._buildPhases(context, plan),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, AdaptiveProgramPlan plan) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(plan.weekLabel,
                    style: Theme.of(context).textTheme.titleLarge),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.palette(context).accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(plan.phaseLabel,
                      style: TextStyle(
                          color: AppTheme.palette(context).accent, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan.phaseLabel,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              plan.subtitle,
              style:  TextStyle(color: AppTheme.palette(context).textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPhases(BuildContext context, AdaptiveProgramPlan plan) {
    return List.generate(plan.phases.length, (index) {
      final phase = plan.phases[index];
      return _PhaseCard(
        title: phase.title,
        weeks: phase.weeks,
        isActive: index == 0,
        modules: phase.modules,
      );
    });
  }
}

class _PhaseCard extends StatelessWidget {
  final String title;
  final String weeks;
  final bool isActive;
  final List<ProgramModuleItem> modules;

  const _PhaseCard({
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
        color: isActive ? null : AppTheme.palette(context).surfaceRaised.withValues(alpha: 0.5),
        child: ExpansionTile(
          initiallyExpanded: isActive,
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(
            isActive ? Icons.play_circle_fill : Icons.lock_outline,
            color: isActive ? AppTheme.palette(context).accent : AppTheme.palette(context).borderStrong,
          ),
          title: Text(title,
              style: TextStyle(
                color: isActive ? AppTheme.palette(context).textPrimary : AppTheme.palette(context).textTertiary,
                fontWeight: FontWeight.w600,
              )),
          subtitle: Text(weeks,
              style: TextStyle(
                color: isActive ? AppTheme.palette(context).textSecondary : AppTheme.palette(context).borderStrong,
                fontSize: 12,
              )),
          children: modules
              .map((m) => ListTile(
                    leading: Icon(
                      m.complete
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          m.complete ? AppTheme.palette(context).success : AppTheme.palette(context).borderStrong,
                      size: 20,
                    ),
                    title: Text(m.title,
                        style: TextStyle(
                          color: isActive
                              ? AppTheme.palette(context).textPrimary
                              : AppTheme.palette(context).textTertiary,
                          fontSize: 14,
                        )),
                    subtitle: Text(m.description,
                        style: TextStyle(
                          color: isActive
                              ? AppTheme.palette(context).textSecondary
                              : AppTheme.palette(context).borderStrong,
                          fontSize: 12,
                        )),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
