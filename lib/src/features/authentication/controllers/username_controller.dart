import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserNameController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final RxBool isUserNameValid = true.obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;

  // Get Firebase service instance
  final FirebaseService _firebaseService = FirebaseService.instance;

  Future<void> validateAndProceed() async {
    final userName = userNameController.text.trim();

    // Reset previous states
    isLoading.value = true;
    errorMessage.value = '';

    // Basic validation
    if (userName.isEmpty) {
      isUserNameValid.value = false;
      errorMessage.value = userNameErrorText;
      isLoading.value = false;
      return;
    }

    // Username format validation
    final userNameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,23}$');
    if (!userNameRegex.hasMatch(userName)) {
      isUserNameValid.value = false;
      errorMessage.value = userNameErrorText2;
      isLoading.value = false;
      return;
    }

    // Check username availability and save if available
    await _checkUsernameAvailabilityAndSave(userName);
  }

  Future<void> _checkUsernameAvailabilityAndSave(String username) async {
    try {
      print('Checking username availability for: $username');

      // Check if user is authenticated first
      final currentUser = _firebaseService.currentUser;
      if (currentUser == null) {
        throw 'User not authenticated. Please sign in again.';
      }

      print('Current user: ${currentUser.uid}');

      // Check if username is available
      final isAvailable = await _firebaseService.isUsernameAvailable(username);
      print('Username available: $isAvailable');

      if (!isAvailable) {
        isUserNameValid.value = false;
        errorMessage.value = 'Username is already taken';
        return;
      }

      // Username is available, save it
      print('Saving username to Firebase...');
      await _saveUsername(username);

      // Success state
      isUserNameValid.value = true;
      errorMessage.value = '';

      print('Username saved successfully!');
    } catch (e) {
      print('Error in username check/save: $e');
      isUserNameValid.value = false;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUsername(String username) async {
    try {
      final currentUser = _firebaseService.currentUser;
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      await _firebaseService.createUserDocument(
        currentUser.uid,
        currentUser.email!,
        username,
      );
    } catch (e) {
      throw 'Failed to save username: ${e.toString()}';
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    super.onClose();
  }
}
