import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothingapp/providers/products.dart';
import 'package:clothingapp/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
            //create: (cot) => products[i],
            value: products[i],
            child: ProductItem(
                // products[i].id, products[i].title, products[i].imageUrl),
                )));
  }
}
