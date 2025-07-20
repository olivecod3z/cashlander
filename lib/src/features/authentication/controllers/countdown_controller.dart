import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cash_lander2/src/services/firebase_service.dart';
import 'package:cash_lander2/src/features/authentication/controllers/signup_controller.dart';

class CountdownController extends GetxController {
  final RxInt _secondsRemaining = 300.obs; // 5 minutes in seconds
  late Timer _timer;

  // Firebase service
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Loading state for resend functionality
  final RxBool isLoading = false.obs;

  // OTP verification
  var otpCode = ''.obs;

  // NEW: Verification success state (for widget to react to)
  var verificationSuccess = false.obs;
  var verificationError = ''.obs;

  String get timeFormatted {
    final minutes = (_secondsRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  RxString formattedTime = '05:00'.obs;
  RxBool canResend = false.obs;

  @override
  void onInit() {
    startCountdown();
    super.onInit();
  }

  void startCountdown() {
    canResend.value = false;
    _secondsRemaining.value = 300; // Reset to 5 minutes

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
        formattedTime.value = timeFormatted;
      } else {
        _timer.cancel();
        canResend.value = true; // Enable resend after countdown ends
      }
    });
  }

  // Handle OTP input completion
  void onOTPSubmit(String code) async {
    print("OTP entered: $code");
    otpCode.value = code;
    await verifyOTPWithoutNavigation(code);
  }

  // Verify OTP WITHOUT navigation - returns success/failure
  Future<void> verifyOTPWithoutNavigation(String code) async {
    try {
      print('🔍 === Starting OTP Verification ===');
      print('🔍 Code to verify: "$code"');
      isLoading.value = true;

      // Reset previous states
      verificationSuccess.value = false;
      verificationError.value = '';

      // Get user email from signup controller
      final signupController = Get.find<SignupController>();
      final email = signupController.userEmail.value;

      print('📧 Email from signup controller: "$email"');

      if (email.isEmpty) {
        print('❌ Email is empty!');
        throw 'Email not found. Please restart signup process.';
      }

      print('🔍 Verifying OTP: $code for email: $email');

      // Verify OTP
      print('🚀 Calling Firebase verifyOTPFromFirestore...');
      final isValid = await _firebaseService.verifyOTPFromFirestore(
        email,
        code,
      );

      print('📊 Verification result: $isValid');

      if (isValid) {
        print('✅ OTP is valid! Stopping timer...');
        _timer.cancel();

        // Set success state (widget will react to this)
        verificationSuccess.value = true;

        print('🎉 Showing success message...');
        Get.snackbar(
          'Success',
          'Email verified successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        print(
          '✅ OTP verification successful - widget should handle navigation',
        );
      } else {
        print('❌ OTP verification returned false');
        verificationError.value = 'Invalid verification code';
      }
    } catch (e) {
      print('💥 OTP Verification Error: $e');
      verificationError.value = e.toString();

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      print('🏁 OTP verification process completed');
    }
  }

  // Legacy method (keep for compatibility but don't use navigation)
  Future<void> verifyOTP(String code) async {
    await verifyOTPWithoutNavigation(code);
  }

  // Call this method to reset the countdown and resend OTP
  void restartTimer() async {
    try {
      isLoading.value = true;

      // Get user email from signup controller
      final signupController = Get.find<SignupController>();
      final email = signupController.userEmail.value;

      if (email.isEmpty) {
        throw 'Email not found. Please restart signup process.';
      }

      // Generate new OTP
      final newOTP = _firebaseService.generateOTP();

      // Store new OTP
      await _firebaseService.storeOTPInFirestore(email, newOTP);

      // For development, print OTP to console
      print('🔐 New OTP for $email: $newOTP');

      // Restart countdown
      _timer.cancel();
      startCountdown();

      Get.snackbar(
        'New Code Sent',
        'A new verification code has been sent to your email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
