import 'package:cash_lander2/src/common_widgets/insight_calendar.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/widgets/piechart.dart';
import 'package:cash_lander2/widgets/spend_comparison.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'August',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    //dropdown icon
                    PhosphorIcon(
                      PhosphorIconsFill.caretDown,
                      size: 18.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 344.w,
                  height: 123.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 18.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Monthly Expense',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(254, 77, 77, 77),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\u20A6', // ₦
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              TextSpan(
                                text: '522,500',
                                style: TextStyle(
                                  fontFamily: 'Campton',
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // SizedBox(height: 17.w),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '82% of ', // ₦
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: btnColor1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\u20A6', // ₦
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: btnColor1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '822,500',
                                    style: TextStyle(
                                      fontFamily: 'Campton',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: btnColor1,
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        LinearPercentIndicator(
                          width: 310.0.w,
                          lineHeight: 8.0,
                          percent: 0.82,
                          animation: true,
                          backgroundColor: Color(0xFFEDEDED),
                          progressColor: btnColor1,
                          barRadius: const Radius.circular(12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Daily Spending HeatMap',
                  style: TextStyle(
                    color: Color(0xFF111E33),
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 17.h),
                InsightCalendar(),
                SizedBox(height: 17.h),
                //highest, lowest day/ top category
                SpendingComparisons(),

                DoughnutChart(),
                //Goals tracker
                Text(
                  'Goals Tracker',
                  style: TextStyle(
                    color: Color(0xFF111E33),
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 17.h),
                SizedBox(
                  width: 344.w,
                  height: 76.h,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE5F9FF),
                            ),
                            child: Center(
                              child: PhosphorIcon(
                                PhosphorIconsLight.coins,
                                color: btnColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
