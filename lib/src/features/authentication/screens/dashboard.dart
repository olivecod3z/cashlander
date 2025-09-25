// Updated dashboard.dart (StatelessWidget with GetX Controller)
import 'package:cash_lander2/src/common_widgets/budget_progressive_bars.dart';
import 'package:cash_lander2/src/common_widgets/budgetbuttons.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/images.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/features/authentication/controllers/dashboard_controller.dart';
import 'package:cash_lander2/src/features/authentication/controllers/slider.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';
import 'package:cash_lander2/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final DashboardController dashboardController = Get.put(
      DashboardController(),
    );
    final ScrollSliderController scrollController = Get.put(
      ScrollSliderController(),
    );
    final BudgetStorageService budgetStorage = Get.put(
      BudgetStorageService(),
      permanent: true,
    );

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics().applyTo(
            BouncingScrollPhysics(),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      //Profile image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(19.r),
                        child: Image.asset(
                          avatarImg,
                          width: 38.w,
                          height: 38.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Greeting text with username using Obx
                            Obx(
                              () =>
                                  dashboardController.isLoadingUserData.value
                                      ? Container(
                                        width: 60.w,
                                        height: 18.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      )
                                      : Text(
                                        'Hi ${dashboardController.displayName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          letterSpacing: -1.sp,
                                        ),
                                      ),
                            ),
                            Text(
                              dashText1,
                              style: TextStyle(
                                color: subColor,
                                letterSpacing: -0.5.sp,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Notification btn
                      Row(
                        children: [
                          PhosphorIcon(PhosphorIcons.scan(), size: 24.sp),

                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 45.w,
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  child: PhosphorIcon(
                                    PhosphorIcons.headset(),
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 30,
                                child: Container(
                                  height: 9.h,
                                  width: 17.w,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: dashboardController.onNotificationTap,
                                child: Container(
                                  width: 45.w,
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  child: Icon(
                                    PhosphorIcons.bell(),
                                    size: 24.sp,
                                    color: textColor1,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 30,
                                child: Container(
                                  height: 13.h,
                                  width: 13.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                //BALANCE CARD
                Container(
                  width: 342.w,
                  height: 72.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF007DFE), Color(0xFF0062C8)],
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      width: 1.w,
                      color: const Color.fromARGB(44, 0, 0, 0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: '\u20A6',
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                            TextSpan(
                              text: '800,000',
                              style: const TextStyle(fontFamily: 'Campton'),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                // TOTAL EXPENSE CARD trenddown icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 17.w,
                                  height: 17.h,
                                  decoration: BoxDecoration(
                                    color: btnColor1,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Center(
                                    child: PhosphorIcon(
                                      PhosphorIconsBold.trendDown,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.caretRight,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            //text
                            Text(
                              'Total expense',
                              style: TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                letterSpacing: 0.1,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '\u20A6',
                                    style: TextStyle(fontFamily: 'Roboto'),
                                  ),
                                  TextSpan(
                                    text: '1,000,000',
                                    style: const TextStyle(
                                      fontFamily: 'Campton',
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //TOTAL INCOME
                    Container(
                      width: 160.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 17.w,
                                  height: 17.h,
                                  decoration: BoxDecoration(
                                    color: btnColor1,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Center(
                                    child: PhosphorIcon(
                                      PhosphorIconsBold.trendUp,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.caretRight,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            //text
                            Text(
                              'Total income',
                              style: TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                letterSpacing: 0.1,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '\u20A6',
                                    style: TextStyle(fontFamily: 'Roboto'),
                                  ),
                                  TextSpan(
                                    text: '1,800,000',
                                    style: const TextStyle(
                                      fontFamily: 'Campton',
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                //add bank
                Container(
                  width: 343.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BudgetButtons(
                          icon: PhosphorIconsFill.bank,
                          onTap: () {},
                          text: 'Add Bank',
                        ),
                        SizedBox(width: 30.w),
                        BudgetButtons(
                          icon: PhosphorIconsFill.folder,
                          onTap: () {},
                          text: 'Export Report',
                        ),
                        SizedBox(width: 30.w),
                        BudgetButtons(
                          icon: PhosphorIconsFill.trophy,
                          onTap: () {},
                          text: 'Set Goals',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                //Goals set sections
                SingleChildScrollView(
                  controller: scrollController.scrollController,
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BudgetBars(
                          goalName: 'Buying a Macbook',
                          targetAmount: 2500,
                          amountSaved: 1550,
                        ),
                        SizedBox(width: 16.w),
                        BudgetBars(
                          goalName: 'Girlfriend Allowance',
                          targetAmount: 25000,
                          amountSaved: 11500,
                        ),
                        SizedBox(width: 16.w),
                        BudgetBars(
                          goalName: 'Mercedes Benz',
                          targetAmount: 30000,
                          amountSaved: 9550,
                        ),
                      ],
                    ),
                  ),
                ),

                //slider
                Padding(
                  padding: EdgeInsets.fromLTRB(80.w, 25.h, 50.w, 30.h),
                  child: SliderWidget(),
                ),

                //recent transactions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF007DFE),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF007DFE),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                //transaction containers (keeping your existing implementation)
                // Stack(
                //   children: [
                //     Container(
                //       width: 328.w,
                //       height: 59.h,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     Positioned(
                //       top: 10.h,
                //       left: 17.w,
                //       child: Container(
                //         width: 40.w,
                //         height: 40.h,
                //         decoration: BoxDecoration(
                //           color: saveColor,
                //           shape: BoxShape.circle,
                //         ),
                //         child: Center(
                //           child: PhosphorIcon(
                //             PhosphorIconsFill.piggyBank,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       top: 10.h,
                //       left: 70.w,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Savings',
                //             style: TextStyle(
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black,
                //             ),
                //           ),
                //           SizedBox(height: 2.h),
                //           Text(
                //             'Today',
                //             style: TextStyle(
                //               fontSize: 12.sp,
                //               color: Colors.grey[600],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Positioned(
                //       top: 10.h,
                //       right: 17.w,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Text.rich(
                //             TextSpan(
                //               children: [
                //                 const TextSpan(
                //                   text: '-\u20A6',
                //                   style: TextStyle(fontFamily: 'Roboto'),
                //                 ),
                //                 TextSpan(
                //                   text: '5500',
                //                   style: const TextStyle(fontFamily: 'Campton'),
                //                 ),
                //               ],
                //             ),
                //             style: TextStyle(
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black,
                //             ),
                //           ),
                //           SizedBox(height: 2.h),
                //           Text(
                //             '30 mins ago',
                //             style: TextStyle(
                //               fontSize: 12.sp,
                //               color: Colors.grey[600],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 8.h),
                // Stack(
                //   children: [
                //     Container(
                //       width: 328.w,
                //       height: 59.h,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     Positioned(
                //       top: 10.h,
                //       left: 17.w,
                //       child: Container(
                //         width: 40.w,
                //         height: 40.h,
                //         decoration: BoxDecoration(
                //           color: foodColor,
                //           shape: BoxShape.circle,
                //         ),
                //         child: Center(
                //           child: PhosphorIcon(
                //             PhosphorIconsFill.bowlFood,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       top: 10.h,
                //       left: 70.w,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Feeding',
                //             style: TextStyle(
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black,
                //             ),
                //           ),
                //           SizedBox(height: 2.h),
                //           Text(
                //             'Yesterday',
                //             style: TextStyle(
                //               fontSize: 12.sp,
                //               color: Colors.grey[600],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Positioned(
                //       top: 10.h,
                //       right: 17.w,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Text.rich(
                //             TextSpan(
                //               children: [
                //                 const TextSpan(
                //                   text: '-\u20A6',
                //                   style: TextStyle(fontFamily: 'Roboto'),
                //                 ),
                //                 TextSpan(
                //                   text: '10500',
                //                   style: const TextStyle(fontFamily: 'Campton'),
                //                 ),
                //               ],
                //             ),
                //             style: TextStyle(
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black,
                //             ),
                //           ),
                //           SizedBox(height: 2.h),
                //           Text(
                //             '16:45',
                //             style: TextStyle(
                //               fontSize: 12.sp,
                //               color: Colors.grey[600],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Positioned(
        bottom: 100.h,
        right: 20.w,
        child: Material(
          elevation: 6,
          shape: CircleBorder(),
          color: btnColor1,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              context.push('/addcategory');
            },
            child: SizedBox(
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
    );
  }
}
