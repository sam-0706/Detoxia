import 'dart:convert';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/question_bank_loader.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:detoxia/presentation/questionnaire/games/micro_game_host.dart';
import 'package:detoxia/presentation/questionnaire/safety_gate_screen.dart';
import 'package:detoxia/presentation/questionnaire/support_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/progress_ring.dart';
import 'widgets/question_card.dart';
import 'widgets/section_complete_animation.dart';

/// Optional override for the question bank loader — useful in tests.
final questionBankLoaderProvider = Provider<QuestionBankLoader?>((_) => null);

// ─── Screen ───────────────────────────────────────────────────────────────────

class QuestionnaireScreen extends ConsumerStatefulWidget {
  final int profileId;
  final int sessionId;

  /// Which slice of the bank to ask. Onboarding passes
  /// [QuestionTier.core]; the "finish your setup" flow from home passes null
  /// to pick up everything that was deferred.
  final QuestionTier? tier;

  const QuestionnaireScreen({
    super.key,
    required this.profileId,
    required this.sessionId,
    this.tier,
  });

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen>
    with TickerProviderStateMixin {
  // ── Loading state ─────────────────────────────────────────────────────────
  bool _isLoading = true;
  String? _loadError;

  // ── Data ──────────────────────────────────────────────────────────────────
  RegistrationProfile? _profile;
  QuestionnaireSession? _session;
  DetoxiaQuestionBank? _bank;

  /// All answers accumulated so far: questionId → raw answer JSON.
  Map<String, dynamic> _answers = {};

  /// Flat ordered list of visible questions under the current [_resolverCtx].
  List<_QuestionEntry> _visibleQuestions = [];

  /// Index into [_visibleQuestions] — the card currently shown.
  int _currentIndex = 0;

  // ── Intro card ────────────────────────────────────────────────────────────
  bool _showIntro = false;

  // ── Slide animation ───────────────────────────────────────────────────────
  late AnimationController _slideController;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeIn;

  /// Which way the next card should enter from. Going back slides in from the
  /// left so the motion matches the direction of travel.
  bool _slidingForward = true;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _rebuildSlideTween();
    _fadeIn = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );
    _load();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> _load() async {
    try {
      final registrationRepo = ref.read(registrationRepositoryProvider);
      final questionnaireRepo = ref.read(questionnaireRepositoryProvider);
      final loaderOverride = ref.read(questionBankLoaderProvider);

      // Load profile, session, bank, existing answers concurrently.
      final results = await Future.wait([
        registrationRepo.getProfile(),
        questionnaireRepo.getAnswersMap(widget.sessionId),
        DetoxiaQuestionBank.loadFromAssets(loader: loaderOverride),
      ]);

      final profile = results[0] as RegistrationProfile?;
      final answersMap = results[1] as Map<String, dynamic>;
      final bank = results[2] as DetoxiaQuestionBank;

      if (!mounted) return;

      final session = await questionnaireRepo.ensureSession(widget.profileId);

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _session = session;
        _bank = bank;
        _answers = Map<String, dynamic>.from(answersMap);
        _showIntro = answersMap.isEmpty;
        _isLoading = false;
      });

      _rebuildVisibleQuestions();

      if (!_showIntro) {
        _restorePosition();
      }

      _slideController.forward(from: 0);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Computes the flat visible question list from the current [_answers].
  void _rebuildVisibleQuestions() {
    final profile = _profile;
    final bank = _bank;
    if (profile == null || bank == null) return;

    final ageBand = _ageBandFromString(profile.ageBand);
    final gender = _genderFromString(profile.gender);
    final selectedGoals = _extractSelectedGoals(_answers);

    final ctx = ResolverContext(
      ageBand: ageBand,
      gender: gender,
      selectedGoals: selectedGoals,
      answers: _answers,
    );

    final resolver = QuestionVisibilityResolver(bank);
    final sections = resolver.resolveVisibleSections(ctx, tier: widget.tier);

    final entries = <_QuestionEntry>[];
    for (final section in sections) {
      for (int i = 0; i < section.questions.length; i++) {
        entries.add(
          _QuestionEntry(
            question: section.questions[i],
            sectionTitle: section.sectionTitle,
            sectionSubtitle: section.sectionSubtitle,
            positionInSection: i + 1,
            countInSection: section.questions.length,
          ),
        );
      }
    }

    setState(() => _visibleQuestions = entries);
  }

  /// After resuming from a prior session, jump to the first unanswered question.
  void _restorePosition() {
    for (int i = 0; i < _visibleQuestions.length; i++) {
      if (!_answers.containsKey(_visibleQuestions[i].question.questionId)) {
        setState(() => _currentIndex = i);
        return;
      }
    }
    // All answered → show last question or complete.
    setState(() {
      _currentIndex = _visibleQuestions.isEmpty
          ? 0
          : _visibleQuestions.length - 1;
    });
  }

