import 'package:ecomerce/core/constants/app_asset.dart';

enum PaymentMethodType {
  
  creditCard('credit_card', 'Creditcard', [AppAsset.masterCard, AppAsset.visaCard]),
  applePay('apple_pay', 'Apple Pay', [AppAsset.applePay]),
  paypal('paypal', 'PayPal', [AppAsset.paypal]),
  cod('cod', 'Payment upon delivery',[ AppAsset.cashOnDelivery]);
  final String code;
  final String title;
  final List<String> iconPath;
  const PaymentMethodType(this.code, this.title, this.iconPath);

  static PaymentMethodType fromString(String code) {
    return PaymentMethodType.values.firstWhere(
          (e) => e.code == code,
      orElse: () => PaymentMethodType.cod,
    );
  }
}