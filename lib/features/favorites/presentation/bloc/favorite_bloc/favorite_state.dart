part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState {
  const FavoriteState({this.favoriteIds = const {}});
  final Set<int> favoriteIds;
}

final class FavoriteInitial extends FavoriteState {
  const FavoriteInitial({super.favoriteIds});
}

final class FavoritesEmpty extends FavoriteState {
  const FavoritesEmpty({super.favoriteIds});
}

final class FavoritesLoadedState extends FavoriteState {
  const FavoritesLoadedState({
    required this.favorites,
    super.favoriteIds,
  });

  final List<ProductModel> favorites;
}
