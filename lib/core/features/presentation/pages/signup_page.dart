import 'package:flutter/material.dart';
import 'package:my_website/core/features/presentation/widgets/background_widget.dart';
import 'package:my_website/core/features/presentation/widgets/navbar_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:my_website/core/features/presentation/pages/verify_email_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const path = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Sign Up page goes here")
      )
    );
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController(text: '');
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  int? _month, _day, _year;

  bool _obscurePassword = true; //default will be obscured
  bool _obscureConfirmPassword = true;

  bool get _isValid {
    final nameOK = _name.text.trim().isNotEmpty;
    final emailOk = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_email.text.trim());
    final phoneOk = _phone.text.trim().length >= 4;
    final passOK = _password.text.trim().length >= 6;
    final confirmOK = _password.text.trim() == _confirmPassword.text.trim();
    final dobOk = _month != null && _day != null && _year != null;
    return emailOk && phoneOk && dobOk && passOK && nameOK;
  }

  void _submit() {
  if (!_isValid) return;

  // TODO: call backend to send verification email
  context.go(VerifyEmailPage.path, extra: {
    'email': _email.text.trim(),
    'name': _name.text.trim(),
  });
}


  List<int> get _years {
    final now = DateTime.now().year;
    return List.generate(100, (i) => now - i); // last 100 years
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        const BackgroundWidget(), //gradient bg
        SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const NavbarWidget(),
                  const SizedBox(height: 32),

                  // white card
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // title/logo area
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: Text(
                              'Sign up',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700
                                    ),
                            ),
                          ),

                          // Name
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Your name',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _name,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.black87),
                            decoration: _inputDecoration('John Doe'),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),


                          // email
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Your email',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500
                                )),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black87),
                            decoration: _inputDecoration('name@email.com'),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),

                          // phone (simple +65 prefix)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Phone number',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500
                                )),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: const Text('+65'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _phone,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: _inputDecoration('8123 4567'),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _password,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black87,
                            decoration: _inputDecoration('Enter a strong password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Confirm Password',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _confirmPassword,
                            obscureText: _obscureConfirmPassword,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black87,
                            decoration: _inputDecoration('Re-enter password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),

                          // DOB
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("What's your date of birth?",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500
                                )),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _Dropdown<int>(
                                  hint: 'Month',
                                  value: _month,
                                  items: List.generate(12, (i) => i + 1),
                                  itemLabel: (m) => _monthNames[m - 1],
                                  onChanged: (v) => setState(() => _month = v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _Dropdown<int>(
                                  hint: 'Date',
                                  value: _day,
                                  items: List.generate(31, (i) => i + 1),
                                  itemLabel: (d) => d.toString(),
                                  onChanged: (v) => setState(() => _day = v),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _Dropdown<int>(
                                  hint: 'Year',
                                  value: _year,
                                  items: _years,
                                  itemLabel: (y) => y.toString(),
                                  onChanged: (v) => setState(() => _year = v),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: _isValid ? _submit : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF6C63FF),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text('Confirm Verification Email'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black38), // subtle gray hint
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFBDB2FF)), // light violet
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFBDB2FF)), // same light violet
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2), // darker violet focus
    ),
  );
}

}

const _monthNames = [
  'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
];

class _Dropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.grey[100],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
      hint: Text(
        hint,
        style: const TextStyle(color: Colors.black38),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(itemLabel(e),
                    style: const TextStyle(color: Colors.black87)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}