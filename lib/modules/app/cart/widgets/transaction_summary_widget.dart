import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class TransactionSummaryWidget extends StatelessWidget {
  final double totalPrice;
  final double shippingFee;
  final double discount;

  const TransactionSummaryWidget({
    super.key,
    required this.totalPrice,
    required this.shippingFee,
    required this.discount,
  });

  double get finalTotal => (totalPrice + shippingFee) - discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transaction summary',
            style: AppStyle.smallContentBold.copyWith(fontSize: 16.0),
          ),
          const SizedBox(height: 20.0),

          _buildSummaryRow('Total Price', totalPrice.formatPrice()),
          const SizedBox(height: 12.0),

          _buildSummaryRow('Shipping', shippingFee.formatPrice()),
          const SizedBox(height: 12.0),

          _buildSummaryRow('Discount', '-${discount.formatPrice()}'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: AppColor.black100, height: 1, thickness: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppStyle.smallContentBold.copyWith(
                  fontSize: 16.0,
                  color: AppColor.black500,
                ),
              ),
              Text(
                finalTotal.formatPrice(),
                style: AppStyle.smallContentBold.copyWith(
                  fontSize: 16.0,
                  color: AppColor.black500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          CustomButton(btnText: 'Buy', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494),
        ),
        Text(
          value,
          style: AppStyle.smallContentBold.copyWith(color: AppColor.k949494),
        ),
      ],
    );
  }
}
