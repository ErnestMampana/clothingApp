import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothingapp/providers/product.dart';
import 'package:clothingapp/providers/products.dart';
import 'package:clothingapp/widgets/user_product_item.dart';

class UserProductScreen extends StatefulWidget {
  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  //get i => null;
  var _isLoading = false;
  Future<void> _refreshProducts(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _refreshProducts(context);
    super.initState();
  }

  //const UserProductScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/edit_product_screen', arguments: 'newProduct');
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                              productData.items[i].id,
                              productData.items[i].title,
                              productData.items[i].imageUrl),
                          Divider(),
                        ],
                      )),
        ),
      ),
    );
  }
}
