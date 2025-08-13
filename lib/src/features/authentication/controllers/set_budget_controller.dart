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

  void saveBudget(BuildContext context) {
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

    // Navigate using context
    context.push(
      '/budget-display',
      extra: {
        'category': category,
        'budgetAmount': budgetAmount,
        'spentAmount': 0.0,
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
}
