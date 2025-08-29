// add_expense_screen.dart (Fixed for navigation error)
import 'package:cash_lander2/src/features/authentication/controllers/add_expense_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddExpenseScreen extends StatefulWidget {
  final BudgetCategory category;
  final double budgetAmount;
  final double currentSpentAmount;

  const AddExpenseScreen({
    super.key,
    required this.category,
    required this.budgetAmount,
    required this.currentSpentAmount,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late AddExpenseController controller;
  late Worker _expenseSavedWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddExpenseController());
    controller.initialize(
      widget.category,
      widget.budgetAmount,
      widget.currentSpentAmount,
    );

    // FIXED: Use Worker for safer navigation handling
    _expenseSavedWorker = ever(controller.expenseSaved, (bool saved) {
      if (saved && mounted) {
        // Use WidgetsBinding to ensure navigation happens after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.pop();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 40.h),
                _buildCategoryInfo(),
                SizedBox(height: 32.h),
                _buildExpenseAmountInput(),
                SizedBox(height: 24.h),
                _buildDescriptionInput(),
                SizedBox(height: 40.h),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header Row
  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            height: 25.h,
            width: 25.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: const Center(
              child: Icon(Icons.arrow_back, color: Colors.white, size: 16),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Add Expense',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  /// Category Information Card
  Widget _buildCategoryInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: controller.category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: controller.category.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.category.color,
            ),
            child: Icon(
              controller.category.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.category.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Budget: ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextSpan(
                        text: '\u20A6', // Naira symbol
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: controller.budgetAmount.toStringAsFixed(0),
                        style: TextStyle(
                          fontFamily: 'Campton',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' | Spent: ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextSpan(
                        text: '\u20A6', // Naira symbol
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: controller.currentSpentAmount.toStringAsFixed(0),
                        style: TextStyle(
                          fontFamily: 'Campton',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Remaining: ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextSpan(
                        text: '\u20A6', // Naira symbol
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: controller.budgetStatusColor,
                        ),
                      ),
                      TextSpan(
                        text: controller.remainingBudget.toStringAsFixed(0),
                        style: TextStyle(
                          fontFamily: 'Campton',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: controller.budgetStatusColor,
                        ),
                      ),
                      TextSpan(
                        text: ' (${controller.remainingPercentage}%)',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: controller.percentageColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Expense Amount Input Field
  Widget _buildExpenseAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expense Amount',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: controller.expenseController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '₦ ',
              prefixStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  /// Description Input Field
  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: controller.descriptionController,
            style: TextStyle(fontSize: 16.sp),
            decoration: InputDecoration(
              hintText: 'What did you spend on?',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  /// Save Button with Loading State
  Widget _buildSaveButton() {
    return Center(
      child: Obx(
        () => GestureDetector(
          onTap: controller.isLoading.value ? null : controller.saveExpense,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 260.w,
            height: 45.h,
            decoration: BoxDecoration(
              color:
                  controller.isLoading.value
                      ? Colors.grey[400]
                      : controller.category.color,
              borderRadius: BorderRadius.circular(100.r),
              boxShadow:
                  controller.isLoading.value
                      ? []
                      : [
                        BoxShadow(
                          color: controller.category.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
            ),
            child: Center(
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        'Add Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // FIXED: Properly dispose of the worker
    _expenseSavedWorker.dispose();
    Get.delete<AddExpenseController>();
    super.dispose();
  }
}
