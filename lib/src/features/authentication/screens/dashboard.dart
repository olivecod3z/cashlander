import 'package:cash_lander2/src/common_widgets/budget_progressive_bars.dart';
import 'package:cash_lander2/src/common_widgets/budgetbuttons.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/images.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/features/authentication/controllers/slider.dart';
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
    // Initialize the controller
    final ScrollSliderController scrollController = Get.put(
      ScrollSliderController(),
    );

    return Scaffold(
      backgroundColor: bgColor1,
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
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          avatarImg,
                          width: 45.w,
                          height: 45.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Greeting text
                            Text(
                              'Hi, Olive! 👋',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                                letterSpacing: -1.sp,
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
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //notification page
                            },
                            child: Container(
                              width: 45.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFD6D6D6),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                PhosphorIcons.bell(),
                                size: 28.sp,
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
                                    fontSize: 8.sp,
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
                ),
                SizedBox(height: 20.h),
                //BALANCE CARD
                Stack(
                  children: [
                    Container(
                      width: 327.w,
                      height: 98.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF130451), // Left end
                            Color(0xFF286274), // Middle left
                            //Color(0xFF006988), // Middle right
                            Color(0xFF111E33), // Right end
                          ],
                          //stops: [0.0, 0.6, 0.8, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    //shield icon
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: PhosphorIcon(
                        PhosphorIconsFill.shieldCheck,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                    ),
                    //month budget text
                    Positioned(
                      top: 10.h,
                      left: 30.w,
                      child: Text(
                        'Monthly Budget',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5.sp,
                        ),
                      ),
                    ),
                    //eye icon
                    Positioned(
                      top: 10.h,
                      left: 115.w,
                      child: PhosphorIcon(
                        PhosphorIconsBold.eye,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                    ),
                    //Budget Amount
                    Positioned(
                      top: 36.h,
                      left: 10.w,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: '\u20A6', // ₦
                              style: TextStyle(
                                fontFamily: 'Roboto',
                              ), // Only symbol uses fallback
                            ),
                            TextSpan(
                              text: '5,000',
                              style: const TextStyle(fontFamily: 'Campton'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Amount Saved in the past month
                    Positioned(
                      top: 78.h,
                      left: 12.w,
                      child: Text(
                        '😁+\$1000 saved past month',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: progressColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    //clock icon
                    Positioned(
                      top: 10.h,
                      left: 195.w,
                      child: PhosphorIcon(
                        PhosphorIconsLight.clock,
                        color: Colors.white,
                        size: 13.sp,
                      ),
                    ),
                    //history text
                    Positioned(
                      top: 11.h,
                      left: 210.w,
                      child: GestureDetector(
                        onTap: () {
                          //transaction history page
                        },
                        child: Text(
                          'Transaction History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5.sp,
                          ),
                        ),
                      ),
                    ),
                    //Go to icon
                    Positioned(
                      top: 11.h,
                      left: 300.w,
                      child: PhosphorIcon(
                        PhosphorIconsRegular.caretRight,
                        color: const Color.fromARGB(169, 255, 255, 255),
                        size: 13.sp,
                      ),
                    ),
                    //Add mooney button
                    Positioned(
                      top: 70.h,
                      left: 200.w,
                      child: GestureDetector(
                        onTap: () {
                          //add money page
                        },
                        child: Container(
                          width: 110.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(237, 255, 255, 255),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Center(
                            child: Text(
                              '+ Add money',
                              style: TextStyle(
                                color: Color(0xFF130451),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                //add bank
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BudgetButtons(
                        icon: PhosphorIconsRegular.bank,
                        onTap: () {},
                        text: 'Add Bank',
                      ),
                      SizedBox(width: 30.w),
                      BudgetButtons(
                        icon: PhosphorIconsRegular.folder,
                        onTap: () {},
                        text: 'Export Report',
                      ),
                      SizedBox(width: 30.w),
                      BudgetButtons(
                        icon: PhosphorIconsRegular.trophy,
                        onTap: () {},
                        text: 'Set Goals',
                      ),
                    ],
                  ),
                ),
                //Goals set sections - YOUR ORIGINAL IMPLEMENTATION
                SingleChildScrollView(
                  controller:
                      scrollController
                          .scrollController, // Only added the controller
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
                //slider - RESPONSIVE TO YOUR BUDGETBARS SCROLL
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

                    //see all recent transaction
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
                //transaction containers
                Stack(
                  children: [
                    Container(
                      width: 328.w,
                      height: 59.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 17.w,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: saveColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: PhosphorIcon(
                            PhosphorIconsFill.piggyBank,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 70.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Savings',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 17.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '-\$5500',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '30 mins ago',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Stack(
                  children: [
                    Container(
                      width: 328.w,
                      height: 59.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 17.w,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: foodColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: PhosphorIcon(
                            PhosphorIconsFill.bowlFood,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 70.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feeding',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Yesterday',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 17.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '-\$7000',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '16:45',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
    );
  }
}
