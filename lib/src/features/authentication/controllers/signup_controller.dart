import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:cash_lander2/src/services/firebase_service.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  var doPasswordsMatch = true.obs;
  var hasAttemptedSubmit = false.obs;
  var isLoading = false.obs;

  // Store email for OTP verification
  var userEmail = ''.obs;

  // Get Firebase service instance
  final FirebaseService _firebaseService = FirebaseService.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool validateEmail(String email) {
    const pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasLetter = password.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = password.contains(RegExp(r'\d'));
    return hasMinLength && hasLetter && hasNumber;
  }

  void validateAndContinue(BuildContext context) async {
    hasAttemptedSubmit.value = true;
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    isEmailValid.value = validateEmail(email);
    isPasswordValid.value = validatePassword(password);
    doPasswordsMatch.value = password == confirmPassword;

    if (isEmailValid.value && isPasswordValid.value && doPasswordsMatch.value) {
      await _signUpUser(context);
    }
  }

  Future<void> _signUpUser(BuildContext context) async {
    try {
      print('🚀 Starting signup process...');
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text;

      // Store email for OTP verification
      userEmail.value = email;
      print('📧 Stored email: $email');

      // Create user with Firebase Auth
      print('🔥 Creating Firebase user...');
      final userCredential = await _firebaseService.signUpWithEmailAndPassword(
        email,
        password,
      );

      print('✅ Firebase user created: ${userCredential?.user?.uid}');

      if (userCredential != null) {
        print('📤 Attempting to send OTP...');

        // Try to send OTP, but don't fail the entire signup if it fails
        try {
          await _sendOTPToUser(email);
          print('✅ OTP sent successfully!');
        } catch (otpError) {
          print('⚠️ OTP sending failed, but continuing anyway: $otpError');

          // Generate fallback OTP
          try {
            final otpCode = _firebaseService.generateOTP();
            await _firebaseService.storeOTPInFirestore(email, otpCode);
            print('🔐 FALLBACK OTP for $email: $otpCode');

            // Use safe snackbar
            _showSafeSnackbar(
              'Account Created',
              'Account created! Check console logs for your verification code.',
              Colors.blue,
            );
          } catch (fallbackError) {
            print('⚠️ Even fallback failed: $fallbackError');
            _showSafeSnackbar(
              'Account Created',
              'Account created! Please try requesting a new verification code on the next screen.',
              Colors.orange,
            );
          }
        }

        print('🧭 Navigating to OTP screen...');
        // ALWAYS navigate to OTP screen if user was created
        context.go('/otp');
        print('✅ Navigation completed!');
      }
    } catch (e) {
      print('💥 Signup error: $e');

      // Handle specific errors
      if (e.toString().contains('email-already-in-use') ||
          e.toString().contains('already exists for that email')) {
        _showSafeSnackbar(
          'Account Exists',
          'This email is already registered. Taking you to the verification screen.',
          Colors.orange,
        );

        // Navigate to OTP screen anyway since account exists
        userEmail.value = emailController.text.trim();
        context.go('/otp');
      } else if (e.toString().contains('Network error') ||
          e.toString().contains('network')) {
        _showSafeSnackbar(
          'Network Error',
          'Please check your internet connection and try again.',
          Colors.red,
        );
      } else {
        // Show generic error message
        _showSafeSnackbar('Error', e.toString(), Colors.red);
      }
    } finally {
      isLoading.value = false;
      print('🏁 Signup process completed');
    }
  }

  // Safe snackbar method that won't crash
  void _showSafeSnackbar(String title, String message, Color color) {
    try {
      if (Get.context != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: color,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        print('⚠️ Cannot show snackbar - no context available');
        print('📝 Message: $title - $message');
      }
    } catch (e) {
      print('⚠️ Snackbar failed: $e');
      print('📝 Intended message: $title - $message');
    }
  }

  Future<void> _sendOTPToUser(String email) async {
    try {
      print('🔐 Using local OTP generation (Functions disabled for now)');

      // Generate and store OTP locally
      final otpCode = _firebaseService.generateOTP();
      await _firebaseService.storeOTPInFirestore(email, otpCode);

      // Print OTP to console for testing
      print('🔐 OTP for $email: $otpCode');

      Get.snackbar(
        'OTP Generated',
        'Your 6-digit verification code: $otpCode\n\nCheck console logs as well.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    } catch (e) {
      print('💥 Even local OTP failed: $e');
      throw 'Failed to generate OTP: ${e.toString()}';
    }
  }
}
