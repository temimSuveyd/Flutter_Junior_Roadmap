import 'package:bloc/bloc.dart';
import 'package:juniorflutterroadmap/features/favorites/data/repositories/favorite_repository.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc(this._repository) : super(const FavoriteInitial()) {
    on<FavoritesLoaded>(_onFavoritesLoaded);
    on<FavoriteToggled>(_onFavoriteToggled);
  }

  final FavoriteRepository _repository;

  Future<void> _onFavoritesLoaded(
    FavoritesLoaded event,
    Emitter<FavoriteState> emit,
  ) async {
    final favorites = _repository.getFavorites();
    final favoriteIds = _repository.getFavoriteIds();
    if (favorites.isEmpty) {
      emit(FavoritesEmpty(favoriteIds: favoriteIds));
    } else {
      emit(FavoritesLoadedState(
        favorites: favorites,
        favoriteIds: favoriteIds,
      ));
    }
  }

  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    await _repository.toggleFavorite(event.product);
    final favorites = _repository.getFavorites();
    final favoriteIds = _repository.getFavoriteIds();
    if (favorites.isEmpty) {
      emit(FavoritesEmpty(favoriteIds: favoriteIds));
    } else {
      emit(FavoritesLoadedState(
        favorites: favorites,
        favoriteIds: favoriteIds,
      ));
    }
  }
}
