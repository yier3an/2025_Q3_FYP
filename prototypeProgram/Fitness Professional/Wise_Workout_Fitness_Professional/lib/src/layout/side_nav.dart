import 'package:flutter/material.dart';

class SideNav extends StatelessWidget {
  final void Function(String route) onNavigate;
  final VoidCallback onLogout;
  const SideNav({super.key, required this.onNavigate, required this.onLogout});

  Widget _navItem(IconData icon, String title, String route, BuildContext ctx) {
    final selected = ModalRoute.of(ctx)?.settings.name == route;
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.white : Colors.white70),
      title: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.white70)),
      selected: selected,
      selectedTileColor: Colors.white.withOpacity(0.12),
      onTap: () => onNavigate(route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
