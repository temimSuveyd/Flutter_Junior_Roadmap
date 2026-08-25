import 'package:juniorflutterroadmap/features/products/data/dtos/product_response.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';

class ProductMapper {
  static ProductModel toProductModel(ProductResponce productResponce) {
    return ProductModel(
      category: productResponce.category,
      description: productResponce.description,
      id: productResponce.id,
      image: productResponce.image,
      price: productResponce.price,
      title: productResponce.title,
    );
  }
}
