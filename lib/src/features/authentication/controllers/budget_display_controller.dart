// budget_display_controller.dart
import 'package:flutter/material.dart'; // for Color
import 'package:get/get.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';

class BudgetDisplayController extends GetxController {
  late BudgetCategory category;
  late RxDouble budgetAmount;
  RxDouble spentAmount = 0.0.obs;

  // NOTE: no onInit(), no Get.arguments

  double get progressPercentage =>
      budgetAmount.value > 0
          ? (spentAmount.value / budgetAmount.value).clamp(0.0, 1.0)
          : 0.0;

  double get remainingAmount => budgetAmount.value - spentAmount.value;

  void updateSpentAmount(double newAmount) {
    spentAmount.value = newAmount;
  }

  String formatCurrency(double amount) => '₦${amount.toStringAsFixed(2)}';

  String getProgressPercentageText() =>
      '${(progressPercentage * 100).toStringAsFixed(0)}% spent';

  bool get isOverBudget => spentAmount.value > budgetAmount.value;

  Color get statusColor {
    if (spentAmount.value == 0) return category.color;
    if (isOverBudget) return const Color(0xFFE53E3E); // Red
    if (progressPercentage > 0.8) return const Color(0xFFFF8C00); // Orange
    return const Color(0xFF38A169); // Green
  }
}
