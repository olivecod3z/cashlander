import 'package:cash_lander2/src/common_widgets/budget_cate_logo.dart';
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/controllers/budget_display_controller.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
import 'package:cash_lander2/src/features/authentication/models/income_model.dart';
import 'package:cash_lander2/src/services/budget_storage_service.dart';
import 'package:cash_lander2/src/services/income_storage_service.dart';
import 'package:cash_lander2/widgets/toggle.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:math';
import 'package:cash_lander2/src/common_widgets/bottom_navbar.dart';

class BudgetDisplayScreen extends StatefulWidget {
  final BudgetCategory? category;
  final double budgetAmount;
  final double spentAmount;
  final bool isIncome;

  const BudgetDisplayScreen({
    super.key,
    this.category,
    this.budgetAmount = 0.0,
    this.spentAmount = 0.0,
    this.isIncome = false,
  });

  @override
  State<BudgetDisplayScreen> createState() => _BudgetDisplayScreenState();
}

class _BudgetDisplayScreenState extends State<BudgetDisplayScreen> {
  late BudgetDisplayController controller;
  late ConfettiController _confettiController;
  bool showContinuingConfetti = false;
  bool isShowingIncome = false;

  @override
  void initState() {
    super.initState();

    isShowingIncome = widget.isIncome;
    controller = Get.put(BudgetDisplayController());

    // Only set category if it exists
    if (widget.category != null) {
      controller.category = widget.category!;
      controller.budgetAmount = widget.budgetAmount.obs;
      controller.spentAmount.value = widget.spentAmount;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final budgetStorage = Get.find<BudgetStorageService>();
        budgetStorage.addUserBudget(
          widget.category!,
          widget.budgetAmount,
          spentAmount: widget.spentAmount,
        );

        showContinuingConfetti = true;
        if (mounted) {
          setState(() {});
          _confettiController.play();
        }

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              showContinuingConfetti = false;
            });
          }
        });
      });
    }

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor2,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 30.h),
                    Center(
                      child: ExpenseIncomeToggle(
                        isOnIncomePage: isShowingIncome,
                        onIncomeSelected: () {
                          setState(() {
                            isShowingIncome = true;
                          });
                        },
                        onExpenseSelected: () {
                          setState(() {
                            isShowingIncome = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Show different grid based on toggle state
                    isShowingIncome ? _buildIncomeGrid() : _buildBudgetGrid(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),

          // Continuing confetti overlay
          if (showContinuingConfetti)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color(0xFF3B82F6),
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                  Color(0xFFF59E0B),
                  Color(0xFF10B981),
                  Color(0xFFEF4444),
                  Color(0xFF6366F1),
                  Color(0xFF14B8A6),
                ],
                createParticlePath: _drawStar,
                emissionFrequency: 0.03,
                numberOfParticles: 30,
                gravity: 0.15,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate based on current view
          if (isShowingIncome) {
            context.push('/incomelist');
          } else {
            context.push('/addcategory');
          }
        },
        backgroundColor: btnColor1,
        child: PhosphorIcon(
          PhosphorIconsBold.plus,
          color: Colors.white,
          size: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavbar(),
    );
  }

  /// Header Row: Back Button and Title
  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            height: 25.h,
            width: 25.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: const Center(
              child: Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
        const Spacer(),
        Text(
          '< This Month >',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  /// Budget Grid (Expenses) using reactive Obx
  Widget _buildBudgetGrid() {
    return Obx(() {
      final budgetStorage = Get.find<BudgetStorageService>();
      final budgets = budgetStorage.userBudgets;

      if (budgets.isEmpty) {
        return _buildEmptyState(
          'No expense budgets yet',
          'Tap + to create one',
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budgetData = budgets[index];
          return _buildBudgetCard(
            budgetData['category'] as BudgetCategory,
            budgetData['budgetAmount'] as double,
            budgetData['spentAmount'] as double,
          );
        },
      );
    });
  }

  /// Income Grid - Placeholder for now
  /// Income Grid - now properly reads from IncomeStorageService
  Widget _buildIncomeGrid() {
    return Obx(() {
      final incomeStorage = Get.find<IncomeStorageService>();
      final incomes = incomeStorage.userIncomes;

      if (incomes.isEmpty) {
        return _buildEmptyState('No income sources yet', 'Tap + to add income');
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemCount: incomes.length,
        itemBuilder: (context, index) {
          final incomeData = incomes[index];
          return _buildIncomeCard(
            incomeData['category'] as IncomeCategory,
            incomeData['incomeAmount'] as double,
            incomeData['receivedAmount'] as double,
          );
        },
      );
    });
  }

  /// Empty state widget
  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.wallet,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(
    BudgetCategory category,
    double budgetAmount,
    double spentAmount,
  ) {
    final progressPercentage =
        budgetAmount > 0 ? (spentAmount / budgetAmount).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: () {
        context.push(
          '/add-expense',
          extra: {
            'category': category,
            'budgetAmount': budgetAmount,
            'spentAmount': spentAmount,
          },
        );
      },
      child: Container(
        width: 163.w,
        height: 250.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color.fromARGB(68, 200, 199, 199),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BudgetCategoryLogo(
                        icon: category.icon,
                        color: category.color,
                        size: 35.w,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 18.h,
                        alignment: Alignment.center,
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Monthly',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF45413C),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CircularPercentIndicator(
                        radius: 35.0.w,
                        lineWidth: 3.5.w,
                        percent: progressPercentage,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 14.h,
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\u20A6',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: budgetAmount.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontFamily: 'Campton',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 10.h,
                              alignment: Alignment.center,
                              child: Text(
                                '${(progressPercentage * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w500,
                                  color: category.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        progressColor: category.color,
                        backgroundColor: Colors.grey[200]!,
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animationDuration: 1200,
                        curve: Curves.easeInOutCubic,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
            Positioned(
              top: -4.h,
              right: -4.w,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert, size: 18, color: Colors.black),
                onSelected: (value) {
                  switch (value) {
                    case 'details':
                      break;
                    case 'edit':
                      break;
                    case 'delete':
                      break;
                  }
                },
                itemBuilder:
                    (context) => const [
                      PopupMenuItem(
                        value: 'details',
                        child: Text('View details'),
                      ),
                      PopupMenuItem(value: 'edit', child: Text('Edit budget')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeCard(
    IncomeCategory category,
    double incomeAmount,
    double receivedAmount,
  ) {
    final progressPercentage =
        incomeAmount > 0
            ? (receivedAmount / incomeAmount).clamp(0.0, 1.0)
            : 0.0;

    return GestureDetector(
      onTap: () {
        // Navigate to income detail or edit screen
        // context.push('/income-detail', extra: {...});
      },
      child: Container(
        width: 163.w,
        height: 250.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color.fromARGB(68, 200, 199, 199),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 45.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: category.incColor,
                        ),
                        child: Center(
                          child: Icon(
                            category.incIcon,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 18.h,
                        alignment: Alignment.center,
                        child: Text(
                          category.incName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Monthly',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF45413C),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CircularPercentIndicator(
                        radius: 35.0.w,
                        lineWidth: 3.5.w,
                        percent: progressPercentage,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 14.h,
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\u20A6',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: incomeAmount.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontFamily: 'Campton',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 10.h,
                              alignment: Alignment.center,
                              child: Text(
                                '${(progressPercentage * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w500,
                                  color: category.incColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        progressColor: category.incColor,
                        backgroundColor: Colors.grey[200]!,
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animationDuration: 1200,
                        curve: Curves.easeInOutCubic,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
            Positioned(
              top: -4.h,
              right: -4.w,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert, size: 18, color: Colors.black),
                onSelected: (value) {
                  switch (value) {
                    case 'details':
                      break;
                    case 'edit':
                      break;
                    case 'delete':
                      final incomeStorage = Get.find<IncomeStorageService>();
                      incomeStorage.removeIncome(category.incName);
                      break;
                  }
                },
                itemBuilder:
                    (context) => const [
                      PopupMenuItem(
                        value: 'details',
                        child: Text('View details'),
                      ),
                      PopupMenuItem(value: 'edit', child: Text('Edit income')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    Get.delete<BudgetDisplayController>();
    super.dispose();
  }
}
