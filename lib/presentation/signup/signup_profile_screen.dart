import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/core/theme/app_theme.dart';
import 'package:detoxia/data/repositories/questionnaire_repository.dart';
import 'package:detoxia/data/repositories/registration_repository.dart';
import 'package:detoxia/data/repositories/user_repository.dart';
import 'package:detoxia/domain/entities/user_profile.dart';
import 'package:detoxia/domain/registration/signup_validation.dart';
import 'package:detoxia/domain/questionnaire/models/questionnaire_question.dart';
import 'package:detoxia/presentation/questionnaire/questionnaire_screen.dart';
import 'package:detoxia/services/registration_webhook_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _CountryOption {
  final String code;
  final String name;
  final String dialCode;

  const _CountryOption(this.code, this.name, this.dialCode);
}

const _countries = [
  _CountryOption('IN', 'India', '+91'),
  _CountryOption('US', 'United States', '+1'),
  _CountryOption('GB', 'United Kingdom', '+44'),
  _CountryOption('CA', 'Canada', '+1'),
  _CountryOption('AU', 'Australia', '+61'),
  _CountryOption('AE', 'United Arab Emirates', '+971'),
  _CountryOption('SG', 'Singapore', '+65'),
  _CountryOption('XX', 'Other', '+'),
];

class SignupProfileScreen extends ConsumerStatefulWidget {
  const SignupProfileScreen({super.key});

  @override
  ConsumerState<SignupProfileScreen> createState() =>
      _SignupProfileScreenState();
}

