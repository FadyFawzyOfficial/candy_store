part of 'favorite_bloc.dart';

class FavoriteState extends Equatable {
  final List<ProductListItem> items;

  const FavoriteState({required this.items});

  FavoriteState copyWith({List<ProductListItem>? items}) =>
      FavoriteState(items: items ?? this.items);

  @override
  List<Object> get props => [items];
}
