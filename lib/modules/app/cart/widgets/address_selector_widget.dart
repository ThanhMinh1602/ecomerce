import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class AddressSelectorWidget extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? address;
  final List<String>? addresses;
  final int? selectedIndex;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(int)? onSelect;

  const AddressSelectorWidget({
    super.key,
    this.name,
    this.phone,
    this.address,
    this.addresses,
    this.selectedIndex,
    this.isExpanded = false,
    required this.onTap,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    bool isMultipleMode = addresses != null && addresses!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null && phone != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery information', style: AppStyle.smallContentBold),
              InkWell(
                onTap: ()=> Get.toNamed(AppRouter.myDetails,arguments: true),
                child: Text('Update', style: AppStyle.smallContentRegular.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  decorationThickness: 1.5,
                )),
              )
            ],
          ),
          const SizedBox(height: 8),
        ],

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: AppColor.black100.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(14.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColor.black500,
                          size: 28,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (name != null && phone != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppStyle.smallContentBold.copyWith(
                                        color: AppColor.black500,
                                      ),
                                      children: [
                                        TextSpan(text: name),
                                        TextSpan(
                                          text: ' ($phone)',
                                          style: AppStyle.smallContentRegular
                                              .copyWith(
                                                color: AppColor.k949494,
                                              ),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              Text(
                                isMultipleMode
                                    ? addresses![selectedIndex ?? 0]
                                    : (address ?? ''),
                                style: AppStyle.smallContentRegular.copyWith(
                                  color: AppColor.k949494,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        AnimatedRotation(
                          turns: isExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColor.black500,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (isMultipleMode && isExpanded) ...[
                  const Divider(height: 1, indent: 10, endIndent: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses!.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      return InkWell(
                        onTap: () => onSelect?.call(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: isSelected
                              ? AppColor.orange500.withOpacity(0.05)
                              : null,
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? AppColor.orange500
                                    : AppColor.k949494,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  addresses![index],
                                  style: AppStyle.smallContentRegular.copyWith(
                                    color: isSelected
                                        ? AppColor.black500
                                        : AppColor.k949494,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
