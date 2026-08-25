class ProductModel {
  ProductModel({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
  });
  final List<dynamic> image;
  final String title;
  final String description;
  final double price;
  final String id;
  final String category;

  String? get thumbnailImage =>
      image.isNotEmpty && image.first is String ? image.first as String : null;
}
