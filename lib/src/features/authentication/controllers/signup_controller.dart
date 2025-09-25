// Updated signup_controller.dart with email verification
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:cash_lander2/src/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Store email for verification
  var userEmail = ''.obs;

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
      userEmail.value = email;

      // Create user with Firebase Auth
      print('🔥 Creating Firebase user...');
      final userCredential = await _firebaseService.signUpWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential?.user != null) {
        print('✅ Firebase user created: ${userCredential!.user!.uid}');

        // Send email verification
        print('📧 Sending email verification...');
        await userCredential.user!.sendEmailVerification();

        print('✅ Email verification sent!');

        // Show success message
        _showSafeSnackbar(
          'Account Created',
          'Please check your email and click the verification link to continue.',
          Colors.blue,
        );

        // Navigate to email verification screen
        print('🧭 Navigating to email verification screen...');
        context.go('/email-verification');
      }
    } catch (e) {
      print('💥 Signup error: $e');

      if (e.toString().contains('email-already-in-use') ||
          e.toString().contains('already exists for that email')) {
        _showSafeSnackbar(
          'Account Already Exists',
          'This email is already registered. Please use the login screen instead.',
          Colors.red,
        );
      } else if (e.toString().contains('Network error') ||
          e.toString().contains('network')) {
        _showSafeSnackbar(
          'Network Error',
          'Please check your internet connection and try again.',
          Colors.red,
        );
      } else {
        _showSafeSnackbar('Error', e.toString(), Colors.red);
      }
    } finally {
      isLoading.value = false;
      print('🏁 Signup process completed');
    }
  }

  void _showSafeSnackbar(String title, String message, Color color) {
    try {
      if (Get.context != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: color,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
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

  // Check email verification status
  Future<bool> checkEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload(); // Refresh user data
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      print('Error checking email verification: $e');
      return false;
    }
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _showSafeSnackbar(
          'Email Sent',
          'Verification email sent. Please check your inbox.',
          Colors.blue,
        );
      }
    } catch (e) {
      print('Error resending email: $e');
      _showSafeSnackbar(
        'Error',
        'Failed to send verification email. Please try again.',
        Colors.red,
      );
    }
  }
}
