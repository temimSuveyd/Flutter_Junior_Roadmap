class ProductResponce {
  final List<dynamic> image;
  final String title;
  final String description;
  final double price;
  final String id;
  final String category;
  ProductResponce({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
  });

  factory ProductResponce.fromJson(Map<String, dynamic> json) =>
      ProductResponce(
        image: json['images'],
        title: json['title'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        id: json['id'].toString(),
        category: json['category']['name'],
      );
}
