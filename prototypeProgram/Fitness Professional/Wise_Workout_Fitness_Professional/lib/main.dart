import 'package:flutter/material.dart';
import 'src/auth/auth_service_mock.dart';
import 'src/layout/shell.dart';
import 'src/pages/login_page.dart';
import 'src/pages/dashboard_page.dart';
import 'src/pages/workouts_page.dart';
import 'src/pages/chat_list_page.dart';
import 'src/pages/chat_page.dart';
import 'src/pages/settings_page.dart';

void main() {
  runApp(const WiseWorkoutApp());
}

class WiseWorkoutApp extends StatefulWidget {
  const WiseWorkoutApp({super.key});
  @override
  State<WiseWorkoutApp> createState() => _WiseWorkoutAppState();
}

class _WiseWorkoutAppState extends State<WiseWorkoutApp> {
  final auth = AuthServiceMock();

  ThemeData _theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF6A00F4),
      brightness: Brightness.light,
      fontFamily: 'Roboto',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Workout – Fitness Pro',
      debugShowCheckedModeBanner: false,
      theme: _theme(),
      // Simple routes
      routes: {
        '/': (_) => LoginPage(auth: auth),
        '/dash': (_) => Shell(auth: auth, child: const DashboardPage()),
        '/workouts': (_) => Shell(auth: auth, child: const WorkoutsPage()),
        '/chats': (_) => Shell(auth: auth, child: const ChatListPage()),
        '/chat': (_) => Shell(auth: auth, child: const ChatPage()),
        '/settings': (_) => Shell(auth: auth, child: SettingsPage(auth: auth)),
      },
      initialRoute: '/',
    );
  }
}
