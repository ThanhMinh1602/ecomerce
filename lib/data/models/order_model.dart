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
  double shippingFee; // Thêm phí ship
  double discountAmount; // Thêm giảm giá
  String shippingAddress;
  PaymentMethodType paymentMethod;
  OrderStatus status;
  DateTime createdAt;

  String? paymentId;
  String? payerEmail;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    this.shippingFee = 0.0,
    this.discountAmount = 0.0,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.paymentId,
    this.payerEmail,
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
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      shippingAddress: json['shippingAddress'] ?? '',
      paymentMethod: PaymentMethodType.fromString(json['paymentMethod'] ?? ''),
      status: OrderStatus.fromString(json['status'] ?? ''),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentId: json['paymentId'],
      payerEmail: json['payerEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'customerName': customerName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingFee': shippingFee,
      'discountAmount': discountAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod.code,
      'status': status.code,
      'createdAt': createdAt,
      'paymentId': paymentId,
      'payerEmail': payerEmail,
    };
  }
}