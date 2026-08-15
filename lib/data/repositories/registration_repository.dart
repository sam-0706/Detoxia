import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class SignupProfileInput {
  final String displayName;
  final String email;
  final String phone;
  final RegistrationAgeBand ageBand;
  final RegistrationGender gender;
  final String countryCode;
  final String regionName;
  final String timezone;
  final bool privacyAcknowledged;
  final bool marketingConsent;

  const SignupProfileInput({
    required this.displayName,
    required this.email,
    required this.phone,
    required this.ageBand,
    required this.gender,
    required this.countryCode,
    required this.regionName,
    required this.timezone,
    required this.privacyAcknowledged,
    required this.marketingConsent,
  });
}

class RegistrationRepository {
  final AppDatabase _db;
  final Uuid _uuid;

  RegistrationRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  Future<RegistrationProfile?> getProfile() {
    return _db.select(_db.registrationProfiles).getSingleOrNull();
  }

  Future<bool> isSignupCompleted() async {
    final profile = await getProfile();
    return profile?.signupCompletedAt != null;
  }

  Future<RegistrationProfile> saveLocalProfile(SignupProfileInput input) async {
    final existing = await getProfile();
    final now = DateTime.now();
    final appInstallId = existing?.appInstallId ?? _uuid.v4();

    final companion = RegistrationProfilesCompanion(
      appInstallId: Value(appInstallId),
      displayName: Value(input.displayName.trim()),
      email: Value(input.email.trim()),
      phone: Value(input.phone.trim()),
      ageBand: Value(input.ageBand.name),
      gender: Value(input.gender.name),
      countryCode: Value(input.countryCode),
      regionName: Value(input.regionName),
      timezone: Value(input.timezone),
      privacyAcknowledged: Value(input.privacyAcknowledged),
      marketingConsent: Value(input.marketingConsent),
      webhookSyncStatus: Value(WebhookSyncStatus.notAttempted.name),
      signupCompletedAt: Value(now),
      updatedAt: Value(now),
    );

    if (existing == null) {
      final id = await _db.into(_db.registrationProfiles).insert(companion);
      return (_db.select(_db.registrationProfiles)
            ..where((t) => t.id.equals(id)))
          .getSingle();
    }

    await (_db.update(_db.registrationProfiles)
          ..where((t) => t.id.equals(existing.id)))
        .write(companion);
    return (_db.select(_db.registrationProfiles)
          ..where((t) => t.id.equals(existing.id)))
        .getSingle();
  }

  Future<void> updateWebhookStatus(
    int profileId,
    WebhookSyncStatus status,
  ) async {
    await (_db.update(_db.registrationProfiles)
          ..where((t) => t.id.equals(profileId)))
        .write(
      RegistrationProfilesCompanion(
        webhookSyncStatus: Value(status.name),
        webhookLastAttemptAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  return RegistrationRepository(ref.watch(databaseProvider));
});
