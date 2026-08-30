class ProductResponse {
  ProductResponse({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        image: json['images'],
        title: json['title'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        id: json['id'] as int,
        category:
            (json['category'] as Map<String, dynamic>?)?['name'] as String? ??
            '',
      );
  final List<dynamic> image;
  final String title;
  final String description;
  final double price;
  final int id;
  final String category;
}
