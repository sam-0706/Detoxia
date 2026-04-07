import 'package:detoxia/presentation/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _CountryInfo {
  final String name;
  final String code;
  final String dialCode;
  const _CountryInfo(this.name, this.code, this.dialCode);
}

const List<_CountryInfo> _countries = [
  _CountryInfo('India', 'IN', '+91'),
  _CountryInfo('United States', 'US', '+1'),
  _CountryInfo('United Kingdom', 'GB', '+44'),
  _CountryInfo('Canada', 'CA', '+1'),
  _CountryInfo('Australia', 'AU', '+61'),
  _CountryInfo('Germany', 'DE', '+49'),
  _CountryInfo('France', 'FR', '+33'),
  _CountryInfo('Brazil', 'BR', '+55'),
  _CountryInfo('Indonesia', 'ID', '+62'),
  _CountryInfo('Nigeria', 'NG', '+234'),
  _CountryInfo('South Africa', 'ZA', '+27'),
  _CountryInfo('UAE', 'AE', '+971'),
  _CountryInfo('Saudi Arabia', 'SA', '+966'),
  _CountryInfo('Pakistan', 'PK', '+92'),
  _CountryInfo('Bangladesh', 'BD', '+880'),
  _CountryInfo('Philippines', 'PH', '+63'),
  _CountryInfo('Mexico', 'MX', '+52'),
  _CountryInfo('Japan', 'JP', '+81'),
  _CountryInfo('South Korea', 'KR', '+82'),
  _CountryInfo('Turkey', 'TR', '+90'),
  _CountryInfo('Egypt', 'EG', '+20'),
  _CountryInfo('Kenya', 'KE', '+254'),
  _CountryInfo('Malaysia', 'MY', '+60'),
  _CountryInfo('Singapore', 'SG', '+65'),
  _CountryInfo('Thailand', 'TH', '+66'),
  _CountryInfo('Vietnam', 'VN', '+84'),
  _CountryInfo('Colombia', 'CO', '+57'),
  _CountryInfo('Argentina', 'AR', '+54'),
  _CountryInfo('Italy', 'IT', '+39'),
  _CountryInfo('Spain', 'ES', '+34'),
  _CountryInfo('Netherlands', 'NL', '+31'),
  _CountryInfo('Sweden', 'SE', '+46'),
  _CountryInfo('Norway', 'NO', '+47'),
  _CountryInfo('Denmark', 'DK', '+45'),
  _CountryInfo('New Zealand', 'NZ', '+64'),
  _CountryInfo('Ireland', 'IE', '+353'),
  _CountryInfo('Sri Lanka', 'LK', '+94'),
  _CountryInfo('Nepal', 'NP', '+977'),
  _CountryInfo('Other', 'XX', '+'),
];

final _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

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
  _CountryInfo? _selectedCountry;
  String? _emailError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _emailRegex.hasMatch(_emailCtrl.text.trim()) &&
      _selectedCountry != null;

  void _validateEmail() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _emailError = null;
    } else if (!_emailRegex.hasMatch(email)) {
      _emailError = 'Please enter a valid email address';
    } else {
      _emailError = null;
    }
  }

  void _onContinue() {
    _validateEmail();
    if (!_isValid) {
      setState(() {});
      return;
    }

    final phone = _phoneCtrl.text.trim();
    final fullPhone = phone.isNotEmpty
        ? '${_selectedCountry?.dialCode ?? ''} $phone'
        : '';

    ref.read(onboardingStateProvider.notifier).update((s) {
      s.name = _nameCtrl.text.trim();
      s.email = _emailCtrl.text.trim();
      s.phone = fullPhone;
      s.country = _selectedCountry?.name ?? '';
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
            'Welcome',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Let's get to know you. This stays private.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),

          // Name
          _buildLabel('Your name'),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
            decoration: _inputDeco(
              hint: 'What should we call you?',
              icon: Icons.person_outline,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          _buildLabel('Email'),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              _validateEmail();
              setState(() {});
            },
            decoration: _inputDeco(
              hint: 'your@email.com',
              icon: Icons.email_outlined,
              errorText: _emailError,
            ),
          ),
          const SizedBox(height: 16),

          // Country
          _buildLabel('Country'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCountry?.name,
            dropdownColor: const Color(0xFF1E1E2E),
            style: const TextStyle(color: Colors.white),
            isExpanded: true,
            decoration: _inputDeco(
              hint: 'Select your country',
              icon: Icons.public,
            ),
            items: _countries
                .map((c) => DropdownMenuItem(
                      value: c.name,
                      child: Text(c.name),
                    ))
                .toList(),
            onChanged: (v) {
              setState(() {
                _selectedCountry =
                    _countries.firstWhere((c) => c.name == v);
              });
            },
          ),
          const SizedBox(height: 16),

          // Phone with country code
          _buildLabel('Phone (optional)'),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedCountry?.dialCode ?? '+--',
                  style: TextStyle(
                    color: _selectedCountry != null
                        ? Colors.white
                        : Colors.white38,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9 \-]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDeco(
                    hint: 'Phone number',
                    icon: Icons.phone_outlined,
                  ),
                ),
              ),
            ],
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
                    'updates. Your wellness data never leaves your '
                    'device. Contact info may be used for product updates.',
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    String? errorText,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white38),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      errorText: errorText,
      errorStyle: const TextStyle(color: Color(0xFFEF5350), fontSize: 12),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF5350)),
      ),
    );
  }
}
