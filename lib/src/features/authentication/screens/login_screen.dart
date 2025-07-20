import 'package:cash_lander2/src/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 249, 249),
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [Image.asset(logoImg, height: 200.h, width: 200.w)],
          ),
        ),
      ),
    );
  }
}
