// import 'package:cash_lander2/src/constants/colors.dart';
// import 'package:cash_lander2/src/constants/images.dart';
// import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/constants/colors.dart';
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
                  color: const Color.fromARGB(13, 0, 127, 254),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: PhosphorIcon(icon, size: 24.sp, color: btnColor1),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              text,
              style: TextStyle(
                letterSpacing: 0,
                color: Color(0xFF8A8A8A),
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
