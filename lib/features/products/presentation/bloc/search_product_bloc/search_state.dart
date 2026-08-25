part of 'search_bloc.dart';

@immutable
sealed class SearchProductState {}

final class SearchInitial extends SearchProductState {}

final class SearchLoading extends SearchProductState {}

final class SearchError extends SearchProductState {
  SearchError(this.message);
  final String message;
}

final class SearchEmpty extends SearchProductState {}

final class SearchLoaded extends SearchProductState {
  SearchLoaded(this.products);
  final List<ProductModel> products;
}
