import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class PaymentService extends GetxService {
  static const String _clientId = "AWYnObd_SzPVkHX_BKrSfkEyA5Q2W9LnN-oxniidyKNh5A8brfRqTIDByLWk19HbhjkItZ9F2Oalp34X";
  static const String _secretKey = "EJnD0dlTbH9YQRa3BwznwrONZXTj0MART21USUCYxsFzxJwlMZJMfYgqwZ0SzJPyKuJcWsdoN-elK5tw";

  // Sửa kiểu trả về thành Map?
  Future<Map<String, dynamic>?> processPayment(PaymentMethodType type, {
    required double amount,
    required String currency,
    required String orderId,
    required String shippingAddress,
    required String recipientName,
  }) async {
    switch (type) {
      case PaymentMethodType.paypal:
        return await _payWithPayPal(amount, currency, orderId, shippingAddress, recipientName);
      case PaymentMethodType.cod:
      // Trả về một Map rỗng để đánh dấu là thành công (vì COD không có data từ cổng thanh toán)
        return {'method': 'cod', 'status': 'success'};
      default:
        debugPrint("Phương thức ${type.title} chưa được cấu hình.");
        return null;
    }
  }

  Future<Map<String, dynamic>?> _payWithPayPal(
      double amount,
      String currency,
      String orderId,
      String address,
      String name
      ) async {
    final Map<String, dynamic>? result = await Get.to(
          () => PaypalCheckoutView(
        sandboxMode: true,
        clientId: _clientId,
        secretKey: _secretKey,
        transactions: [
          {
            "amount": {
              "total": amount.toStringAsFixed(2),
              "currency": currency,
              "details": {
                "subtotal": amount.toStringAsFixed(2),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "Thanh toán đơn hàng #$orderId",
            "item_list": {
              "items": [
                {
                  "name": "Order #$orderId",
                  "quantity": 1,
                  "price": amount.toStringAsFixed(2),
                  "currency": currency
                }
              ],
              "shipping_address": {
                "recipient_name": name,
                "line1": address,
                "line2": "",
                "city": "Da Nang",
                "country_code": "VN",
                "postal_code": "550000",
                "phone": "+84905123456",
                "state": "Da Nang"
              },
            }
          }
        ],
        note: "Liên hệ với chúng tôi nếu bạn có bất kỳ thắc mắc nào về đơn hàng.",
            onSuccess: (Map params) async {
              debugPrint("PayPal Success: $params");

              // --- SỬA CHỖ NÀY ---
              // Ép kiểu từ Map<dynamic, dynamic> sang Map<String, dynamic>
              final Map<String, dynamic> formattedParams = Map<String, dynamic>.from(params);

              Get.back(result: formattedParams);
            },
        onError: (error) {
          debugPrint("PayPal Error: $error");
          Get.back(result: null);
        },
        onCancel: () {
          debugPrint("PayPal Cancelled");
          Get.back(result: null);
        },
      ),
    );

    return result;
  }
}