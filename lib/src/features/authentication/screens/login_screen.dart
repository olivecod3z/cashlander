import 'package:cash_lander2/src/constants/images.dart';
import 'package:cash_lander2/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    // Set the context for navigation
    controller.setContext(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: btnColor4,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: IconButton(
                      iconSize: 18.sp,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Divider
                Divider(color: Colors.grey[300], thickness: 1),

                // Logo and Title
                Transform.translate(
                  offset: Offset(0, -50.h),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          logoImg,
                          height: 220.h,
                          width: 220.w,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -55.h),
                        child: Center(
                          child: Text(
                            "Hey, there!",
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Section
                Transform.translate(
                  offset: Offset(0, -90.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text(
                          "Email Address",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Email text field with error handling
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      controller.hasEmailError.value
                                          ? Colors.red[50]
                                          : controller.isEmailFocused.value
                                          ? btnColor4
                                          : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: TextField(
                                  controller: controller.emailController,
                                  focusNode: controller.emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(fontSize: 16.sp),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            controller.hasEmailError.value
                                                ? Colors.red
                                                : btnColor1,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder:
                                        controller.hasEmailError.value
                                            ? OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            )
                                            : null,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                      vertical: 13.h,
                                    ),
                                  ),
                                ),
                              ),

                              // Email error message
                              if (controller.hasEmailError.value)
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h, left: 5.w),
                                  child: Text(
                                    controller.emailErrorMessage.value,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // Password Field
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Password text field with error handling
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      controller.hasPasswordError.value
                                          ? Colors.red[50]
                                          : controller.isPasswordFocused.value
                                          ? btnColor4
                                          : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: TextField(
                                  controller: controller.passwordController,
                                  focusNode: controller.passwordFocusNode,
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => controller.signIn(),
                                  style: TextStyle(fontSize: 16.sp),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            controller.hasPasswordError.value
                                                ? Colors.red
                                                : btnColor1,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder:
                                        controller.hasPasswordError.value
                                            ? OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            )
                                            : null,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 13.h,
                                    ),
                                    suffixIcon: Semantics(
                                      label:
                                          controller.isPasswordVisible.value
                                              ? "Hide password"
                                              : "Show password",
                                      child: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Password error message
                              if (controller.hasPasswordError.value)
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h, left: 5.w),
                                  child: Text(
                                    controller.passwordErrorMessage.value,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 22.h),

                        // Forgot Password
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: controller.forgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: const Color(0xFF007AFF),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // Sign up prompt for unregistered emails
                        Obx(
                          () =>
                              controller.showSignUpPrompt.value
                                  ? Padding(
                                    padding: EdgeInsets.only(bottom: 18.h),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account? ",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: controller.navigateToSignUp,
                                            child: Text(
                                              "Sign up",
                                              style: TextStyle(
                                                color: const Color(0xFF007AFF),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: const Color(
                                                  0xFF007AFF,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        SizedBox(height: 18.h),

                        // Sign In Button
                        Obx(
                          () => Container(
                            width: double.infinity,
                            height: 53.h,
                            decoration: BoxDecoration(
                              color: btnColor1,
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  controller.isLoading.value
                                      ? null
                                      : controller.signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child:
                                  controller.isLoading.value
                                      ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
