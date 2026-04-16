import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class AdminDashboardController extends BaseController {
  final totalRevenue = 0.0.obs;
  final totalOrders = 0.obs;
  final totalProducts = 0.obs;
  final newCustomers = 0.obs;

  // Dữ liệu cho biểu đồ: Doanh thu & Nhãn ngày tháng (7 ngày gần nhất)
  final RxList<double> weeklyRevenue = List.filled(7, 0.0).obs;
  final RxList<String> weeklyLabels = List.filled(7, '').obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    showLoading();
    try {
      // 1. Tính toán Đơn hàng & Doanh thu
      final ordersSnapshot = await _firestore.collection('orders').get();
      double revenue = 0.0;
      List<double> tempWeeklyRevenue = List.filled(7, 0.0);

      DateTime now = DateTime.now();
      DateTime startOfToday = DateTime(now.year, now.month, now.day);

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();

        // Bỏ qua các đơn hàng đã bị hủy (cancelled) khi tính doanh thu
        if (data['status'] != 'cancelled') {
          double amount = (data['totalAmount'] ?? 0.0).toDouble();
          revenue += amount;

          // Phân bổ doanh thu vào mảng 7 ngày cho biểu đồ
          if (data['createdAt'] != null) {
            DateTime createdAt = (data['createdAt'] as Timestamp).toDate();
            DateTime orderDate = DateTime(
              createdAt.year,
              createdAt.month,
              createdAt.day,
            );
            int differenceInDays = startOfToday.difference(orderDate).inDays;

            // Nếu đơn hàng nằm trong 7 ngày qua (0 là hôm nay, 6 là 6 ngày trước)
            if (differenceInDays >= 0 && differenceInDays < 7) {
              tempWeeklyRevenue[6 - differenceInDays] += amount;
            }
          }
        }
      }

      // Tạo nhãn (Labels) cho trục X của biểu đồ (VD: 25/10)
      List<String> tempLabels = [];
      for (int i = 6; i >= 0; i--) {
        DateTime date = startOfToday.subtract(Duration(days: i));
        tempLabels.add("${date.day}/${date.month}");
      }

      totalOrders.value = ordersSnapshot.docs.length;
      totalRevenue.value = revenue;
      weeklyRevenue.value = tempWeeklyRevenue;
      weeklyLabels.value = tempLabels;

      // 2. Đếm tổng số Sản phẩm
      final productsSnapshot = await _firestore.collection('products').get();
      totalProducts.value = productsSnapshot.docs.length;

      // 3. Đếm tổng số Khách hàng (lọc user có role là 'customer')
      final usersSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'customer')
          .get();
      newCustomers.value = usersSnapshot.docs.length;
    } catch (e) {
      print("Lỗi khi tải dữ liệu Dashboard: $e");
      showError("Đã xảy ra lỗi khi tải dữ liệu tổng quan.");
    } finally {
      hideLoading();
    }
  }

  void logout() {
    Get.offAllNamed(AppRouter.adminLogin);
  }
}
