import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../services/admin_service.dart';
import '../../core/constants.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Requests'),
        backgroundColor: Colors.indigo.shade800,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Deposits'),
            Tab(text: 'Withdraws'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDepositList(),
          _buildWithdrawList(),
        ],
      ),
    );
  }

  Widget _buildDepositList() {
    return StreamBuilder<DatabaseEvent>(
      stream: _adminService.getPendingDeposits(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text('No pending deposits'));
        }
        final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final items = data.entries.toList();

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final id = items[index].key;
            final d = Map<String, dynamic>.from(items[index].value);
            return Card(
              child: ListTile(
                title: Text('UID: ${d['user_uid']}'),
                subtitle: Text('Amount: ৳${d['amount']}\nTrxID: ${d['transaction_id']}\nMethod: ${d['method']}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        await _adminService.approveDeposit(id, d['user_uid'], (d['amount'] as num).toDouble());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await _adminService.rejectDeposit(id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWithdrawList() {
    return StreamBuilder<DatabaseEvent>(
      stream: _adminService.getPendingWithdraws(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text('No pending withdraws'));
        }
        final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final items = data.entries.toList();

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final id = items[index].key;
            final d = Map<String, dynamic>.from(items[index].value);
            return Card(
              child: ListTile(
                title: Text('UID: ${d['user_uid']}'),
                subtitle: Text('Amount: ৳${d['amount']}\nNumber: ${d['number']}\nMethod: ${d['method']}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        await _adminService.approveWithdraw(id, d['user_uid'], (d['amount'] as num).toDouble());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await _adminService.rejectWithdraw(id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
