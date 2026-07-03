import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class SimulatorView extends StatefulWidget {
  const SimulatorView({super.key});

  @override
  State<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends State<SimulatorView> {
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  
  double? _daily;
  double? _weekly;
  double? _monthly;

  void _calculate() {
    final amountStr = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final durationStr = _durationController.text;
    
    if (amountStr.isEmpty || durationStr.isEmpty) return;
    
    final amount = double.tryParse(amountStr);
    final months = int.tryParse(durationStr);
    
    if (amount == null || months == null || months <= 0) return;
    
    final totalDays = months * 30;
    final totalWeeks = months * 4;
    
    setState(() {
      _daily = amount / totalDays;
      _weekly = amount / totalWeeks;
      _monthly = amount / months;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Nabung'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Kalkulator Pintar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Hitung berapa yang harus ditabung untuk mencapai target Anda.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Dana (Rp)',
                  prefixIcon: const Icon(Icons.monetization_on_rounded, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Waktu (Bulan)',
                  prefixIcon: const Icon(Icons.access_time_filled_rounded, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 32),
              
              if (_monthly != null) ...[
                Text(
                  'Rekomendasi Nabung:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildResultCard(
                  title: 'Bulanan',
                  amount: formatter.format(_monthly),
                  icon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 12),
                _buildResultCard(
                  title: 'Mingguan',
                  amount: formatter.format(_weekly),
                  icon: Icons.date_range_rounded,
                ),
                const SizedBox(height: 12),
                _buildResultCard(
                  title: 'Harian',
                  amount: formatter.format(_daily),
                  icon: Icons.today_rounded,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({required String title, required String amount, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textSecondary)),
                Text(
                  amount,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
