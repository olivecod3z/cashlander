//import 'package:cash_lander2/src/features/authentication/controllers/toggle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseIncomeToggle extends StatelessWidget {
  final VoidCallback onExpenseSelected;
  final VoidCallback onIncomeSelected;
  final bool isOnIncomePage;

  ExpenseIncomeToggle({
    super.key,
    required this.onExpenseSelected,
    required this.onIncomeSelected,
    required this.isOnIncomePage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26.h,
      width: 203.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          // Use AnimatedAlign instead
          AnimatedAlign(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment:
                isOnIncomePage ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.all(3.w),
              height: 20.5.h,
              width: 91.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onIncomeSelected,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        'Income',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onExpenseSelected,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        'Expense',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
