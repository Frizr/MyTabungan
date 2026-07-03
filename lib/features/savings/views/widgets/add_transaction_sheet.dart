import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabungan_frontend/core/constants/app_colors.dart';
import '../../controllers/savings_controller.dart';
import '../../models/savings_goal.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  final SavingsGoal goal;

  const AddTransactionSheet({super.key, required this.goal});

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isDeposit = true;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final amountValue = double.parse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final amount = _isDeposit ? amountValue : -amountValue;
      final note = _noteController.text.trim();

      await ref.read(savingsControllerProvider.notifier).addTransaction(
            goalId: widget.goal.id,
            amount: amount,
            note: note,
          );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savingsControllerProvider);
    final isLoading = state.isLoading;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tambah Transaksi',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Setor (Masuk)'),
                    selected: _isDeposit,
                    onSelected: (val) => setState(() => _isDeposit = true),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: _isDeposit ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Tarik (Keluar)'),
                    selected: !_isDeposit,
                    onSelected: (val) => setState(() => _isDeposit = false),
                    selectedColor: AppColors.error.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: !_isDeposit ? AppColors.error : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal (Rp)',
                hintText: 'Misal: 50000',
                prefixIcon: Icon(
                  _isDeposit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: _isDeposit ? AppColors.success : AppColors.error,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Nominal wajib diisi';
                final amount = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                if (amount == null || amount <= 0) return 'Nominal tidak valid';
                if (!_isDeposit && amount > widget.goal.currentAmount) {
                  return 'Saldo tidak mencukupi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan (Opsional)',
                hintText: 'Misal: Uang jajan sisa',
                prefixIcon: Icon(Icons.note_alt_rounded),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.background,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Simpan Transaksi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
