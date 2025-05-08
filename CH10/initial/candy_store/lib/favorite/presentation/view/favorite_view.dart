import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/presentation/widget/product_list_item_view.dart';
import '../../domain/repository/favorite_repository.dart';
import '../bloc/favorite_bloc.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocProvider(
        create: (context) =>
            FavoriteBloc(favoriteRepository: context.read<FavoriteRepository>())
              ..add(LoadFavorite()),
        child: const FavoriteViewBody(),
      ),
    );
  }
}

class FavoriteViewBody extends StatelessWidget {
  const FavoriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final items = state.items;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => ProductListItemView(
            item: items[index],
            // ToDo: Need to to refactor it
            onAddToCart: (item) {},
          ),
        );
      },
    );
  }
}
