import 'package:ecomerce/modules/app/profile/widgets/address_section.dart';
import 'package:ecomerce/modules/app/profile/widgets/personal_info_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/modules/app/auth/widgets/auth_layout_wrapper.dart';
import '../controllers/my_detail_view_controller.dart';

class MyDetailsView extends GetView<MyDetailViewController> {
  const MyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayoutWrapper(
      isLoading: controller.isLoading,
      formKey: controller.formKey,
      appBar: const SmallAppBar(title: 'My Details'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        child: CustomButton(
          btnText: 'Submit',
          onPressed: controller.updateProfile,
        ),
      ),
      builder: (BuildContext context, bool isCrowded) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonalInfoSection(),
            AddressSection(),
          ],
        );
      },
    );
  }
}