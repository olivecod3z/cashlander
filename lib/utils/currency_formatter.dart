import 'package:intl/intl.dart';

String formatNaira(dynamic amount, {bool showDecimals = false}) {
  final format = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: showDecimals ? 2 : 0,
  );
  if (amount == null) return '₦0';

  try {
    return format.format(amount);
  } catch (_) {
    return '₦0';
  }
}
