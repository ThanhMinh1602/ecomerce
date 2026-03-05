import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/modules/app/cart/widgets/cart_item_widget.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:get/get.dart';
class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // Thay thế bằng Model xịn của bạn
  List<CartItemModel> cartItems = [
    CartItemModel(
      id: 'doc_1',
      productId: 'p_01',
      name: 'Regular Fit shirt',
      image: 'https://img.freepik.com/free-photo/blue-t-shirt_125540-727.jpg',
      price: 120.00,
      quantity: 1,
      selectedColor: 'Blue',
      selectedSize: 'M',
      isSelected: true, // Khởi tạo check sẵn
    ),
    CartItemModel(
      id: 'doc_2',
      productId: 'p_02',
      name: 'Classic White Sneakers',
      image: 'https://img.freepik.com/free-photo/white-sneakers-isolated_2829-21473.jpg',
      price: 85.50,
      quantity: 2,
      selectedColor: 'White',
      selectedSize: '42',
    ),
    CartItemModel(
      id: 'doc_3',
      productId: 'p_03',
      name: 'Slim Fit Denim Jacket',
      image: 'https://img.freepik.com/free-photo/jeans-jacket_1203-8202.jpg',
      price: 150.00,
      quantity: 1,
      selectedColor: 'Navy Blue',
      selectedSize: 'L',
    ),
  ];

  // Tính tổng tiền các item được check
  double get _totalPrice {
    return cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Hàm helper để tạo chuỗi variant đẹp mắt (VD: "Blue, Size M")
  String _buildVariantInfo(CartItemModel item) {
    List<String> parts = [];
    if (item.selectedColor != null && item.selectedColor!.isNotEmpty) {
      parts.add(item.selectedColor!);
    }
    if (item.selectedSize != null && item.selectedSize!.isNotEmpty) {
      parts.add('Size ${item.selectedSize}');
    }
    return parts.join(', '); // Nối lại bằng dấu phẩy
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cart", style: AppStyle.contentBold),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
              child: Text(
                "Your cart is empty",
                style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final item = cartItems[index];

                // Lấy thông tin Color & Size
                final baseVariant = _buildVariantInfo(item);

                return CartItemWidget(
                  isSelected: item.isSelected,
                  imageUrl: item.image, // Dùng item.image
                  title: item.name,     // Dùng item.name

                  // Ghép thêm số lượng phía sau (VD: "Blue, Size M, x1")
                  variantInfo: baseVariant.isEmpty
                      ? 'x${item.quantity}'
                      : '$baseVariant, x${item.quantity}',

                  price: item.price,
                  quantity: item.quantity,

                  // --- CÁC SỰ KIỆN UI ---
                  onCheckboxChanged: (value) {
                    setState(() {
                      item.isSelected = value ?? false;
                    });
                  },
                  onIncrement: () {
                    setState(() {
                      item.quantity++;
                    });
                  },
                  onDecrement: () {
                    if (item.quantity > 1) {
                      setState(() {
                        item.quantity--;
                      });
                    }
                  },
                  onDelete: () {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),

          _buildCheckoutBar(),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 110.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: AppStyle.smallContentRegular.copyWith(
                  color: AppColor.k949494,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                _totalPrice.formatPrice(),
                style: AppStyle.contentBold.copyWith(
                  color: AppColor.black500,
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
          ElevatedButton(
            // Nếu tổng tiền > 0 thì mới cho bấm
            onPressed: _totalPrice > 0 ? () {
              // 1. Lọc ra danh sách CHỈ những sản phẩm đang được tick chọn (isSelected == true)
              final selectedItems = cartItems.where((item) => item.isSelected).toList();

              // 2. Đóng gói vào OrderModel
              OrderModel newOrder = OrderModel(
                id: '', // ID sẽ do Firebase tự tạo sau khi push lên
                userId: 'user_123', // Tạm hardcode, sau này bạn truyền ID của user đang đăng nhập vào đây
                customerName: 'Sooti', // Tên user đang đăng nhập
                items: selectedItems, // Truyền danh sách đồ đã lọc ở trên vào
                totalAmount: _totalPrice,
                shippingAddress: '', // Sẽ được khách chọn lại ở màn Checkout
                paymentMethod: 'COD', // Set mặc định
                createdAt: DateTime.now(),
              );

              // 3. Chuyển hướng sang màn Checkout và ném OrderModel qua arguments
              Get.toNamed(AppRouter.checkout, arguments: newOrder);

              // LƯU Ý: Nếu bạn chưa setup route '/checkout' trong file app_pages.dart,
              // bạn có thể dùng lệnh này để chuyển trang trực tiếp:
              // Get.to(() => const CheckoutView(), arguments: newOrder);

            } : null, // Disable nút nếu chưa chọn món nào
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.orange500,
              disabledBackgroundColor: AppColor.orange200,
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99.0),
              ),
              elevation: 0,
            ),
            child: Text(
              'Checkout',
              style: AppStyle.smallContentBold.copyWith(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}