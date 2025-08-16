// budget_success_screen.dart - Auto-navigate after confetti
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

class BudgetSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> extra; // The data from navigation

  const BudgetSuccessScreen({super.key, required this.extra});

  @override
  State<BudgetSuccessScreen> createState() => _BudgetSuccessScreenState();
}

class _BudgetSuccessScreenState extends State<BudgetSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // Initialize confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Start confetti after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _confettiController.play();
      }
    });

    // Auto-navigate to budget display after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _navigateToBudgetDisplay();
      }
    });
  }

  void _navigateToBudgetDisplay() {
    // Update the extra data to prevent redirecting back to success screen
    final updatedExtra = Map<String, dynamic>.from(widget.extra);
    updatedExtra['isFirstBudget'] = false; // Set to false to prevent loop

    // Navigate to the actual budget display screen
    context.pushReplacement('/budget-display', extra: updatedExtra);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light gray background
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main success message
                    Text(
                      'You are all set',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20.h),

                    // Subtitle
                    Text(
                      'Good job, You just created\nyour first budget!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 50.h),

                    SizedBox(
                      width: 333,
                      height: 320,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Shield image
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              'assets/images/success.png',
                              width: 333,
                              height: 292,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Shadow using ClipOval
                          Positioned(
                            bottom: 6,
                            left: (333 - 140) / 2, // centers shadow
                            child: ClipOval(
                              child: Container(
                                width: 140,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                    0.15,
                                  ), // shadow tone
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 35,
                                      spreadRadius: 6,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF3B82F6), // Blue
                Color(0xFF8B5CF6), // Purple
                Color(0xFFEC4899), // Pink
                Color(0xFFF59E0B), // Amber
                Color(0xFF10B981), // Emerald
                Color(0xFFEF4444), // Red
                Color(0xFF6366F1), // Indigo
                Color(0xFF14B8A6), // Teal
              ],
              createParticlePath: _drawStar,
              emissionFrequency: 0.05,
              numberOfParticles: 60,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // Custom star-shaped particles
  Path _drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}
