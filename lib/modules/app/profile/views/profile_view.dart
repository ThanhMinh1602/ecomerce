import 'package:ecomerce/modules/app/profile/widgets/my_orders_card.dart';
import 'package:ecomerce/modules/app/profile/widgets/profile_header_info.dart';
import 'package:ecomerce/modules/app/profile/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_asset.dart';


class ProfileView extends StatelessWidget {
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

                    const ProfileHeaderInfo(
                        name: 'Sooti',
                        email: 'nhattrieuk4@gmail.com',
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
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    iconPath: AppAsset.star01,
                    title: 'Vouchers & Offers',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    iconPath: AppAsset.lock_03,
                    title: 'Privacy & Settings',
                    onTap: () {},
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