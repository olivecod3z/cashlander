// budget_storage_service.dart
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

  // Get all budgets
  List<Map<String, dynamic>> get allBudgets => userBudgets;

  // Check if user has budgets
  bool get hasBudgets => userBudgets.isNotEmpty;

  // Get budget count
  int get budgetCount => userBudgets.length;
}
