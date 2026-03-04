import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/widgets/vertical_product_widget.dart';
import 'package:flutter/material.dart';

class HorizontalProductListSection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final bool isLoading;

  const HorizontalProductListSection({
    super.key,
    required this.title,
    required this.products,
    this.isLoading = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyle.smallContentBold),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 258,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
              ? const Center(child: Text("Chưa có sản phẩm nào"))
              : ListView.separated(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return VerticalProductWidget(product: products[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 16.0),
          ),
        ),
      ],
    );
  }
}