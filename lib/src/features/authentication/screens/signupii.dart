import 'package:cash_lander2/src/common_widgets/signupnav.dart';
import 'package:cash_lander2/src/constants/text.dart';

import 'package:cash_lander2/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  //get authController => null;

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(SignupController());
    return Form(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignUpNav(authController: authController),
                  //SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    height: 1.h,
                    color: const Color.fromARGB(255, 222, 221, 221),
                  ),
                  SizedBox(height: 20.h),
                  // SIGNUP TITLE
                  Text(
                    signUpTitle,
                    style: TextStyle(
                      //letterSpacing: -1.sp,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  //PASSWORD DIRECTION
                  Obx(
                    () => Text(
                      signUpSubTitle,
                      style: TextStyle(
                        fontSize: 15.sp,

                        fontWeight: FontWeight.w400,
                        color:
                            authController.isPasswordValid.value
                                ? Colors.black
                                : Colors.red,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // EMAIL TITLE
                  Text(
                    emailHint,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  // EMAIL TEXTFIELD
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Obx(
                      () => TextFormField(
                        controller: authController.emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color:
                                  authController.isEmailValid.value
                                      ? btnColor1
                                      : Colors.red,
                              width: 1.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color:
                                  authController.isEmailValid.value
                                      ? Colors.grey.shade400
                                      : Colors.red,
                              width: 1.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // PASSWORD TITLE
                  Text(
                    passwordHint,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  // PASSWORD TEXTFIELD
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Obx(
                      () => TextFormField(
                        controller: authController.passwordController,
                        obscureText: !authController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color:
                                  authController.isPasswordValid.value
                                      ? btnColor1
                                      : Colors.red,
                              width: 1.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color:
                                  authController.isPasswordValid.value
                                      ? Colors.grey.shade400
                                      : Colors.red,
                              width: 1.w,
                            ),
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade500,
                            ),
                            onPressed:
                                // Toggle password visibility
                                authController.togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),
                  //CONFIRM PASSWORD TITLE
                  Text(
                    confirmHint,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  // CONFIRM PASSWORD TEXTFIELD
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Obx(
                      () => TextFormField(
                        controller: authController.confirmPasswordController,
                        obscureText:
                            !authController.isConfirmPasswordVisible.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color:
                                  authController.doPasswordsMatch.value
                                      ? btnColor1
                                      : Colors.red,
                              width: 1.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color:
                                  authController.doPasswordsMatch.value
                                      ? Colors.grey.shade400
                                      : Colors.red,
                              width: 1.w,
                            ),
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isConfirmPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade500,
                            ),
                            onPressed:
                                authController.toggleConfirmPasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (!authController.doPasswordsMatch.value &&
                        authController.hasAttemptedSubmit.value) {
                      return Padding(
                        padding: EdgeInsets.only(left: 6.w, top: 8.h),
                        child: Text(
                          'Passwords do not match',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink(); // Don't show anything
                    }
                  }),

                  //TERMS AND CONDITIONS
                  SizedBox(height: 50.h),
                  Text(
                    termsText1,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      // Navigate to Terms and Conditions page
                      // context.push('/terms');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0), // No minimum size
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      termsText2,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: btnColor1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
