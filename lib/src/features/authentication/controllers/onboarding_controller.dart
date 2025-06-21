// import 'package:cash_lander2/src/constants/images.dart';
// import 'package:cash_lander2/src/constants/text.dart';
// import 'package:cash_lander2/src/features/authentication/models/model_onboarding.dart';
// import 'package:cash_lander2/src/features/authentication/screens/onboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class OnboardingController extends GetxController {
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;
  late Timer _timer;
  int totalPages = 4;
  // bool _isAutoScrolling = true;

  //start the controller and declare function for autoscroll
  @override
  void onInit() {
    super.onInit();
    //print("OnboardingController onInit called!");
    startAutoScroll();
  }

  void startAutoScroll() {
    // print("startAutoScroll called, totalPages: $totalPages"); // Add this back
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      //  print("Timer fired - currentPage: ${currentPage.value}"); // Add this back
      if (currentPage.value < totalPages - 1) {
        currentPage.value++;
        // print("Animating to page: ${currentPage.value}"); // Add this back
        pageController.animateToPage(
          currentPage.value,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        // print("Reached last page, canceling timer"); // Add this back
        _timer.cancel();
      }
    });
  }

  //  Autoscroll function that changes the page every 3 seconds
  // void startAutoScroll() {
  //   _timer = Timer.periodic(Duration(seconds: 3), (_) {
  //     if (currentPage.value < totalPages - 1) {
  //       currentPage.value++;
  //       pageController.animateToPage(
  //         currentPage.value,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.ease,
  //       );
  //     } else {
  //       _timer.cancel();
  //     }
  //   });
  // }
  //manual page change function
  // void onManualPageChange(int index) {
  //   print('Manual page change to index: $index');
  //   _isAutoScrolling = false;
  //   if (_timer.isActive) {
  //     _timer.cancel();
  //   }
  //   currentPage.value = index;
  // }

  //skip button logic
  void skipToEnd() {
    currentPage.value = totalPages - 1;
    pageController.jumpToPage(currentPage.value);
    _timer.cancel();
  }

  //Controller disposal
  @override
  void onClose() {
    _timer.cancel();
    pageController.dispose();
    super.onClose();
  }
}
