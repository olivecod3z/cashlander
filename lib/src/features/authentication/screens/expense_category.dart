// Updated CategoryScreen with correct navigation
import 'package:cash_lander2/data/category_data.dart';
//import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/controllers/toggle_controller.dart';
import 'package:cash_lander2/widgets/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ToggleController toggleController = Get.put(ToggleController());
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
                  //Expense to Income toggle
                  ExpenseIncomeToggle(
                    onExpenseSelected: () {
                      toggleController.toggletoExpense();
                      context.go('/addcategory');
                    },
                    onIncomeSelected: () {
                      toggleController.toggletoIncome();
                      context.go('/incomelist');
                    },
                  ),
                ],
              ),
            ),
            //CATEGORY LIST
            Expanded(
              child: ListView.builder(
                itemCount: allCategories.length,
                itemBuilder: (context, index) {
                  final category = allCategories[index];
                  return ListTile(
                    contentPadding: EdgeInsets.only(
                      left: 16.w,
                      right: 8.w,
                      bottom: 12.h,
                    ),
                    //Icon + container
                    leading: Container(
                      width: 45.w,
                      height: 45.h,
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
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          category.icon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //Category name
                    title: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.push(
                          '/set-budget',
                          extra: category,
                        ); // ✅ Works!
                      },
                      icon: Icon(Icons.add),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
