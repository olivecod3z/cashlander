import 'package:get/get.dart';

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
