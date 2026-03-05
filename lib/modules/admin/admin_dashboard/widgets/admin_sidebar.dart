import 'package:ecomerce/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/routes/app_router.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Container(
      width: 250,
      color: const Color(0xFF1E1E2D),
      child: Column(
        children: [
          Container(
            height: 70,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: const Text(
              'SALES ADMIN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Các Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Tổng quan',
                  isActive: currentRoute == AppRouter.adminDashboard,
                  onTap: () => _navigateTo(AppRouter.adminDashboard),
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'Sản phẩm',
                  isActive: currentRoute == AppRouter.adminProducts,
                  onTap: () => _navigateTo(AppRouter.adminProducts),
                ),
                _buildMenuItem(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Đơn hàng',
                  isActive: currentRoute == AppRouter.adminOrders,
                  onTap: () => _navigateTo(AppRouter.adminOrders),
                ),
                _buildMenuItem(
                  icon: Icons.people_outline,
                  title: 'Khách hàng',
                  isActive: currentRoute == AppRouter.adminUsers,
                  onTap: () => _navigateTo(AppRouter.adminUsers),
                ),
                _buildMenuItem(
                  icon: Icons.category_outlined,
                  title: 'Danh mục',
                  isActive: currentRoute == AppRouter.adminCategories,
                  onTap: () => _navigateTo(AppRouter.adminCategories),
                ),
              ],
            ),
          ),

          // Nút Đăng xuất ở cuối cùng
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Gọi hàm logout từ AuthService và đẩy về trang login admin
                Get.find<AuthService>().logout();
                Get.offAllNamed(AppRouter.adminLogin);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                minimumSize: const Size(double.infinity, 45),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm điều hướng dùng chung để tránh lặp code
  void _navigateTo(String route) {
    if (Get.currentRoute != route) {
      // Dùng offAllNamed để reset stack điều hướng cho Admin Web sạch sẽ
      Get.offAllNamed(route);
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.blueAccent.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.blueAccent : Colors.grey[400],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blueAccent : Colors.grey[400],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: Colors.white10,
      ),
    );
  }
}
