import 'package:flutter/material.dart';
import 'package:cash_lander2/src/common_widgets/bottom_navbar.dart'; // Your existing file

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // This shows the current route from GoRouter
      bottomNavigationBar: BottomNavbar(), // Your existing bottom nav
    );
  }
}
