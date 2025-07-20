import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/features/authentication/controllers/username_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class UserNamePage extends StatelessWidget {
  const UserNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserNameController controller = Get.put(UserNameController());

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
                          context.pop(); // Navigate back
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
                          controller.isLoading.value
                              ? null
                              : () async {
                                await controller.validateAndProceed();

                                // Navigate only if username is valid and saved
                                if (controller.isUserNameValid.value &&
                                    !controller.isLoading.value &&
                                    controller.errorMessage.value.isEmpty) {
                                  context.go('/profile');
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            controller.isLoading.value
                                ? Colors.grey
                                : btnColor1,
                        foregroundColor: Colors.white,
                        minimumSize: Size(80.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:
                          controller.isLoading.value
                              ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text('Next'),
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
            //username create text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                userNameTitle,
                style: TextStyle(
                  letterSpacing: -0.4.sp,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            //username sub text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                userNameSubTitle,
                style: TextStyle(
                  height: 1.4.h,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: subColor,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            //username text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Username',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor1,
                ),
              ),
            ),
            //username textfield
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () => TextFormField(
                  controller: controller.userNameController,
                  enabled:
                      !controller.isLoading.value, // Disable during loading
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color:
                            controller.isUserNameValid.value
                                ? btnColor1
                                : Colors.red,
                        width: 1.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color:
                            controller.isUserNameValid.value
                                ? Colors.grey.shade400
                                : Colors.red,
                        width: 1.w,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.w,
                      ),
                    ),
                    suffixIcon:
                        controller.isLoading.value
                            ? Padding(
                              padding: EdgeInsets.all(12.w),
                              child: SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: btnColor1,
                                ),
                              ),
                            )
                            : null,
                  ),
                  onChanged: (value) {
                    // Reset error state when user starts typing
                    if (controller.errorMessage.value.isNotEmpty) {
                      controller.errorMessage.value = '';
                      controller.isUserNameValid.value = true;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            //username error text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () =>
                    controller.errorMessage.value.isNotEmpty
                        ? Text(
                          controller.errorMessage.value,
                          style: TextStyle(fontSize: 14.sp, color: Colors.red),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
