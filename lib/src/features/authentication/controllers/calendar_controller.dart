import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  // Selected month is always the 1st day of that month
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  final RxMap<DateTime, double> dailySpend = <DateTime, double>{}.obs;

  final NumberFormat compact = NumberFormat.compactCurrency(
    locale: 'en_NG',
    symbol: '₦',
  );

  @override
  void onInit() {
    super.onInit();
    // Initialize selectedMonth to the first day of current month
    final now = DateTime.now();
    selectedMonth.value = DateTime(now.year, now.month, 1);
    loadMonthData();
  }

  // This is called whenever selectedMonth changes
  Future<void> loadMonthData() async {
    print('Loading month data for: ${selectedMonth.value}');

    final start = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month,
      1,
    );
    final end = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
      0, // This gets the last day of the current month
    );

    print('Month range: $start to $end (${end.day} days)');

    // Fill all days with 0 by default
    final tmp = <DateTime, double>{};
    for (int d = 1; d <= end.day; d++) {
      final date = DateTime(start.year, start.month, d);
      tmp[date] = 0.0;
      print('Added day: $date');
    }

    // Fake data for money spent
    tmp[DateTime(start.year, start.month, 2)] = 1500;
    tmp[DateTime(start.year, start.month, 12)] = 3200;
    tmp[DateTime(start.year, start.month, 21)] = 8500;

    print('Final tmp map: $tmp');
    dailySpend.assignAll(tmp);
    print('Daily spend after assignment: $dailySpend');
  }

  void setMonth(DateTime monthStart) {
    selectedMonth.value = DateTime(monthStart.year, monthStart.month, 1);
    loadMonthData();
  }

  void nextMonth() {
    final m = selectedMonth.value;
    setMonth(DateTime(m.year, m.month + 1, 1));
  }

  void prevMonth() {
    final m = selectedMonth.value;
    setMonth(DateTime(m.year, m.month - 1, 1));
  }

  int get daysInSelectedMonth {
    final m = selectedMonth.value;
    final lastDay = DateTime(m.year, m.month + 1, 0).day;
    print('Days in selected month: $lastDay');
    return lastDay;
  }

  // 1=Mon ... 7=Sun (matches DateTime.weekday)
  int get firstWeekdayOfMonth {
    final m = selectedMonth.value;
    final firstDay = DateTime(m.year, m.month, 1);
    final weekday = firstDay.weekday;
    print('First weekday of month: $weekday ($firstDay)');
    return weekday;
  }

  String get monthLabel => DateFormat.yMMMM().format(selectedMonth.value);
}
