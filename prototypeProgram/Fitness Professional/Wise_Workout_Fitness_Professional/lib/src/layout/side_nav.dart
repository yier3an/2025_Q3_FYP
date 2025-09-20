import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../theme/app_theme.dart';
=======
>>>>>>> origin/main

class SideNav extends StatelessWidget {
  final void Function(String route) onNavigate;
  final VoidCallback onLogout;
  const SideNav({super.key, required this.onNavigate, required this.onLogout});

  Widget _navItem(IconData icon, String title, String route, BuildContext ctx) {
<<<<<<< HEAD
    final currentRoute = ModalRoute.of(ctx)?.settings.name;
    final selected = currentRoute == route;

    return InkWell(
      onTap: () => onNavigate(route),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
          border: selected
              ? const Border(left: BorderSide(color: Colors.white, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
=======
    final selected = ModalRoute.of(ctx)?.settings.name == route;
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.white : Colors.white70),
      title: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.white70)),
      selected: selected,
      selectedTileColor: Colors.white.withOpacity(0.12),
      onTap: () => onNavigate(route),
>>>>>>> origin/main
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
      width: 260, // ✅ Admin-like width
      color: AppTheme.sidebarBg, // ✅ Admin sidebar bg
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Logo / Header
            Container(
              height: 72,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'FP Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const Divider(color: Colors.white24, height: 1),

            // Nav items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  _navItem(Icons.dashboard_outlined, 'Dashboard', '/dash', context),
                  _navItem(Icons.fitness_center_outlined, 'Workouts', '/workouts', context),
                  _navItem(Icons.chat_outlined, 'Chats', '/chats', context),
                  _navItem(Icons.settings_outlined, 'Settings', '/settings', context),
                ],
              ),
            ),

            const Divider(color: Colors.white24, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.14),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
=======
      width: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A0066), Color(0xFF4B0099)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('WISE WORKOUT', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _navItem(Icons.dashboard, 'Dashboard', '/dash', context),
          _navItem(Icons.fitness_center, 'Workout List', '/workouts', context),
          _navItem(Icons.chat_bubble_outline, 'User Chats', '/chats', context),
          _navItem(Icons.settings, 'Settings', '/settings', context),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                foregroundColor: Colors.white,
              ),
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
>>>>>>> origin/main
    );
  }
}
