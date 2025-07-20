import 'package:cash_lander2/src/features/authentication/screens/login_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/onboarding_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/otp_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/profile_created.dart';

import 'package:cash_lander2/src/features/authentication/screens/signupii.dart';
import 'package:cash_lander2/src/features/authentication/screens/username.dart';

import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    //GoRoute(path: '/', builder: (context, state) => OnboardingScreen()),
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => CreateAccount()),
    //GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/otp', builder: (context, state) => OtpScreen()),
    GoRoute(path: '/username', builder: (context, state) => UserNamePage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileCreated()),
  ],
);
