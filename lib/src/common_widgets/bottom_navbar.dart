import 'package:cash_lander2/src/features/authentication/controllers/bottombar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavbar extends StatelessWidget {
  final BottombarController controller = Get.put(BottombarController());

  BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context: context,
                iconRegular: PhosphorIconsRegular.house,
                iconFilled: PhosphorIconsFill.house,
                index: 0,
                isSelected: controller.selectedIndex.value == 0,
              ),
              _buildNavItem(
                context: context,
                iconRegular: PhosphorIconsRegular.chartBar,
                iconFilled: PhosphorIconsFill.chartBar,
                index: 1,
                isSelected: controller.selectedIndex.value == 1,
              ),
              _buildNavItem(
                context: context,
                iconRegular: PhosphorIconsRegular.gear,
                iconFilled: PhosphorIconsFill.gear,
                index: 2,
                isSelected: controller.selectedIndex.value == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData iconRegular,
    required IconData iconFilled,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/insights');
            break;
          case 2:
            // context.go('/settings');
            break;
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              isSelected ? iconFilled : iconRegular,
              color: isSelected ? Colors.blue : Colors.black,
              size: 20.sp,
            ),
            if (isSelected) ...[SizedBox(width: 4.w)],
          ],
        ),
      ),
    );
  }
}
