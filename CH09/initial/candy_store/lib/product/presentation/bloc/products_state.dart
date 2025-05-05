part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<ProductListItem> items;
  final DelayedResult<void> loadingResult;

  const ProductsState({
    this.items = const [],
    this.loadingResult = const DelayedResult.idle(),
  });

  ProductsState copyWith({
    List<ProductListItem>? items,
    DelayedResult<void>? loadingResult,
  }) {
    return ProductsState(
      items: items ?? this.items,
      loadingResult: loadingResult ?? this.loadingResult,
    );
  }

  @override
  List<Object> get props => [items, loadingResult];
}
