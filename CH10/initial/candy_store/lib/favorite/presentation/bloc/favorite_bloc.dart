import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/domain/model/product_list_item.dart';
import '../../domain/repository/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;
  FavoriteBloc({required FavoriteRepository favoriteRepository})
      : _favoriteRepository = favoriteRepository,
        super(const FavoriteState(items: [])) {
    on<LoadFavorite>(_onLoadFavorite);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorite(LoadFavorite event, Emitter emit) async {
    final favorites = await _favoriteRepository.getFavorites();
    emit(state.copyWith(items: favorites));
  }

  Future<void> _onAddFavorite(AddFavorite event, Emitter emit) async {
    await _favoriteRepository.addFavorite(event.item);
    final favorites = await _favoriteRepository.getFavorites();
    emit(state.copyWith(items: favorites));
  }

  Future<void> _onRemoveFavorite(RemoveFavorite event, Emitter emit) async {
    await _favoriteRepository.removeFavorite(event.id);
    final favorites = await _favoriteRepository.getFavorites();
    emit(state.copyWith(items: favorites));
  }
}
