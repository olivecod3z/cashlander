//This is the screen that displays the budget after creating and setting it
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/controllers/budget_display_controller.dart';
import 'package:cash_lander2/src/features/authentication/controllers/toggle_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';
import 'package:cash_lander2/widgets/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetDisplayScreen extends StatefulWidget {
  final BudgetCategory category;
  final double budgetAmount;
  final double spentAmount;

  const BudgetDisplayScreen({
    super.key,
    required this.category,
    required this.budgetAmount,
    this.spentAmount = 0.0,
  });

  @override
  State<BudgetDisplayScreen> createState() => _BudgetDisplayScreenState();
}

class _BudgetDisplayScreenState extends State<BudgetDisplayScreen> {
  late BudgetDisplayController controller;

  // Initialize budget list with empty list
  List<Map<String, dynamic>> budgetList = [];

  @override
  void initState() {
    super.initState();
    // Initialize controller and set data
    controller = Get.put(BudgetDisplayController());
    controller.category = widget.category;
    controller.budgetAmount = widget.budgetAmount.obs;
    controller.spentAmount.value = widget.spentAmount;

    // Get persistent budget storage
    final budgetStorage = Get.put(BudgetStorageService());

    // Add current budget to user's collection
    budgetStorage.addUserBudget(
      widget.category,
      widget.budgetAmount,
      spentAmount: widget.spentAmount,
    );

    // Use accumulated budgets for grid display
    budgetList = budgetStorage.userBudgets;
  }

  @override
  Widget build(BuildContext context) {
    final toggleController = Get.put(ToggleController());

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: Positioned(
        bottom: 100.h, // Above the navbar
        right: 20.w,
        child: Material(
          elevation: 6,
          shape: CircleBorder(),
          color: btnColor1,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              // Your action
              context.push('/addcategory');
            },
            child: Container(
              width: 56.w,
              height: 56.h,
              child: PhosphorIcon(
                PhosphorIconsBold.plus,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 30.h),
                Center(
                  child: ExpenseIncomeToggle(
                    onExpenseSelected: () {
                      toggleController.toggletoExpense();
                      context.go('/budget_display');
                    },
                    onIncomeSelected: () {
                      toggleController.toggletoIncome();
                      context.go('/incomelist');
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildBudgetGrid(),
                SizedBox(height: 32.h),
                _buildSuccessMessage(),
                SizedBox(height: 80.h), // Extra space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header Row: Back Button and Title
  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            height: 25.h,
            width: 25.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: const Center(
              child: Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Budget Created',
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

  /// Budget Grid (2 cards per row)
  Widget _buildBudgetGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85, // Adjust this to control card height
      ),
      itemCount: budgetList.length,
      itemBuilder: (context, index) {
        final budgetData = budgetList[index];
        return _buildBudgetCard(
          budgetData['category'] as BudgetCategory,
          budgetData['budgetAmount'] as double,
          budgetData['spentAmount'] as double,
        );
      },
    );
  }

  /// Individual Budget Card (smaller for grid)
  Widget _buildBudgetCard(
    BudgetCategory category,
    double budgetAmount,
    double spentAmount,
  ) {
    final progressPercentage =
        budgetAmount > 0 ? (spentAmount / budgetAmount).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Category Icon (smaller)
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  category.color.withOpacity(0.9),
                  category.color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: category.color.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(category.icon, size: 18, color: Colors.white),
            ),
          ),

          SizedBox(height: 8.h),

          // Category Name
          Text(
            category.name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4.h),

          // Period
          Text(
            'Monthly',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
              color: textColor4,
            ),
          ),

          SizedBox(height: 12.h),

          // Circular Progress (smaller)
          CircularPercentIndicator(
            radius: 35.0.w,
            lineWidth: 5.0.w,
            percent: progressPercentage,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${budgetAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                if (spentAmount > 0)
                  Text(
                    '${(progressPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: category.color,
                    ),
                  ),
              ],
            ),
            progressColor: category.color,
            backgroundColor: Colors.grey[200]!,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1200,
            curve: Curves.easeInOutCubic,
          ),

          //SizedBox(height: 8.h),

          // // Budget Summary (compact)
          // if (spentAmount > 0) ...[
          //   Text(
          //     'Spent: \$${spentAmount.toStringAsFixed(0)}',
          //     style: TextStyle(
          //       fontSize: 9.sp,
          //       fontWeight: FontWeight.w500,
          //       color: textColor4,
          //     ),
          //   ),
          //   Text(
          //     'Left: \$${(budgetAmount - spentAmount).toStringAsFixed(0)}',
          //     style: TextStyle(
          //       fontSize: 9.sp,
          //       fontWeight: FontWeight.w500,
          //       color:
          //           (budgetAmount - spentAmount) >= 0
          //               ? Colors.green[600]
          //               : Colors.red[600],
          //     ),
          //   ),
          // ] else ...[
          //   Text(
          //     'Budget Set',
          //     style: TextStyle(
          //       fontSize: 9.sp,
          //       fontWeight: FontWeight.w500,
          //       color: category.color,
          //     ),
          //   ),
        ],
        // ],
      ),
    );
  }

  /// Success Message
  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.green[500],
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Budget successfully created! Start tracking your expenses.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<BudgetDisplayController>();
    super.dispose();
  }
}
