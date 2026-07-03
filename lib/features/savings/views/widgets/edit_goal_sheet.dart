import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabungan_frontend/core/constants/app_colors.dart';
import '../../controllers/savings_controller.dart';
import '../../models/savings_goal.dart';

class EditGoalSheet extends ConsumerStatefulWidget {
  final SavingsGoal goal;

  const EditGoalSheet({super.key, required this.goal});

  @override
  ConsumerState<EditGoalSheet> createState() => _EditGoalSheetState();
}

class _EditGoalSheetState extends ConsumerState<EditGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _amountController = TextEditingController(text: widget.goal.targetAmount.toInt().toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      final updatedGoal = SavingsGoal(
        id: widget.goal.id,
        title: title,
        targetAmount: amount,
        currentAmount: widget.goal.currentAmount,
        createdAt: widget.goal.createdAt,
      );

      await ref.read(savingsControllerProvider.notifier).updateSavingsGoal(updatedGoal);

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _delete() async {
    // Tampilkan dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Hapus Tabungan?'),
        content: const Text('Tabungan dan semua riwayat transaksinya akan terhapus. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(savingsControllerProvider.notifier).deleteSavingsGoal(widget.goal.id);
      if (mounted) {
        Navigator.of(context).pop(); // Tutup bottom sheet
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), // Spacer
                Text(
                  'Edit Target',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: isLoading ? null : _delete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Untuk apa tabungan ini?',
                hintText: 'Misal: Beli Laptop, Liburan',
                prefixIcon: Icon(Icons.flag_rounded),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Nominal (Rp)',
                hintText: 'Misal: 15000000',
                prefixIcon: Icon(Icons.monetization_on_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Nominal wajib diisi';
                final amount = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                if (amount == null || amount <= 0) return 'Nominal tidak valid';
                return null;
              },
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
                      child: CircularProgressIndicator(color: AppColors.background, strokeWidth: 2),
                    )
                  : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
