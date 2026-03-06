import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/components/empty_address_widget.dart';
import 'package:ecomerce/core/components/text_field/custom_text_field.dart';
import 'package:ecomerce/modules/app/cart/widgets/address_selector_widget.dart';
import '../controllers/my_detail_view_controller.dart';

class AddressSection extends GetView<MyDetailViewController> {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Saved Addresses', style: AppStyle.smallContentBold),
          const SizedBox(height: 16),

          if (controller.userAddresses.isNotEmpty)
            for (int i = 0; i < controller.userAddresses.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: controller.editingIndex.value == i
                      ? const _AddressForm()
                      : Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: _buildDeleteBackground(),
                          onDismissed: (direction) {
                            controller.deleteAddress(i);
                          },
                          child: AddressSelectorWidget(
                            address: controller.userAddresses[i],
                            onTap: () => controller.editAddress(i),
                          ),
                        ),
                ),
              ),
          const SizedBox(height: 8.0),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child:
                (controller.isAddingAddress.value &&
                    controller.editingIndex.value == null)
                ? const _AddressForm()
                : EmptyAddressWidget(
                    title: 'Add new delivery address',
                    onTap: controller.toggleAddingAddress,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    );
  }
}

class _AddressForm extends GetView<MyDetailViewController> {
  const _AddressForm();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColor.orange500.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextField(
              key: const ValueKey('new_address_field'),
              controller: controller.newAddressController,
              hintText: controller.isFetchingLocation.value
                  ? 'Getting location...'
                  : 'Ex: 123 Nguyen Van Linh',
              labelText: controller.editingIndex.value != null
                  ? 'Edit Address'
                  : 'New Street Address',
              suffixIcon: controller.isFetchingLocation.value
                  ? Icons.downloading
                  : AppAsset.riMapPin2Fill,
              readOnly: controller.isFetchingLocation.value,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.toggleAddingAddress,
                  child: Text(
                    'Cancel',
                    style: AppStyle.smallContentBold.copyWith(
                      color: AppColor.k949494,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.isFetchingLocation.value
                      ? null
                      : controller.saveNewAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.orange500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    controller.editingIndex.value != null ? 'Update' : 'Save',
                    style: AppStyle.smallContentBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
