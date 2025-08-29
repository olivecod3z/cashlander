import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetCategoryLogo extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size; // Optional: so you can control overall logo size

  const BudgetCategoryLogo({
    super.key,
    required this.icon,
    required this.color,
    this.size = 45, // default size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: Icon(icon, size: 24, color: Colors.white)),
    );
  }
}
