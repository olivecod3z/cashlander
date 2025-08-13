import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/images.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/features/authentication/controllers/onboarding_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/model_onboarding.dart';
import 'package:cash_lander2/src/features/authentication/screens/onboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final controller = Get.put(OnboardingController());

  final List<OnboardingModel> pages = [
    OnboardingModel(
      logo: logoText,
      image: onboardingImage1,
      title: onboardingTitle1,
      description: onboardingSubTitle1,
    ),
    OnboardingModel(
      logo: logoText,
      image: onboardingImage2,
      title: onboardingTitle2,
      description: onboardingSubTitle2,
    ),
    OnboardingModel(
      logo: logoText,
      image: onboardingImage3,
      title: onboardingTitle3,
      description: onboardingSubTitle3,
    ),
    OnboardingModel(
      logo: logoText,
      image: onboardingImage4,
      title: onboardingTitle4,
      description: onboardingSubTitle4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    print("OnboardingScreen build called!");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: controller.pageController,
                physics: PageScrollPhysics(),
                onPageChanged: (index) => controller.currentPage.value = index,
                itemCount: pages.length,
                itemBuilder:
                    (_, index) => OnboardWidget(
                      model: pages[index],
                      currentPage: controller.currentPage,
                      totalPages: pages.length,
                    ),
              ),
            ),

            // Dot indicators and buttons
            Obx(
              () => Positioned(
                bottom:
                    controller.currentPage.value == pages.length - 1
                        ? 40
                            .h // Higher position on last page to create space
                        : 130.h, // Normal position on other pages
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dots - always visible
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: controller.currentPage.value,
                        count: pages.length,
                        effect: WormEffect(
                          dotHeight: 10.h,
                          dotWidth: 10.w,
                          activeDotColor: btnColor1,
                          dotColor: const Color.fromARGB(249, 211, 211, 211),
                          spacing: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Buttons - only on last page
                    controller.currentPage.value == pages.length - 1
                        ? Column(
                          children: [
                            // First button with gradient and pressed effect
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Container(
                                width: double.infinity,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      btnColor1,
                                      const Color.fromARGB(255, 56, 191, 248),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: btnColor1.withOpacity(0.15),
                                      blurRadius: 15.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context.push('/signup');
                                    },
                                    borderRadius: BorderRadius.circular(24.r),
                                    splashColor: Colors.black.withOpacity(0.2),
                                    highlightColor: Colors.black.withOpacity(
                                      0.1,
                                    ),
                                    child: Center(
                                      child: Text(
                                        btnText1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),

                            // SECOND BUTTON
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  context.push('/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnColor4, // Very light blue
                                  minimumSize: Size(double.infinity, 58.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                                child: Text(
                                  btnText2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
