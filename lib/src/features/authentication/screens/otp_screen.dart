import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                        // context.pop();
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

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor1, // Use your primary button color
                    foregroundColor: Colors.white,
                    minimumSize: Size(80.w, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text('Next'),
                ),
              ],
            ),

            //otp prompt
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Text(
                otpTitle,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
