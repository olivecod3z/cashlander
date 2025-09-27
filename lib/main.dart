import 'package:cash_lander2/src/routing/app_router.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';
import 'package:cash_lander2/src/services/firebase_service.dart';
import 'package:cash_lander2/src/services/income_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Get.put(FirebaseService());
  // Initialize both storage services
  Get.put(BudgetStorageService(), permanent: true);
  Get.put(IncomeStorageService(), permanent: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Campton'),
        );
      },
    );
  }
}
