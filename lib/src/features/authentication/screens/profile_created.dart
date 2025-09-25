import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/constants/images.dart';
import 'package:cash_lander2/src/constants/text.dart';
import 'package:cash_lander2/src/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileCreated extends StatefulWidget {
  const ProfileCreated({super.key});

  @override
  State<ProfileCreated> createState() => _ProfileCreatedState();
}

class _ProfileCreatedState extends State<ProfileCreated>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<double> _imageAnimation;
  late Animation<double> _text1Animation;
  late Animation<double> _text2Animation;
  late Animation<double> _buttonAnimation;

  late Animation<Offset> _imageSlideAnimation;
  late Animation<Offset> _text1SlideAnimation;
  late Animation<Offset> _text2SlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  bool _isNavigating = false; // Add loading state

  @override
  void initState() {
    super.initState();

    // Animation Controllers
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Fade Animations
    _imageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _text1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _text2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    // Slide Animations
    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _text1SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _text2SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    // Start animations with delays
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _imageController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(15.w, 60.h, 15.w, 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ANIMATED PROFILE CREATED IMAGE
            SlideTransition(
              position: _imageSlideAnimation,
              child: FadeTransition(
                opacity: _imageAnimation,
                child: ScaleTransition(
                  scale: _imageAnimation,
                  child: Image.asset(
                    profileImage,
                    height: 200.h,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ANIMATED PROFILE TEXT 1
            SlideTransition(
              position: _text1SlideAnimation,
              child: FadeTransition(
                opacity: _text1Animation,
                child: Text(
                  profileText1,
                  style: TextStyle(
                    letterSpacing: -0.4.sp,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // ANIMATED TEXT 2
            SlideTransition(
              position: _text2SlideAnimation,
              child: FadeTransition(
                opacity: _text2Animation,
                child: Text(
                  profileText2,
                  style: TextStyle(
                    height: 1.4.h,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: subColor,
                  ),
                ),
              ),
            ),
            Spacer(),

            // ANIMATED CONTINUE BUTTON
            SlideTransition(
              position: _buttonSlideAnimation,
              child: FadeTransition(
                opacity: _buttonAnimation,
                child: ScaleTransition(
                  scale: _buttonAnimation,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      0,
                      20.w,
                      40.h,
                    ), // Added bottom margin
                    child: AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: btnColor1,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow:
                                _buttonController.isCompleted
                                    ? [
                                      BoxShadow(
                                        color: btnColor1.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                // Add button press animation
                                _animateButtonPress();

                                // Mark profile as completed in Firebase
                                try {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .update({
                                          'profileCompleted': true,
                                          'updatedAt':
                                              FieldValue.serverTimestamp(),
                                        });
                                  }
                                } catch (e) {
                                  print('Error marking profile complete: $e');
                                }

                                // Navigate to dashboard
                                context.go('/');
                              },
                              borderRadius: BorderRadius.circular(24.r),
                              child: Center(
                                child:
                                    _isNavigating
                                        ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Text(
                                          'Continue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button press animation
  void _animateButtonPress() {
    _buttonController.reverse().then((_) {
      _buttonController.forward();
    });
  }
}
