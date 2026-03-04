import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/animated_auth_logo.dart';
import 'package:ecomerce/modules/app/auth/widgets/auth_layout_wrapper.dart';
import 'package:ecomerce/modules/app/auth/widgets/forgot_password_button.dart';
import 'package:ecomerce/modules/app/auth/widgets/input_field.dart';
import 'package:ecomerce/modules/app/auth/widgets/sign_up_row.dart';
import 'package:ecomerce/modules/app/auth/widgets/social_login_section.dart';
import 'package:ecomerce/modules/app/auth/widgets/submit_login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayoutWrapper(
      isLoading: controller.isLoading,
      formKey: controller.formKey,
      crowdedThreshold: 580, // Ngưỡng của Login
      builder: (context, isCrowded) {
        return Column(
          children: [
            const SizedBox(height: 20.0),
            AnimatedAuthLogo(isCrowded: isCrowded),

            InputField(
              key: const ValueKey('email_field'),
              hintText: 'Enter your email',
              labelText: 'Email',
              prefixIcon: AppAsset.mail_01,
              validator: ValidatorUtil.validateEmail,
              controller: controller.emailController,
            ),
            const SizedBox(height: 20.0),

            InputField(
              key: const ValueKey('pass_field'),
              hintText: 'Enter your password',
              labelText: 'Password',
              prefixIcon: AppAsset.lock_03,
              isPassword: true,
              validator: ValidatorUtil.validatePassword,
              controller: controller.passwordController,
            ),
            const SizedBox(height: 10.0),

            const ForgotPasswordButton(),
            const SocialLoginSection(),
            const SizedBox(height: 20.0),

            const SubmitLoginButton(),
            const SignUpRow(),

            if (isCrowded) const SizedBox(height: 20.0),
          ],
        );
      },
    );
  }
}