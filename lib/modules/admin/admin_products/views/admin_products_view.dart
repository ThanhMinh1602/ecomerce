import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/table/custom_admin_table.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/admin/admin_products/widgets/product_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/admin_products_controller.dart';
import '../../admin_dashboard/widgets/admin_sidebar.dart';

class AdminProductsView extends GetView<AdminProductsController> {
  const AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Obx(() {
                      if (controller.products.isEmpty &&
                          controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CustomAdminTable<ProductModel>(
                        columns: const [
                          'Ảnh',
                          'Tên sản phẩm',
                          'Danh mục',
                          'Phân loại',
                          'Giá',
                          'Kho',
                          'Thao tác',
                        ],
                        items: controller.products,
                        isLoading: controller.isLoading.value,
                        rowBuilder: (product, index) => DataRow(
                          cells: [
                            DataCell(
                              _buildImageCell(product.images.firstOrNull),
                            ),
                            DataCell(
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(_buildCategoryName(product.categoryId)),

                            DataCell(
                              _buildVariantCell(product.colors, product.sizes),
                            ),
                            DataCell(
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '\$ ',
                                ).format(product.price),
                              ),
                            ),
                            DataCell(Text(product.stock.toString())),
                            DataCell(_buildActionButtons(product)),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Sản phẩm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () {
              controller.clearFields();

              Get.dialog(const ProductFormDialog(), barrierDismissible: false);
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Thêm sản phẩm mới',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ProductModel product) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
          onPressed: () {
            controller.prepareEdit(product);
            Get.dialog(
              ProductFormDialog(oldProduct: product),
              barrierDismissible: false,
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 20,
          ),
          onPressed: () => controller.deleteProduct(product),
        ),
      ],
    );
  }

  Widget _buildCategoryName(String categoryId) {
    return Text(categoryId ?? 'N/A', style: TextStyle(color: Colors.grey[600]));
  }

  Widget _buildImageCell(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl != null
          ? CldImageWidget(
              publicId: imageUrl,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            )
          : const Icon(Icons.image, size: 40),
    );
  }

  Widget _buildVariantCell(List<String> colors, List<String> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (colors.isNotEmpty)
          Wrap(
            spacing: 4,
            children: colors
                .map(
                  (c) => Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(int.parse(c)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

        if (colors.isNotEmpty && sizes.isNotEmpty) const SizedBox(height: 6),

        if (sizes.isNotEmpty)
          Text(
            "Sizes: ${sizes.join(', ')}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),

        if (colors.isEmpty && sizes.isEmpty)
          const Text('N/A', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
