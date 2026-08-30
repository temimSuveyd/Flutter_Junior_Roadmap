import 'package:juniorflutterroadmap/features/favorites/data/services/favorite_local_service.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_hive_model.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';

abstract class FavoriteRepository {
  Set<int> getFavoriteIds();
  List<ProductModel> getFavorites();
  bool isFavorite(int productId);
  Future<void> toggleFavorite(ProductModel product);
}

class FavoriteRepositoryImpl extends FavoriteRepository {
  FavoriteRepositoryImpl(this._localService);

  final FavoriteLocalService _localService;

  @override
  Set<int> getFavoriteIds() => _localService.getFavoriteIds();

  @override
  List<ProductModel> getFavorites() {
    return _localService
        .getFavorites()
        .map(
          (item) => ProductModel(
            image: item.image,
            title: item.title,
            description: item.description,
            price: item.price,
            id: item.id,
            category: item.category,
          ),
        )
        .toList();
  }

  @override
  bool isFavorite(int productId) => _localService.isFavorite(productId);

  @override
  Future<void> toggleFavorite(ProductModel product) async {
    if (_localService.isFavorite(product.id)) {
      await _localService.removeFavorite(product.id);
    } else {
      await _localService.addFavorite(
        ProductHiveModel(
          image: product.image.cast<String>(),
          title: product.title,
          description: product.description,
          price: product.price,
          id: product.id,
          category: product.category,
        ),
      );
    }
  }
}
