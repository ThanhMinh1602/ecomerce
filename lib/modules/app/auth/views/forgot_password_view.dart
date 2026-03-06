import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/modules/app/auth/controllers/forgot_password_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/animated_auth_header.dart';
import 'package:ecomerce/modules/app/auth/widgets/auth_layout_wrapper.dart';
import 'package:ecomerce/core/components/text_field/input_field.dart';
import 'package:ecomerce/modules/app/auth/widgets/submit_forgot_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayoutWrapper(
      appBar: const SmallAppBar(),
      isLoading: controller.isLoading,
      formKey: controller.formKey,
      crowdedThreshold: 400, // Ngưỡng của Forgot Password
      builder: (context, isCrowded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            AnimatedAuthHeader(
              isCrowded: isCrowded,
              title: 'Forgot password',
              subtitle: 'Please enter your email address to receive the code.',
            ),

            InputField(
              key: const ValueKey('email_field'),
              controller: controller.emailController,
              validator: ValidatorUtil.validateEmail,
              hintText: 'Enter your email',
              labelText: 'Email',
              prefixIcon: AppAsset.mail_01,
            ),

            const Spacer(),
            const SizedBox(height: 20.0),

            const SubmitForgotButton(),

            const SizedBox(height: 30.0),
          ],
        );
      },
    );
  }
}