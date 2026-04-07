import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/domain/depression/thought_challenger.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThoughtRecordScreen extends ConsumerStatefulWidget {
  const ThoughtRecordScreen({super.key});

  @override
  ConsumerState<ThoughtRecordScreen> createState() =>
      _ThoughtRecordScreenState();
}

class _ThoughtRecordScreenState extends ConsumerState<ThoughtRecordScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  static const _totalSteps = 7;

  final _situationController = TextEditingController();
  final _thoughtController = TextEditingController();
  final _emotionController = TextEditingController();
  final _evidenceForController = TextEditingController();
  final _evidenceAgainstController = TextEditingController();
  final _balancedController = TextEditingController();

  double _emotionIntensity = 5;
  double _newIntensity = 5;
  CognitiveDistortion? _detectedDistortion;

  @override
  void dispose() {
    _pageController.dispose();
    _situationController.dispose();
    _thoughtController.dispose();
    _emotionController.dispose();
    _evidenceForController.dispose();
    _evidenceAgainstController.dispose();
    _balancedController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1 && _thoughtController.text.trim().isNotEmpty) {
      _detectedDistortion =
          ThoughtChallenger.identifyDistortion(_thoughtController.text);
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _save();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.into(db.thoughtRecords).insert(
          ThoughtRecordsCompanion.insert(
            date: DateTime.now(),
            situation: _situationController.text.trim(),
            automaticThought: _thoughtController.text.trim(),
            emotion: _emotionController.text.trim(),
            emotionIntensity: _emotionIntensity.round(),
            evidenceFor: Value(_evidenceForController.text.trim()),
            evidenceAgainst: Value(_evidenceAgainstController.text.trim()),
            balancedThought: Value(_balancedController.text.trim()),
            newIntensity: Value(_newIntensity.round()),
            distortionType: Value(_detectedDistortion?.name),
          ),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thought record saved'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thought Record'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: Colors.white12,
            color: AppTheme.accent,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                  _buildStep5(),
                  _buildStep6(),
                  _buildStep7(),
                ],
              ),
            ),
            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _stepContainer({
    required String stepLabel,
    required String prompt,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepLabel,
            style: TextStyle(color: AppTheme.accent, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            prompt,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return _stepContainer(
      stepLabel: 'Step 1 of 7',
      prompt: 'What happened?',
      child: TextField(
        controller: _situationController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Describe the situation briefly...',
          hintStyle: TextStyle(color: Colors.white30),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return _stepContainer(
      stepLabel: 'Step 2 of 7',
      prompt: 'What went through your mind?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _thoughtController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Write the automatic thought...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
          ),
          if (_detectedDistortion != null) ...[
            const SizedBox(height: 16),
            _buildDistortionHint(),
          ],
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return _stepContainer(
      stepLabel: 'Step 3 of 7',
      prompt: 'How did that make you feel?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _emotionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Name the emotion (e.g. sad, anxious, angry)...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Intensity',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('Low', style: TextStyle(color: Colors.white38, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _emotionIntensity,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '${_emotionIntensity.round()}',
                  activeColor: AppTheme.accent,
                  onChanged: (v) => setState(() => _emotionIntensity = v),
                ),
              ),
              const Text('High', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Center(
            child: Text(
              '${_emotionIntensity.round()} / 10',
              style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return _stepContainer(
      stepLabel: 'Step 4 of 7',
      prompt: 'Evidence for this thought?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What facts support this thought being true?',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _evidenceForController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'List the evidence...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
          ),
          if (_detectedDistortion != null) ...[
            const SizedBox(height: 16),
            _buildDistortionHint(),
          ],
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return _stepContainer(
      stepLabel: 'Step 5 of 7',
      prompt: 'Evidence against this thought?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What facts suggest this thought might not be completely true?',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _evidenceAgainstController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'List the counter-evidence...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
          ),
          if (_detectedDistortion != null) ...[
            const SizedBox(height: 16),
            _buildChallengeQuestions(),
          ],
        ],
      ),
    );
  }

  Widget _buildStep6() {
    return _stepContainer(
      stepLabel: 'Step 6 of 7',
      prompt: 'A more balanced way to see this?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Considering the evidence for and against, write a more balanced thought.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balancedController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Write a balanced thought...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep7() {
    return _stepContainer(
      stepLabel: 'Step 7 of 7',
      prompt: 'How do you feel now?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You said you felt "${_emotionController.text}" at '
            '${_emotionIntensity.round()}/10.',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'After examining the evidence, how intense is that feeling now?',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Low', style: TextStyle(color: Colors.white38, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _newIntensity,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '${_newIntensity.round()}',
                  activeColor: AppTheme.success,
                  onChanged: (v) => setState(() => _newIntensity = v),
                ),
              ),
              const Text('High', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Center(
            child: Text(
              '${_newIntensity.round()} / 10',
              style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          if (_newIntensity < _emotionIntensity)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_down, color: AppTheme.success, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your intensity dropped by ${(_emotionIntensity - _newIntensity).round()} points. '
                      'Challenging thoughts works.',
                      style: TextStyle(color: AppTheme.success, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDistortionHint() {
    final distortion = _detectedDistortion!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: AppTheme.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Possible pattern: ${_distortionLabel(distortion)}',
                  style: TextStyle(
                    color: AppTheme.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ThoughtChallenger.distortionDescriptions[distortion] ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeQuestions() {
    final questions =
        ThoughtChallenger.generateChallenge(_detectedDistortion!);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions to consider:',
            style: TextStyle(
              color: AppTheme.accent,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          ...questions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: AppTheme.accent)),
                    Expanded(
                      child: Text(q,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 13)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: _prevStep,
              child: const Text('Back'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: _nextStep,
            child: Text(_currentStep == _totalSteps - 1 ? 'Save' : 'Next'),
          ),
        ],
      ),
    );
  }

  String _distortionLabel(CognitiveDistortion d) => switch (d) {
        CognitiveDistortion.allOrNothing => 'All-or-Nothing Thinking',
        CognitiveDistortion.catastrophizing => 'Catastrophizing',
        CognitiveDistortion.mindReading => 'Mind Reading',
        CognitiveDistortion.fortuneTelling => 'Fortune Telling',
        CognitiveDistortion.emotionalReasoning => 'Emotional Reasoning',
        CognitiveDistortion.shouldStatements => 'Should Statements',
        CognitiveDistortion.labeling => 'Labeling',
        CognitiveDistortion.overgeneralization => 'Overgeneralization',
        CognitiveDistortion.discountingPositives => 'Discounting Positives',
        CognitiveDistortion.magnification => 'Magnification',
      };
}
