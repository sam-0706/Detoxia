import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> _countries = [
  'India',
  'United States',
  'United Kingdom',
  'Canada',
  'Australia',
  'Germany',
  'France',
  'Brazil',
  'Indonesia',
  'Nigeria',
  'South Africa',
  'UAE',
  'Saudi Arabia',
  'Pakistan',
  'Bangladesh',
  'Philippines',
  'Mexico',
  'Japan',
  'South Korea',
  'Turkey',
  'Egypt',
  'Kenya',
  'Other',
];

class PersonalInfoPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const PersonalInfoPage({super.key, required this.onNext});

  @override
  ConsumerState<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends ConsumerState<PersonalInfoPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _selectedCountry;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.contains('@') &&
      _selectedCountry != null;

  void _onContinue() {
    ref.read(onboardingStateProvider.notifier).update((s) {
      s.name = _nameCtrl.text.trim();
      s.email = _emailCtrl.text.trim();
      s.phone = _phoneCtrl.text.trim();
      s.country = _selectedCountry ?? '';
    });
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to\nDetoxia',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Let's get to know you. This stays private.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),

          _buildField(
            controller: _nameCtrl,
            label: 'Your name',
            hint: 'What should we call you?',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: _emailCtrl,
            label: 'Email',
            hint: 'your@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: _phoneCtrl,
            label: 'Phone (optional)',
            hint: '+1 234 567 8901',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          const Text('Country',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCountry,
            dropdownColor: const Color(0xFF1E1E2E),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.public, color: Colors.white38),
              hintText: 'Select your country',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: _countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _selectedCountry = v),
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lock_outline,
                    color: Colors.white38, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We collect your name, email, and country to '
                    'personalize your experience and send important '
                    'updates about your recovery journey. Your '
                    'behavioral data never leaves your device. '
                    'Contact info may be used for product updates.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white38),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
