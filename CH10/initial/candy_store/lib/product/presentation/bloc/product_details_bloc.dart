import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/product_list_item.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc({
    required ProductListItem item,
  }) : super(ProductDetailsState(item: item, isFavorite: false)) {
    on<ProductDetailsEvent>((event, emit) {});
  }
}
