import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/cart_model.dart';

class OrderModel {
  String id;
  String userId;
  String customerName;
  List<CartItemModel> items;
  double totalAmount;
  String shippingAddress;
  PaymentMethodType paymentMethod;
  OrderStatus status;
  DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending, // Dùng enum thay vì 'Pending'
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    return OrderModel(
      id: docId,
      userId: json['userId'] ?? '',
      customerName: json['customerName'] ?? 'Unknown',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>, item['id'] ?? ''))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      shippingAddress: json['shippingAddress'] ?? '',

      // Chuyển từ JSON String sang Enum bằng hàm fromString
      paymentMethod: PaymentMethodType.fromString(json['paymentMethod'] ?? ''),
      status: OrderStatus.fromString(json['status'] ?? ''),

      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'customerName': customerName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,

      // Chuyển từ Enum sang String (code) để lưu vào Firestore
      'paymentMethod': paymentMethod.code,
      'status': status.code,

      'createdAt': createdAt,
    };
  }
}