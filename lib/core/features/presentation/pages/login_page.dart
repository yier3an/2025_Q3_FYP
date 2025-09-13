import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_website/core/features/presentation/widgets/background_widget.dart';
import 'package:my_website/core/features/presentation/widgets/navbar_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const path = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;

  bool get _isValid {
    final emailOk = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_email.text.trim());
    final passOk = _password.text.trim().length >= 6;
    return emailOk && passOk;
  }

  void _login() {
    if (!_isValid) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logging in... (mock)')),
    );
    // TODO: Replace with real login logic
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),
          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const NavbarWidget(),
                    const SizedBox(height: 32),

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
                            Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration('name@email.com'),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _password,
                              obscureText: !_showPassword,
                              decoration: _inputDecoration('Enter password').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () =>
                                      setState(() => _showPassword = !_showPassword),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: _isValid ? _login : null,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C63FF),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text('Login'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextButton(
                              onPressed: () => context.go('/signup'),
                              child: const Text("Don't have an account? Sign up"),
                            ),
                          ],
                        ),
                      ),
                    ),
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
      hintStyle: const TextStyle(color: Colors.black38),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBDB2FF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBDB2FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
    );
  }
}
