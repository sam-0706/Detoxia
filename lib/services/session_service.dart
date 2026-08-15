import 'package:detoxia/core/encryption/data_export.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/presentation/signup/signup_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Clears local profile so the user can re-pick modules (ADHD, anxiety, etc.).
class SessionService {
  final AppDatabase _db;
  final Ref _ref;

  SessionService(this._db, this._ref);

  Future<void> signOut(BuildContext context) async {
    await DataExport(_db).deleteAll();
    _ref.invalidate(registrationRepositoryProvider);
    _ref.invalidate(questionnaireRepositoryProvider);
    _ref.read(activeThemeProvider.notifier).setTheme(AppTheme.darkTheme);

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignupProfileScreen()),
      (_) => false,
    );
  }
}

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref.watch(databaseProvider), ref);
});
