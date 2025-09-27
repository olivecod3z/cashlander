// Fixed CategoryScreen - Swapped callbacks to match swapped labels
import 'package:cash_lander2/data/category_data.dart';
import 'package:cash_lander2/src/common_widgets/budget_cate_logo.dart';
import 'package:cash_lander2/src/features/authentication/controllers/toggle_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';
import 'package:cash_lander2/widgets/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final ToggleController toggleController = Get.put(ToggleController());
    // Initialize BudgetStorageService
    final BudgetStorageService budgetStorage = Get.put(
      BudgetStorageService(),
      permanent: true,
    );

    // Set initial state - CategoryScreen is Expense, so isIncome should be false
    //toggleController.setInitialState(false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w, top: 12.h, bottom: 28.h),
              child: Row(
                //cancel btn
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                  //Expense to Income toggle - SWAPPED CALLBACKS
                  ExpenseIncomeToggle(
                    isOnIncomePage: false,
                    onIncomeSelected: () {
                      //toggleController.toggletoIncome(); // ← Fixed
                      context.go('/incomelist');
                    },
                    onExpenseSelected: () {
                      //toggleController.toggletoExpense(); // ← Fixed
                      context.go('/addcategory');
                    },
                  ),
                ],
              ),
            ),
            //CATEGORY LIST
            Expanded(
              child: Obx(() {
                // This forces the ListView to rebuild when userBudgets changes
                budgetStorage
                    .userBudgets
                    .length; // Access the reactive list to trigger rebuilds

                return ListView.builder(
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final category = allCategories[index];
                    // Now use the NON-REACTIVE method inside the builder
                    final hasBudget = budgetStorage.hasBudgetForCategory(
                      category.name,
                    );

                    return ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 16.w,
                        right: 8.w,
                        bottom: 12.h,
                      ),
                      //Icon + container
                      leading: BudgetCategoryLogo(
                        icon: category.icon,
                        color: category.color,
                      ),
                      //Category name
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: _buildTrailingButton(
                        category,
                        hasBudget,
                        context,
                        budgetStorage,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the trailing button (+ or ✓)
  Widget _buildTrailingButton(
    BudgetCategory category,
    bool hasBudget,
    BuildContext context,
    BudgetStorageService budgetStorage,
  ) {
    if (hasBudget) {
      // Show checkmark if budget exists
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[50],
          border: Border.all(color: Colors.green[300]!, width: 1.5),
        ),
        child: IconButton(
          onPressed: () {
            // Navigate to add expense screen for existing budget
            final existingBudget = budgetStorage.getBudgetForCategory(
              category.name,
            );
            if (existingBudget != null) {
              context.push(
                '/add-expense',
                extra: {
                  'category': existingBudget['category'],
                  'budgetAmount': existingBudget['budgetAmount'],
                  'spentAmount': existingBudget['spentAmount'],
                },
              );
            }
          },
          icon: Icon(Icons.check, color: Colors.green[600], size: 20),
        ),
      );
    } else {
      // Show plus icon if no budget exists
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: IconButton(
          onPressed: () {
            // Navigate to create new budget
            context.push('/set-budget', extra: category);
          },
          icon: Icon(Icons.add, color: Colors.grey[600], size: 20),
        ),
      );
    }
  }
}
