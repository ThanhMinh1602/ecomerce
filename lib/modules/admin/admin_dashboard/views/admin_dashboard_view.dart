import 'package:fl_chart/fl_chart.dart'; // Đảm bảo đã cài đặt package fl_chart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../widgets/admin_sidebar.dart';
import 'dart:math' as math;

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // Nền xám nhạt toàn trang
      body: Row(
        children: [
          // 1. Sidebar (Menu trái)
          const AdminSidebar(),

          // 2. Nội dung chính bên phải
          Expanded(
            child: Column(
              children: [
                // Header (Thanh Topbar)
                _buildHeader(),

                // Phần nội dung (Body)
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tổng quan Kinh doanh',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Hàng chứa các Card Thống kê
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Tổng Doanh Thu',
                                  '\$${controller.totalRevenue.value.toStringAsFixed(2)}',
                                  Icons.attach_money,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Đơn Hàng Mới',
                                  '${controller.totalOrders.value}',
                                  Icons.shopping_bag_outlined,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Tổng Sản Phẩm',
                                  '${controller.totalProducts.value}',
                                  Icons.inventory_2_outlined,
                                  Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Khách Hàng Mới',
                                  '${controller.newCustomers.value}',
                                  Icons.people_outline,
                                  Colors.purple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Biểu đồ Doanh thu (Fl_chart)
                          _buildRevenueChart(),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Biểu đồ Doanh thu
  Widget _buildRevenueChart() {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu 7 ngày gần nhất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              if (controller.weeklyRevenue.every((element) => element == 0)) {
                return const Center(
                  child: Text(
                    'Chưa có dữ liệu doanh thu trong 7 ngày qua.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              // 1. Lấy giá trị cao nhất từ dữ liệu
              double rawMax = controller.weeklyRevenue.reduce(
                (curr, next) => curr > next ? curr : next,
              );
              if (rawMax == 0) rawMax = 10;

              // 2. THUẬT TOÁN TÌM BƯỚC NHẢY TRÒN SỐ (10, 50, 100, 200, 500...)
              double rawStep = rawMax / 5; // Chia mặc định 5 mốc

              // Tính bậc độ lớn (Ví dụ: rawStep=123 => mag=100)
              double mag = math
                  .pow(10, (math.log(rawStep) / math.ln10).floor())
                  .toDouble();
              double normStep = rawStep / mag; // Đưa về số từ 1 đến 10

              // Ép vào các mốc tròn đẹp nhất
              double niceNorm;
              if (normStep <= 1) {
                niceNorm = 1;
              } else if (normStep <= 2) {
                niceNorm = 2;
              } else if (normStep <= 5) {
                niceNorm = 5;
              } else {
                niceNorm = 10;
              }

              // Bước nhảy cuối cùng (Ví dụ: 100, 200, 500)
              double step = niceNorm * mag;

              // Đỉnh trục Y (luôn là bội số của step)
              double finalMaxY = step * 5;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: finalMaxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '\$${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 &&
                              index < controller.weeklyLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                controller.weeklyLabels[index],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: step,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == meta.max) {
                            return const SizedBox.shrink();
                          }

                          // Rút gọn text nếu quá lớn
                          String textValue;
                          if (value >= 1000000) {
                            textValue =
                                '\$${(value / 1000000).toStringAsFixed(1)}M';
                          } else if (value >= 1000) {
                            textValue =
                                '\$${(value / 1000).toStringAsFixed(1)}k';
                          } else {
                            textValue = '\$${value.toInt()}';
                          }

                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              textValue,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: false,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: step, // Kẻ gạch ngang theo mốc tròn
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: controller.weeklyRevenue[index],
                          color: Colors.blueAccent,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget Thanh Header trên cùng
  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.grey),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: controller.logout,
                child: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.logout, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Thẻ Thống kê (Stat Card)
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            // Tránh lỗi overflow nếu số liệu quá dài
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
