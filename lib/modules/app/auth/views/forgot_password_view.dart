import 'package:ecomerce/core/components/animation/custom_animated_visibility.dart';
import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/components/custom_loading_overlay.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/modules/app/auth/controllers/forgot_password_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: const SmallAppBar(),
        body: SafeArea(
          child: CustomLoadingOverlay(
            isLoading: controller.isLoading,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double currentHeight = constraints.maxHeight;
                bool isCrowded = currentHeight < 400;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: controller.formKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20.0),

                              CustomAnimatedVisibility(
                                visible: !isCrowded,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Forgot password',
                                      style: AppStyle.titleBold,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Please enter your email address to receive the code.',
                                      style: AppStyle.smallContentRegular
                                          .copyWith(color: AppColor.black200),
                                    ),
                                    const SizedBox(height: 40.0),
                                  ],
                                ),
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

                              Obx(() {
                                return CustomButton(
                                  btnText: 'Confirm',
                                  onPressed: controller.isFormValid.value
                                      ? controller.sendResetEmail
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
          ),
        ),
      ),
    );
  }
}
