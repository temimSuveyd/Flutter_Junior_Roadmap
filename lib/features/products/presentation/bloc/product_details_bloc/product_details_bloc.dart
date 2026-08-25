import 'package:bloc/bloc.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:meta/meta.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {

  ProductDetailsBloc(
    this._repository, {
    this.product,
    this.productId,
  }) : super(ProductDetailsInitial()) {
    on<ProductDetailsRequested>(_onRequested);
  }
  final ProductRepository _repository;
  final ProductModel? product;
  final int? productId;

  Future<void> _onRequested(
    ProductDetailsRequested event,
    Emitter<ProductDetailsState> emit,
  ) async {
    if (product != null) {
      emit(ProductDetailsLoaded(product!));
      return;
    }
    if (productId == null) {
      emit(ProductDetailsError('Product not found.'));
      return;
    }

    emit(ProductDetailsLoading());
    final result = await _repository.getProductById(productId!);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(ProductDetailsLoaded(data));
      case Error(:final error):
        emit(ProductDetailsError(error.message));
    }
  }
}
