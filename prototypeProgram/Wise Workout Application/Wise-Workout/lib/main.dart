import 'package:flutter/material.dart';
import 'services/auth_service_mock.dart';
import 'mock_data.dart';
import 'pages/login_page.dart';
import 'pages/tab_home.dart';
import 'pages/tab_map.dart';
import 'pages/tab_workouts.dart';
import 'pages/tab_community.dart';
import 'pages/tab_profile.dart';
import 'app/di.dart';
import 'theme.dart';
import 'globals.dart';
import 'pages/create_profile_page.dart';

void main() => runApp(const WiseWorkoutApp());

class WiseWorkoutApp extends StatefulWidget {
  const WiseWorkoutApp({super.key});
  @override
  State<WiseWorkoutApp> createState() => _WiseWorkoutAppState();
}

class _WiseWorkoutAppState extends State<WiseWorkoutApp> {
  late final AuthServiceMock _auth;
  late final DI _di;

  @override
  void initState() {
    super.initState();
    _auth = AuthServiceMock(MockData.accounts);
    Globals.auth = _auth; // make globally reachable
    _di = DI(auth: _auth);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Workout',
      theme: AppTheme.theme(),
      home: AnimatedBuilder(
        animation: _auth,
        builder: (context, _) {
          if (_auth.isLoggedIn) {
            return _ProfileGate(child: MainFiveTabShell(auth: _auth, di: _di));
          } else {
            return LoginPage(auth: _auth, authUseCase: _di.authUseCase);
          }
        },
      ),
    );
  }
}

class MainFiveTabShell extends StatefulWidget {
  final AuthServiceMock auth;
  final DI di;
  const MainFiveTabShell({super.key, required this.auth, required this.di});

  @override
  State<MainFiveTabShell> createState() => _MainFiveTabShellState();
}

class _MainFiveTabShellState extends State<MainFiveTabShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeTabPage(),
      const MapTabPage(),
      WorkoutsTabPage(isPremium: widget.auth.isPremium),
      CommunityTabPage(isPremium: widget.auth.isPremium),
      ProfileTabPage(auth: widget.auth, di: widget.di),
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
class _ProfileGate extends StatefulWidget {
  final Widget child;
  const _ProfileGate({required this.child});

  @override
  State<_ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<_ProfileGate> {
  bool _checked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_checked) {
      _checked = true;
      final auth = Globals.auth;
      final u = auth.currentUser;
      if (u != null && auth.profileFor(u.id) == null) {
        Future.microtask(() async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateProfilePage()),
          );
          if (mounted) setState(() {}); // rebuild after return
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

