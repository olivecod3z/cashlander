import 'package:cash_lander2/src/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  // Error states for fields
  final RxBool hasEmailError = false.obs;
  final RxBool hasPasswordError = false.obs;
  final RxString emailErrorMessage = ''.obs;
  final RxString passwordErrorMessage = ''.obs;

  // Show sign up prompt for unregistered emails
  final RxBool showSignUpPrompt = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Store context reference safely
  BuildContext? _context;

  // Store listener references for proper disposal
  VoidCallback? _emailFocusListener;
  VoidCallback? _passwordFocusListener;
  VoidCallback? _emailTextListener;
  VoidCallback? _passwordTextListener;

  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  void _setupListeners() {
    // Email focus listener
    _emailFocusListener = () {
      isEmailFocused.value = emailFocusNode.hasFocus;
      // Clear email error when user focuses on field
      if (emailFocusNode.hasFocus && hasEmailError.value) {
        clearEmailError();
      }
    };

    // Password focus listener
    _passwordFocusListener = () {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
      // Clear password error when user focuses on field
      if (passwordFocusNode.hasFocus && hasPasswordError.value) {
        clearPasswordError();
      }
    };

    // Email text change listener
    _emailTextListener = () {
      if (hasEmailError.value && emailController.text.isNotEmpty) {
        clearEmailError();
      }
    };

    // Password text change listener
    _passwordTextListener = () {
      if (hasPasswordError.value && passwordController.text.isNotEmpty) {
        clearPasswordError();
      }
    };

    // Add listeners
    emailFocusNode.addListener(_emailFocusListener!);
    passwordFocusNode.addListener(_passwordFocusListener!);
    emailController.addListener(_emailTextListener!);
    passwordController.addListener(_passwordTextListener!);
  }

  void clearEmailError() {
    hasEmailError.value = false;
    emailErrorMessage.value = '';
    showSignUpPrompt.value = false;
  }

  void clearPasswordError() {
    hasPasswordError.value = false;
    passwordErrorMessage.value = '';
  }

  void clearAllErrors() {
    clearEmailError();
    clearPasswordError();
  }

  void setEmailError(String message) {
    hasEmailError.value = true;
    emailErrorMessage.value = message;
  }

  void setPasswordError(String message) {
    hasPasswordError.value = true;
    passwordErrorMessage.value = message;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Safe snackbar method using Flutter's native SnackBar
  void _showSnackbar(String title, String message, {Color? backgroundColor}) {
    if (_context != null && _context!.mounted) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              Text(message),
            ],
          ),
          backgroundColor: backgroundColor ?? Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> signIn() async {
    // Clear previous errors
    clearAllErrors();

    // Validate fields
    bool hasValidationErrors = false;

    if (emailController.text.isEmpty) {
      setEmailError('Email is required');
      hasValidationErrors = true;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      setEmailError('Please enter a valid email address');
      hasValidationErrors = true;
    }

    if (passwordController.text.isEmpty) {
      setPasswordError('Password is required');
      hasValidationErrors = true;
    }

    if (hasValidationErrors) {
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        print("User authenticated: ${userCredential.user!.uid}");
        print("User email: ${userCredential.user!.email}");

        _showSnackbar(
          "Success",
          "Login successful!",
          backgroundColor: btnColor2,
        );

        // Navigate using GoRouter with safety check
        if (_context != null && _context!.mounted) {
          _context!.go('/dashboard');
        }
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      print("Login error: $e");
      _showSnackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        _showSnackbar(
          "Network Error",
          "Please check your internet connection and try again.",
        );
        break;
      case 'user-not-found':
        setEmailError('Invalid email address');
        showSignUpPrompt.value = true;
        break;
      case 'wrong-password':
        setPasswordError('Incorrect password');
        break;
      case 'invalid-email':
        setEmailError('Invalid email address');
        showSignUpPrompt.value = true;
        break;
      case 'user-disabled':
        setEmailError('This account has been disabled');
        break;
      case 'too-many-requests':
        _showSnackbar(
          "Too Many Attempts",
          "Too many failed attempts. Please try again later.",
        );
        break;
      case 'invalid-credential':
        _handleInvalidCredential();
        break;
      case 'operation-not-allowed':
        _showSnackbar("Error", "Email/password authentication is not enabled.");
        break;
      default:
        _showSnackbar(
          "Login Failed",
          e.message ?? "An error occurred during login.",
        );
    }
  }

  // Method to handle invalid-credential by checking if email exists
  Future<void> _handleInvalidCredential() async {
    try {
      // Use a more modern approach to check email existence
      final methods = await _auth.fetchSignInMethodsForEmail(
        emailController.text.trim(),
      );

      if (methods.isEmpty) {
        // Email doesn't exist
        setEmailError('Invalid email address');
        showSignUpPrompt.value = true;
      } else {
        // Email exists, so password must be wrong
        setPasswordError('Incorrect password');
      }
    } catch (e) {
      // If we can't check, provide a generic message
      _showSnackbar(
        "Login Failed",
        "Invalid email or password. Please try again.",
      );
    }
  }

  void forgotPassword() {
    if (_context != null && _context!.mounted) {
      _context!.push('/forgot-password');
    }
  }

  void navigateToSignUp() {
    if (_context != null && _context!.mounted) {
      _context!.push('/signup');
    }
  }

  @override
  void onClose() {
    // Remove listeners before disposing
    if (_emailFocusListener != null) {
      emailFocusNode.removeListener(_emailFocusListener!);
    }
    if (_passwordFocusListener != null) {
      passwordFocusNode.removeListener(_passwordFocusListener!);
    }
    if (_emailTextListener != null) {
      emailController.removeListener(_emailTextListener!);
    }
    if (_passwordTextListener != null) {
      passwordController.removeListener(_passwordTextListener!);
    }

    // Dispose controllers and focus nodes
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
