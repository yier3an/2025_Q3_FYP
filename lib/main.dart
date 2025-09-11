import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/user_management_screen.dart';
import 'screens/report_review_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/placeholder.dart';
import 'screens/fitness_category_screen.dart';
import 'screens/exercise_list_screen.dart';
import 'screens/moderation_log_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/require_admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WiseWorkoutAdminApp());
}

class WiseWorkoutAdminApp extends StatelessWidget {
  const WiseWorkoutAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Workout Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/dashboard',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) => const RequireAdmin(child: DashboardScreen()),
        '/users':     (_) => const RequireAdmin(child: UserManagementScreen()),
        '/reports':   (_) => const RequireAdmin(child: ReportReviewScreen()),
        '/tos':       (_) => const RequireAdmin(child: TermsScreen()),
        '/fitness': (_) => const RequireAdmin(child: FitnessCategoryScreen()),
        '/fitness/exercises': (_) => const RequireAdmin(child: ExerciseListScreen()),
        '/moderation': (_) => const RequireAdmin(child: ModerationLogScreen()),
        '/landing': (_) => const RequireAdmin(child: PlaceholderScreen(title: 'Landing Page Management', route: '/landing')),
        '/map': (_) => const RequireAdmin(child:PlaceholderScreen(title: 'Map Management', route: '/map')),
        '/feedback': (_) => const RequireAdmin(child:PlaceholderScreen(title: 'Feedback', route: '/feedback')),
      },
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage();

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Wise Workout Admin',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 10),
                  TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                    child: const Text('Login (prototype)'),
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
