import 'package:cash_lander2/data/income_data.dart';
import 'package:cash_lander2/src/features/authentication/controllers/toggle_controller.dart';
import 'package:cash_lander2/widgets/toggle.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
//import 'package:phosphor_flutter/phosphor_flutter.dart';

class IncomeCategory extends StatelessWidget {
  const IncomeCategory({super.key});

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
            //Income list
            Expanded(
              child: ListView.builder(
                itemCount: theCategories.length,
                itemBuilder: (context, index) {
                  final category = theCategories[index];
                  return ListTile(
                    contentPadding: EdgeInsets.only(
                      left: 16.w,
                      right: 8.w,
                      bottom: 12.h,
                    ),
                    //Icon + conatiner
                    leading: Container(
                      width: 45.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: category.incColor,
                      ),
                      child: Center(
                        child: Icon(
                          category.incIcon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //Category name
                    title: Text(
                      category.incName,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => SetBudgetScreen(category: category)))
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
