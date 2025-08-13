import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleController extends GetxController {
  RxBool isIncome = false.obs;

  void toggletoExpense() {
    isIncome.value = false;
  }

  void toggletoIncome() {
    isIncome.value = true;
    //Get.toNamed('/incomelist');
  }

  String get currentMode => isIncome.value ? 'Income' : 'Expense';
}
