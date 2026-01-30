import 'package:ecomerce/core/components/text_field/custom_text_field.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/home/widgets/home_app_bar_widget.dart';
import 'package:ecomerce/modules/home/widgets/horizontal_product_widget.dart';
import 'package:ecomerce/modules/home/widgets/vertical_product_widget.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final categories = ['Best seller', 'Deals', 'Trending'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 25.0,
        ).copyWith(bottom: 38 + 71 + 16.0),
        children: [
          _buildSearch(),
          SizedBox(height: 20.0),
          _buildBanner(),
          SizedBox(height: 16.0),
          _buildCategory(),
          SizedBox(height: 16.0),
          _buildBestSeller(),
          SizedBox(height: 16.0),
          _buildCombo(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return CustomTextField(
      hintText: 'Enter the item you want to search for.',
      labelText: '',
      suffixIcon: AppAsset.camera,
      prefixIcon: AppAsset.search,
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(
        'https://thietkewebchuyen.com/wp-content/uploads/thiet-ke-banner-website-anh-bia-Facebook-shop-thoi-trang-quan-ao-10.jpg',
      ),
    );
  }

  Widget _buildCategory() {
    return SizedBox(
      height: 35.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            height: 35.0,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: index == 0 ? AppColor.orange500 : AppColor.white,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColor.k949494),
            ),
            child: Text(
              categories[index],
              style: AppStyle.smallContentBold.copyWith(
                color: index == 0 ? AppColor.white : AppColor.black500,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 13.0),
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildBestSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Best seller', style: AppStyle.smallContentBold),
        SizedBox(height: 16.0),
        SizedBox(
          height: 258,
          child: ListView.separated(
            itemCount: ProductModel.dummyProducts.length,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return VerticalProductWidget(
                product: ProductModel.dummyProducts[index],
              );
            },
            separatorBuilder: (_, __) => SizedBox(width: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildCombo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Combo', style: AppStyle.smallContentBold),
        SizedBox(height: 16.0),
        ListView.separated(
          itemCount: ProductModel.dummyProducts.length,
          clipBehavior: Clip.none,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return HorizontalProductWidget(
              product: ProductModel.dummyProducts[index],
            );
          },
          separatorBuilder: (_, __) => SizedBox(height: 16.0),
        ),
      ],
    );
  }
}
