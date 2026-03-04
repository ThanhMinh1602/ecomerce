import 'dart:math' as math;
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDescriptionTile extends StatelessWidget {
  final String description;
  final RxBool isExpanded = false.obs;

  ProductDescriptionTile({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => isExpanded.toggle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: AppColor.k949494.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Description',
                    style: AppStyle.smallContentBold.copyWith(
                      color: AppColor.black500,
                    ),
                  ),
                  Transform.rotate(
                    angle: isExpanded.value ? math.pi : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.black500,
                    ),
                  ),
                ],
              ),

              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    description,
                    style: AppStyle.smallContentRegular.copyWith(
                      color: AppColor.black300,
                      height: 1.5,
                    ),
                  ),
                ),
                crossFadeState: isExpanded.value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
