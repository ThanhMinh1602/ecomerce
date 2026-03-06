import 'package:ecomerce/modules/app/profile/controllers/profile_controller.dart';
import 'package:ecomerce/modules/app/profile/widgets/my_orders_card.dart';
import 'package:ecomerce/modules/app/profile/widgets/profile_header_info.dart';
import 'package:ecomerce/modules/app/profile/widgets/profile_menu_item.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_asset.dart';


class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              alignment: Alignment.topCenter,
              children: [

                Container(
                  height: 310,
                  decoration: BoxDecoration(
                    color: AppColor.orange500,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(MediaQuery
                          .of(context)
                          .size
                          .width, 90),
                    ),
                  ),
                ),


                Column(
                  children: [

                    SizedBox(height: MediaQuery
                        .of(context)
                        .padding
                        .top + 20),

                     ProfileHeaderInfo(
                        name: controller.userName,
                        email: controller.userEmail,
                      avatarUrl: 'https://img.freepik.com/free-photo/handsome-businessman-suit-glasses-cross-arms-chest-look_176420-21750.jpg',

                    ),

                    const SizedBox(height: 32),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: MyOrdersCard(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  ProfileMenuItem(
                    iconPath: AppAsset.user03,
                    title: 'My Details',
                    onTap: controller.onTapMyDetail,
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    iconPath: AppAsset.star01,
                    title: 'Vouchers & Offers',
                    onTap: () {
                      Get.toNamed(AppRouter.vouchersOffers);
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    iconPath: AppAsset.lock_03,
                    title: 'My Order',
                    onTap: () {
                      Get.toNamed(AppRouter.myOrders);
                    },
                  ),


                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}