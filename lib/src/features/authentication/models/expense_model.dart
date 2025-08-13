import 'package:flutter/widgets.dart';

class BudgetCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> subCategories;
  const BudgetCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.subCategories,
  });
}
