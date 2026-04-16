import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/user_model.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:get/get.dart';

class AdminCustomersController extends BaseController {
  // Sử dụng UserModel thay vì Map
  final RxList<UserModel> allCustomers = <UserModel>[].obs;
  final RxList<UserModel> filteredCustomers = <UserModel>[].obs;

  final RxBool isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPurchasedCustomers();
  }

  Future<void> fetchPurchasedCustomers() async {
    try {
      isLoading.value = true;

      // 1. Lấy tất cả đơn hàng và parse sang OrderModel
      final ordersSnapshot = await _firestore.collection('orders').get();
      final List<OrderModel> orders = ordersSnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
          .toList();

      // Lọc ra các userId duy nhất đã từng mua hàng
      final Set<String> buyerIds = orders
          .map((order) => order.userId)
          .where((id) => id.isNotEmpty)
          .toSet();

      List<UserModel> customersTemp = [];

      // 2. Lấy thông tin chi tiết của user và parse sang UserModel
      for (String userId in buyerIds) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists && userDoc.data() != null) {
          customersTemp.add(UserModel.fromJson(userDoc.data()!, userDoc.id));
        }
      }

      allCustomers.value = customersTemp;
      filteredCustomers.value = customersTemp;
    } catch (e) {
      print("Lỗi khi lấy dữ liệu khách hàng: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Tìm kiếm sử dụng thuộc tính của UserModel
  void searchCustomer(String query) {
    if (query.isEmpty) {
      filteredCustomers.value = allCustomers;
    } else {
      final lowerCaseQuery = query.toLowerCase();
      filteredCustomers.value = allCustomers.where((user) {
        final name = user.name.toLowerCase();
        final email = user.email.toLowerCase();
        final phone = (user.phone ?? '').toLowerCase();

        return name.contains(lowerCaseQuery) ||
            email.contains(lowerCaseQuery) ||
            phone.contains(lowerCaseQuery);
      }).toList();
    }
  }
}
