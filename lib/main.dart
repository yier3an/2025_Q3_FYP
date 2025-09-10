import 'package:flutter/material.dart';
import 'services/auth_service_mock.dart';
import 'mock_data.dart';
import 'pages/login_page.dart';
import 'pages/tab_home.dart';
import 'pages/tab_map.dart';
import 'pages/tab_workouts.dart';
import 'pages/tab_community.dart';
import 'pages/tab_profile.dart';

void main() => runApp(const WiseWorkoutApp());

class WiseWorkoutApp extends StatefulWidget {
  const WiseWorkoutApp({super.key});
  @override
  State<WiseWorkoutApp> createState() => _WiseWorkoutAppState();
}

class _WiseWorkoutAppState extends State<WiseWorkoutApp> {
  late final AuthServiceMock _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthServiceMock(MockData.accounts);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Workout (Mock)',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.black),
      home: AnimatedBuilder(
        animation: _auth,
        builder: (context, _) {
          if (_auth.isLoggedIn) {
            return MainFiveTabShell(auth: _auth);
          } else {
            return LoginPage(auth: _auth);
          }
        },
      ),
    );
  }
}

class MainFiveTabShell extends StatefulWidget {
  final AuthServiceMock auth;
  const MainFiveTabShell({super.key, required this.auth});
  @override
  State<MainFiveTabShell> createState() => _MainFiveTabShellState();
}

class _MainFiveTabShellState extends State<MainFiveTabShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      const HomeTabPage(),
      const MapTabPage(),
      const WorkoutsTabPage(),
      const CommunityTabPage(),
      ProfileTabPage(auth: widget.auth),
    ];

    return Scaffold(
      body: tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
