import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/presentation/questionnaire/safety_gate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RegistrationProfile testProfile;
  late MockQuestionnaireRepository mockRepo;

  setUp(() {
    testProfile = RegistrationProfile(
      id: 1,
      appInstallId: 'test-install',
      displayName: 'Test User',
      email: 'test@example.com',
      phone: '+1234567890',
      ageBand: 'adult18Plus',
      gender: 'male',
      countryCode: 'US',
      regionName: 'California',
      timezone: 'America/Los_Angeles',
      privacyAcknowledged: true,
      marketingConsent: false,
      webhookSyncStatus: 'notAttempted',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    mockRepo = MockQuestionnaireRepository();
  });

  Widget buildScreen({RegistrationProfile? profile}) {
    return ProviderScope(
      overrides: [
        questionnaireRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: MaterialApp(
        home: SafetyGateScreen(
          profile: profile ?? testProfile,
          sessionId: 1,
        ),
      ),
    );
  }

  testWidgets('1. Renders headline and body', (tester) async {
    await tester.pumpWidget(buildScreen());

    expect(find.text("You matter. You're not alone."), findsOneWidget);
    expect(
      find.textContaining("These thoughts can be scary"),
      findsOneWidget,
    );
  });

  testWidgets('2. Shows at least one helpline card', (tester) async {
    await tester.pumpWidget(buildScreen());

    expect(find.byType(Card), findsAtLeastNWidgets(1));
    expect(
      find.textContaining('988'),
      findsAtLeastNWidgets(1),
    );
  });

  testWidgets(
    '3. Tapping "I want to continue the questionnaire" calls markSafetyGateTriggered',
    (tester) async {
      await tester.pumpWidget(buildScreen());

      final continueButton = find.text('I want to continue the questionnaire');
      expect(continueButton, findsOneWidget);

      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();

      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(mockRepo.markSafetyGateTriggeredCallCount, 1);
      expect(mockRepo.lastSessionId, 1);
    },
  );

  testWidgets('4. Tapping "Continue" pops the screen', (tester) async {
    await tester.pumpWidget(buildScreen());

    final continueButton = find.text('I want to continue the questionnaire');
    
    await tester.ensureVisible(continueButton);
    await tester.pumpAndSettle();
    
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.byType(SafetyGateScreen), findsNothing);
  });

  testWidgets('5. Indian country code (IN) shows iCall or similar',
      (tester) async {
    final indianProfile = testProfile.copyWith(countryCode: 'IN');
    await tester.pumpWidget(buildScreen(profile: indianProfile));

    expect(
      find.textContaining('iCall'),
      findsOneWidget,
    );
    expect(
      find.textContaining('9152987821'),
      findsOneWidget,
    );
  });

  testWidgets('6. Unknown country code shows fallback helplines',
      (tester) async {
    final unknownProfile = testProfile.copyWith(countryCode: 'XX');
    await tester.pumpWidget(buildScreen(profile: unknownProfile));

    expect(
      find.textContaining('International Association for Suicide Prevention'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Befrienders Worldwide'),
      findsOneWidget,
    );
  });
}

class MockQuestionnaireRepository implements QuestionnaireRepository {
  int markSafetyGateTriggeredCallCount = 0;
  int? lastSessionId;

  @override
  Future<void> markSafetyGateTriggered(int sessionId) async {
    markSafetyGateTriggeredCallCount++;
    lastSessionId = sessionId;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
