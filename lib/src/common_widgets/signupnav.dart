import 'package:cash_lander2/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class SignUpNav extends StatelessWidget {
  const SignUpNav({super.key, required this.authController});

  final SignupController authController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                  authController.isLoading.value
                      ? null // Disable button when loading
                      : () {
                        print('🔍 SignUp Next button clicked!');
                        print(
                          '📧 Email: ${authController.emailController.text}',
                        );
                        print(
                          '🔒 Password: ${authController.passwordController.text.isNotEmpty ? "***entered***" : "empty"}',
                        );
                        print(
                          '🔒 Confirm: ${authController.confirmPasswordController.text.isNotEmpty ? "***entered***" : "empty"}',
                        );

                        authController.validateAndContinue(context);
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    authController.isLoading.value
                        ? btnColor1.withOpacity(
                          0.7,
                        ) // Slightly faded when loading
                        : btnColor1,
                foregroundColor: Colors.white,
                minimumSize: Size(80.w, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child:
                  authController.isLoading.value
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
    );
  }
}
