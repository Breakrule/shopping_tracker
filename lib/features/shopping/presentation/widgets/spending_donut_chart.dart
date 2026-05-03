import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:monthly_shop_tracker/core/theme/app_colors.dart';

class SpendingDonutChart extends StatelessWidget {
  final Map<String, double> stats;
  final double total;

  const SpendingDonutChart({
    super.key,
    required this.stats,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    return Semantics(
      label: 'Spending breakdown chart. Total spent: Rp ${total.toStringAsFixed(0)}. ${stats.entries.map((e) => '${e.key}: Rp ${e.value.toStringAsFixed(0)}').join(', ')}',
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 50,
            startDegreeOffset: -90,
            sections: stats.entries.map((entry) {
              final category = entry.key;
              final amount = entry.value;
              final percentage = (amount / total) * 100;
              
              return PieChartSectionData(
                color: AppColors.getCategoryColor(category),
                value: amount,
                title: '${percentage.toStringAsFixed(0)}%',
                radius: 40,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                badgeWidget: _Badge(
                  category,
                  size: 30,
                  borderColor: AppColors.getCategoryColor(category),
                ),
                badgePositionPercentageOffset: 1.3,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String category;
  final double size;
  final Color borderColor;

  const _Badge(
    this.category, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Icon(
          _getCategoryIcon(category),
          size: size * 0.6,
          color: borderColor,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.shopping_cart_rounded;
      case 'Household':
        return Icons.home_rounded;
      case 'Health':
        return Icons.medical_services_rounded;
      case 'Personal':
        return Icons.person_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
