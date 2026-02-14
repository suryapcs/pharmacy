class Medicine {
  final String id;
  final String name;
  final double price;
  final String description;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
    );
  }
}
