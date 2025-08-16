// Updated app_router.dart - Matches your existing BudgetSuccessScreen
import 'package:cash_lander2/src/features/authentication/screens/budget_display_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/budget_success_screen.dart'; // ADD THIS IMPORT
import 'package:cash_lander2/src/features/authentication/screens/expense_category.dart';
import 'package:cash_lander2/src/features/authentication/screens/dashboard.dart';
import 'package:cash_lander2/src/features/authentication/screens/income_category.dart';
import 'package:cash_lander2/src/features/authentication/screens/login_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/main_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/onboarding_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/otp_screen.dart';
import 'package:cash_lander2/src/features/authentication/screens/profile_created.dart';
import 'package:cash_lander2/src/features/authentication/screens/set_budget.dart';
import 'package:cash_lander2/src/features/authentication/screens/signupii.dart';
import 'package:cash_lander2/src/features/authentication/screens/username.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // Authentication routes (no bottom nav)
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(path: '/signup', builder: (context, state) => CreateAccount()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/otp', builder: (context, state) => OtpScreen()),
    GoRoute(path: '/username', builder: (context, state) => UserNamePage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileCreated()),

    //Create budget paths
    GoRoute(
      path: '/addcategory',
      builder: (context, state) => CategoryScreen(),
    ),
    GoRoute(path: '/incomelist', builder: (context, state) => IncomeCategory()),

    GoRoute(
      path: '/set-budget',
      builder: (context, state) {
        final category = state.extra as BudgetCategory;
        return SetBudgetScreen(category: category);
      },
    ),

    // ADD THIS NEW ROUTE - Success screen with confetti
    GoRoute(
      path: '/budget-success',
      builder: (context, state) {
        if (state.extra == null) {
          return const Scaffold(
            body: Center(child: Text('Error: No budget data received')),
          );
        }

        final data = state.extra as Map<String, dynamic>;
        return BudgetSuccessScreen(
          extra: data,
        ); // This matches your constructor
      },
    ),

    GoRoute(
      path: '/budget-display',
      builder: (context, state) {
        // Safe null handling
        if (state.extra == null) {
          return const Scaffold(
            body: Center(child: Text('Error: No budget data received')),
          );
        }

        final data = state.extra as Map<String, dynamic>;

        // Check if this is first budget and redirect to success screen
        final isFirstBudget = data['isFirstBudget'] ?? false;
        if (isFirstBudget) {
          // Use WidgetsBinding to redirect after build completes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(
              context,
            ).pushReplacement('/budget-success', extra: data);
          });
        }

        return BudgetDisplayScreen(
          category: data['category'] as BudgetCategory,
          budgetAmount: data['budgetAmount'] as double,
          spentAmount: data['spentAmount'] as double? ?? 0.0,
        );
      },
    ),

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
        // GoRoute(
        //   path: '/insights',
        //   name: 'insights',
        //   builder: (context, state) => InsightsScreen(),
        // ),
        // GoRoute(
        //   path: '/settings',
        //   name: 'settings',
        //   builder: (context, state) => SettingsScreen(),
        // ),
      ],
    ),
  ],
);
