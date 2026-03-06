enum OrderStatus {
  pending('pending', 'Pending'),
  processing('processing', 'Processing'),
  shipped('shipped', 'Shipped'),
  delivered('delivered', 'Delivered'),
  cancelled('cancelled', 'Cancelled');

  final String code;
  final String title;

  const OrderStatus(this.code, this.title);

  static OrderStatus fromString(String code) {
    return OrderStatus.values.firstWhere(
          (e) => e.code.toLowerCase() == code.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }
}