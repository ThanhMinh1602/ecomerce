import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/models/cart_model.dart'; // Import thêm CartItemModel
import 'package:ecomerce/modules/app/cart/widgets/address_selector_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/discount_selector_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/payment_methodI_item_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/transaction_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late OrderModel _order;

  String _selectedPaymentMethod = 'Payment upon delivery';
  String? _appliedDiscountCode;
  double _discountAmount = 0.0;
  final double _shippingFee = 10.0;

  @override
  void initState() {
    super.initState();
    _order = Get.arguments as OrderModel;
    if (_order.paymentMethod != 'COD') {
      _selectedPaymentMethod = _order.paymentMethod;
    }
  }

  void _handlePlaceOrder() {
    _order.paymentMethod = _selectedPaymentMethod;
    _order.shippingAddress = '79k5 Phan Van Dinh, Da Nang';
    _order.totalAmount = (_order.totalAmount + _shippingFee) - _discountAmount;
    _order.status = 'Pending';
    _order.createdAt = DateTime.now();

    print("----- ĐƠN HÀNG SẴN SÀNG GỬI LÊN FIREBASE -----");
    print(_order.toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: AppColor.orange500,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // BỔ SUNG: Hàm render từng item trong đơn hàng (Dạng chỉ đọc)
  Widget _buildOrderItem(CartItemModel item) {
    // Gom Color và Size lại
    List<String> parts = [];
    if (item.selectedColor != null && item.selectedColor!.isNotEmpty) parts.add(item.selectedColor!);
    if (item.selectedSize != null && item.selectedSize!.isNotEmpty) parts.add('Size ${item.selectedSize}');
    String variantInfo = parts.join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hình ảnh thu nhỏ
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              item.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 12.0),

          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppStyle.smallContentBold.copyWith(color: AppColor.black500, fontSize: 15.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  variantInfo.isEmpty ? 'Qty: ${item.quantity}' : '$variantInfo, x${item.quantity}',
                  style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494, fontSize: 13.0),
                ),
              ],
            ),
          ),

          // Tổng giá của item đó (giá x số lượng)
          Text(
            (item.price * item.quantity).formatPrice(),
            style: AppStyle.smallContentBold.copyWith(color: AppColor.black500, fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Checkout", style: AppStyle.contentBold),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address', style: AppStyle.smallContentBold),
                  const SizedBox(height: 16),
                  AddressSelectorWidget(
                    name: 'Nguyen Nhat Trieu',
                    phone: '+84 354 823 243',
                    address: '79k5 Phan Van Dinh , Da Nang',
                    onTap: () {},
                  ),

                  const SizedBox(height: 32),

                  // BỔ SUNG: KHU VỰC HIỂN THỊ CÁC SẢN PHẨM TRONG ĐƠN HÀNG
                  Text('Order Items', style: AppStyle.smallContentBold),
                  const SizedBox(height: 16),
                  // Render danh sách các món đồ khách đã chọn
                  ..._order.items.map((item) => _buildOrderItem(item)),

                  const SizedBox(height: 16),

                  Text('Payment Method', style: AppStyle.smallContentBold),
                  const SizedBox(height: 16),

                  PaymentMethodItemWidget(
                    isSelected: _selectedPaymentMethod == 'Creditcard',
                    title: 'Creditcard',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('VISA', style: AppStyle.smallContentBold.copyWith(color: Colors.blue[800], fontStyle: FontStyle.italic)),
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, color: Colors.redAccent, size: 16),
                        const Icon(Icons.circle, color: Colors.orangeAccent, size: 16),
                      ],
                    ),
                    onTap: () => setState(() => _selectedPaymentMethod = 'Creditcard'),
                  ),
                  const SizedBox(height: 12),

                  PaymentMethodItemWidget(
                    isSelected: _selectedPaymentMethod == 'Apple Pay',
                    title: 'Apple Pay',
                    trailing: const Icon(Icons.apple, size: 28),
                    onTap: () => setState(() => _selectedPaymentMethod = 'Apple Pay'),
                  ),
                  const SizedBox(height: 12),

                  PaymentMethodItemWidget(
                    isSelected: _selectedPaymentMethod == 'Payment upon delivery',
                    title: 'Payment upon delivery',
                    trailing: const SizedBox(),
                    onTap: () => setState(() => _selectedPaymentMethod = 'Payment upon delivery'),
                  ),

                  const SizedBox(height: 32),

                  DiscountSelectorWidget(
                    selectedDiscountCode: _appliedDiscountCode,
                    onTap: () {
                      setState(() {
                        _appliedDiscountCode = 'FREESHIP10';
                        _discountAmount = 10.0;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  TransactionSummaryWidget(
                    totalPrice: _order.totalAmount,
                    shippingFee: _shippingFee,
                    discount: _discountAmount,
                  ),
                ],
              ),
            ),
          ),
          _buildPlaceOrderBar(),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar() {
    final finalTotal = (_order.totalAmount + _shippingFee) - _discountAmount;

    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, MediaQuery.of(context).padding.bottom + 16.0),
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
                'Total Payment',
                style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494, fontSize: 14.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                finalTotal.formatPrice(),
                style: AppStyle.contentBold.copyWith(color: AppColor.black500, fontSize: 22.0),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _handlePlaceOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.orange500,
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99.0),
              ),
              elevation: 0,
            ),
            child: Text(
              'Place Order',
              style: AppStyle.smallContentBold.copyWith(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}