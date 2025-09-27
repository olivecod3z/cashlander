// budget_storage_service.dart - With Firebase persistence
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';

class BudgetStorageService extends GetxController {
  RxList<Map<String, dynamic>> userBudgets = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadBudgetsFromFirebase();
  }

  // Load budgets from Firebase
  Future<void> loadBudgetsFromFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('budgets')
              .get();

      userBudgets.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        userBudgets.add({
          'id': doc.id,
          'categoryName': data['categoryName'],
          'budgetAmount': data['budgetAmount'],
          'spentAmount': data['spentAmount'] ?? 0.0,
        });
      }
      print('Loaded ${userBudgets.length} budgets from Firebase');
    } catch (e) {
      print('Error loading budgets: $e');
    }
  }

  // Add a new budget and save to Firebase
  Future<void> addUserBudget(
    BudgetCategory category,
    double budgetAmount, {
    double spentAmount = 0.0,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final existingIndex = userBudgets.indexWhere((budget) {
        final cat = budget['category'];
        if (cat is BudgetCategory) {
          return cat.name == category.name;
        } else if (budget['categoryName'] != null) {
          return budget['categoryName'] == category.name;
        }
        return false;
      });

      final budgetData = {
        'categoryName': category.name,
        'budgetAmount': budgetAmount,
        'spentAmount': spentAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (existingIndex != -1) {
        // Update existing in Firebase
        final docId = userBudgets[existingIndex]['id'];
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('budgets')
            .doc(docId)
            .update(budgetData);

        // Update in memory
        userBudgets[existingIndex] = {
          'id': docId,
          'category': category,
          'categoryName': category.name,
          'budgetAmount': budgetAmount,
          'spentAmount': spentAmount,
        };
      } else {
        // Add new to Firebase
        final docRef = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('budgets')
            .add(budgetData);

        // Add to memory
        userBudgets.add({
          'id': docRef.id,
          'category': category,
          'categoryName': category.name,
          'budgetAmount': budgetAmount,
          'spentAmount': spentAmount,
        });
      }
      print('Budget saved to Firebase: ${category.name} - ₦$budgetAmount');
    } catch (e) {
      print('Error saving budget: $e');
    }
  }

  // Remove a budget from Firebase
  Future<void> removeBudget(String categoryName) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final index = userBudgets.indexWhere((budget) {
        final cat = budget['category'];
        if (cat is BudgetCategory) {
          return cat.name == categoryName;
        } else if (budget['categoryName'] != null) {
          return budget['categoryName'] == categoryName;
        }
        return false;
      });

      if (index != -1) {
        final docId = userBudgets[index]['id'];
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('budgets')
            .doc(docId)
            .delete();

        userBudgets.removeAt(index);
        print('Budget removed from Firebase: $categoryName');
      }
    } catch (e) {
      print('Error removing budget: $e');
    }
  }

  // Update spent amount and save to Firebase
  Future<void> updateSpentAmount(
    String categoryName,
    double newSpentAmount,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final index = userBudgets.indexWhere((budget) {
        final cat = budget['category'];
        if (cat is BudgetCategory) {
          return cat.name == categoryName;
        } else if (budget['categoryName'] != null) {
          return budget['categoryName'] == categoryName;
        }
        return false;
      });

      if (index != -1) {
        final docId = userBudgets[index]['id'];

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('budgets')
            .doc(docId)
            .update({
              'spentAmount': newSpentAmount,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        userBudgets[index]['spentAmount'] = newSpentAmount;
        userBudgets.refresh();
        print('Spent amount updated: $categoryName - ₦$newSpentAmount');
      }
    } catch (e) {
      print('Error updating spent amount: $e');
    }
  }

  // Non-reactive method
  bool hasBudgetForCategory(String categoryName) {
    return userBudgets.value.any((budget) {
      final cat = budget['category'];
      if (cat is BudgetCategory) {
        return cat.name == categoryName;
      } else if (budget['categoryName'] != null) {
        return budget['categoryName'] == categoryName;
      }
      return false;
    });
  }

  // Non-reactive method
  Map<String, dynamic>? getBudgetForCategory(String categoryName) {
    try {
      return userBudgets.value.firstWhere((budget) {
        final cat = budget['category'];
        if (cat is BudgetCategory) {
          return cat.name == categoryName;
        } else if (budget['categoryName'] != null) {
          return budget['categoryName'] == categoryName;
        }
        return false;
      });
    } catch (e) {
      return null;
    }
  }

  // Reactive getters
  double get totalBudgetAmount {
    double total = 0.0;
    for (var budget in userBudgets) {
      total += budget['budgetAmount'] as double;
    }
    return total;
  }

  double get totalSpentAmount {
    double total = 0.0;
    for (var budget in userBudgets) {
      total += budget['spentAmount'] as double;
    }
    return total;
  }

  // Non-reactive versions
  double getTotalBudgetAmount() {
    double total = 0.0;
    for (var budget in userBudgets.value) {
      total += budget['budgetAmount'] as double;
    }
    return total;
  }

  double getTotalSpentAmount() {
    double total = 0.0;
    for (var budget in userBudgets.value) {
      total += budget['spentAmount'] as double;
    }
    return total;
  }

  List<Map<String, dynamic>> get allBudgets => userBudgets.value;
  bool get hasBudgets => userBudgets.value.isNotEmpty;
  int get budgetCount => userBudgets.value.length;
}
