// dashboard_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardController extends GetxController {
  // Observables
  var username = ''.obs;
  var email = ''.obs;
  var isLoadingUserData = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoadingUserData.value = true;
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        email.value = user.email ?? '';

        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (doc.exists) {
          username.value = doc.data()?['username'] ?? '';
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoadingUserData.value = false;
    }
  }

  // Method to refresh user data if needed
  Future<void> refreshUserData() async {
    await loadUserData();
  }

  // Getter for display name
  String get displayName => username.value.isEmpty ? 'there' : username.value;

  // Method to handle notification tap
  void onNotificationTap() {
    // Navigate to notifications page
    print('Navigate to notifications');
  }

  // Method to handle transaction history tap
  void onTransactionHistoryTap() {
    // Navigate to transaction history
    print('Navigate to transaction history');
  }

  // Method to handle add money tap
  void onAddMoneyTap() {
    // Navigate to add money page
    print('Navigate to add money');
  }
}
