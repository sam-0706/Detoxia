import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/anxiety/anxiety_toolkit.dart';
import 'package:detoxia/domain/anxiety/grounding_exercises.dart';
import 'package:detoxia/presentation/anxiety/anxiety_insights_screen.dart';
import 'package:detoxia/presentation/anxiety/breathing_screen.dart';
import 'package:detoxia/presentation/anxiety/grounding_screen.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnxietyHome extends ConsumerStatefulWidget {
  const AnxietyHome({super.key});

  @override
  ConsumerState<AnxietyHome> createState() => _AnxietyHomeState();
}

class _AnxietyHomeState extends ConsumerState<AnxietyHome> {
  int? _lastAnxietyLevel;
  DateTime? _lastLoggedAt;
  int _breathingSessionsToday = 0;
  int _groundingSessionsToday = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final latestAnxiety = await (db.select(db.anxietyEvents)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .getSingleOrNull();

    final breathingCount = await (db.select(db.breathingLogs)
          ..where(
              (t) => t.timestamp.isBiggerOrEqualValue(todayStart)))
        .get();

    final groundingCount = await (db.select(db.anxietyEvents)
          ..where(
              (t) => t.timestamp.isBiggerOrEqualValue(todayStart))
          ..where((t) => t.copingUsed.isNotNull()))
        .get();

    if (mounted) {
      setState(() {
        _lastAnxietyLevel = latestAnxiety?.anxietyLevel;
        _lastLoggedAt = latestAnxiety?.timestamp;
        _breathingSessionsToday = breathingCount.length;
        _groundingSessionsToday = groundingCount.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anxiety Toolkit'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AnxietyInsightsScreen()),
            ),
            icon: const Icon(Icons.insights, color: Colors.white70),
            tooltip: 'Insights',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAnxietyLevelCard(),
            const SizedBox(height: 16),
            _buildEmergencyButton(),
            const SizedBox(height: 20),
            _buildTodayProgress(),
            const SizedBox(height: 20),
            Text('Quick Access',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildQuickAccessGrid(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnxietyLevelCard() {
    final hasData = _lastAnxietyLevel != null;
    final level = _lastAnxietyLevel ?? 0;
    final color = level <= 3
        ? AppTheme.success
        : level <= 6
            ? AppTheme.warning
            : AppTheme.danger;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: hasData
            ? Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        '$level',
                        style: TextStyle(
                          color: color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last anxiety level',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _timeAgo(_lastLoggedAt!),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _anxietyLabel(level),
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(Icons.self_improvement,
                      color: AppTheme.accent, size: 36),
                  const SizedBox(height: 8),
                  const Text(
                    'No anxiety logged yet',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Complete a breathing session to start tracking',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return Material(
      color: AppTheme.danger.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BreathingScreen()),
        ).then((_) => _loadData()),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(Icons.air, color: AppTheme.danger, size: 28),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feeling anxious right now?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Start a guided breathing exercise',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppTheme.danger, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgress() {
    return Row(
      children: [
        Expanded(
          child: _ProgressCard(
            icon: Icons.air,
            label: 'Breathing',
            count: _breathingSessionsToday,
            color: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProgressCard(
            icon: Icons.self_improvement,
            label: 'Grounding',
            count: _groundingSessionsToday,
            color: AppTheme.success,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessGrid() {
    final topBreathing = breathingTechniques.take(2).toList();
    final topGrounding = groundingExercises.take(2).toList();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        ...topBreathing.map((t) => _QuickAccessCard(
              icon: Icons.air,
              label: t.name,
              subtitle: '${t.totalDurationSeconds ~/ 60} min',
              color: AppTheme.accent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BreathingScreen(initialTechnique: t.id),
                ),
              ).then((_) => _loadData()),
            )),
        ...topGrounding.map((g) => _QuickAccessCard(
              icon: Icons.self_improvement,
              label: g.name,
              subtitle: '${g.durationMinutes} min',
              color: AppTheme.success,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroundingScreen(initialExercise: g.id),
                ),
              ).then((_) => _loadData()),
            )),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _anxietyLabel(int level) {
    if (level <= 2) return 'Calm';
    if (level <= 4) return 'Mild';
    if (level <= 6) return 'Moderate';
    if (level <= 8) return 'High';
    return 'Severe';
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _ProgressCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label today',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
