import 'package:hive/hive.dart';
import '../dtos/product_response.dart';

class ProductHiveModel {
  ProductHiveModel({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
  });

  factory ProductHiveModel.fromResponse(ProductResponse response) {
    return ProductHiveModel(
      image: response.image.map((e) => e.toString()).toList(),
      title: response.title,
      description: response.description,
      price: response.price,
      id: response.id,
      category: response.category,
    );
  }

  factory ProductHiveModel.fromJson(Map<String, dynamic> json) =>
      ProductHiveModel(
        image: (json['image'] as List<dynamic>?)?.cast<String>() ?? [],
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        id: json['id'] as int? ?? 0,
        category: json['category'] as String? ?? '',
      );

  final List<String> image;
  final String title;
  final String description;
  final double price;
  final int id;
  final String category;

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'description': description,
        'price': price,
        'id': id,
        'category': category,
      };
}

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 0;

  @override
  ProductHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductHiveModel(
      image: (fields[0] as List).cast<String>(),
      title: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      id: fields[4] is int
          ? fields[4] as int
          : int.tryParse(fields[4]?.toString() ?? '') ?? 0,
      category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.category);
  }
}
