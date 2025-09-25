//Insight calendar
import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/controllers/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InsightCalendar extends StatelessWidget {
  final CalendarController c = Get.put(CalendarController());

  InsightCalendar({super.key}) {
    c.loadMonthData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int daysInMonth = c.daysInSelectedMonth;
      final int firstWeekday = c.firstWeekdayOfMonth;

      // Debug print (remove after fixing)
      print(
        'month=${c.selectedMonth.value} days=$daysInMonth firstWeekday=$firstWeekday',
      );
      final int leadingEmpty =
          firstWeekday % 7; // Sun(7) -> 0, Mon(1) -> 1, etc.
      final int totalCells = leadingEmpty + daysInMonth;

      print('leadingEmpty=$leadingEmpty totalCells=$totalCells');

      return Container(
        width: 343.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color.fromARGB(68, 200, 199, 199),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _WeekdayLabel('SUN'),
                  _WeekdayLabel('MON'),
                  _WeekdayLabel('TUE'),
                  _WeekdayLabel('WED'),
                  _WeekdayLabel('THU'),
                  _WeekdayLabel('FRI'),
                  _WeekdayLabel('SAT'),
                ],
              ),
              SizedBox(height: 10.h),

              // Grid without height constraints
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: totalCells,
                itemBuilder: (context, index) {
                  if (index < leadingEmpty) {
                    return const SizedBox.shrink();
                  }

                  final day = index - leadingEmpty + 1;
                  final date = DateTime(
                    c.selectedMonth.value.year,
                    c.selectedMonth.value.month,
                    day,
                  );
                  final amount = c.dailySpend[date] ?? 0.0;

                  return _DayCell(
                    date: date,
                    amount: amount,
                    isToday: _isSameDay(date, DateTime.now()),
                    formatter: c.compact,
                    onTap: () => _showDayDetailsModal(context, date, amount),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDayDetailsModal(
    BuildContext context,
    DateTime date,
    double amount,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailsModal(date: date, amount: amount),
    );
  }
}

class DayDetailsModal extends StatelessWidget {
  final DateTime date;
  final double amount;

  const DayDetailsModal({super.key, required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: bgColor3,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 134.w,
            height: 10.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: Color(0xFFCBCBCB),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Column(
              children: [
                Text(
                  DateFormat(' MMMM d, y').format(date),
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                IntrinsicWidth(
                  child: Container(
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: btnColor1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: btnColor1, width: 1.w),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\u20A6', // ₦
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  color: btnColor1,
                                ),
                              ),
                              TextSpan(
                                text: amount.toStringAsFixed(0),
                                style: TextStyle(
                                  fontFamily: 'Campton',
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  color: btnColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content area - you can expand this based on your needs
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Expenses',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: mainTextColor,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Here you would typically show a list of expenses for that day
                  // For now, showing a placeholder
                  if (amount > 0) ...[
                    _ExpenseItem(
                      icon: Icons.restaurant,
                      category: 'Food',
                      amount: amount * 0.6,
                    ),
                    _ExpenseItem(
                      icon: Icons.directions_car,
                      category: 'Transport',
                      amount: amount * 0.4,
                    ),
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.money_off,
                            size: 48.w,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No expenses recorded for this day',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final IconData icon;
  final String category;
  final double amount;

  const _ExpenseItem({
    required this.icon,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),

              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '\u20A6', // ₦
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor1,
                  ),
                ),
                TextSpan(
                  text: amount.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Campton',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final double amount;
  final bool isToday;
  final NumberFormat formatter;
  final VoidCallback? onTap;

  const _DayCell({
    required this.date,
    required this.amount,
    required this.isToday,
    required this.formatter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSpend = amount > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isToday ? Colors.blue : (calendColor ?? Colors.grey.shade100),
          border: Border.all(width: 1.w, color: borderColor),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day number
            Text(
              '${date.day}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),

            // Amount spent in day
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\u20A6',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  NumberFormat.compactCurrency(
                    locale: 'en_NG',
                    symbol: '',
                    decimalDigits: 0,
                  ).format(amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Campton',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
