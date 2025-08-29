// budget_storage_service.dart - Fixed for proper GetX usage
import 'package:get/get.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';

class BudgetStorageService extends GetxController {
  // Persistent list of all user-created budgets
  RxList<Map<String, dynamic>> userBudgets = <Map<String, dynamic>>[].obs;

  // Add a new budget created by user
  void addUserBudget(
    BudgetCategory category,
    double budgetAmount, {
    double spentAmount = 0.0,
  }) {
    // Check if budget already exists for this category
    final existingIndex = userBudgets.indexWhere(
      (budget) => (budget['category'] as BudgetCategory).name == category.name,
    );

    if (existingIndex != -1) {
      // Update existing budget
      userBudgets[existingIndex] = {
        'category': category,
        'budgetAmount': budgetAmount,
        'spentAmount': spentAmount,
      };
    } else {
      // Add new budget
      userBudgets.add({
        'category': category,
        'budgetAmount': budgetAmount,
        'spentAmount': spentAmount,
      });
    }
  }

  // Remove a budget
  void removeBudget(String categoryName) {
    userBudgets.removeWhere(
      (budget) => (budget['category'] as BudgetCategory).name == categoryName,
    );
  }

  // Update spent amount for a specific budget
  void updateSpentAmount(String categoryName, double newSpentAmount) {
    final index = userBudgets.indexWhere(
      (budget) => (budget['category'] as BudgetCategory).name == categoryName,
    );

    if (index != -1) {
      userBudgets[index]['spentAmount'] = newSpentAmount;
      userBudgets.refresh(); // Trigger UI update
    }
  }

  // FIXED: Non-reactive method - Use .value to access the list directly
  bool hasBudgetForCategory(String categoryName) {
    return userBudgets.value.any(
      (budget) => (budget['category'] as BudgetCategory).name == categoryName,
    );
  }

  // FIXED: Non-reactive method - Use .value to access the list directly
  Map<String, dynamic>? getBudgetForCategory(String categoryName) {
    try {
      return userBudgets.value.firstWhere(
        (budget) => (budget['category'] as BudgetCategory).name == categoryName,
      );
    } catch (e) {
      return null;
    }
  }

  // REACTIVE: These should only be called inside Obx() or GetBuilder()
  double get totalBudgetAmount {
    double total = 0.0;
    for (var budget in userBudgets) {
      total += budget['budgetAmount'] as double;
    }
    return total;
  }

  // REACTIVE: These should only be called inside Obx() or GetBuilder()
  double get totalSpentAmount {
    double total = 0.0;
    for (var budget in userBudgets) {
      total += budget['spentAmount'] as double;
    }
    return total;
  }

  // NON-REACTIVE versions for use outside Obx()
  double getTotalBudgetAmount() {
    double total = 0.0;
    for (var budget in userBudgets.value) {
      total += budget['budgetAmount'] as double;
    }
    return total;
  }

  double getTotalSpentAmount() {
    double total = 0.0;
    for (var budget in userBudgets.value) {
      total += budget['spentAmount'] as double;
    }
    return total;
  }

  // Get all budgets (non-reactive)
  List<Map<String, dynamic>> get allBudgets => userBudgets.value;

  // Check if user has budgets (non-reactive)
  bool get hasBudgets => userBudgets.value.isNotEmpty;

  // Get budget count (non-reactive)
  int get budgetCount => userBudgets.value.length;
}
