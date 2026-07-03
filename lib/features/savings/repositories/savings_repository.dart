import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/savings_goal.dart';
import '../models/transaction.dart';
import '../../auth/repositories/auth_repository.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepository(
    ref.watch(firestoreProvider),
    ref.watch(authRepositoryProvider).currentUser?.uid,
  );
});

class SavingsRepository {
  final FirebaseFirestore _firestore;
  final String? _userId;

  SavingsRepository(this._firestore, this._userId);

  CollectionReference get _goalsRef {
    if (_userId == null) throw Exception("User not logged in");
    return _firestore.collection('users').doc(_userId).collection('savings_goals');
  }

  // --- Savings Goals ---
  
  Stream<List<SavingsGoal>> watchSavingsGoals() {
    if (_userId == null) return Stream.value([]);
    
    return _goalsRef.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SavingsGoal.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    await _goalsRef.add(goal.toMap()..remove('id'));
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    await _goalsRef.doc(goal.id).update(goal.toMap()..remove('id'));
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    await _goalsRef.doc(goalId).delete();
  }

  // --- Transactions ---

  CollectionReference _transactionsRef(String goalId) {
    return _goalsRef.doc(goalId).collection('transactions');
  }

  Stream<List<SavingsTransaction>> watchTransactions(String goalId) {
    if (_userId == null) return Stream.value([]);
    
    return _transactionsRef(goalId).orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SavingsTransaction.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> addTransaction(SavingsTransaction transaction) async {
    final batch = _firestore.batch();
    
    // Add the transaction
    final newTxRef = _transactionsRef(transaction.savingsGoalId).doc();
    batch.set(newTxRef, transaction.toMap()..remove('id'));

    // Update the currentAmount in the SavingsGoal
    final goalRef = _goalsRef.doc(transaction.savingsGoalId);
    batch.update(goalRef, {
      'currentAmount': FieldValue.increment(transaction.amount)
    });

    await batch.commit();
  }

  Future<void> updateTransaction(SavingsTransaction oldTx, SavingsTransaction newTx) async {
    final batch = _firestore.batch();
    
    // Update the transaction document
    final txRef = _transactionsRef(oldTx.savingsGoalId).doc(oldTx.id);
    batch.update(txRef, newTx.toMap()..remove('id'));

    // Calculate difference and adjust the Goal's currentAmount
    final delta = newTx.amount - oldTx.amount;
    if (delta != 0) {
      final goalRef = _goalsRef.doc(oldTx.savingsGoalId);
      batch.update(goalRef, {
        'currentAmount': FieldValue.increment(delta)
      });
    }

    await batch.commit();
  }

  Future<void> deleteTransaction(SavingsTransaction tx) async {
    final batch = _firestore.batch();
    
    // Delete the transaction document
    final txRef = _transactionsRef(tx.savingsGoalId).doc(tx.id);
    batch.delete(txRef);

    // Revert the amount in the Goal's currentAmount
    final goalRef = _goalsRef.doc(tx.savingsGoalId);
    batch.update(goalRef, {
      'currentAmount': FieldValue.increment(-tx.amount)
    });

    await batch.commit();
  }
}
