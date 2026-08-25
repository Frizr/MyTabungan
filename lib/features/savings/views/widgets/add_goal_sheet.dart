import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabungan_frontend/core/constants/app_colors.dart';
import '../../controllers/savings_controller.dart';
import '../../models/savings_goal.dart';
import 'goal_type_toggle.dart';

class AddGoalSheet extends ConsumerStatefulWidget {
  const AddGoalSheet({super.key});

  @override
  ConsumerState<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<AddGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  GoalType _type = GoalType.tabungan;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final isWallet = _type == GoalType.dompet;
      final amount = isWallet
          ? 0.0
          : double.parse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      await ref.read(savingsControllerProvider.notifier).addSavingsGoal(
            title: title,
            type: _type,
            targetAmount: amount,
            targetDate: isWallet ? null : _selectedDate,
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
              'Target Tabungan Baru',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GoalTypeToggle(
              value: _type,
              onChanged: (type) => setState(() {
                _type = type;
                if (type == GoalType.dompet) _selectedDate = null;
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: _type == GoalType.dompet ? 'Nama dompet ini?' : 'Untuk apa tabungan ini?',
                hintText: _type == GoalType.dompet ? 'Misal: Dompet Harian, Kas Darurat' : 'Misal: Beli Laptop, Liburan',
                prefixIcon: const Icon(Icons.flag_rounded),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: _type == GoalType.dompet
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                            if (_type == GoalType.dompet) return null;
                            if (value == null || value.isEmpty) return 'Nominal wajib diisi';
                            final amount = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                            if (amount == null || amount <= 0) return 'Nominal tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                            );
                            if (date != null) {
                              setState(() => _selectedDate = date);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Target Tanggal (Opsional)',
                              prefixIcon: Icon(Icons.calendar_month_rounded),
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? 'Pilih tanggal rilis / Hari H'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(
                                color: _selectedDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      'Buat Target',
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
