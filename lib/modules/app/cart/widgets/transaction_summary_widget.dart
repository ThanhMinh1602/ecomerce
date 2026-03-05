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

  // Tự động tính tổng tiền cuối cùng
  double get finalTotal => (totalPrice + shippingFee) - discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Màu xám rất nhạt làm nền
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tiêu đề
          Text(
            'Transaction summary', // Đã sửa lỗi sai chính tả trong hình (sumary -> summary)
            style: AppStyle.smallContentBold.copyWith(fontSize: 16.0),
          ),
          const SizedBox(height: 20.0),

          // Các dòng chi tiết
          _buildSummaryRow('Total Price', totalPrice.formatPrice()),
          const SizedBox(height: 12.0),

          _buildSummaryRow('Shipping', shippingFee.formatPrice()),
          const SizedBox(height: 12.0),

          // Dòng discount có thêm dấu trừ "-" phía trước
          _buildSummaryRow('Discount', '-${discount.formatPrice()}'),

          // Đường kẻ ngang (Divider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: AppColor.black100, height: 1, thickness: 1),
          ),

          // Tổng kết cuối cùng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppStyle.smallContentBold.copyWith(fontSize: 16.0, color: AppColor.black500),
              ),
              Text(
                finalTotal.formatPrice(),
                style: AppStyle.smallContentBold.copyWith(fontSize: 16.0, color: AppColor.black500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Hàm phụ trợ tạo các dòng (Row) thông tin
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