import 'package:hive/hive.dart';

class CartItemModel {
  CartItemModel({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.category,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        image: (json['image'] as List<dynamic>?)?.cast<String>() ?? [],
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        id: json['id'] as int? ?? 0,
        category: json['category'] as String? ?? '',
        quantity: json['quantity'] as int? ?? 1,
      );

  final List<String> image;
  final String title;
  final String description;
  final double price;
  final int id;
  final String category;
  final int quantity;

  double get totalPrice => price * quantity;

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        image: image,
        title: title,
        description: description,
        price: price,
        id: id,
        category: category,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'description': description,
        'price': price,
        'id': id,
        'category': category,
        'quantity': quantity,
      };
}

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 1;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      image: (fields[0] as List).cast<String>(),
      title: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      id: fields[4] is int ? fields[4] as int : int.tryParse(fields[4]?.toString() ?? '') ?? 0,
      category: fields[5] as String,
      quantity: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.quantity);
  }
}
