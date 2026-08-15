import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/domain/questionnaire/models/question_option.dart';
import 'package:detoxia/domain/questionnaire/models/question_type.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_section.dart';
import 'package:detoxia/domain/questionnaire/question_bank_loader.dart';
import 'package:detoxia/presentation/questionnaire/questionnaire_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('QuestionnaireScreen resumes on question 6 after saved answers', (
    tester,
  ) async {
    final setup = await _makeSetup();
    addTearDown(setup.db.close);
    final repo = QuestionnaireRepository(setup.db);

    for (var i = 1; i <= 5; i++) {
      await repo.saveAnswer(
        sessionId: setup.session.id,
        sectionId: 's1',
        questionId: 'q$i',
        answerJson: const {'selectedOptionId': 's0', 'numericValue': 0},
      );
    }

    await tester.pumpWidget(
      _screen(
        db: setup.db,
        profile: setup.profile,
        session: setup.session,
        loader: const _MockLoader([_testSection]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 6'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
    expect(find.text("Let's calibrate Detoxia"), findsNothing);
    expect(find.byTooltip('Back'), findsOneWidget);
  });
}

Future<
  ({AppDatabase db, RegistrationProfile profile, QuestionnaireSession session})
>
_makeSetup() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await RegistrationRepository(db).saveLocalProfile(
    const SignupProfileInput(
      displayName: 'Test',
      email: 'test@example.com',
      phone: '+15555550100',
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
      countryCode: 'US',
      regionName: 'CA',
      timezone: 'UTC',
      privacyAcknowledged: true,
      marketingConsent: false,
    ),
  );
  final session = await QuestionnaireRepository(db).ensureSession(profile.id);
  return (db: db, profile: profile, session: session);
}

Widget _screen({
  required AppDatabase db,
  required RegistrationProfile profile,
  required QuestionnaireSession session,
  required QuestionBankLoader loader,
}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      questionBankLoaderProvider.overrideWithValue(loader),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: QuestionnaireScreen(profileId: profile.id, sessionId: session.id),
    ),
  );
}

class _MockLoader implements QuestionBankLoader {
  final List<QuestionnaireSection> sections;

  const _MockLoader(this.sections);

  @override
  Future<List<QuestionnaireSection>> load() async => sections;
}

const _testSection = QuestionnaireSection(
  sectionId: 's1',
  sectionTitle: 'Test Section',
  engineTarget: 'test',
  order: 1,
  questions: [_q1, _q2, _q3, _q4, _q5, _q6],
);

const _q1 = QuestionnaireQuestion(
  questionId: 'q1',
  sectionId: 's1',
  questionType: QuestionType.scale,
  text: 'Question 1',
  options: _scaleOptions,
);

const _q2 = QuestionnaireQuestion(
  questionId: 'q2',
  sectionId: 's1',
  questionType: QuestionType.scale,
  text: 'Question 2',
  options: _scaleOptions,
);

const _q3 = QuestionnaireQuestion(
  questionId: 'q3',
  sectionId: 's1',
  questionType: QuestionType.scale,
  text: 'Question 3',
  options: _scaleOptions,
);

const _q4 = QuestionnaireQuestion(
  questionId: 'q4',
  sectionId: 's1',
  questionType: QuestionType.scale,
  text: 'Question 4',
  options: _scaleOptions,
);

const _q5 = QuestionnaireQuestion(
  questionId: 'q5',
  sectionId: 's1',
  questionType: QuestionType.scale,
  text: 'Question 5',
  options: _scaleOptions,
);

const _q6 = QuestionnaireQuestion(
  questionId: 'q6',
  sectionId: 's1',
  questionType: QuestionType.scale,
  text: 'Question 6',
  options: _scaleOptions,
);

const _scaleOptions = [
  QuestionOption(optionId: 's0', label: 'Never', numericValue: 0),
  QuestionOption(optionId: 's2', label: 'Often', numericValue: 2),
];
