import 'package:cash_lander2/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cash_lander2/src/features/authentication/controllers/slider.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final ScrollSliderController controller =
        Get.find<ScrollSliderController>();

    return Obx(() {
      return Row(
        children: [
          // Blue container - gets longer as you scroll right
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: (controller.scrollProgress.value * 50.w) + 100.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: btnColor1,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(width: 8.w),
          // Grey container - gets shorter as you scroll right
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: 200.w - ((controller.scrollProgress.value * 50.w) + 150.w),
            height: 3.h,
            decoration: BoxDecoration(
              color: Color(0xFF9CA3AF),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ],
      );
    });
  }
}
