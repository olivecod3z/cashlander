// add_expense_controller.dart - Fixed for setState error
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseController extends GetxController {
  late BudgetCategory category;
  late double budgetAmount;
  late double currentSpentAmount;

  final TextEditingController expenseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool expenseSaved = false.obs;

  // Initialize with data from screen
  void initialize(BudgetCategory cat, double budget, double spent) {
    category = cat;
    budgetAmount = budget;
    currentSpentAmount = spent;
  }

  @override
  void onClose() {
    expenseController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  //https://meet.google.com/zgt-sdze-akx
  void goBack() {
    Get.back();
  }

  void saveExpense() {
    if (!_validateInput()) return;

    final double expenseAmount = double.parse(expenseController.text);
    isLoading.value = true;

    // Simulate brief loading for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      _processExpense(expenseAmount);
    });
  }

  bool _validateInput() {
    if (expenseController.text.isEmpty) {
      _showErrorSnackbar('Please enter an expense amount');
      return false;
    }

    final double? expenseAmount = double.tryParse(expenseController.text);

    if (expenseAmount == null || expenseAmount <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return false;
    }

    if (expenseAmount > 1000000) {
      _showErrorSnackbar('Expense amount seems too high');
      return false;
    }

    return true;
  }

  void _processExpense(double expenseAmount) {
    try {
      // Update spent amount in budget storage
      final budgetStorage = Get.find<BudgetStorageService>();
      final newSpentAmount = currentSpentAmount + expenseAmount;

      budgetStorage.updateSpentAmount(category.name, newSpentAmount);

      isLoading.value = false;

      // Show success message
      _showSuccessSnackbar(
        'Expense added successfully!',
        '₦${expenseAmount.toStringAsFixed(0)} added to ${category.name}',
      );

      // Clear form
      _clearForm();

      // FIXED: Use WidgetsBinding to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          expenseSaved.value = true;
        });
      });
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar('Failed to add expense. Please try again.');
    }
  }

  void _clearForm() {
    expenseController.clear();
    descriptionController.clear();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.error_outline, color: Colors.red[800]),
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.check_circle_outline, color: Colors.green[800]),
    );
  }

  // Format currency display
  String formatCurrency(double amount) {
    return '₦${amount.toStringAsFixed(0)}';
  }

  // Get remaining budget amount
  double get remainingBudget {
    return budgetAmount - currentSpentAmount;
  }

  // Check if expense would exceed budget
  bool wouldExceedBudget(double expenseAmount) {
    return (currentSpentAmount + expenseAmount) > budgetAmount;
  }

  // Get budget status color
  Color get budgetStatusColor {
    final percentage = currentSpentAmount / budgetAmount;
    if (percentage >= 1.0) return Colors.red[600]!;
    if (percentage >= 0.8) return Colors.orange[600]!;
    return Colors.green[600]!;
  }

  // NEW: Calculate remaining percentage
  String get remainingPercentage {
    if (budgetAmount <= 0) return '0';

    double spentPercentage = (currentSpentAmount / budgetAmount) * 100;
    double remainingPercentage = 100 - spentPercentage;

    remainingPercentage = remainingPercentage.clamp(0.0, 100.0);

    return remainingPercentage.toStringAsFixed(0);
  }

  // NEW: Get color for percentage
  Color get percentageColor {
    if (budgetAmount <= 0) return Colors.grey[600]!;

    double percentage = (currentSpentAmount / budgetAmount) * 100;

    if (percentage >= 100) return Colors.red[600]!;
    if (percentage >= 80) return Colors.orange[600]!;
    if (percentage >= 60) return Colors.yellow[700]!;
    return Colors.green[600]!;
  }
}
