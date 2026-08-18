import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<ProductsRequested>(
      transformer: droppable(),
      _onProductsRequested,
    );
  }

  Future<void> _onProductsRequested(
    ProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final (failure, products) = await _productRepository.getProducts();
    if (failure != null) {
      emit(ProductError(failure.message));
    } else {
      emit(ProductLoaded(products ?? []));
    }
  }
}