import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// The "finish your setup" flow has to read the session that actually holds
/// the onboarding answers.
///
/// `ensureSession` opens a *new* session once the previous one is marked
/// complete — which is right for a fresh retake, and wrong for resuming. Using
/// it on the dashboard made the app re-ask every question the user had just
/// answered.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late QuestionnaireRepository repo;
  late RegistrationProfile profile;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = QuestionnaireRepository(db);
    profile = await RegistrationRepository(db).saveLocalProfile(
      const SignupProfileInput(
        displayName: 'Test',
        email: 'test@example.com',
        phone: '+15555550100',
        ageBand: RegistrationAgeBand.adult18Plus,
        gender: RegistrationGender.male,
        countryCode: 'US',
        regionName: 'CA',
        timezone: 'UTC',
        privacyAcknowledged: true,
        marketingConsent: false,
      ),
    );
  });

  tearDown(() => db.close());

  test('answers survive completion when read via getActiveSession', () async {
    final session = await repo.ensureSession(profile.id);
    await repo.saveAnswer(
      sessionId: session.id,
      sectionId: 'goal_selection',
      questionId: 'goal_q1',
      answerJson: const {
        'selectedOptionIds': ['goal_sleep'],
      },
    );
    await repo.saveAnswer(
      sessionId: session.id,
      sectionId: 'routine_map',
      questionId: 'routine_wake',
      answerJson: const {'selectedOptionId': 'wake_7_8'},
    );

    // Onboarding finishes — SupportMapScreen marks the session complete.
    await repo.markCompleted(session.id);

    final resumed = await repo.getActiveSession();
    expect(resumed, isNotNull);
    expect(resumed!.id, session.id, reason: 'must resume the same session');

    final answers = await repo.getAnswersMap(resumed.id);
    expect(answers.keys, containsAll(<String>['goal_q1', 'routine_wake']));
  });

  test('ensureSession after completion starts empty — the original bug',
      () async {
    final session = await repo.ensureSession(profile.id);
    await repo.saveAnswer(
      sessionId: session.id,
      sectionId: 'goal_selection',
      questionId: 'goal_q1',
      answerJson: const {
        'selectedOptionIds': ['goal_sleep'],
      },
    );
    await repo.markCompleted(session.id);

    final fresh = await repo.ensureSession(profile.id);
    expect(
      fresh.id,
      isNot(session.id),
      reason: 'ensureSession is expected to open a new session here',
    );
    expect(
      await repo.getAnswersMap(fresh.id),
      isEmpty,
      reason: 'which is exactly why the dashboard must not call it',
    );
  });
}
