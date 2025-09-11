import 'package:flutter/material.dart';
import '../theme.dart';

class SideNav extends StatelessWidget {
  final String currentRoute;
  const SideNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem('/dashboard', 'Dashboard', Icons.dashboard_outlined),
      _NavItem('/users', 'User Management', Icons.group_outlined),
      _NavItem('/reports', 'Report review', Icons.report_gmailerrorred_outlined),
      _NavItem('/fitness', 'Fitness Category', Icons.category_outlined),
      _NavItem('/landing', 'Landing Page', Icons.web_outlined),
      _NavItem('/map', 'Map Management', Icons.map_outlined),
      _NavItem('/tos', 'Terms of Service', Icons.article_outlined),
      _NavItem('/moderation', 'Moderation Log', Icons.shield_outlined),
      _NavItem('/feedback', 'Feedback', Icons.feedback_outlined),
    ];

    return Container(
      width: 260,
      decoration: AppTheme.dashboardGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: const [
                Icon(Icons.fitness_center, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text('WISE WORKOUT',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: items.map((it) {
                final selected = currentRoute == it.route;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: selected ? Colors.white.withOpacity(0.12) : Colors.transparent,
                    leading: Icon(it.icon, color: Colors.white),
                    title: Text(it.label, style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      if (!selected) {
                        Navigator.pushReplacementNamed(context, it.route);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String route;
  final String label;
  final IconData icon;
  _NavItem(this.route, this.label, this.icon);
}
