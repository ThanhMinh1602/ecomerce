import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/modules/app/auth/widgets/or_continue_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        key: const ValueKey('social'),
        children: [
          const SizedBox(height: 30.0),
          const OrContinueWith(),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              SvgPicture.asset(AppAsset.facebook),
              SvgPicture.asset(AppAsset.apple),
              SvgPicture.asset(AppAsset.google),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}