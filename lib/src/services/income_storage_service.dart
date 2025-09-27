import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cash_lander2/src/features/authentication/models/income_model.dart';

class IncomeStorageService extends GetxService {
  final RxList<Map<String, dynamic>> userIncomes = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadIncomesFromFirebase();
  }

  // Load incomes from Firebase
  Future<void> loadIncomesFromFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('incomes')
              .get();

      userIncomes.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Reconstruct the IncomeCategory from saved data
        // You'll need to store category details or ID to reconstruct it
        userIncomes.add({
          'id': doc.id,
          'categoryName': data['categoryName'],
          'incomeAmount': data['incomeAmount'],
          'receivedAmount': data['receivedAmount'],
        });
      }
      print('Loaded ${userIncomes.length} incomes from Firebase');
    } catch (e) {
      print('Error loading incomes: $e');
    }
  }

  // Add or update income and save to Firebase
  Future<void> addUserIncome(
    IncomeCategory category,
    double incomeAmount, {
    double receivedAmount = 0.0,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final existingIndex = userIncomes.indexWhere(
        (income) => income['categoryName'] == category.incName,
      );

      final incomeData = {
        'categoryName': category.incName,
        'incomeAmount': incomeAmount,
        'receivedAmount': receivedAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (existingIndex != -1) {
        // Update existing in Firebase
        final docId = userIncomes[existingIndex]['id'];
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('incomes')
            .doc(docId)
            .update(incomeData);

        // Update in memory
        userIncomes[existingIndex] = {
          'id': docId,
          'category': category,
          'incomeAmount': incomeAmount,
          'receivedAmount': receivedAmount,
        };
      } else {
        // Add new to Firebase
        final docRef = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('incomes')
            .add(incomeData);

        // Add to memory
        userIncomes.add({
          'id': docRef.id,
          'category': category,
          'incomeAmount': incomeAmount,
          'receivedAmount': receivedAmount,
        });
      }
      print('Income saved to Firebase: ${category.incName}');
    } catch (e) {
      print('Error saving income: $e');
    }
  }

  // Replace income and save to Firebase
  Future<void> replaceUserIncome(
    IncomeCategory category,
    double incomeAmount, {
    double receivedAmount = 0.0,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final existingIndex = userIncomes.indexWhere(
        (income) => income['categoryName'] == category.incName,
      );

      final incomeData = {
        'categoryName': category.incName,
        'incomeAmount': incomeAmount,
        'receivedAmount': receivedAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (existingIndex != -1) {
        final docId = userIncomes[existingIndex]['id'];
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('incomes')
            .doc(docId)
            .set(incomeData);

        userIncomes[existingIndex] = {
          'id': docId,
          'category': category,
          'incomeAmount': incomeAmount,
          'receivedAmount': receivedAmount,
        };
      } else {
        final docRef = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('incomes')
            .add(incomeData);

        userIncomes.add({
          'id': docRef.id,
          'category': category,
          'incomeAmount': incomeAmount,
          'receivedAmount': receivedAmount,
        });
      }
    } catch (e) {
      print('Error replacing income: $e');
    }
  }

  // Remove income from Firebase
  Future<void> removeIncome(String categoryName) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final index = userIncomes.indexWhere(
        (income) => income['categoryName'] == categoryName,
      );

      if (index != -1) {
        final docId = userIncomes[index]['id'];
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('incomes')
            .doc(docId)
            .delete();

        userIncomes.removeAt(index);
      }
    } catch (e) {
      print('Error removing income: $e');
    }
  }

  // Get income for a specific category
  Map<String, dynamic>? getIncomeForCategory(String categoryName) {
    try {
      return userIncomes.firstWhere((income) {
        final cat = income['category'];
        if (cat is IncomeCategory) {
          return cat.incName == categoryName;
        } else if (income['categoryName'] != null) {
          return income['categoryName'] == categoryName;
        }
        return false;
      });
    } catch (e) {
      return null;
    }
  }

  // Check if income exists for a category
  bool hasIncomeForCategory(String categoryName) {
    return userIncomes.any((income) {
      final cat = income['category'];
      if (cat is IncomeCategory) {
        return cat.incName == categoryName;
      } else if (income['categoryName'] != null) {
        return income['categoryName'] == categoryName;
      }
      return false;
    });
  }

  // Update received amount
  void updateReceivedAmount(String categoryName, double newReceivedAmount) {
    final index = userIncomes.indexWhere((income) {
      final cat = income['category'];
      if (cat is IncomeCategory) {
        return cat.incName == categoryName;
      } else if (income['categoryName'] != null) {
        return income['categoryName'] == categoryName;
      }
      return false;
    });

    if (index != -1) {
      userIncomes[index]['receivedAmount'] = newReceivedAmount;
      userIncomes.refresh();
    }
  }

  double get totalIncomeAmount {
    return userIncomes.fold(
      0.0,
      (sum, income) => sum + (income['incomeAmount'] as double),
    );
  }

  double get totalReceivedAmount {
    return userIncomes.fold(
      0.0,
      (sum, income) => sum + (income['receivedAmount'] as double),
    );
  }
}
