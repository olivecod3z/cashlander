// set_budget_screen.dart - GoRouter Compatible
import 'package:cash_lander2/src/common_widgets/budget_cate_logo.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/controllers/set_budget_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SetBudgetScreen extends StatefulWidget {
  final BudgetCategory category;

  const SetBudgetScreen({super.key, required this.category});

  @override
  State<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  late SetBudgetController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SetBudgetController());
    controller.initializeForNewCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row: Back, Category Icon
                Row(
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
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                    const Spacer(),
                    BudgetCategoryLogo(
                      icon: controller.category.icon,
                      color: controller.category.color,
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                /// Category Name Block
                Padding(
                  padding: EdgeInsets.only(left: 6.w, right: 6.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              color: textColor4,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Text(
                              controller.category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// Color Code Row
                      Row(
                        children: [
                          Text(
                            'Color code',
                            style: TextStyle(
                              color: textColor4,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.category.color,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25.h),

                      Row(
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              color: textColor4,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 113.w,
                            height: 27.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(21, 0, 0, 0),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      /// Budget Input (separated properly now)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Set Budget',
                            style: TextStyle(
                              color: textColor4,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1,
                            ),
                          ),
                          const Spacer(),

                          //Budget input
                          IntrinsicWidth(
                            child: Container(
                              height: 25.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: btnColor1, // 👈 your blue border
                                  width: 1.5, // 👈 thickness
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: controller.budgetController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  prefixText: '\u20A6',
                                  prefixStyle: TextStyle(
                                    fontFamily: 'Roboto',

                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 1,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      //Period
                      Obx(
                        () => GestureDetector(
                          onTap: controller.selectPeriod,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Period',
                                style: TextStyle(
                                  color: btnColor3,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                controller.selectedPeriod.value,
                                style: TextStyle(
                                  color: textColor4,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                              ),
                              PhosphorIcon(
                                PhosphorIconsRegular.caretRight,
                                color: Colors.black,
                                size: 13.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// Subcategories Section
                if (controller.category.subCategories.isNotEmpty) ...[
                  Text(
                    'Subcategories',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor4,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children:
                        controller.category.subCategories.map((item) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5), // soft gray
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                //letterSpacing: 0,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
                SizedBox(height: 35.h),

                //Save button
                Center(
                  child: GestureDetector(
                    onTap: () => controller.saveBudget(context),
                    child: Container(
                      width: 260.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: btnColor1,
                        borderRadius: BorderRadius.circular(100.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(37, 0, 0, 0),
                            blurRadius: 8,
                            offset: const Offset(0, 4), // Only downward shadow
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SetBudgetController>();
    super.dispose();
  }
}
