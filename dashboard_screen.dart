import 'package:flutter/material.dart';
import '../users/user_management_screen.dart';
import '../pending/pending_screen.dart';
import '../theme/theme_control_screen.dart';
import '../settings/settings_screen.dart';
import '../tournament/tournament_management_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Sports Admin Panel'),
        backgroundColor: Colors.indigo.shade800,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _menuCard(context, 'Tournaments', Icons.emoji_events, Colors.orange, const TournamentManagementScreen()),
          _menuCard(context, 'Users', Icons.people, Colors.blue, const UserManagementScreen()),
          _menuCard(context, 'Pending', Icons.pending_actions, Colors.red, const PendingScreen()),
          _menuCard(context, 'Theme & Tabs', Icons.color_lens, Colors.purple, const ThemeControlScreen()),
          _menuCard(context, 'Settings', Icons.settings, Colors.grey, const SettingsScreen()),
          _menuCard(context, 'AI Chat History', Icons.chat, Colors.teal, null),
        ],
      ),
    );
  }

  Widget _menuCard(BuildContext context, String title, IconData icon, Color color, Widget? page) {
    return Card(
      color: color.withOpacity(0.2),
      child: InkWell(
        onTap: page == null
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
              }
            : () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => page));
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
