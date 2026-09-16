import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/constants.dart';

class TournamentManagementScreen extends StatefulWidget {
  const TournamentManagementScreen({super.key});

  @override
  State<TournamentManagementScreen> createState() => _TournamentManagementScreenState();
}

class _TournamentManagementScreenState extends State<TournamentManagementScreen> {
  final _titleController = TextEditingController();
  final _entryFeeController = TextEditingController();
  final _slotsController = TextEditingController();
  String _map = 'Bermuda';
  String _mode = 'Solo';

  Future<void> _createTournament() async {
    final ref = FirebaseDatabase.instance.ref(AppConstants.tournamentsPath).push();
    await ref.set({
      'title': _titleController.text.trim(),
      'map': _map,
      'mode': _mode,
      'entry_fee': double.tryParse(_entryFeeController.text) ?? 0,
      'prize_pool': {'1st': 500, '2nd': 300, '3rd': 200, 'per_kill': 10},
      'total_slots': int.tryParse(_slotsController.text) ?? 48,
      'joined_slots': 0,
      'status': 'upcoming',
      'match_time': DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch,
      'room_id': '',
      'room_pass': '',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tournament created'), backgroundColor: Colors.green),
    );
    _titleController.clear();
    _entryFeeController.clear();
    _slotsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Management'), backgroundColor: Colors.indigo.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Create New Tournament', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _map,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Map'),
            items: ['Bermuda', 'Purgatory', 'Alpine', 'Kalahari']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _map = v!),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _mode,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Mode'),
            items: ['Solo', 'Duo', 'Squad']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _mode = v!),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _entryFeeController,
            decoration: const InputDecoration(labelText: 'Entry Fee', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _slotsController,
            decoration: const InputDecoration(labelText: 'Total slots', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _createTournament,
            child: const Text('Create Tournament'),
          ),
        ],
      ),
    );
  }
}
