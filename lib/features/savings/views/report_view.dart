import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tabungan_frontend/core/constants/app_colors.dart';
import 'package:tabungan_frontend/features/savings/controllers/savings_controller.dart';

class ReportView extends ConsumerWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingsAsync = ref.watch(savingsGoalsProvider);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Global'),
      ),
      body: SafeArea(
        child: savingsAsync.when(
          data: (goals) {
            if (goals.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada data untuk dianalisis.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              );
            }

            final totalTarget = goals.fold<double>(0, (sum, item) => sum + item.targetAmount);
            final totalSavings = goals.fold<double>(0, (sum, item) => sum + item.currentAmount);
            final overallProgress = totalTarget > 0 ? (totalSavings / totalTarget).clamp(0.0, 1.0) : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Global Overview Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.surfaceHighlight, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Terkumpul',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormatter.format(totalSavings),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dari Total Target: ${currencyFormatter.format(totalTarget)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        LinearProgressIndicator(
                          value: overallProgress,
                          backgroundColor: AppColors.background,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            overallProgress >= 1.0 ? AppColors.success : AppColors.primary,
                          ),
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${(overallProgress * 100).toStringAsFixed(1)}% Tercapai',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primaryVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Breakdown per Goal
                  Text(
                    'Rincian Tabungan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...goals.map((goal) {
                    final isComplete = goal.progress >= 1.0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: AppColors.surface,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    goal.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isComplete)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currencyFormatter.format(goal.currentAmount),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: isComplete ? AppColors.success : AppColors.primary,
                                      ),
                                ),
                                Text(
                                  '${(goal.progress * 100).toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: goal.progress,
                              backgroundColor: AppColors.background,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isComplete ? AppColors.success : AppColors.primary,
                              ),
                              minHeight: 4,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
        ),
      ),
    );
  }
}
