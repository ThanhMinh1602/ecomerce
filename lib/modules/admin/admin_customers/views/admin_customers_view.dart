import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_customers_controller.dart';
import '../../admin_dashboard/widgets/admin_sidebar.dart';

class AdminCustomersView extends GetView<AdminCustomersController> {
  const AdminCustomersView({super.key});

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
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quản lý Khách hàng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      // Thanh tìm kiếm
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: TextField(
                          onChanged: controller.searchCustomer,
                          decoration: InputDecoration(
                            hintText: 'Tìm theo tên, email, SĐT...',
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

                // Content Body (Bảng khách hàng)
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
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.filteredCustomers.isEmpty) {
                          return const Center(
                            child: Text(
                              'Không tìm thấy khách hàng nào.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        // Dùng LayoutBuilder để đo chiều ngang thực tế của Container chứa bảng
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            // Cấu hình các khoảng cách mặc định của DataTable
                            const double horizontalMargin = 24.0;
                            const double columnSpacing = 20.0;

                            // Tổng chiều rộng có thể sử dụng (Trừ đi lề trái phải và khoảng cách giữa 4 cột)
                            final double availableWidth =
                                constraints.maxWidth -
                                (horizontalMargin * 2) -
                                (columnSpacing * 3);

                            // Chia đều cho 4 cột
                            final double columnWidth = availableWidth / 4;

                            return SingleChildScrollView(
                              // Chỉ giữ cuộn dọc
                              child: DataTable(
                                horizontalMargin: horizontalMargin,
                                columnSpacing: columnSpacing,
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey.shade50,
                                    ),
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: columnWidth,
                                      child: const Text(
                                        'ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: columnWidth,
                                      child: const Text(
                                        'Tên khách hàng',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: columnWidth,
                                      child: const Text(
                                        'Email',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: columnWidth,
                                      child: const Text(
                                        'Số điện thoại',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.filteredCustomers.map((user) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        SizedBox(
                                          width: columnWidth,
                                          child: Text(
                                            user.id.length > 5
                                                ? '${user.id.substring(0, 5)}...'
                                                : user.id,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: columnWidth,
                                          child: Text(
                                            user.name.isNotEmpty
                                                ? user.name
                                                : 'Chưa cập nhật',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu tên quá dài
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: columnWidth,
                                          child: Text(
                                            user.email.isNotEmpty
                                                ? user.email
                                                : 'Chưa cập nhật',
                                            overflow: TextOverflow
                                                .ellipsis, // Cắt bớt nếu email quá dài
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: columnWidth,
                                          child: Text(
                                            user.phone != null &&
                                                    user.phone!.isNotEmpty
                                                ? user.phone!
                                                : 'Chưa cập nhật',
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          },
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
}
