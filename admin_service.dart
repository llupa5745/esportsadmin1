import 'package:firebase_database/firebase_database.dart';
import '../core/constants.dart';

class AdminService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Search user by 10-digit UID
  Future<Map<String, dynamic>?> searchUserByUid(String tenDigitUid) async {
    final snap = await _db.child('${AppConstants.usersPath}/$tenDigitUid').get();
    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);
      data['uid'] = tenDigitUid;
      return data;
    }
    return null;
  }

  // Block / Unblock user
  Future<void> toggleBlockUser(String uid, bool block) async {
    await _db.child('${AppConstants.usersPath}/$uid/is_blocked').set(block);
  }

  // Send Prize to user
  Future<void> sendPrize({
    required String userUid,
    required double amount,
    required String reason,
  }) async {
    final userRef = _db.child('${AppConstants.usersPath}/$userUid');
    
    final snap = await userRef.get();
    if (!snap.exists) throw Exception('User not found');

    final data = Map<String, dynamic>.from(snap.value as Map);
    final currentWinning = (data['winning_balance'] ?? 0).toDouble();

    await userRef.update({
      'winning_balance': currentWinning + amount,
    });

    // Log
    await _db.child('prize_send_log').push().set({
      'user_uid': userUid,
      'amount': amount,
      'reason': reason,
      'sent_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Deduct amount
  Future<void> deductAmount({
    required String userUid,
    required double amount,
    required String from, // main or winning
  }) async {
    final field = from == 'main' ? 'main_balance' : 'winning_balance';
    final userRef = _db.child('${AppConstants.usersPath}/$userUid');

    final snap = await userRef.get();
    if (!snap.exists) throw Exception('User not found');

    final data = Map<String, dynamic>.from(snap.value as Map);
    final current = (data[field] ?? 0).toDouble();
    if (current < amount) throw Exception('Insufficient balance');

    await userRef.update({
      field: current - amount,
    });
  }

  // Approve Deposit
  Future<void> approveDeposit(String requestId, String userUid, double amount) async {
    await _db.child('${AppConstants.depositRequestsPath}/$requestId/status').set('approved');

    final userRef = _db.child('${AppConstants.usersPath}/$userUid');
    final snap = await userRef.get();
    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);
      final current = (data['main_balance'] ?? 0).toDouble();
      await userRef.update({'main_balance': current + amount});
    }
  }

  // Reject Deposit
  Future<void> rejectDeposit(String requestId) async {
    await _db.child('${AppConstants.depositRequestsPath}/$requestId/status').set('rejected');
  }

  // Approve Withdraw
  Future<void> approveWithdraw(String requestId, String userUid, double amount) async {
    await _db.child('${AppConstants.withdrawRequestsPath}/$requestId/status').set('approved');

    final userRef = _db.child('${AppConstants.usersPath}/$userUid');
    final snap = await userRef.get();
    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);
      final current = (data['winning_balance'] ?? 0).toDouble();
      if (current >= amount) {
        await userRef.update({'winning_balance': current - amount});
      }
    }
  }

  // Reject Withdraw
  Future<void> rejectWithdraw(String requestId) async {
    await _db.child('${AppConstants.withdrawRequestsPath}/$requestId/status').set('rejected');
  }

  // Update Theme
  Future<void> updateTheme({
    required String primaryColor,
    required String backgroundColor,
    required String accentColor,
  }) async {
    await _db.child(AppConstants.themePath).set({
      'primary_color': primaryColor,
      'background_color': backgroundColor,
      'accent_color': accentColor,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Update Support Links
  Future<void> updateSupportLinks({
    String? telegram,
    String? whatsapp,
    String? tiktok,
  }) async {
    final data = <String, dynamic>{};
    if (telegram != null) data['telegram'] = telegram;
    if (whatsapp != null) data['whatsapp'] = whatsapp;
    if (tiktok != null) data['tiktok'] = tiktok;
    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

    await _db.child(AppConstants.supportLinksPath).update(data);
  }

  // Set Admin Payment Numbers
  Future<void> setPaymentNumbers({
    required String bkash,
    required String nagad,
  }) async {
    await _db.child(AppConstants.adminConfigPath).update({
      'bkash_number': bkash,
      'nagad_number': nagad,
    });
  }

  // Get pending deposits
  Stream<DatabaseEvent> getPendingDeposits() {
    return _db
        .child(AppConstants.depositRequestsPath)
        .orderByChild('status')
        .equalTo('pending')
        .onValue;
  }

  // Get pending withdraws
  Stream<DatabaseEvent> getPendingWithdraws() {
    return _db
        .child(AppConstants.withdrawRequestsPath)
        .orderByChild('status')
        .equalTo('pending')
        .onValue;
  }
}
