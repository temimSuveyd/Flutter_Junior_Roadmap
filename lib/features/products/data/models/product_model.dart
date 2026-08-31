class ProductModel {
  ProductModel({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        image: (json['image'] as List<dynamic>?) ?? [],
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        id: json['id'] as int? ?? 0,
        category: json['category'] as String? ?? '',
      );

  final List<dynamic> image;
  final String title;
  final String description;
  final double price;
  final int id;
  final String category;

  String? get thumbnailImage =>
      image.isNotEmpty && image.first is String ? image.first as String : null;

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'description': description,
        'price': price,
        'id': id,
        'category': category,
      };
}
