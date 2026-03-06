import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/modules/app/auth/controllers/signup_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/animated_auth_header.dart';
import 'package:ecomerce/modules/app/auth/widgets/auth_layout_wrapper.dart';
import 'package:ecomerce/core/components/text_field/input_field.dart';
import 'package:ecomerce/modules/app/auth/widgets/submit_signup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayoutWrapper(
      appBar: const SmallAppBar(),
      isLoading: controller.isLoading,
      formKey: controller.signupFormKey,
      crowdedThreshold: 500, // Ngưỡng của Signup
      builder: (context, isCrowded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),

            AnimatedAuthHeader(
              isCrowded: isCrowded,
              title: 'Create your account',
              subtitle: 'Enter your details to register.',
            ),

            InputField(
              key: const ValueKey('name_field'),
              controller: controller.nameController,
              validator: (value) => ValidatorUtil.validateEmpty(value, 'User Name'),
              hintText: 'Scott',
              labelText: 'User Name',
              prefixIcon: AppAsset.mail_01,
            ),
            const SizedBox(height: 20.0),

            InputField(
              key: const ValueKey('email_field'),
              controller: controller.emailController,
              validator: ValidatorUtil.validateEmail,
              hintText: 'scott@gmail.com',
              labelText: 'Email',
              prefixIcon: AppAsset.mail_01,
            ),
            const SizedBox(height: 20.0),

            InputField(
              key: const ValueKey('password_field'),
              controller: controller.passwordController,
              validator: ValidatorUtil.validatePassword,
              hintText: '**********',
              labelText: 'Password',
              prefixIcon: AppAsset.lock_03,
              isPassword: true,
            ),
            const SizedBox(height: 20.0),

            InputField(
              key: const ValueKey('confirm_password_field'),
              controller: controller.confirmPasswordController,
              validator: (value) => ValidatorUtil.validateMatchPassword(
                value,
                controller.passwordController.text,
              ),
              hintText: '**********',
              labelText: 'Confirm Password',
              prefixIcon: AppAsset.lock_03,
              isPassword: true,
            ),

            const Spacer(),
            const SizedBox(height: 20.0),

            const SubmitSignupButton(),

            const SizedBox(height: 30.0),
          ],
        );
      },
    );
  }
}