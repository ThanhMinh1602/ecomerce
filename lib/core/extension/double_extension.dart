import 'package:intl/intl.dart';

extension DoubleCurrencyExtension on double? {
  String formatPrice({String locale = 'en_US', String symbol = '\$'}) {
    if (this == null) return '${symbol}0.00';

    final format = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    return format.format(this);
  }

  String formatPriceShort({String symbol = '\$'}) {
    if (this == null) return '${symbol}0';
    final format = NumberFormat.currency(symbol: symbol, decimalDigits: 0);
    return format.format(this);
  }
}
