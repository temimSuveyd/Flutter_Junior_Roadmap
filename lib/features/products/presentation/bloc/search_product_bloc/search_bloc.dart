import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/errors/result.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repositories.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchProductState> {

  SearchBloc(this._productRepository) : super(SearchInitial()) {
    on<Search>(
      _onProductsSearch,
      transformer: debounceAndRestartable(const Duration(milliseconds: 350)),
    );
  }
  final ProductRepository _productRepository;



  // ignore: avoid_types_as_parameter_names
  EventTransformer<SearchEvent> debounceAndRestartable<SearchEvent>(
    Duration duration,
  ) {
    return (events, mapper) =>
        restartable<SearchEvent>().call(events.debounce(duration), mapper);
  }

  Future<void> _onProductsSearch(
    Search event,
    Emitter<SearchProductState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchInitial());
    }
    if (query.length < 2) {
      return;
    }
    emit(SearchLoading());

    final result = await _productRepository.searchProducts(query);
    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(data));
        }
      case Error(:final error):
        emit(SearchError(error.message));
    }
  }
}
