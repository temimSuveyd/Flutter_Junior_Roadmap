part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

final class ProductsRequested extends ProductEvent {}

final class ProductsLoadMore extends ProductEvent {}

final class CategoryRequested extends ProductEvent {}

final class CategorySelected extends ProductEvent {
  CategorySelected(this.categoryId);
  final int? categoryId;
}
