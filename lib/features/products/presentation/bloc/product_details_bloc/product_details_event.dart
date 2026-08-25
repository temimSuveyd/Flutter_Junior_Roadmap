part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsEvent {}

final class ProductDetailsRequested extends ProductDetailsEvent {}
