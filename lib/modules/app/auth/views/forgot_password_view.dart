import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 44.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.0),
            Text(
              'Forgot password',
              style: AppStyle.titleBold,
              textAlign: TextAlign.right,
            ),
            Text(
              'Please enter your email address to receive the code.',
              style: AppStyle.smallContentRegular,
            ),
            SizedBox(height: 30.0),
            InputField(
              hintText: 'Enter your email',
              labelText: 'Email',
              prefixIcon: AppAsset.mail_01,
            ),
            Spacer(),

            CustomButton(btnText: 'Confirm'),
          ],
        ),
      ),
    );
  }
}

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ).copyWith(top: MediaQuery.of(context).padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(),
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              AppAsset.arrowNarrowLeft,
              color: AppColor.black500,
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 56.0);
}
