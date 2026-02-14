class Medicine {
  final String id;
  final String name;
  final double price;
  final String image;

  static const String baseUrl = "http://localhost:3000"; 
  // 👆 emulator use pannina
  // real mobile-na PC IP use pannunga

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    String img = json['image'] ?? "";

    // 🔥 filename mattum irundha full url build pannum
    if (img.isNotEmpty && !img.startsWith("http")) {
      img = "$baseUrl/uploads/$img";
    }

    return Medicine(
      id: json['_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: img.isNotEmpty
          ? img
          : "https://via.placeholder.com/150",
    );
  }
}
