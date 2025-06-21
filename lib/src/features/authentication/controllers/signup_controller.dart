import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

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

  void validateAndContinue(BuildContext context) {
    hasAttemptedSubmit.value = true;
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    isEmailValid.value = validateEmail(email);
    isPasswordValid.value = validatePassword(password);
    doPasswordsMatch.value = password == confirmPassword;

    if (isEmailValid.value && isPasswordValid.value && doPasswordsMatch.value) {
      context.push('/otp');
    }
  }
}
