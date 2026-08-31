import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:juniorflutterroadmap/core/data/dtos/product_response.dart';

class ProductModel {
  ProductModel({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
  });

  factory ProductModel.fromResponse(ProductResponse response) {
    return ProductModel(
      image: response.image,
      title: response.title,
      description: response.description,
      price: response.price,
      id: response.id,
      category: response.category,
    );
  }

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

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final json = jsonDecode(reader.read() as String) as Map<String, dynamic>;
    return ProductModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.write(jsonEncode(obj.toJson()));
  }
}
