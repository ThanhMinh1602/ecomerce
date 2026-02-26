import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAsset.logo),
        const SizedBox(height: 49),
        Text('Welcome Back', style: AppStyle.titleBold),
        Text(
          'Please enter your details to sign in',
          style: AppStyle.smallContentRegular,
        ),
      ],
    );
  }
}
