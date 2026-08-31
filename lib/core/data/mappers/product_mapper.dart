import 'package:juniorflutterroadmap/core/data/dtos/product_response.dart';
import 'package:juniorflutterroadmap/core/data/models/product_model.dart';

class ProductMapper {
  static ProductModel toProductModel(ProductResponse productResponse) {
    return ProductModel(
      category: productResponse.category,
      description: productResponse.description,
      id: productResponse.id,
      image: productResponse.image,
      price: productResponse.price,
      title: productResponse.title,
    );
  }
}
