import 'package:flutter/material.dart';
import '../../services/admin_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _adminService = AdminService();
  final _bkashController = TextEditingController();
  final _nagadController = TextEditingController();
  final _telegramController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _tiktokController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: Colors.indigo.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Payment Numbers (for Deposit)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _bkashController,
            decoration: const InputDecoration(labelText: 'bKash Number', border: OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nagadController,
            decoration: const InputDecoration(labelText: 'Nagad Number', border: OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await _adminService.setPaymentNumbers(
                bkash: _bkashController.text.trim(),
                nagad: _nagadController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment numbers updated'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Save Payment Numbers'),
          ),
          const Divider(height: 40),
          const Text('Support Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _telegramController,
            decoration: const InputDecoration(labelText: 'Telegram Link', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _whatsappController,
            decoration: const InputDecoration(labelText: 'WhatsApp Link', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tiktokController,
            decoration: const InputDecoration(labelText: 'TikTok Link', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await _adminService.updateSupportLinks(
                telegram: _telegramController.text.trim(),
                whatsapp: _whatsappController.text.trim(),
                tiktok: _tiktokController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support links updated'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Save Support Links'),
          ),
        ],
      ),
    );
  }
}
