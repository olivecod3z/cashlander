// dashboard_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_lander2/src/services/income_storage_service.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';

class DashboardController extends GetxController {
  // Observables
  var username = ''.obs;
  var email = ''.obs;
  var isLoadingUserData = true.obs;

  // Financial observables
  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var availableBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _calculateTotals();
    _initializeFinancialData();
    _listenToFinancialChanges();
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

  // Initialize financial data
  void _initializeFinancialData() {
    _calculateTotals();
  }

  // Listen to changes in income and budget storage
  void _listenToFinancialChanges() {
    try {
      final incomeStorage = Get.find<IncomeStorageService>();
      final budgetStorage = Get.find<BudgetStorageService>();

      // Listen to income changes
      ever(incomeStorage.userIncomes, (_) {
        _calculateTotals();
      });

      // Listen to budget changes
      ever(budgetStorage.userBudgets, (_) {
        _calculateTotals();
      });
    } catch (e) {
      print('Error setting up financial listeners: $e');
    }
  }

  // Calculate all financial totals
  void _calculateTotals() {
    try {
      // Get storage services
      final incomeStorage = Get.find<IncomeStorageService>();
      final budgetStorage = Get.find<BudgetStorageService>();

      // Calculate total income (sum of all income amounts)
      totalIncome.value = incomeStorage.totalIncomeAmount;

      // Calculate total expense (sum of all spent amounts from budgets)
      totalExpense.value = budgetStorage.userBudgets.fold(
        0.0,
        (sum, budget) => sum + (budget['spentAmount'] as double),
      );

      // Calculate available balance
      availableBalance.value = totalIncome.value - totalExpense.value;

      print('Financial Summary:');
      print('Total Income: ₦${totalIncome.value}');
      print('Total Expense: ₦${totalExpense.value}');
      print('Available Balance: ₦${availableBalance.value}');
    } catch (e) {
      print('Error calculating totals: $e');
    }
  }

  // Format currency with commas
  String formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  // Method to refresh all data
  Future<void> refreshAllData() async {
    await loadUserData();
    _calculateTotals();
  }

  // Getter for display name
  String get displayName => username.value.isEmpty ? 'there' : username.value;

  // Method to handle notification tap
  void onNotificationTap() {
    print('Navigate to notifications');
  }

  // Method to handle transaction history tap
  void onTransactionHistoryTap() {
    print('Navigate to transaction history');
  }

  // Method to handle add money tap
  void onAddMoneyTap() {
    print('Navigate to add money');
  }
}
