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
              // Gọi Widget Dialog mới
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

  // ... (Giữ nguyên các hàm _buildCategoryName, _buildImageCell, _cardDecoration của bạn)

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
    final cat = controller.categories.firstWhereOrNull(
      (c) => c.id == categoryId,
    );
    return Text(cat?.name ?? 'N/A', style: TextStyle(color: Colors.grey[600]));
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
}
