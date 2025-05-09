import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favorite/domain/repository/favorite_repository.dart';
import '../../domain/model/product_list_item.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final FavoriteRepository _favoriteRepository;
  ProductDetailsBloc({
    required FavoriteRepository favoriteRepository,
    required ProductListItem item,
  })  : _favoriteRepository = favoriteRepository,
        super(ProductDetailsState(item: item, isFavorite: false)) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final isFavorite = await _favoriteRepository.isFavorite(state.item.id);
    emit(state.copyWith(isFavorite: isFavorite));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final isFavorite = state.isFavorite;
    emit(state.copyWith(isFavorite: !isFavorite));
    if (isFavorite) {
      await _favoriteRepository.removeFavorite(state.item.id);
    } else {
      await _favoriteRepository.addFavorite(state.item);
    }
  }
}
