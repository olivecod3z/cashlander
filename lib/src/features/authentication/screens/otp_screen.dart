import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/features/authentication/controllers/countdown_controller.dart';
import 'package:cash_lander2/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SignupController>()) {
      Get.put(SignupController()); // rebind if not found
    }

    final countdownController = Get.put(CountdownController());

    // Listen for verification success and navigate automatically
    ever(countdownController.verificationSuccess, (bool success) {
      if (success) {
        print(
          '🎯 Success listener triggered! Navigating to username screen...',
        );
        Future.delayed(Duration(milliseconds: 100), () {
          context.go('/username');
          print('✅ Navigation to /username completed!');
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 55.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Row(
                children: [
                  // Back button with constrained size
                  SizedBox(
                    height: 40.h,
                    width: 40.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: btnColor4,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  // Flexible spacer
                  const Expanded(child: SizedBox()),

                  // Next button with loading state
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          countdownController.isLoading.value
                              ? null
                              : () async {
                                print('🔘 Next button clicked!');
                                final code = countdownController.otpCode.value;
                                print(
                                  '📝 Current OTP code: "$code" (length: ${code.length})',
                                );

                                if (code.length == 6) {
                                  print('🚀 Starting verification...');
                                  await countdownController
                                      .verifyOTPWithoutNavigation(code);
                                  // Navigation will be handled by the listener above
                                } else {
                                  print('❌ Invalid OTP length');
                                  Get.snackbar(
                                    'Invalid OTP',
                                    'Please enter the complete 6-digit code.',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            countdownController.isLoading.value
                                ? btnColor1.withOpacity(0.7)
                                : btnColor1,
                        foregroundColor: Colors.white,
                        minimumSize: Size(80.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:
                          countdownController.isLoading.value
                              ? SizedBox(
                                height: 16.h,
                                width: 16.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              height: 1.h,
              color: const Color.fromARGB(255, 222, 221, 221),
            ),
            SizedBox(height: 20.h),

            // OTP Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor1,
                  letterSpacing: -0.5.sp,
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // POLISHED OTP INPUT
            Center(
              child: OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.grey.shade300,
                focusedBorderColor: btnColor1, // Blue when focused
                borderRadius: BorderRadius.circular(8.r),
                borderWidth: 1.5.w,
                fieldWidth: 45.w,
                fieldHeight: 50.h,
                showFieldAsBox: true,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                cursorColor: btnColor1,
                enabledBorderColor: Colors.grey.shade300,
                disabledBorderColor: Colors.grey.shade300,
                //filledBorderColor: btnColor1, // Blue border when filled
                keyboardType: TextInputType.number,
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: btnColor1, // Blue text color
                ),
                onCodeChanged: (code) {
                  print(
                    '📝 OTP code changed: "$code" (length: ${code.length})',
                  );
                  countdownController.otpCode.value = code;
                },
                onSubmit: (code) {
                  print('✅ OTP submitted: "$code"');
                  print('🔍 Calling onOTPSubmit...');
                  countdownController.onOTPSubmit(code);
                },
              ),
            ),
            SizedBox(height: 40.h),

            // POLISHED TEXT SECTION
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Main text
                  Text(
                    sentText,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: subColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Timer
                  Obx(
                    () => Text(
                      countdownController.formattedTime.value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: btnColor1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Resend section
                  Obx(() {
                    if (countdownController.canResend.value) {
                      return RichText(
                        text: TextSpan(
                          text: 'Didn\'t receive the code? ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: subColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Resend',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: btnColor1,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: btnColor1,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      countdownController.restartTimer();
                                    },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text(
                        'Didn\'t receive the code? Resend',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }
                  }),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // // Development note (remove in production)
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   child: Container(
            //     padding: EdgeInsets.all(12.w),
            //     decoration: BoxDecoration(
            //       color: Colors.blue.withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(8.r),
            //       border: Border.all(color: Colors.blue.withOpacity(0.3)),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Development Mode:',
            //           style: TextStyle(
            //             fontSize: 12.sp,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.blue.shade700,
            //           ),
            //         ),
            //         SizedBox(height: 4.h),
            //         Text(
            //           'Check console logs for OTP code. Navigation will happen automatically when verification succeeds.',
            //           style: TextStyle(
            //             fontSize: 11.sp,
            //             color: Colors.blue.shade600,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
