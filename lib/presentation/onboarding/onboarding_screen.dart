import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/utils/time_utils.dart';
import 'package:detoxia/data/repositories/peak_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/entities/peak_node.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/presentation/guide/feature_guide_screen.dart';
import 'package:detoxia/presentation/onboarding/pages/personal_info_page.dart';
import 'package:detoxia/presentation/onboarding/pages/goal_page.dart';
import 'package:detoxia/presentation/onboarding/pages/life_structure_page.dart';
import 'package:detoxia/presentation/onboarding/pages/scope_timing_page.dart';
import 'package:detoxia/presentation/onboarding/pages/triggers_depth_page.dart';
import 'package:detoxia/services/data_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  String name = '';
  String email = '';
  String phone = '';
  String country = '';

  RoleType? roleType;
  Set<int> workDays = {1, 2, 3, 4, 5};
  TimeOfDay? workStart = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay? workEnd = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay weekdayWake = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay weekdaySleep = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay offdayWake = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay offdaySleep = const TimeOfDay(hour: 0, minute: 0);

  Set<BehaviorType> struggles = {};
  ScrollingLinkage scrollingLinkage = ScrollingLinkage.never;
  bool weekendDifferent = false;
  List<PeakPin> peakPins = [];
  List<PeakPin> weekendPeakPins = [];

  Set<TriggerType> triggers = {};
  StruggleDuration? struggleDuration;
  ResistAbility? resistAbility;

  GoalType? goalType;
  Set<MotivationType> motivations = {};
}

class PeakPin {
  TimeOfDay time;
  Frequency frequency;
  PeakPin({required this.time, this.frequency = Frequency.almostDaily});
}

class OnboardingStateNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => OnboardingState();

  void update(void Function(OnboardingState s) updater) {
    updater(state);
    ref.notifyListeners();
  }
}

final onboardingStateProvider =
    NotifierProvider<OnboardingStateNotifier, OnboardingState>(
        OnboardingStateNotifier.new);

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _complete() async {
    final state = ref.read(onboardingStateProvider);

    if (state.roleType == null ||
        state.struggleDuration == null ||
        state.resistAbility == null ||
        state.goalType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final profile = UserProfile(
      name: state.name,
      email: state.email,
      phone: state.phone,
      country: state.country,
      roleType: state.roleType!,
      workDays: state.workDays.toList(),
      workStart: state.workStart,
      workEnd: state.workEnd,
      weekdayWakeTime: state.weekdayWake,
      weekdaySleepTime: state.weekdaySleep,
      offdayWakeTime: state.offdayWake,
      offdaySleepTime: state.offdaySleep,
      struggles: state.struggles.toList(),
      scrollingTriggersSexual: state.scrollingLinkage,
      triggers: state.triggers.toList(),
      struggleDuration: state.struggleDuration!,
      resistAbility: state.resistAbility!,
      goalType: state.goalType!,
      motivations: state.motivations.toList(),
      weekendDifferent: state.weekendDifferent,
    );

    await ref.read(userRepositoryProvider).saveUser(profile);

    final peakRepo = ref.read(peakRepositoryProvider);
    final allPins = [...state.peakPins];

    for (int i = 0; i < allPins.length; i++) {
      final pin = allPins[i];
      final label = _labelForTime(pin.time);
      await peakRepo.insertPeak(PeakNodeEntity(
        label: label,
        centerTime: pin.time,
        frequency: pin.frequency,
        isHardest: i == 0,
        dayTypes: const ['both'],
      ));
    }

    if (state.weekendDifferent) {
      for (final pin in state.weekendPeakPins) {
        final label = 'Weekend ${_labelForTime(pin.time)}';
        await peakRepo.insertPeak(PeakNodeEntity(
          label: label,
          centerTime: pin.time,
          frequency: pin.frequency,
          dayTypes: const ['weekend'],
        ));
      }
    }

    // Send registration data to your backend (fire-and-forget)
    DataSyncService.sendRegistration(
      name: state.name,
      email: state.email,
      phone: state.phone,
      country: state.country,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const FeatureGuideScreen()),
    );
  }

  String _labelForTime(TimeOfDay time) {
    final minutes = TimeUtils.timeToMinutes(time);
    if (minutes < 360) return 'Early morning';
    if (minutes < 720) return 'Morning';
    if (minutes < 1020) return 'Afternoon';
    if (minutes < 1260) return 'Evening';
    return 'Late night';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _prevPage,
                    ),
                  const Spacer(),
                  Text(
                    '${_currentPage + 1}/5',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / 5,
                backgroundColor: Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) =>
                    setState(() => _currentPage = page),
                children: [
                  PersonalInfoPage(onNext: _nextPage),
                  LifeStructurePage(onNext: _nextPage),
                  ScopeTimingPage(onNext: _nextPage),
                  TriggersDepthPage(onNext: _nextPage),
                  GoalPage(onComplete: _complete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
