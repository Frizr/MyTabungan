import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tabungan_frontend/core/constants/app_colors.dart';
import '../models/savings_goal.dart';
import '../controllers/savings_controller.dart';
import 'widgets/add_transaction_sheet.dart';
import 'widgets/edit_transaction_sheet.dart';

class GoalDetailView extends ConsumerWidget {
  final SavingsGoal goal;

  const GoalDetailView({super.key, required this.goal});

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddTransactionSheet(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We need real-time updates for the goal itself so the progress ring updates immediately
    final savingsAsync = ref.watch(savingsGoalsProvider);
    final currentGoal = savingsAsync.value?.firstWhere((g) => g.id == goal.id, orElse: () => goal) ?? goal;
    
    final transactionsAsync = ref.watch(transactionsProvider(goal.id));
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentGoal.title),
      ),
      body: Column(
        children: [
          // Header section (Progress Ring & Info)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(bottom: BorderSide(color: AppColors.surfaceHighlight, width: 1)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: currentGoal.progress,
                        strokeWidth: 12,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          currentGoal.progress >= 1.0 ? AppColors.success : AppColors.primary,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(currentGoal.progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.primaryVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  currencyFormatter.format(currentGoal.currentAmount),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Target: ${currencyFormatter.format(currentGoal.targetAmount)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          
          // Transactions List section
          Expanded(
            child: Container(
              color: AppColors.surface,
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada riwayat transaksi.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final isDeposit = tx.amount >= 0;
                      return Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        color: AppColors.background,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.background,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (context) => EditTransactionSheet(transaction: tx),
                            );
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (isDeposit ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isDeposit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                              color: isDeposit ? AppColors.success : AppColors.error,
                            ),
                          ),
                          title: Text(
                            isDeposit ? 'Setor Tabungan' : 'Tarik Saldo',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tx.note.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(tx.note, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM yyyy, HH:mm').format(tx.date),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '${isDeposit ? '+' : ''}${currencyFormatter.format(tx.amount)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: isDeposit ? AppColors.success : AppColors.error,
                                ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.background),
        label: const Text(
          'Transaksi',
          style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
