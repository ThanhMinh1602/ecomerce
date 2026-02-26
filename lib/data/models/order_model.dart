class OrderModel {
  String id;
  String userId;
  double totalAmount;
  String status;
  DateTime orderDate;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    this.status = 'pending',
    required this.orderDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String documentId) {
    return OrderModel(
      id: documentId,
      userId: json['userId'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      orderDate: json['orderDate'] != null
          ? json['orderDate'].toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate,
    };
  }
}
