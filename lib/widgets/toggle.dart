import 'package:cash_lander2/src/features/authentication/controllers/toggle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ExpenseIncomeToggle extends StatelessWidget {
  final ToggleController controller = Get.find<ToggleController>();
  final VoidCallback onExpenseSelected;
  final VoidCallback onIncomeSelected;

  ExpenseIncomeToggle({
    super.key,
    required this.onExpenseSelected,
    required this.onIncomeSelected,
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
          //animated sliding indicator
          Obx(
            () => AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: controller.isIncome.value ? 109.w : 3.w,
              top: 3.h,
              child: Container(
                height: 20.5.h,
                width: 91.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),

          //toggle texts and btn
          //Expense button
          Row(
            children: [
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
              //Income button
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
            ],
          ),
        ],
      ),
    );
  }
}
