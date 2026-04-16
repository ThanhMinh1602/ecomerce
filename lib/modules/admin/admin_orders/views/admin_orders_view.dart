import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/modules/admin/admin_dashboard/widgets/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_orders_controller.dart';

class AdminOrdersView extends GetView<AdminOrdersController> {
  const AdminOrdersView({super.key});

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
                // HEADER
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Quản lý Đơn hàng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(),
                      // Nút hiển thị tổng số đơn
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(
                          () => Text(
                            'Tổng: ${controller.filteredOrders.length} đơn',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ), // Thanh tìm kiếm
                      SizedBox(width: 16.0),
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: TextField(
                          onChanged: controller.searchOrder,
                          decoration: InputDecoration(
                            hintText: 'Tìm mã ĐH, tên khách...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BODY CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Obx(() {
                        if (controller.allOrders.isEmpty) {
                          return const Center(
                            child: Text('Chưa có đơn hàng nào trong hệ thống.'),
                          );
                        }

                        if (controller.filteredOrders.isEmpty) {
                          return const Center(
                            child: Text('Không tìm thấy đơn hàng phù hợp.'),
                          );
                        }

                        return Column(
                          children: [
                            _buildTableHeader(),
                            const Divider(height: 1),

                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: controller.filteredOrders.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 32),
                                itemBuilder: (context, index) {
                                  // Sử dụng filteredOrders
                                  final order =
                                      controller.filteredOrders[index];
                                  return _buildOrderRow(order);
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Mã ĐH', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Khách hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Tổng tiền',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Trạng thái',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text('Xem', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(dynamic order) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            order.id.toString().substring(0, 8).toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),

        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.customerName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${order.items.length} sản phẩm',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            '\$${order.totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: _getStatusColor(order.status).withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(8),
              color: _getStatusColor(order.status).withOpacity(0.1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<OrderStatus>(
                value: order.status,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: _getStatusColor(order.status),
                ),
                style: TextStyle(
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                onChanged: (OrderStatus? newValue) {
                  if (newValue != null && newValue != order.status) {
                    controller.changeOrderStatus(order.id, newValue);
                  }
                },
                items: OrderStatus.values.map((OrderStatus status) {
                  return DropdownMenuItem<OrderStatus>(
                    value: status,
                    child: Text(
                      status.title,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        SizedBox(
          width: 50,
          child: IconButton(
            icon: const Icon(Icons.visibility_outlined, color: Colors.grey),
            onPressed: () => _showOrderDetailsDialog(order),
            tooltip: 'Xem chi tiết',
          ),
        ),
      ],
    );
  }

  void _showOrderDetailsDialog(dynamic order) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chi tiết đơn hàng: #${order.id.toString().substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thông tin giao hàng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildDetailText(
                                  'Khách hàng:',
                                  order.customerName,
                                ),
                                _buildDetailText(
                                  'Ngày đặt:',
                                  controller.formatDate(order.createdAt),
                                ),
                                _buildDetailText(
                                  'Địa chỉ:',
                                  order.shippingAddress,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thông tin thanh toán',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildDetailText(
                                  'Phương thức:',
                                  order.paymentMethod.title,
                                ),
                                if (order.paymentId != null)
                                  _buildDetailText('Mã GD:', order.paymentId!),
                                if (order.payerEmail != null)
                                  _buildDetailText(
                                    'Email PayPal:',
                                    order.payerEmail!,
                                  ),
                                const SizedBox(height: 8),
                                _buildDetailText(
                                  'Phí Ship:',
                                  '\$${order.shippingFee.toStringAsFixed(2)}',
                                ),
                                _buildDetailText(
                                  'Giảm giá:',
                                  '-\$${order.discountAmount.toStringAsFixed(2)}',
                                  color: Colors.green,
                                ),
                                _buildDetailText(
                                  'Tổng thanh toán:',
                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      const Text(
                        'Sản phẩm đã đặt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...order.items
                          .map<Widget>(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          (item.image != null &&
                                              item.image!.isNotEmpty)
                                          ? CldImageWidget(
                                              publicId: item.image!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                            )
                                          : const Icon(
                                              Icons.image_outlined,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name ?? 'Sản phẩm',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Số lượng: ${item.quantity}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailText(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
