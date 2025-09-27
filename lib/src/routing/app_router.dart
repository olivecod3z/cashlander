import 'package:cash_lander2/src/features/authentication/models/income_model.dart';
import 'package:cash_lander2/src/features/authentication/screens/add_expense_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/budget_display_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/budget_success_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/budget_category.dart';
import 'package:cash_lander2/src/features/authentication/screens/dashboard.dart';
import 'package:cash_lander2/src/features/authentication/screens/income_category.dart';
import 'package:cash_lander2/src/features/authentication/screens/insight_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/login_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/main_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/onboarding_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/otp_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/profile_created.dart';
import 'package:cash_lander2/src/features/authentication/screens/set_budget.dart';
import 'package:cash_lander2/src/features/authentication/screens/set_income.dart';
import 'package:cash_lander2/src/features/authentication/screens/signupii.dart';
import 'package:cash_lander2/src/features/authentication/screens/username.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Changed to dashboard as default

  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final path = state.matchedLocation;

    // Define route categories
    final publicPages = ['/onboarding']; // Pages anyone can access
    final authPages = [
      '/signup',
      '/login',
    ]; // Auth-required pages for non-users
    final emailVerificationPage = '/email-verification';
    final profileSetupPages = ['/username', '/profile'];
    final protectedPages = [
      '/',
      '/insights',
      '/addcategory',
      '/set-budget',
      '/add-expense',
      '/budget-display',
      '/budget-success',
      '/incomelist',
    ];

    print(
      'Redirect check - Path: $path, User: ${user?.uid}, EmailVerified: ${user?.emailVerified}',
    );

    // Allow public pages (like onboarding) for everyone
    if (publicPages.contains(path)) {
      return null; // Always allow onboarding
    }

    // No user authenticated
    if (user == null) {
      if (authPages.contains(path)) {
        return null; // Allow access to signup/login pages
      }
      // For protected pages, redirect to onboarding first (better UX)
      if (protectedPages.contains(path)) {
        return '/onboarding';
      }
      return null; // Allow other pages
    }

    // User exists but email not verified
    if (user != null && !user.emailVerified) {
      if (path == emailVerificationPage) {
        return null; // Allow email verification page
      }
      return '/email-verification'; // Redirect to email verification
    }

    // User exists and email is verified - check profile completion
    if (user != null && user.emailVerified) {
      try {
        // Check if user has completed profile setup
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        final hasUsername =
            userDoc.exists &&
            userDoc.data()?['username'] != null &&
            userDoc.data()!['username'].toString().trim().isNotEmpty;

        final profileComplete =
            hasUsername && userDoc.data()?['profileCompleted'] == true;

        print('Has username: $hasUsername, Profile complete: $profileComplete');

        if (profileComplete) {
          // Full profile is complete - full access granted
          if (publicPages.contains(path) ||
              authPages.contains(path) ||
              path == emailVerificationPage ||
              profileSetupPages.contains(path)) {
            return '/'; // Redirect to dashboard
          }
          // Allow access to all protected pages
          return null;
        } else if (hasUsername && path != '/profile') {
          // Has username but hasn't seen profile created screen
          if (publicPages.contains(path) ||
              authPages.contains(path) ||
              path == emailVerificationPage) {
            return '/profile'; // Show profile created screen
          }
          if (protectedPages.contains(path)) {
            return '/profile'; // Block protected pages until profile flow complete
          }
          return null; // Allow profile page
        } else if (!hasUsername) {
          // Profile incomplete - needs to complete setup
          if (publicPages.contains(path) ||
              authPages.contains(path) ||
              path == emailVerificationPage) {
            return '/username'; // Redirect to profile setup
          }
          if (protectedPages.contains(path)) {
            return '/username'; // Block protected pages until profile complete
          }
          if (profileSetupPages.contains(path)) {
            return null; // Allow profile setup pages
          }
        }
      } catch (e) {
        print('Error checking profile completion: $e');
        // On error, default to profile setup for safety
        if (publicPages.contains(path) ||
            authPages.contains(path) ||
            path == emailVerificationPage) {
          return '/username';
        }
        if (protectedPages.contains(path)) {
          return '/username';
        }
      }
    }

    return null; // No redirect needed
  },

  routes: [
    // Public routes
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),

    // Authentication routes
    GoRoute(path: '/signup', builder: (context, state) => CreateAccount()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),

    // Email verification route
    GoRoute(
      path: '/email-verification',
      builder: (context, state) => EmailVerificationScreen(),
    ),

    // Profile setup routes
    GoRoute(path: '/username', builder: (context, state) => UserNamePage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileCreated()),

    // Budget creation routes
    GoRoute(
      path: '/addcategory',
      builder: (context, state) => CategoryScreen(),
    ),
    GoRoute(
      path: '/incomelist',
      builder: (context, state) => IncomeListScreen(),
    ),
    GoRoute(
      path: '/set-budget',
      builder: (context, state) {
        final category = state.extra as BudgetCategory;
        return SetBudgetScreen(category: category);
      },
    ),
    GoRoute(
      path: '/set-income',
      builder: (context, state) {
        final category = state.extra as IncomeCategory;
        return SetIncomeScreen(category: category);
      },
    ),

    // Expense routes
    GoRoute(
      path: '/add-expense',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return AddExpenseScreen(
          category: data['category'] as BudgetCategory,
          budgetAmount: data['budgetAmount'] as double,
          currentSpentAmount: data['spentAmount'] as double,
        );
      },
    ),

    // Budget display routes
    GoRoute(
      path: '/budget-success',
      builder: (context, state) {
        if (state.extra == null) {
          return const Scaffold(
            body: Center(child: Text('Error: No budget data received')),
          );
        }
        final data = state.extra as Map<String, dynamic>;
        return BudgetSuccessScreen(extra: data);
      },
    ),
    GoRoute(
      path: '/budget-display',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;

        // Handle null state
        if (data == null) {
          // Navigate to empty budget display (showing income view by default)
          return const BudgetDisplayScreen(
            category: null,
            budgetAmount: 0.0,
            spentAmount: 0.0,
            isIncome: false,
          );
        }

        // Handle first budget creation flow
        final isFirstBudget = data['isFirstBudget'] ?? false;
        if (isFirstBudget) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(
              context,
            ).pushReplacement('/budget-success', extra: data);
          });
        }

        return BudgetDisplayScreen(
          category: data['category'] as BudgetCategory?, // Make it nullable
          budgetAmount: data['budgetAmount'] as double? ?? 0.0,
          spentAmount: data['spentAmount'] as double? ?? 0.0,
          isIncome: data['isIncome'] as bool? ?? false,
        );
      },
    ),

    // Main app with bottom navigation
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => DashBoard(),
        ),
        GoRoute(
          path: '/insights',
          name: 'insights',
          builder: (context, state) => InsightScreen(),
        ),
      ],
    ),
  ],
);

// Helper class to refresh router on auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
