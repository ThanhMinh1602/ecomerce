import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/modules/app/cart/widgets/payment_method_item_widget.dart';
import 'package:flutter/material.dart';
// Nhớ import PaymentMethodType và PaymentMethodItemWidget

class PaymentMethodSectionWidget extends StatelessWidget {
  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onChanged;

  const PaymentMethodSectionWidget({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppStyle.smallContentBold),
        const SizedBox(height: 8),
        ...PaymentMethodType.values.map((method) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: PaymentMethodItemWidget(
              isSelected: selectedMethod == method,
              title: method.title,
              icons: method.iconPath,
              onTap: () => onChanged(method),
            ),
          );
        }),
      ],
    );
  }
}
