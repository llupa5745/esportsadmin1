import 'package:flutter/material.dart';
import '../../services/admin_service.dart';

class ThemeControlScreen extends StatefulWidget {
  const ThemeControlScreen({super.key});

  @override
  State<ThemeControlScreen> createState() => _ThemeControlScreenState();
}

class _ThemeControlScreenState extends State<ThemeControlScreen> {
  final _adminService = AdminService();
  final _primaryController = TextEditingController(text: '#FF5722');
  final _bgController = TextEditingController(text: '#0D0D0D');
  final _accentController = TextEditingController(text: '#FF9800');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme & UI Control'), backgroundColor: Colors.indigo.shade800),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User App Home Screen Colors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _primaryController,
              decoration: const InputDecoration(labelText: 'Primary Color (Hex)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bgController,
              decoration: const InputDecoration(labelText: 'Background Color (Hex)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accentController,
              decoration: const InputDecoration(labelText: 'Accent Color (Hex)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _adminService.updateTheme(
                  primaryColor: _primaryController.text.trim(),
                  backgroundColor: _bgController.text.trim(),
                  accentColor: _accentController.text.trim(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme updated successfully'), backgroundColor: Colors.green),
                );
              },
              child: const Text('Update Theme'),
            ),
            const Divider(height: 40),
            const Text('Tab Control (Upcoming / Live / Completed)', style: TextStyle(fontSize: 16)),
            const Text('Tabs are currently fixed. Advanced control can be added later.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
