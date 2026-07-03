import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/savings_goal.dart';
import '../models/transaction.dart';
import '../repositories/savings_repository.dart';

// Stream Providers to be consumed by the UI

final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  final repository = ref.watch(savingsRepositoryProvider);
  return repository.watchSavingsGoals();
});

final transactionsProvider = StreamProvider.family<List<SavingsTransaction>, String>((ref, goalId) {
  final repository = ref.watch(savingsRepositoryProvider);
  return repository.watchTransactions(goalId);
});

// Controller for mutations (adding goals/transactions)
class SavingsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addSavingsGoal({required String title, required double targetAmount, DateTime? targetDate}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsRepositoryProvider);
      final newGoal = SavingsGoal(
        id: '', // Firestore will generate this
        title: title,
        targetAmount: targetAmount,
        createdAt: DateTime.now(),
        targetDate: targetDate,
      );
      await repository.addSavingsGoal(newGoal);
    });
  }

  Future<void> addTransaction({
    required String goalId,
    required double amount,
    required String note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsRepositoryProvider);
      final newTx = SavingsTransaction(
        id: '', // Firestore will generate this
        savingsGoalId: goalId,
        amount: amount,
        note: note,
        date: DateTime.now(),
      );
      await repository.addTransaction(newTx);
    });
  }
  Future<void> updateSavingsGoal(SavingsGoal updatedGoal) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsRepositoryProvider);
      await repository.updateSavingsGoal(updatedGoal);
    });
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsRepositoryProvider);
      await repository.deleteSavingsGoal(goalId);
    });
  }

  Future<void> updateTransaction(SavingsTransaction oldTx, SavingsTransaction newTx) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsRepositoryProvider);
      await repository.updateTransaction(oldTx, newTx);
    });
  }

  Future<void> deleteTransaction(SavingsTransaction tx) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsRepositoryProvider);
      await repository.deleteTransaction(tx);
    });
  }
}

final savingsControllerProvider = AsyncNotifierProvider<SavingsController, void>(() {
  return SavingsController();
});
