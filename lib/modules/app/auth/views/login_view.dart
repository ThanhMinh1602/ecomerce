import 'package:ecomerce/core/components/animation/custom_animated_visibility.dart';
import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/auth_logo.dart';
import 'package:ecomerce/modules/app/auth/widgets/input_field.dart';
import 'package:ecomerce/modules/app/auth/widgets/or_continue_with.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double currentHeight = constraints.maxHeight;
              bool isCrowded = currentHeight < 580;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: IntrinsicHeight(
                      child: Form(
                        key: controller.formKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            CustomAnimatedVisibility(
                              visible: !isCrowded,
                              child: SizedBox(
                                width: double.infinity,
                                key: const ValueKey('logo'),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    AuthLogo(),
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),

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
                            _buildForgotPassword(),

                            Expanded(
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
                            ),

                            const SizedBox(height: 20.0),
                            Obx(() {
                              return CustomButton(
                                btnText: 'Login',
                                // Nếu true -> truyền hàm login. Nếu false -> truyền null (disable nút)
                                onPressed: controller.isFormValid.value
                                    ? () => controller.login()
                                    : null,
                              );
                            }),

                            Padding(
                              key: const ValueKey('signup'),
                              padding: const EdgeInsets.only(
                                top: 16.0,
                                bottom: 20.0,
                              ),
                              child: _buildSignUpRow(),
                            ),

                            if (isCrowded) const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() => Align(
    alignment: Alignment.centerRight,
    child: InkWell(
      onTap: () => controller.onTapSignup(),
      child: Text(
        'Forgot password?',
        style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500),
      ),
    ),
  );

  Widget _buildSignUpRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Don’t have account? ', style: AppStyle.smallContentRegular),
      GestureDetector(
        onTap: () => controller.onTapSignup(),
        child: Text(
          'Sign up',
          style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500),
        ),
      ),
    ],
  );
}
