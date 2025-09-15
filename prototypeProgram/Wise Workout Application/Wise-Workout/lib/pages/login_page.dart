
import 'package:flutter/material.dart';
import '../services/auth_service_mock.dart';
import '../usecases/auth_usecase.dart';

class LoginPage extends StatefulWidget {
  final AuthServiceMock auth;
  final AuthUseCase? authUseCase;
  const LoginPage({super.key, required this.auth, this.authUseCase});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController(text: 'user@demo.com');
  final _pass  = TextEditingController(text: 'password123');
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Wise Workout (Mock)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 8),
                  TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                  const SizedBox(height: 16),
                  if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _loading ? null : () async {
                      setState(()=>_loading=true);
                      try {
                        if (widget.authUseCase != null) {
                          await widget.authUseCase!.logIn(email: _email.text.trim(), password: _pass.text);
                        } else {
                          await widget.auth.signIn(email: _email.text.trim(), password: _pass.text);
                        }
                      } catch (e) {
                        setState(()=>_error=e.toString());
                      } finally {
                        if (mounted) setState(()=>_loading=false);
                      }
                    },
                    child: _loading ? const CircularProgressIndicator() : const Text('Login'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Use demo accounts:\nuser@demo.com / password123\n'
                    'instructor@demo.com / password123\n'
                    'admin@demo.com / password123',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