class _SignupProfileScreenState extends ConsumerState<SignupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  RegistrationAgeBand? _ageBand;
  RegistrationGender? _gender;
  _CountryOption? _country = _countries.first;
  bool _privacyAcknowledged = false;
  bool _marketingConsent = false;
  bool _saving = false;

  String get _timezone {
    final now = DateTime.now();
    final name = now.timeZoneName;
    final offset = now.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final abs = offset.abs();
    final hours = abs.inHours.toString().padLeft(2, '0');
    final minutes = (abs.inMinutes % 60).toString().padLeft(2, '0');
    return '$name (UTC$sign$hours:$minutes)';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    if (SignupValidation.validatePrivacy(_privacyAcknowledged) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please acknowledge the privacy note.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final input = SignupProfileInput(
        displayName: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: '${_country?.dialCode ?? ''}${_phoneCtrl.text}',
        ageBand: _ageBand!,
        gender: _gender!,
        countryCode: _country!.code,
        regionName: _country!.name,
        timezone: _timezone,
        privacyAcknowledged: _privacyAcknowledged,
        marketingConsent: _marketingConsent,
      );

      final profile =
          await ref.read(registrationRepositoryProvider).saveLocalProfile(input);

      // Keep the legacy Detox Recovery shell functional until Questionnaire V1
      // fully replaces the old user profile shape.
      await ref.read(userRepositoryProvider).saveUser(
            UserProfile(
              name: profile.displayName,
              email: profile.email,
              phone: profile.phone,
              country: profile.regionName,
              conditions: const [ConditionType.detoxRecovery],
              roleType: RoleType.notWorking,
              weekdayWakeTime: const TimeOfDay(hour: 7, minute: 0),
              weekdaySleepTime: const TimeOfDay(hour: 23, minute: 0),
              offdayWakeTime: const TimeOfDay(hour: 8, minute: 0),
              offdaySleepTime: const TimeOfDay(hour: 23, minute: 30),
              struggles: const [BehaviorType.scrolling],
              scrollingTriggersSexual: ScrollingLinkage.never,
              triggers: const [],
              struggleDuration: StruggleDuration.twoToFiveYears,
              resistAbility: ResistAbility.sometimes,
              goalType: GoalType.control,
              motivations: const [MotivationType.health],
            ),
          );

      final webhookStatus =
          await const RegistrationWebhookService().sync(profile);
      await ref
          .read(registrationRepositoryProvider)
          .updateWebhookStatus(profile.id, webhookStatus);

      final session = await ref
          .read(questionnaireRepositoryProvider)
          .ensureSession(profile.id);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuestionnaireScreen(
            profileId: profile.id,
            sessionId: session.id,
            tier: QuestionTier.core,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                children: [
                  // ListView hands children a tight width, so the badge needs
                  // an Align to keep its own size instead of stretching.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: p.accentSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: p.accent,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Set up your private profile',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your wellness answers stay on this device. Only basic '
                    'signup details are synced, for your account record.',
                    style: TextStyle(
                      color: p.textSecondary,
                      fontSize: 15.5,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _FieldGroupLabel('About you', palette: p),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Name / nickname',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: SignupValidation.validateName,
                  ),
                  const SizedBox(height: 26),
                  _FieldGroupLabel('How we reach you', palette: p),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: SignupValidation.validateEmail,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<_CountryOption>(
                    initialValue: _country,
                    decoration:
                        const InputDecoration(labelText: 'Country / region'),
                    items: _countries
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text('${c.name} (${c.dialCode})'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _country = value),
                    validator: (value) =>
                        SignupValidation.validateRequired(value, 'Country'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      prefixText: _country?.dialCode,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                    ],
                    validator: SignupValidation.validatePhone,
                  ),
                  const SizedBox(height: 26),
                  _FieldGroupLabel('So questions fit you', palette: p),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<RegistrationAgeBand>(
                    initialValue: _ageBand,
                    decoration: const InputDecoration(labelText: 'Age band'),
                    items: const [
                      DropdownMenuItem(
                        value: RegistrationAgeBand.teen13To15,
                        child: Text('13-15'),
                      ),
                      DropdownMenuItem(
                        value: RegistrationAgeBand.teen16To17,
                        child: Text('16-17'),
                      ),
                      DropdownMenuItem(
                        value: RegistrationAgeBand.adult18Plus,
                        child: Text('18+'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _ageBand = value),
                    validator: (value) =>
                        SignupValidation.validateRequired(value, 'Age band'),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<RegistrationGender>(
                    initialValue: _gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: const [
                      DropdownMenuItem(
                        value: RegistrationGender.male,
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: RegistrationGender.female,
                        child: Text('Female'),
                      ),
                      DropdownMenuItem(
                        value: RegistrationGender.preferNotToSay,
                        child: Text('Prefer not to say'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _gender = value),
                    validator: (value) =>
                        SignupValidation.validateRequired(value, 'Gender'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 15,
                        color: p.textTertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Timezone: $_timezone',
                          style: TextStyle(
                            color: p.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _ConsentTile(
                    value: _privacyAcknowledged,
                    onChanged: (value) =>
                        setState(() => _privacyAcknowledged = value),
                    label:
                        'I understand my sensitive Detoxia wellness data '
                        'stays on this device.',
                    required: true,
                  ),
                  const SizedBox(height: 10),
                  _ConsentTile(
                    value: _marketingConsent,
                    onChanged: (value) =>
                        setState(() => _marketingConsent = value),
                    label:
                        'Send me product updates and registration '
                        'communications.',
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _submit,
                      child: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (_saving)
              Container(
                color: p.canvas.withValues(alpha: 0.72),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 18),
                      Text(
                        'Creating your profile…',
                        style: TextStyle(color: p.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small caps label that breaks the form into scannable groups — a single
/// undifferentiated column of eight inputs reads as much longer than it is.
class _FieldGroupLabel extends StatelessWidget {
  final String label;
  final AppPalette palette;

  const _FieldGroupLabel(this.label, {required this.palette});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: palette.textTertiary,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}

/// Consent row with a full-width tap target.
class _ConsentTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final bool required;

  const _ConsentTile({
    required this.value,
    required this.onChanged,
    required this.label,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppTheme.palette(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: value ? p.accentWhisper : p.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: value ? p.accent.withValues(alpha: 0.5) : p.borderSubtle,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: value ? p.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: value ? p.accent : p.borderStrong,
                    width: 1.5,
                  ),
                ),
                child: value
                    ? Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: AppTheme.palette(context).textPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: p.textSecondary,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    if (required) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Required',
                        style: TextStyle(
                          color: p.textTertiary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
