// email_verification_screen.dart
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isLoading = false;
  bool canResend = false;
  int countdown = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
    startVerificationCheck();
  }

  void startCountdown() {
    countdown = 60;
    canResend = false;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void startVerificationCheck() {
    // Check email verification status every 3 seconds
    Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final controller = Get.find<SignupController>();
      final isVerified = await controller.checkEmailVerification();

      if (isVerified) {
        timer.cancel();
        // Navigate to username screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/username');
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SignupController>()) {
      Get.put(SignupController());
    }

    final controller = Get.find<SignupController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: btnColor4,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Verify Email',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 40.w), // Balance the back button
                ],
              ),

              SizedBox(height: 40.h),

              // Email icon
              Center(
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: btnColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: PhosphorIcon(
                    PhosphorIconsBold.envelope,
                    color: btnColor1,
                    size: 40.sp,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Title
              Text(
                'Check your email',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor1,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Description
              Obx(
                () => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'We sent a verification link to\n',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: subColor,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: controller.userEmail.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: btnColor1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Instructions
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next steps:',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor1,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildInstruction('1', 'Check your email inbox'),
                    SizedBox(height: 8.h),
                    _buildInstruction('2', 'Click the verification link'),
                    SizedBox(height: 8.h),
                    _buildInstruction('3', 'Return to this app'),
                  ],
                ),
              ),

              Spacer(),

              // Resend section
              Center(
                child:
                    canResend
                        ? TextButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await controller.resendVerificationEmail();
                                    startCountdown();

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        btnColor1,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'Resend verification email',
                                    style: TextStyle(
                                      color: btnColor1,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        )
                        : Text(
                          'Resend available in ${countdown}s',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.sp,
                          ),
                        ),
              ),

              SizedBox(height: 20.h),

              // Manual refresh button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final isVerified =
                        await controller.checkEmailVerification();
                    if (isVerified) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email verified successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.go('/username');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Email not verified yet. Please check your email.',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor1,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'I\'ve verified my email',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: btnColor1,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 14.sp, color: subColor)),
        ),
      ],
    );
  }
}
