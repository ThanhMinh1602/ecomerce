import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/components/text_field/custom_text_field.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import '../controllers/my_detail_view_controller.dart';

class PersonalInfoSection extends GetView<MyDetailViewController> {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text('Personal Information', style: AppStyle.smallContentBold),
        const SizedBox(height: 16),
        CustomTextField(
          key: const ValueKey('name_field'),
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          controller: controller.nameController,
          prefixIcon: AppAsset.user03,
          validator: (value) => ValidatorUtil.validateEmpty(value, 'Full Name'),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          key: const ValueKey('email_field'),
          labelText: 'Email',
          hintText: 'Enter your email',
          controller: controller.emailController,
          prefixIcon: AppAsset.mail_01,
          readOnly: true,
          validator: (value) => ValidatorUtil.validateEmpty(value, 'Email'),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          key: const ValueKey('phone_field'),
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          controller: controller.phoneController,
          prefixIcon: AppAsset.chevronLeft,
          validator: (value) => ValidatorUtil.validateEmpty(value, 'Phone Number'),
        ),
      ],
    );
  }
}