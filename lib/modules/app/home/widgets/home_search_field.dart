import 'package:ecomerce/core/components/text_field/search_field.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search-field',
      child: Material(
        color: Colors.transparent,
        child: SearchField(
          readOnly: true,

          onTap: () => Get.toNamed(AppRouter.search),
        ),
      ),
    );
  }
}
