part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}

final class FavoritesLoaded extends FavoriteEvent {}

final class FavoriteToggled extends FavoriteEvent {
  FavoriteToggled(this.product);
  final ProductModel product;
}
