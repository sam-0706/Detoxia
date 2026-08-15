import 'dart:io';

import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/presentation/questionnaire/questionnaire_screen.dart';
import 'package:detoxia/presentation/signup/signup_profile_screen.dart';
import 'package:detoxia/services/event_processor.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }
  runApp(const ProviderScope(child: DetoxiaApp()));
}

class DetoxiaApp extends ConsumerStatefulWidget {
  const DetoxiaApp({super.key});

  @override
  ConsumerState<DetoxiaApp> createState() => _DetoxiaAppState();
}

class _DetoxiaAppState extends ConsumerState<DetoxiaApp> {
  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      final notifService = ref.read(notificationServiceProvider);
      await notifService.initialize();
    } catch (e) {
      debugPrint('Notification init failed (non-fatal): $e');
    }
    try {
      ref.read(eventProcessorProvider).start();
    } catch (e) {
      debugPrint('Event processor init failed (non-fatal): $e');
    }

    // Cycle-tracking users get the Rose palette by default — but only until
    // they pick a theme themselves, after which their choice always wins.
    try {
      if (await ActiveThemeNotifier.hasUserChoice()) return;
      final user = await ref.read(userRepositoryProvider).getUser();
      if (user != null && user.isPinkTheme) {
        ref.read(activeThemeProvider.notifier).applyDefault(ThemePresets.rose);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(activeThemeProvider);
    return MaterialApp(
      title: 'Detoxia',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const _EntryGate(),
    );
  }
}

class _EntryGate extends ConsumerWidget {
  const _EntryGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Widget>(
      future: _resolveEntry(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data ?? const SignupProfileScreen();
      },
    );
  }

  Future<Widget> _resolveEntry(WidgetRef ref) async {
    final registrationRepo = ref.read(registrationRepositoryProvider);
    final questionnaireRepo = ref.read(questionnaireRepositoryProvider);

    final profile = await registrationRepo.getProfile();
    if (profile?.signupCompletedAt == null) {
      return const SignupProfileScreen();
    }

    final session = await questionnaireRepo.ensureSession(profile!.id);
    if (!session.isCompleted) {
      return QuestionnaireScreen(
        profileId: profile.id,
        sessionId: session.id,
        tier: QuestionTier.core,
      );
    }

    return const HomeScreen();
  }
}
