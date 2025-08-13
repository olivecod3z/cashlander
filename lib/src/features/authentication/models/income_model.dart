import 'package:flutter/widgets.dart';

class IncomeCategory {
  final String incName;
  final IconData incIcon;
  final Color incColor;
  final List<String> incSubCategories;
  const IncomeCategory({
    required this.incName,
    required this.incIcon,
    required this.incColor,
    required this.incSubCategories,
  });
}
