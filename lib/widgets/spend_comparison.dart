import 'package:cash_lander2/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SpendingComparisons extends StatelessWidget {
  const SpendingComparisons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //highest day
        Container(
          width: 103.w,
          height: 103.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5E5),
                    shape: BoxShape.circle,
                  ),
                  child: PhosphorIcon(
                    PhosphorIconsRegular.trendDown,
                    size: 18,
                    color: Color(0xFF7C0202),
                  ),
                ),
                SizedBox(height: 5.h),

                //amount
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\u20A6', // ₦
                        style: TextStyle(fontFamily: 'Roboto'),
                      ),
                      TextSpan(
                        text: '150,000',
                        style: TextStyle(fontFamily: 'Campton'),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Color(0xFF7C0202),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  'Highest Day',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                //Date
                Text(
                  'Aug 21st',
                  style: TextStyle(
                    letterSpacing: -0.5,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        //lowest day
        Container(
          width: 103.w,
          height: 103.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5FFE5),
                    shape: BoxShape.circle,
                  ),
                  child: PhosphorIcon(
                    PhosphorIconsRegular.trendUp,
                    size: 18,
                    color: Color(0xFF006D04),
                  ),
                ),
                SizedBox(height: 5.h),

                //amount
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\u20A6', // ₦
                        style: TextStyle(fontFamily: 'Roboto'),
                      ),
                      TextSpan(
                        text: '20,000',
                        style: TextStyle(fontFamily: 'Campton'),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Color(0xFF006D04),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  'Lowest Day',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                //Date
                Text(
                  'Aug 12th',
                  style: TextStyle(
                    letterSpacing: -0.5,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        //top category
        Container(
          width: 103.w,
          height: 103.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE5F9FF),
                    shape: BoxShape.circle,
                  ),
                  // child: PhosphorIcon(
                  //   PhosphorIconsRegular.trendUp,
                  //   size: 18,
                  //   color: Color(0xFF006D04),
                  // ),
                ),
                SizedBox(height: 5.h),

                //percent
                Text(
                  '35%',
                  style: TextStyle(
                    color: btnColor1,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  'Top Category',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                //category
                Text(
                  'Feeding',
                  style: TextStyle(
                    letterSpacing: -0.5,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
