import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollSliderController extends GetxController {
  late ScrollController scrollController;

  // Observable variables
  var scrollProgress = 0.0.obs;
  var currentIndex = 0.obs;
  var totalItems = 3.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_updateScrollProgress);
  }

  void _updateScrollProgress() {
    if (scrollController.hasClients) {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;

      // Update scroll progress (0.0 to 1.0)
      scrollProgress.value = maxScroll > 0 ? currentScroll / maxScroll : 0.0;

      // Calculate current index based on scroll position
      // Each card is 180w + 20w spacing = 200w total
      double itemWidth = 200.0;
      currentIndex.value = (currentScroll / itemWidth).round().clamp(
        0,
        totalItems.value - 1,
      );
    }
  }

  // Method to scroll to specific index
  void scrollToIndex(int index) {
    double itemWidth = 200.0; // 180w card + 20w spacing
    double targetOffset = index * itemWidth;

    scrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.removeListener(_updateScrollProgress);
    scrollController.dispose();
    super.onClose();
  }
}
