import 'package:detoxia/core/constants/daily_insights.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/data/repositories/event_repository.dart';
import 'package:detoxia/data/repositories/peak_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/entities/peak_node.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/domain/prediction/risk_calculator.dart';
import 'package:detoxia/presentation/adhoc_report/adhoc_sheet.dart';
import 'package:detoxia/presentation/daily_checkin/checkin_screen.dart';
import 'package:detoxia/presentation/dashboard/weekly_review/weekly_review_screen.dart';
import 'package:detoxia/presentation/dashboard/recovery_projection/projection_screen.dart';
import 'package:detoxia/presentation/dashboard/confidence_analysis/confidence_screen.dart';
import 'package:detoxia/presentation/dashboard/achievements/achievements_screen.dart';
import 'package:detoxia/presentation/program/program_screen.dart';
import 'package:detoxia/presentation/settings/settings_screen.dart';
import 'package:detoxia/presentation/urge_rescue/rescue_screen.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  UserProfile? _profile;
  List<PeakNodeEntity> _peaks = [];
  List<RiskBlock> _todayBlocks = [];
  int _slipsToday = 0;
  int _urgesToday = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await ref.read(userRepositoryProvider).getUser();
    if (profile == null) return;

    final peaks = await ref.read(peakRepositoryProvider).getAllPeaks();
    final now = DateTime.now();
    final slips =
        await ref.read(eventRepositoryProvider).getSlipsForDate(now);
    final urges =
        await ref.read(eventRepositoryProvider).getUrgesForDate(now);

    final calculator = RiskCalculator(profile: profile, peaks: peaks);
    final state = RecentState(
      slipsToday: slips.length,
      recentSlip: slips.isNotEmpty,
    );
    final blocks = calculator.calculateDay(now.weekday, state);

    if (mounted) {
      setState(() {
        _profile = profile;
        _peaks = peaks;
        _todayBlocks = blocks;
        _slipsToday = slips.length;
        _urgesToday = urges.length;
      });
    }

    // Schedule daily check-in reminders 1 hour before sleep
    _scheduleCheckinReminders(profile);
  }

  void _scheduleCheckinReminders(UserProfile profile) {
    final now = DateTime.now();
    final isOffDay = profile.isOffDay(now.weekday);
    final sleepTime = isOffDay ? profile.offdaySleepTime : profile.weekdaySleepTime;
    var sleepDT = DateTime(
      now.year, now.month, now.day,
      sleepTime.hour, sleepTime.minute,
    );
    // If sleep time is past midnight (e.g. 00:30), it's technically the next day
    if (sleepDT.isBefore(now.subtract(const Duration(hours: 6)))) {
      sleepDT = sleepDT.add(const Duration(days: 1));
    }
    ref.read(notificationServiceProvider).scheduleCheckinReminders(sleepDT);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentBlock = (now.hour * 60 + now.minute) ~/ 30;

    RiskBlock? nextHighRisk;
    for (final block in _todayBlocks) {
      if (block.blockIndex > currentBlock && block.score >= 0.7) {
        nextHighRisk = block;
        break;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: _profile == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildDailyInsight(),
                    const SizedBox(height: 16),
                    _buildQuickStats(),
                    const SizedBox(height: 16),
                    _buildDailyProgress(),
                    const SizedBox(height: 16),
                    if (nextHighRisk != null)
                      _buildNextRiskCard(nextHighRisk),
                    const SizedBox(height: 16),
                    _buildPeakCards(now),
                    const SizedBox(height: 20),
                    _buildTimeline(currentBlock),
                    const SizedBox(height: 20),
                    _buildNavigationGrid(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdHocSheet(context),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add),
        label: const Text('Report'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Review'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'Program'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const WeeklyReviewScreen()),
              );
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProgramScreen()),
              );
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SettingsScreen()),
              );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    final greeting = _getGreeting();
    final name = _profile?.name ?? '';
    final displayName = name.isNotEmpty ? ', $name' : '';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting$displayName',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                '${TimeUtils.dayName(DateTime.now().weekday)}, ${_formatDate(DateTime.now())}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CheckinScreen()),
          ),
          icon: const Icon(Icons.nightlight_round,
              color: Colors.white70),
          tooltip: 'Daily Check-in',
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildDailyInsight() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accent.withValues(alpha: 0.12),
            AppTheme.accent.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Today's Insight",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  getTodayInsight(),
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgress() {
    final cleanDays = _peaks.isNotEmpty ? _peaks.first.currentPeakStreak : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart,
                    color: AppTheme.success, size: 20),
                const SizedBox(width: 8),
                const Text("Today's Status",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            _ProgressRow(
              label: 'Clean days',
              value: '$cleanDays',
              icon: Icons.favorite,
              color: AppTheme.success,
            ),
            _ProgressRow(
              label: 'Urges resisted today',
              value: '$_urgesToday',
              icon: Icons.shield,
              color: AppTheme.accent,
            ),
            _ProgressRow(
              label: 'Risk windows survived',
              value: _survivedWindows(),
              icon: Icons.check_circle,
              color: AppTheme.success,
            ),
            if (_slipsToday == 0)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'You\'re doing great today. Keep going.',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _survivedWindows() {
    final now = DateTime.now();
    final currentBlock = (now.hour * 60 + now.minute) ~/ 30;
    int passed = 0;
    for (final block in _todayBlocks) {
      if (block.blockIndex < currentBlock && block.score >= 0.7) {
        passed++;
      }
    }
    return '$passed';
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _StatChip(
          label: 'Clean streak',
          value: '${_peaks.isNotEmpty ? _peaks.first.currentPeakStreak : 0}d',
          color: AppTheme.success,
        ),
        const SizedBox(width: 8),
        _StatChip(
          label: 'Urges today',
          value: '$_urgesToday',
          color: AppTheme.warning,
        ),
        const SizedBox(width: 8),
        _StatChip(
          label: 'Setbacks',
          value: '$_slipsToday',
          color: _slipsToday > 0 ? AppTheme.danger : AppTheme.success,
        ),
      ],
    );
  }

  Widget _buildNextRiskCard(RiskBlock block) {
    final minutesUntil =
        block.startMinute - (DateTime.now().hour * 60 + DateTime.now().minute);
    final countdownText = minutesUntil > 60
        ? '${minutesUntil ~/ 60}h ${minutesUntil % 60}m'
        : '${minutesUntil}m';

    return Card(
      color: AppTheme.danger.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: AppTheme.danger, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Next high-risk window',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${TimeUtils.blockLabel(block.startMinute)} '
                    '- in $countdownText',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RescueScreen()),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger),
              child: const Text('Prepare'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakCards(DateTime now) {
    if (_peaks.isEmpty) return const SizedBox.shrink();
    final currentMinute = now.hour * 60 + now.minute;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Peaks",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ..._peaks.map((peak) {
          final status = _peakStatus(peak, currentMinute);
          return Card(
            child: ListTile(
              leading: Icon(
                status.icon,
                color: status.color,
                size: 28,
              ),
              title: Text(
                '${peak.label} (${peak.centerTime.format(context)})',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                status.text,
                style: TextStyle(color: status.color),
              ),
              trailing: Text(
                '${peak.currentPeakStreak}d',
                style: const TextStyle(
                    color: Colors.white54, fontSize: 12),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTimeline(int currentBlock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Risk Timeline',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              48,
              (i) {
                final block = i < _todayBlocks.length
                    ? _todayBlocks[i]
                    : null;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0.5),
                    decoration: BoxDecoration(
                      color: block != null
                          ? AppTheme.riskColor(block.score)
                              .withValues(alpha: 0.7)
                          : Colors.white12,
                      border: i == currentBlock
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('12AM',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
            const Text('6AM',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
            const Text('12PM',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
            const Text('6PM',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
            const Text('12AM',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _NavCard(
          icon: Icons.psychology,
          label: 'Where You Stand',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ConfidenceScreen()),
          ),
        ),
        _NavCard(
          icon: Icons.trending_up,
          label: 'My Journey',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ProjectionScreen()),
          ),
        ),
        _NavCard(
          icon: Icons.emoji_events,
          label: 'Achievements',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AchievementsScreen()),
          ),
        ),
        _NavCard(
          icon: Icons.shield,
          label: 'Urge Rescue',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RescueScreen()),
          ),
        ),
      ],
    );
  }

  void _showAdHocSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AdHocSheet(
        onComplete: () {
          Navigator.pop(context);
          _loadData();
        },
      ),
    );
  }

  _PeakStatus _peakStatus(PeakNodeEntity peak, int currentMinute) {
    if (currentMinute < peak.startMinutes) {
      final diff = peak.startMinutes - currentMinute;
      final text = diff > 60
          ? 'Approaching in ${diff ~/ 60}h ${diff % 60}m'
          : 'Approaching in ${diff}m';
      return _PeakStatus(
        Icons.schedule,
        AppTheme.warning,
        text,
      );
    }
    if (currentMinute <= peak.endMinutes) {
      return _PeakStatus(
        Icons.warning,
        AppTheme.danger,
        'Active now - stay strong',
      );
    }
    return _PeakStatus(
      Icons.check_circle,
      AppTheme.success,
      'Passed - held',
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}

class _PeakStatus {
  final IconData icon;
  final Color color;
  final String text;
  const _PeakStatus(this.icon, this.color, this.text);
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style:
                    const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13)),
          ),
          Text(
            value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.accent, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
