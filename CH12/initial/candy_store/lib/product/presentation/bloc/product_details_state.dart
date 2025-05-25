part of 'product_details_bloc.dart';

class ProductDetailsState extends Equatable {
  final ProductListItem item;
  final bool isFavorite;

  const ProductDetailsState({required this.item, required this.isFavorite});

  ProductDetailsState copyWith({
    ProductListItem? item,
    bool? isFavorite,
  }) {
    return ProductDetailsState(
      item: item ?? this.item,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [item, isFavorite];
}
