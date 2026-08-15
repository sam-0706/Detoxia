import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/domain/questionnaire/detoxia_question_bank.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/domain/questionnaire/question_visibility_resolver.dart';
import 'package:detoxia/domain/questionnaire/resolver_context.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DetoxiaQuestionBank bank;
  late QuestionVisibilityResolver resolver;
  late AppDatabase db;
  late RegistrationRepository registrationRepository;
  late QuestionnaireRepository questionnaireRepository;

  setUpAll(() async {
    bank = await DetoxiaQuestionBank.loadFromAssets();
    resolver = QuestionVisibilityResolver(bank);
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    registrationRepository = RegistrationRepository(db);
    questionnaireRepository = QuestionnaireRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  List<QuestionnaireQuestion> visibleQuestions(ResolverContext ctx) {
    return resolver
        .resolveVisibleSections(ctx)
        .expand((section) => section.questions)
        .toList();
  }

  test('resume flow returns the 6th visible question after restart', () async {
    final registration = await registrationRepository.saveLocalProfile(
      _input(),
    );
    final session = await questionnaireRepository.ensureSession(
      registration.id,
    );
    final initialContext = ResolverContext(
      ageBand: RegistrationAgeBand.adult18Plus,
      gender: RegistrationGender.female,
      selectedGoals: const [],
      answers: const {},
    );
    final ordered = visibleQuestions(initialContext);

    for (var i = 0; i < 5; i++) {
      final question = ordered[i];
      await questionnaireRepository.saveAnswer(
        sessionId: session.id,
        sectionId: question.sectionId,
        questionId: question.questionId,
        answerJson: const {'answered': true},
      );
    }

    final restartedRepository = QuestionnaireRepository(db);
    final answers = await restartedRepository.getAnswersMap(session.id);
    final next = resolver.resolveNextQuestion(
      ctx: ResolverContext(
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.female,
        selectedGoals: _extractSelectedGoals(answers),
        answers: answers,
      ),
      completedSectionIds: const [],
    );

    expect(next, isNotNull);
    expect(next!.questionId, ordered[5].questionId);
    expect(next.sectionId, ordered[5].sectionId);
  });
}

List<String> _extractSelectedGoals(Map<String, dynamic> answers) {
  final answer = answers['goal_q1'];
  if (answer is Map && answer['selectedOptionIds'] is List) {
    return List<String>.from(answer['selectedOptionIds'] as List);
  }
  return const [];
}

SignupProfileInput _input() {
  return const SignupProfileInput(
    displayName: 'Test User',
    email: 'test@example.com',
    phone: '+15555551234',
    ageBand: RegistrationAgeBand.adult18Plus,
    gender: RegistrationGender.female,
    countryCode: 'US',
    regionName: 'CA',
    timezone: 'America/Los_Angeles',
    privacyAcknowledged: true,
    marketingConsent: false,
  );
}
