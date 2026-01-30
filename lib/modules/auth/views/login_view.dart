import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/auth/widgets/auth_logo.dart';
import 'package:ecomerce/modules/auth/widgets/input_field.dart';
import 'package:ecomerce/modules/auth/widgets/or_continue_with.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthLogo(),
            SizedBox(height: 20.0),
            InputField(
              hintText: 'Enter your email',
              labelText: 'Email',
              prefixIcon: AppAsset.mail_01,
            ),
            SizedBox(height: 20.0),
            InputField(
              hintText: 'Enter your password',
              labelText: 'Password',
              prefixIcon: AppAsset.lock_03,
              isPassword: true,
            ),
            SizedBox(height: 6.0),
            _buildForgotPassword(),
            SizedBox(height: 60.0),
            OrContinueWith(),
            SizedBox(height: 38.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16.0,
              children: [
                SvgPicture.asset(AppAsset.facebook),
                SvgPicture.asset(AppAsset.apple),
                SvgPicture.asset(AppAsset.google),
              ],
            ),
            Spacer(),
            CustomButton(
              btnText: 'Login',
              onPressed: () {
                Get.toNamed(AppRouter.dashboard);
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have account? ',
                  style: AppStyle.smallContentRegular.copyWith(
                    color: AppColor.black200,
                  ),
                ),
                Text(
                  'Sign up',
                  style: AppStyle.smallContentBold.copyWith(
                    color: AppColor.orange500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.0),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => Get.toNamed(Get.currentRoute + AppRouter.forgotPassword),
        child: Text(
          'Forgot password?',
          style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500),
        ),
      ),
    );
  }
}
