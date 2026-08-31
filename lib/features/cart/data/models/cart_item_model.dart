import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:juniorflutterroadmap/core/data/models/product_model.dart';


class CartItemModel {
  CartItemModel({
    required this.product,
    required this.quantity,
  });

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(product: product, quantity: quantity);
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        product: ProductModel.fromJson(json),
        quantity: json['quantity'] as int? ?? 1,
      );

  final ProductModel product;
  final int quantity;

  // ── Convenience getters ──────────────────────────────────────────────

  int get id => product.id;
  String get title => product.title;
  double get price => product.price;
  List<dynamic> get image => product.image;
  String get category => product.category;
  String get description => product.description;
  double get totalPrice => product.price * quantity;

  // ── Immutability ─────────────────────────────────────────────────────

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        product: product,
        quantity: quantity ?? this.quantity,
      );

  // ── Serialization ────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        ...product.toJson(),
        'quantity': quantity,
      };
}

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 1;

  @override
  CartItemModel read(BinaryReader reader) {
    final json = jsonDecode(reader.read() as String) as Map<String, dynamic>;
    return CartItemModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer.write(jsonEncode(obj.toJson()));
  }
}
