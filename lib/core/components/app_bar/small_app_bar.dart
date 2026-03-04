import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? trailingIcon;
  final int? cartItemCount;
  final VoidCallback? onTrailingTap;

  const SmallAppBar({
    super.key,
    this.title,
    this.trailingIcon,
    this.cartItemCount,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: SvgPicture.asset(AppAsset.chevronLeft),
            ),
            const SizedBox(width: 19.0),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: AppStyle.contentBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const Spacer(),

            if (cartItemCount != null) _buildTrailingIcon(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildTrailingIcon() {
    return InkWell(
      onTap: onTrailingTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.black500),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(trailingIcon ?? AppAsset.shoppingCar02),

            if (cartItemCount! > 0)
              Positioned(
                right: -2.0,
                top: -2.0,
                child: CircleAvatar(
                  radius: 7.0,
                  backgroundColor: AppColor.orange500,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        cartItemCount! > 99 ? '99+' : cartItemCount.toString(),
                        style: const TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