  // ── Answer handling ───────────────────────────────────────────────────────

  Future<void> _onAnswer(
    QuestionnaireQuestion question,
    Map<String, dynamic> answer,
  ) async {
    final repo = ref.read(questionnaireRepositoryProvider);
    final session = _session;
    if (session == null) return;

    // Persist immediately.
    await repo.saveAnswer(
      sessionId: session.id,
      sectionId: question.sectionId,
      questionId: question.questionId,
      answerJson: answer,
    );

    // Update local state.
    setState(() {
      _answers = Map<String, dynamic>.from(_answers)
        ..[question.questionId] = answer;
    });

    // Recompute visible questions now that answers may unlock new sections.
    _rebuildVisibleQuestions();

    // Check if this is a safety gate question answered "yes".
    if (_isSafetyGateTriggered(question.questionId, answer)) {
      final profile = _profile;
      if (profile != null && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                SafetyGateScreen(profile: profile, sessionId: session.id),
          ),
        );
      }
    }

    await _advanceToNextQuestion(question);
  }

  Future<void> _advanceToNextQuestion(QuestionnaireQuestion answered) async {
    // Find next unanswered question after the current position.
    final nextIndex = _findNextUnansweredIndex();

    if (nextIndex == null) {
      // Questionnaire complete.
      await _onComplete();
      return;
    }

    // Check if we're completing a section
    final currentSectionId = answered.sectionId;
    final nextEntry = _visibleQuestions[nextIndex];
    final nextSectionId = nextEntry.question.sectionId;

    if (currentSectionId != nextSectionId) {
      // Section completed! Show animation.
      final bank = _bank;
      if (bank != null && mounted) {
        final completedSection = bank.sectionById(currentSectionId);
        if (completedSection?.completionMessage != null) {
          await Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SectionCompleteAnimation(
                    message: completedSection!.completionMessage!,
                    onComplete: () {
                      Navigator.of(context).pop();
                    },
                  ),
            ),
          );
        }

        // Optional micro-game after every 3rd completed section.
        final completedCount = _computeCompletedSections().length;
        if (completedCount > 0 && completedCount % 3 == 0 && mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (hostContext) => MicroGameHost(
                sectionsCompleted: completedCount,
                onDone: () => Navigator.of(hostContext).pop(),
              ),
            ),
          );
        }
      }
    }

    _slidingForward = true;
    _rebuildSlideTween();
    setState(() => _currentIndex = nextIndex);

    // Update session progress.
    final session = _session;
    if (session != null) {
      final completedSections = _computeCompletedSections();
      await ref
          .read(questionnaireRepositoryProvider)
          .updateSessionProgress(
            sessionId: session.id,
            sectionId: nextEntry.question.sectionId,
            questionId: nextEntry.question.questionId,
            completedSectionIds: completedSections,
            answerCount: _answers.length,
          );
    }

    _slideController.forward(from: 0);
  }

  int? _findNextUnansweredIndex() {
    for (int i = 0; i < _visibleQuestions.length; i++) {
      if (!_answers.containsKey(_visibleQuestions[i].question.questionId)) {
        return i;
      }
    }
    return null;
  }

  List<String> _computeCompletedSections() {
    // A section is complete when every visible question in it has an answer.
    final Map<String, List<_QuestionEntry>> bySec = {};
    for (final e in _visibleQuestions) {
      bySec.putIfAbsent(e.question.sectionId, () => []).add(e);
    }
    return bySec.entries
        .where(
          (entry) => entry.value.every(
            (e) => _answers.containsKey(e.question.questionId),
          ),
        )
        .map((entry) => entry.key)
        .toList();
  }

  Future<void> _onComplete() async {
    final session = _session;
    final profile = _profile;
    if (session == null || profile == null) return;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            SupportMapScreen(profileId: profile.id, sessionId: session.id),
      ),
    );
  }

  void _rebuildSlideTween() {
    _slideIn =
        Tween<Offset>(
          begin: Offset(_slidingForward ? 0.10 : -0.10, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _onBack() {
    if (_currentIndex <= 0) return;
    _slidingForward = false;
    _rebuildSlideTween();
    setState(() => _currentIndex -= 1);
    _slideController.forward(from: 0);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<String> _extractSelectedGoals(Map<String, dynamic> answers) {
    final goalAnswer = answers['goal_q1'];
    if (goalAnswer == null) return const [];
    if (goalAnswer is Map) {
      final ids = goalAnswer['selectedOptionIds'];
      if (ids is List) return List<String>.from(ids);
      final id = goalAnswer['selectedOptionId'];
      if (id is String) return [id];
    }
    return const [];
  }

  RegistrationAgeBand _ageBandFromString(String value) {
    return switch (value) {
      'teen13To15' => RegistrationAgeBand.teen13To15,
      'teen16To17' => RegistrationAgeBand.teen16To17,
      _ => RegistrationAgeBand.adult18Plus,
    };
  }

  RegistrationGender _genderFromString(String value) {
    return switch (value) {
      'male' => RegistrationGender.male,
      'female' => RegistrationGender.female,
      _ => RegistrationGender.preferNotToSay,
    };
  }

  /// Answers that count toward the visible progress.
  ///
  /// Deliberately not `_answers.length`: answers to questions that later
  /// became irrelevant (a commute answered before switching to "works from
  /// home") are still stored, and counting them would push progress past the
  /// number of questions actually on screen.
  int get _answeredCount => _visibleQuestions
      .where((entry) => _answers.containsKey(entry.question.questionId))
      .length;

  bool _isSafetyGateTriggered(String questionId, Map<String, dynamic> answer) {
    const safetyQuestionIds = {'safety_q1', 'safety_q2', 'safety_q3'};
    if (!safetyQuestionIds.contains(questionId)) return false;

    final selectedOption = answer['selectedOptionId'];
    return selectedOption == 'yes';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Failed to load questionnaire.\n$_loadError',
            textAlign: TextAlign.center,
            style:  TextStyle(color: AppTheme.palette(context).textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _showIntro ? _buildIntroCard() : _buildQuestionCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final p = AppTheme.palette(context);
    final totalCount = _visibleQuestions.length;
    final canGoBack = !_showIntro && _currentIndex > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
      child: Row(
        children: [
          // Built only when it can actually be used — an always-present but
          // invisible button still reaches screen readers.
          if (canGoBack)
            IconButton(
              onPressed: _onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 22),
              color: p.textSecondary,
              tooltip: 'Back',
            )
          else
            const SizedBox(width: 48, height: 48),
          const Spacer(),
          ProgressRing(
            answered: _answeredCount.clamp(0, totalCount),
            total: totalCount > 0 ? totalCount : 1,
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    final p = AppTheme.palette(context);

    return FadeTransition(
      opacity: _fadeIn,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: p.accentSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.tune_rounded, color: p.accent, size: 26),
            ),
            const SizedBox(height: 24),
            Text(
              "Let's calibrate Detoxia",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 14),
            Text(
              "You're not taking a test. Answer honestly and Detoxia learns "
              'the shape of your day — when you\'re free, when you\'re alone, '
              'and when things get hard.',
              style: TextStyle(color: p.textSecondary, fontSize: 16.5, height: 1.55),
            ),
            const SizedBox(height: 26),
            // No question count here on purpose: goals aren't chosen yet, so
            // any number shown now would be an undercount that grows on the
            // next screen. The progress ring carries the real total once the
            // questionnaire knows what's relevant.
            _IntroFact(
              icon: Icons.checklist_rounded,
              title: 'Only what applies to you',
              body: "Your answers hide the questions that don't fit — most "
                  'are a single tap.',
            ),
            const SizedBox(height: 12),
            _IntroFact(
              icon: Icons.lock_outline_rounded,
              title: 'Stays on this device',
              body: 'Your sensitive answers are never uploaded.',
            ),
            const SizedBox(height: 12),
            _IntroFact(
              icon: Icons.pause_circle_outline_rounded,
              title: 'Stop any time',
              body: 'Your place is saved as you go.',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _showIntro = false);
                  _slideController.forward(from: 0);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'Begin',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    if (_visibleQuestions.isEmpty) {
      return Center(
        child: Text(
          'No questions available.',
          style: TextStyle(color: AppTheme.palette(context).textSecondary),
        ),
      );
    }

    final safeIndex = _currentIndex.clamp(0, _visibleQuestions.length - 1);
    final entry = _visibleQuestions[safeIndex];
    final existing = _answers[entry.question.questionId];

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: QuestionCard(
            key: ValueKey(entry.question.questionId),
            question: entry.question,
            sectionTitle: entry.sectionTitle,
            sectionSubtitle: entry.sectionSubtitle,
            positionInSection: entry.positionInSection,
            countInSection: entry.countInSection,
            initialAnswer: existing is Map
                ? Map<String, dynamic>.from(existing)
                : null,
            showPrivacyNote: safeIndex == 0,
            onAnswer: (answer) => _onAnswer(entry.question, answer),
          ),
        ),
      ),
    );
  }
}

/// One reassurance line on the intro card.
class _IntroFact extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _IntroFact({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: p.calm),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: p.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: TextStyle(
                  color: p.textTertiary,
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _QuestionEntry {
  final QuestionnaireQuestion question;
  final String sectionTitle;
  final String? sectionSubtitle;
  final int positionInSection;
  final int countInSection;

  const _QuestionEntry({
    required this.question,
    required this.sectionTitle,
    this.sectionSubtitle,
    required this.positionInSection,
    required this.countInSection,
  });
}

// ── Provider helpers used externally ─────────────────────────────────────────

/// Convenience: encode a [Map] to JSON for persistence comparisons in tests.
String encodeAnswer(Map<String, dynamic> answer) => jsonEncode(answer);
