import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:detoxia/presentation/home/home_screen.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/services/event_processor.dart';
import 'package:detoxia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detoxia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _EntryGate(),
    );
  }
}

class _EntryGate extends ConsumerWidget {
  const _EntryGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(userRepositoryProvider).getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == null) {
          return const OnboardingScreen();
        }
        return const HomeScreen();
      },
    );
  }
}
