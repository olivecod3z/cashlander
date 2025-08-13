// import 'package:cash_lander2/src/constants/colors.dart';
// import 'package:cash_lander2/src/constants/images.dart';
// import 'package:cash_lander2/src/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetButtons extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String text;
  const BudgetButtons({
    super.key,
    required this.icon,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(225, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(55, 33, 149, 243),
                      blurRadius: 6.r,
                      spreadRadius: 1.r,
                      offset: Offset(0, 4), // No offset for centered glow
                    ),
                  ],
                ),
                child: Center(child: PhosphorIcon(icon, size: 24.sp)),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              text,
              style: TextStyle(
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
