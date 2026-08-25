class CategoryModel {

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });
  final int id;
  final String name;
  final String slug;
  final String image;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as int,
        name: json['name'] as String,
        slug: json['slug'] as String,
        image: (json['image'] as String?) ?? '',
      );
}
