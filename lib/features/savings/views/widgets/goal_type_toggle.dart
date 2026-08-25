import 'package:flutter/material.dart';
import 'package:tabungan_frontend/core/constants/app_colors.dart';
import '../../models/savings_goal.dart';

/// Pill-shaped segmented control for choosing between a target-based
/// Tabungan and a target-free Dompet. Mirrors the animated-pill language
/// already used by the bottom nav in [main_scaffold], instead of dropping
/// in a stock Material [SegmentedButton].
class GoalTypeToggle extends StatelessWidget {
  const GoalTypeToggle({super.key, required this.value, required this.onChanged});

  final GoalType value;
  final ValueChanged<GoalType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: GoalType.values.map((type) {
          final isSelected = type == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type == GoalType.tabungan ? Icons.flag_rounded : Icons.account_balance_wallet_rounded,
                      size: 18,
                      color: isSelected ? AppColors.background : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? AppColors.background : AppColors.textSecondary,
                      ),
                      child: Text(type.label),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Small pill badge marking a card as Tabungan (target) or Dompet (free
/// balance) — placed near a goal's title in list/detail views.
class GoalTypeBadge extends StatelessWidget {
  const GoalTypeBadge({super.key, required this.type});

  final GoalType type;

  @override
  Widget build(BuildContext context) {
    final color = type == GoalType.dompet ? AppColors.accent : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: color,
        ),
      ),
    );
  }
}
