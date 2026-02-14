class Order {
  final String id;
  final double total;

  Order({required this.id, required this.total});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      total: json['total'].toDouble(),
    );
  }
}
