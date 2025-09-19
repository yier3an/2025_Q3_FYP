import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SideNav extends StatelessWidget {
  final void Function(String route) onNavigate;
  final VoidCallback onLogout;
  const SideNav({super.key, required this.onNavigate, required this.onLogout});

  Widget _navItem(IconData icon, String title, String route, BuildContext ctx) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
