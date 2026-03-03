import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SmallAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            InkWell(
              child: SvgPicture.asset(AppAsset.chevronLeft),
              onTap: () => Get.back(),
            ),
            const SizedBox(width: 19.0),
            Text('Search', style: AppStyle.contentBold),
            Spacer(),
            _buildCardIcon(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildCardIcon() {
    return FittedBox(
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsetsGeometry.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: AppColor.black500),
        ),
        child: Stack(
          children: [
            SvgPicture.asset(AppAsset.shoppingCar02),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: CircleAvatar(
                radius: 6.0,
                backgroundColor: AppColor.orange500,
                child: Center(child: FittedBox(child: Text('1',style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.w700, color: AppColor.white),))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
