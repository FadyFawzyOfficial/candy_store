part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorite extends FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final ProductListItem item;

  const AddFavorite({required this.item});

  @override
  List<Object> get props => [item];
}

class RemoveFavorite extends FavoriteEvent {
  final String id;

  const RemoveFavorite({required this.id});

  @override
  List<Object> get props => [id];
}
