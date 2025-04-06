import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_service.dart';
import 'app_product_repository.dart';
import 'delayed_result.dart';
import 'hive_service.dart';
import 'local_product_repository.dart';
import 'network_product_repository.dart';
import 'product_list_item.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  late final _productRepository = AppProductRepository(
    remoteDataSource: NetworkProductRepository(ApiService()),
    localProductRepository:
        LocalProductRepository(HiveService().getProductBox()),
  );

  ProductsBloc() : super(const ProductsState()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      final products = await _productRepository.fetchProduct();
      emit(
        state.copyWith(
          items: products
              .map(
                (p) => ProductListItem(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                  price: p.price,
                  imageUrl: p.imageUrl,
                ),
              )
              .toList(),
        ),
      );
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (e) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(e)));
    }
  }
}
