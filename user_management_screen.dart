import 'package:flutter/material.dart';
import '../../services/admin_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _uidController = TextEditingController();
  final _adminService = AdminService();
  Map<String, dynamic>? _user;
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  Future<void> _search() async {
    final uid = _uidController.text.trim();
    if (uid.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter 10-digit UID')),
      );
      return;
    }
    final user = await _adminService.searchUserByUid(uid);
    setState(() => _user = user);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management'), backgroundColor: Colors.indigo.shade800),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _uidController,
              decoration: InputDecoration(
                labelText: '10-digit UID',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _search),
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            if (_user != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${_user!['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Email: ${_user!['email']}'),
                      Text('Main Balance: ৳${_user!['main_balance']}'),
                      Text('Winning: ৳${_user!['winning_balance']}'),
                      Text('Blocked: ${_user!['is_blocked']}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _adminService.toggleBlockUser(_user!['uid'], !(_user!['is_blocked'] ?? false));
                              _search();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (_user!['is_blocked'] ?? false) ? Colors.green : Colors.red,
                            ),
                            child: Text((_user!['is_blocked'] ?? false) ? 'Unblock' : 'Block'),
                          ),
                        ],
                      ),
                      const Divider(),
                      TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonController,
                        decoration: const InputDecoration(labelText: 'Reason (for prize)', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _adminService.sendPrize(
                                userUid: _user!['uid'],
                                amount: double.parse(_amountController.text),
                                reason: _reasonController.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Prize sent'), backgroundColor: Colors.green),
                              );
                              _search();
                            },
                            child: const Text('Send Prize'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await _adminService.deductAmount(
                                userUid: _user!['uid'],
                                amount: double.parse(_amountController.text),
                                from: 'winning',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Amount deducted'), backgroundColor: Colors.orange),
                              );
                              _search();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Deduct'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
