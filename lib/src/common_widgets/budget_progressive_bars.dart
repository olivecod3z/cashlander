import 'package:cash_lander2/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:intl/intl.dart';

class BudgetBars extends StatelessWidget {
  final String goalName;
  final double amountSaved;
  final double targetAmount;
  const BudgetBars({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.amountSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 140.w,
          height: 98.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        //Second container
        Positioned(
          left: 4.w,
          top: 4.h,
          child: Container(
            width: 132.w,
            height: 85.h,
            decoration: BoxDecoration(
              //color: bgColor1,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgColor1, Color.fromARGB(116, 204, 204, 204)],
                stops: [0.85, 0.0],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        //third container
        Positioned(
          left: 7.5.w,
          top: 30.h,
          child: Container(
            width: 125.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        //Goal Name
        Positioned(
          left: 13.w,
          top: 12.h,
          child: Text(
            goalName,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 0,
            ),
          ),
        ),
        Positioned(
          left: 114.w,
          top: 12.h,
          child: PhosphorIcon(
            PhosphorIconsRegular.caretRight,
            color: Colors.black,
            size: 12.sp,
          ),
        ),
        //Amount saved
        Positioned(
          left: 14.w,
          top: 40.h,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '\u20A6', // ₦
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
                TextSpan(
                  text: NumberFormat.compact().format(amountSaved),
                  style: const TextStyle(fontFamily: 'Campton'),
                ),
              ],
            ),
            style: TextStyle(
              color: btnColor1,
              fontWeight: FontWeight.w600,
              fontSize: 9.sp,
            ),
          ),
        ),
        //Amount to be saved
        Positioned(
          left: 100.w,
          top: 40.h,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '\u20A6', // ₦
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
                TextSpan(
                  text: NumberFormat.compact().format(targetAmount),
                  style: const TextStyle(fontFamily: 'Campton'),
                ),
              ],
            ),
            style: TextStyle(
              color: btnColor1,
              fontWeight: FontWeight.w600,
              fontSize: 9.sp,
            ),
          ),
        ),
        //Progress bar
        // Progress bar
        Positioned(
          left: 14.w,
          top: 60.h,
          child: SizedBox(
            width: 110.w, // Set the bar width
            child: LinearPercentIndicator(
              lineHeight: 4.h,
              percent: amountSaved / targetAmount, // 62%
              progressColor: btnColor3,
              backgroundColor: Colors.grey[300],
              barRadius: Radius.circular(8),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
