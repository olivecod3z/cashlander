// set_budget_controller.dart
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SetBudgetController extends GetxController {
  late BudgetCategory category;
  final TextEditingController budgetController = TextEditingController();
  RxString selectedPeriod = 'Monthly'.obs;

  @override
  void onClose() {
    budgetController.dispose();
    super.onClose();
  }

  void initializeForNewCategory(BudgetCategory cat) {
    category = cat;
    budgetController.clear(); // Clear previous amount
    selectedPeriod.value = 'Monthly'; // Reset period
  }

  void saveBudget(BuildContext context) async {
    if (budgetController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a budget amount',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final double budgetAmount = double.tryParse(budgetController.text) ?? 0.0;

    if (budgetAmount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid budget amount',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // ADD THIS - Check if this is the user's first budget
    final isFirstBudget = await _checkIfFirstBudget();

    // ADD THIS - Save the budget (replace with your actual save logic)
    await _saveBudgetToDatabase(budgetAmount);

    // UPDATED - Add isFirstBudget to your existing navigation
    context.push(
      '/budget-display',
      extra: {
        'category': category,
        'budgetAmount': budgetAmount,
        'spentAmount': 0.0,
        'isFirstBudget': isFirstBudget, // ADD THIS LINE
      },
    );
  }

  void selectPeriod() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Period',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.h),
            ...['Monthly', 'Yearly'].map((period) {
              return ListTile(
                title: Text(period),
                trailing:
                    selectedPeriod.value == period
                        ? Icon(Icons.check, color: category.color)
                        : null,
                onTap: () {
                  selectedPeriod.value = period;
                  Get.back();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ADD THIS METHOD - Check if this is the user's first budget
  Future<bool> _checkIfFirstBudget() async {
    // FOR TESTING - Always return true to show confetti
    return true;

    // REPLACE WITH YOUR ACTUAL LOGIC:
    // Example using SharedPreferences:
    // final prefs = await SharedPreferences.getInstance();
    // final hasCreatedBudget = prefs.getBool('has_created_budget') ?? false;
    // return !hasCreatedBudget;

    // Example using your database/storage:
    // return await YourDatabaseService.isFirstBudget();
  }

  // ADD THIS METHOD - Save budget to your storage/database
  Future<void> _saveBudgetToDatabase(double budgetAmount) async {
    // REPLACE WITH YOUR ACTUAL SAVE LOGIC:
    // Example: Save to local database, API, etc.

    // Simulate save operation
    await Future.delayed(const Duration(milliseconds: 500));

    // Example: Mark that user has created their first budget
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('has_created_budget', true);

    // Example: Save to your database
    // await YourDatabaseService.saveBudget(category, budgetAmount, selectedPeriod.value);

    print(
      'Budget saved: ${category.name} - \$${budgetAmount.toStringAsFixed(2)} - ${selectedPeriod.value}',
    );
  }
}
