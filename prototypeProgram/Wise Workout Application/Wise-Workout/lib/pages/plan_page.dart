import 'package:flutter/material.dart';
import '../globals.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Globals.auth;
    final isPremium = auth.isPremium;
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Your Current Plan', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(isPremium ? 'Premium User' : 'Free User'),
              subtitle: Text(isPremium
                  ? 'Advanced analytics, groups & tournaments'
                  : 'Basic workouts, community feed'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (!isPremium)
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('Upgrade to Premium'),
                subtitle: const Text('Unlock premium features instantly'),
                trailing: FilledButton(
                  onPressed: () {
                    auth.upgradeToPremium();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upgraded to Premium')),
                    );
                    setState(() {});
                  },
                  child: const Text('Upgrade'),
                ),
              ),
            )
          else
            Card(
              child: ListTile(
                leading: const Icon(Icons.cancel_outlined),
                title: const Text('Cancel Premium'),
                subtitle: const Text('Revert to Free plan'),
                trailing: FilledButton(
                  onPressed: () {
                    auth.downgradeToFree();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Premium cancelled')),
                    );
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text('Billing History (mock)'),
          const ListTile(title: Text('— No charges yet —')),
        ],
      ),
    );
  }
}
