import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';
import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';

class VouchersOffersView extends StatelessWidget {
  const VouchersOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SmallAppBar(title: 'Vouchers & Offers'),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: 4, // Giả lập 4 voucher
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildVoucherCard(
            title: index % 2 == 0 ? 'Free Shipping' : '20% OFF',
            desc: 'Valid for orders over \$50.00',
            code: index % 2 == 0 ? 'FREESHIP' : 'SUMMER20',
          );
        },
      ),
    );
  }

  Widget _buildVoucherCard({required String title, required String desc, required String code}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColor.orange500.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColor.orange500.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Icon Voucher màu cam
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColor.orange500.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer, color: AppColor.orange500),
          ),
          const SizedBox(width: 16),

          // Chi tiết Voucher
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.smallContentBold),
                const SizedBox(height: 4),
                Text(desc, style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494, fontSize: 12.0)),
              ],
            ),
          ),

          // Nút Copy hoặc Use
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.orange500,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            child: Text('Use', style: AppStyle.smallContentBold.copyWith(color: Colors.white, fontSize: 13.0)),
          ),
        ],
      ),
    );
  }
}