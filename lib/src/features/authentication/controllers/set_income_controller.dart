// set_income_controller.dart
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/services/income_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cash_lander2/src/features/authentication/models/income_model.dart';

class SetIncomeController extends GetxController {
  late IncomeCategory category;
  final TextEditingController incomeController = TextEditingController();
  var selectedPeriod = 'Monthly'.obs;

  void initializeForNewCategory(IncomeCategory cat) {
    category = cat;
    incomeController.clear();
    selectedPeriod.value = 'Monthly';
  }

  void selectPeriod() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Daily'),
              onTap: () {
                selectedPeriod.value = 'Daily';
                Get.back();
              },
            ),
            ListTile(
              title: Text('Weekly'),
              onTap: () {
                selectedPeriod.value = 'Weekly';
                Get.back();
              },
            ),
            ListTile(
              title: Text('Monthly'),
              onTap: () {
                selectedPeriod.value = 'Monthly';
                Get.back();
              },
            ),
            ListTile(
              title: Text('Yearly'),
              onTap: () {
                selectedPeriod.value = 'Yearly';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void saveIncome(BuildContext context) {
    final incomeText = incomeController.text.trim();

    // Validate empty input
    if (incomeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an income amount'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validate amount
    final incomeAmount = double.tryParse(incomeText);
    if (incomeAmount == null || incomeAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final incomeStorage = Get.find<IncomeStorageService>();
      final existing = incomeStorage.getIncomeForCategory(category.incName);

      // If income already exists, ask user whether to add or replace
      if (existing != null) {
        final existingAmount = existing['incomeAmount'] as double;
        _showAddOrReplaceDialog(
          context,
          existingAmount,
          incomeAmount,
          incomeStorage,
        );
      } else {
        // New income - just add it
        incomeStorage.addUserIncome(
          category,
          incomeAmount,
          receivedAmount: 0.0,
        );
        _showSuccessAndNavigateBack(context, 'Income saved successfully!');
      }
    } catch (e) {
      print('Error saving income: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save income. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddOrReplaceDialog(
    BuildContext context,
    double existingAmount,
    double newAmount,
    IncomeStorageService incomeStorage,
  ) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Income Already Exists',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: 'Roboto',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This category already has an income of ₦${existingAmount.toStringAsFixed(0)}.',
                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                ),
                SizedBox(height: 12),
                Text(
                  'Would you like to:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.add, size: 16, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'Add ₦${newAmount.toStringAsFixed(0)} ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '= ₦${(existingAmount + newAmount).toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.swap_horiz, size: 16, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      'Replace with ₦${newAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Close dialog first
                  Navigator.of(dialogContext).pop();

                  // Replace the income
                  incomeStorage.replaceUserIncome(
                    category,
                    newAmount,
                    receivedAmount: 0.0,
                  );

                  // Wait for dialog to close, then navigate with original context
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      _showSuccessAndNavigateBack(
                        context,
                        'Income replaced: ₦${newAmount.toStringAsFixed(0)}',
                      );
                    }
                  });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
                child: Text(
                  'Replace',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Close dialog first
                  Navigator.of(dialogContext).pop();

                  // Add to existing income
                  incomeStorage.addUserIncome(
                    category,
                    newAmount,
                    receivedAmount: 0.0,
                  );

                  // Wait for dialog to close, then navigate with original context
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      _showSuccessAndNavigateBack(
                        context,
                        'Added! Total: ₦${(existingAmount + newAmount).toStringAsFixed(0)}',
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor1,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showSuccessAndNavigateBack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Roboto', // ← Added this
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.go('/budget-display', extra: {'isIncome': true});
      }
    });
  }
}
