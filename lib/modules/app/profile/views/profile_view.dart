import 'package:ecomerce/modules/app/profile/controllers/profile_controller.dart';
import 'package:ecomerce/modules/app/profile/widgets/my_orders_card.dart';
import 'package:ecomerce/modules/app/profile/widgets/profile_menu_item.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // Mã màu chuẩn theo thiết kế
  static const Color textBrown = Color(0xFF4A2B1D);
  static const Color bgOrangeLight = Color(0xFFFFF0E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER CARD (Avatar, Tên, Cấp độ) ---
              Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7A00), Color(0xFFFF5E00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A00).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Nút cài đặt ở góc trên phải
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.settings_outlined, color: Colors.white),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar với viền trắng và icon edit
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  'https://blog.vn.revu.net/wp-content/uploads/2025/09/anh-son-tung-mtp-thumb.jpg',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Color(0xFFFF7A00),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Thông tin người dùng
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${controller.userName.toLowerCase().replaceAll(' ', '_')} • Gold Member',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- 2. TRACK ORDER SECTION ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: MyOrdersCard(),
              ),

              const SizedBox(height: 32),

              // --- 3. ACCOUNT SETTINGS SECTION ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textBrown,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // ITEM 1: Chuyển đến My Details
                    ProfileMenuItem(
                      iconData: Icons.person_outline,
                      title: 'My Details',
                      subtitle: 'Thông tin cá nhân, địa chỉ',
                      onTap: controller.onTapMyDetail,
                    ),

                    // ITEM 2: Chuyển đến Vouchers & Offers
                    ProfileMenuItem(
                      iconData: Icons.local_offer_outlined,
                      title: 'Vouchers & Offers',
                      subtitle: 'Mã giảm giá, khuyến mãi',
                      onTap: () {
                        Get.toNamed(AppRouter.vouchersOffers);
                      },
                    ),

                    // ITEM 3: Chuyển đến My Orders (Lịch sử đơn hàng đầy đủ)
                    ProfileMenuItem(
                      iconData: Icons.receipt_long_outlined,
                      title: 'My Orders',
                      subtitle: 'Lịch sử mua hàng',
                      onTap: () {
                        Get.toNamed(AppRouter.myOrders);
                      },
                    ),

                    // CÁC ITEM CŨ (Giữ lại nếu bạn muốn)
                    ProfileMenuItem(
                      iconData: Icons.shield_outlined,
                      title: 'Security & Privacy',
                      subtitle: 'Bảo mật tài khoản',
                      onTap: () {},
                    ),

                    // --- CẬP NHẬT NÚT LOG OUT VỚI DIALOG XÁC NHẬN ---
                    ProfileMenuItem(
                      iconData: Icons.logout_outlined,
                      title: 'Log Out',
                      subtitle: 'Đăng xuất tài khoản',
                      iconColor: const Color(0xFFD34C4C),
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Confirm Log Out',
                          titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          middleText:
                              'Are you sure you want to log out of your account?',
                          middleTextStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          backgroundColor: Colors.white,
                          radius: 16,
                          textCancel: 'Cancel',
                          cancelTextColor: textBrown,
                          textConfirm: 'Log Out',
                          confirmTextColor: Colors.white,
                          buttonColor: const Color(
                            0xFFD34C4C,
                          ), // Trùng màu đỏ với icon
                          onConfirm: () {
                            Get.back(); // Đóng Dialog trước
                            controller.logout(); // Sau đó mới gọi hàm đăng xuất
                          },
                          onCancel: () {},
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
