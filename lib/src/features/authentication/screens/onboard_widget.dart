//import 'package:cash_lander2/src/constants/images.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/text.dart';
//import 'package:cash_lander2/src/features/authentication/controllers/onboarding_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/model_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:get/get.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardWidget extends StatelessWidget {
  const OnboardWidget({
    super.key,
    required this.model,
    required this.currentPage,
    required this.totalPages,
  });
  final OnboardingModel model;
  final RxInt currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<OnboardingController>();

    return Obx(() {
      bool isLastPage = currentPage.value == totalPages - 1;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //LOGO TEXT
            SizedBox(height: 50.h),
            // Text(
            //   logoText,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     letterSpacing: -1.sp,
            //     fontSize: 22.sp,
            //     fontWeight: FontWeight.bold,
            //     //color: Colors.white,
            //     foreground:
            //         Paint()
            //           ..shader =
            //               LinearGradient(
            //                     colors: [
            //                       btnColor1,
            //                       const Color.fromARGB(255, 56, 191, 248),
            //                     ],
            //                     begin: Alignment.centerLeft,
            //                     end: Alignment.centerRight,
            //                   ).createShader(Rect.fromLTWH(0, 0, 400, 60))
            //                   as Shader?,
            //   ),
            // ),
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [
                      btnColor1,
                      const Color.fromARGB(255, 56, 191, 248),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
              child: Text(
                logoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: -1.sp,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // This will be masked by the gradient
                ),
              ),
            ),
            SizedBox(height: isLastPage ? 40.h : 90.h),
            //image
            Image(image: AssetImage(model.image), height: 250.h),
            SizedBox(height: 20.h),

            //title
            Center(
              child: Text(
                model.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theTitle,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.w,
                ),
              ),
            ),
            //SizedBox(height: 20.h),

            //subtitle
            Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: subTitle,
                fontWeight: FontWeight.w500,
              ),
            ),
            //SizedBox(height: isLastPage ? 0.h : 20.h),
            //if (isLastPage) SizedBox(height: 50.h),
          ],
        ),
      );
    });
  }
}
