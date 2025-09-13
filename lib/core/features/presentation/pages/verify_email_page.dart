import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_website/core/features/presentation/widgets/background_widget.dart';
import 'package:my_website/core/features/presentation/widgets/navbar_widget.dart';
import 'package:my_website/core/features/presentation/pages/welcome_download_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  static const path = '/verify';

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  String? _email;
  String? _name;

  // 6 single-char fields
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes       = List.generate(6, (_) => FocusNode());

  // 15:00 countdown
  static const _initialSeconds = 15 * 60;
  int _secondsLeft = _initialSeconds;
  Timer? _timer;

  bool get _canVerify => _controllers.every((c) => c.text.trim().isNotEmpty);

  String get _pin =>
      _controllers.map((c) => c.text.trim()).join();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map) {
      if (extra['email'] is String) _email = extra['email'] as String;
      if (extra['name']  is String) _name  = extra['name']  as String;
    }
    _startTimerIfNeeded();
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final n in _nodes) { n.dispose(); }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerIfNeeded() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        _timer = null;
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    // TODO: trigger your backend to resend the code
    setState(() => _secondsLeft = _initialSeconds);
    _startTimerIfNeeded();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent')),
    );
  }

  void _verify() {
  if (!_canVerify) return;
  // TODO: real verification. On success:
  context.go(WelcomeDownloadPage.path, extra: {'name': _name});
}


  String get _mmss {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Same navbar as the rest of the site
                    const NavbarWidget(),
                    const SizedBox(height: 24),

                    // Card
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.96),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              SizedBox(
                                height: 56,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'WISE WORKOUT',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.black87,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              Text(
                                'VERIFY YOUR EMAIL ADDRESS',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 12),

                              if (_email != null)
                                Text(
                                  'A verification code has been sent to\n$_email',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black54),
                                ),
                              if (_email == null)
                                Text(
                                  'Please check your inbox and enter the 6-digit verification code below.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black54),
                                ),
                              const SizedBox(height: 20),

                              // PIN inputs
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(6, (i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: _PinBox(
                                      controller: _controllers[i],
                                      node: _nodes[i],
                                      onChanged: (v) {
                                        if (v.isNotEmpty && i < 5) {
                                          _nodes[i + 1].requestFocus();
                                        }
                                        setState(() {}); // update verify enabled
                                      },
                                      onBackspaceEmpty: () {
                                        if (i > 0) _nodes[i - 1].requestFocus();
                                      },
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: FilledButton(
                                  onPressed: _canVerify ? _verify : null,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF14CBA8),
                                    disabledBackgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Verify'),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Footer actions
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: _secondsLeft == 0 ? _resend : null,
                                    child: Text(
                                      _secondsLeft == 0
                                          ? 'Resend code'
                                          : 'Resend in $_mmss',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.go('/signup'),
                                    child: const Text('Change email'),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
}

class _PinBox extends StatelessWidget {
  const _PinBox({
    required this.controller,
    required this.node,
    required this.onChanged,
    required this.onBackspaceEmpty,
  });

  final TextEditingController controller;
  final FocusNode node;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspaceEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: TextField(
        controller: controller,
        focusNode: node,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBDB2FF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBDB2FF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
          ),
        ),
        onChanged: onChanged,
        // handle backspace when empty to jump to previous field
        onEditingComplete: () {}, // no-op
        onSubmitted: (_) {},      // no-op
      ),
    );
  }
}
