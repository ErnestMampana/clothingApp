import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clothingapp/providers/cart.dart';
import 'package:clothingapp/providers/products.dart';
import 'package:clothingapp/screens/cart_screen.dart';
import 'package:clothingapp/screens/orders_screen.dart';
import 'package:clothingapp/widgets/app_drawer.dart';
import 'package:clothingapp/widgets/badge.dart';
import 'package:clothingapp/widgets/navigationBar.dart';

import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FiltereOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  int index = 2;
  bool _cardScreen = false;
  bool _ordersScreen = false;
  String _title = 'My Store';

  @override
  void initState() {
    // TODO: implement initState
    //Provider.of<Products>(context).fetchAndSetProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //const ProductOverviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title'),
        centerTitle: true,
        actions: [
          // PopupMenuButton(
          //   onSelected: (FiltereOptions selectedValue) {
          //     setState(() {
          //       if (selectedValue == FiltereOptions.Favorites) {
          //         _showFavoritesOnly = true;
          //       } else {
          //         _showFavoritesOnly = false;
          //       }
          //     });
          //   },
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('Only Favorites'),
          //       value: FiltereOptions.Favorites,
          //     ),
          //     PopupMenuItem(
          //       child: Text('Show All'),
          //       value: FiltereOptions.All,
          //     ),
          //   ],
          //   icon: Icon(Icons.more_vert),
          // ),
          // Consumer<Cart>(
          //   builder: (_, cart, ch) => Badge(
          //     child: ch as Widget,
          //     value: cart.itemCount.toString(),
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.shopping_cart,
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed('/cart_screen');
          //     },
          //   ),
          // ),
        ],
      ),
      drawer: AppDrawer(),
      //bottomNavigationBar: NavigationBarCurved(),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.purpleAccent,
        buttonBackgroundColor: Colors.blueAccent,
        //animationDuration: ,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          const Icon(Icons.person, size: 30),
          const Icon(Icons.favorite, size: 30),
          const Icon(Icons.home, size: 30),
          const Icon(Icons.payment, size: 30),
          Stack(
            children: [
              Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                  child: ch as Widget,
                  value: cart.itemCount.toString(),
                ),
                child: Icon(
                  Icons.shopping_cart,
                ),
              ),
              // Icon(
              //   Icons.shopping_cart,
              //   size: 30,
              // ),
            ],
          )
        ],
        index: index,
        onTap: (index) {
          setState(() {
            if (index == 2) {
              _cardScreen = false;
              _ordersScreen = false;
              _showFavoritesOnly = false;
              _title = 'My Store';
            }
            if (index == 1) {
              _cardScreen = false;
              _ordersScreen = false;
              _showFavoritesOnly = true;
              _title = 'Favourites';
            }
            if (index == 3) {
              _cardScreen = false;
              _title = 'Your Orders';
              _ordersScreen = true;
            }
            if (index == 4) {
              _ordersScreen = false;
              _cardScreen = true;
              _title = 'Shopping Cart';
            }
            // _page = index;
          });
        },
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _cardScreen
              ? CartScreen()
              : _ordersScreen
                  ? OrdersScreen()
                  : ProductsGrid(_showFavoritesOnly),
    );
  }
}
