import '../dtos/category_response.dart';
import '../models/category_model.dart';

class CategoryMapper {
  static CategoryModel toCategoryModel(CategoryResponse response) {
    return CategoryModel(
      id: response.id,
      name: response.name,
      slug: response.slug,
      image: response.image,
    );
  }
}
