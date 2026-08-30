class CategoryResponse {
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  CategoryResponse({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });
  final int id;
  final String name;
  final String slug;
  final String image;
}
