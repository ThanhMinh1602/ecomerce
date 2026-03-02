import 'package:ecomerce/core/components/animation/custom_animated_visibility.dart';
import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/modules/app/auth/controllers/signup_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: const SmallAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double currentHeight = constraints.maxHeight;
                  bool isCrowded = currentHeight < 500;

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Form(
                          key: controller.signupFormKey,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20.0),

                                CustomAnimatedVisibility(
                                  visible: !isCrowded,
                                  child: Column(
                                    key: const ValueKey('title_texts'),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Create your account',
                                        style: AppStyle.titleBold,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Enter your details to register.',
                                        style: AppStyle.smallContentRegular
                                            .copyWith(color: AppColor.black200),
                                      ),
                                      const SizedBox(height: 40.0),
                                    ],
                                  ),
                                ),

                                InputField(
                                  key: const ValueKey('name_field'),
                                  controller: controller.nameController,
                                  validator: (value) =>
                                      ValidatorUtil.validateEmpty(
                                        value,
                                        'User Name',
                                      ),
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
                                  controller:
                                      controller.confirmPasswordController,
                                  validator: (value) =>
                                      ValidatorUtil.validateMatchPassword(
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

                                Obx(() {
                                  return CustomButton(
                                    btnText: 'Confirm',
                                    onPressed: controller.isFormValid.value
                                        ? controller.signup
                                        : null,
                                  );
                                }),

                                const SizedBox(height: 30.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white.withOpacity(0.7),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.orange500,
                        strokeWidth: 4.0,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
