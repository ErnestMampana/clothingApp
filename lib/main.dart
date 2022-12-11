import 'package:clothingapp/providers/auth.dart';
import 'package:clothingapp/providers/cart.dart';
import 'package:clothingapp/providers/orders.dart';
import 'package:clothingapp/providers/products.dart';
import 'package:clothingapp/screens/auth_screen.dart';
import 'package:clothingapp/screens/cart_screen.dart';
import 'package:clothingapp/screens/edit_product_screen.dart';
import 'package:clothingapp/screens/orders_screen.dart';
import 'package:clothingapp/screens/product_detail_screen.dart';
import 'package:clothingapp/screens/products_overview_screen.dart';
import 'package:clothingapp/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (BuildContext context) => Products('', [], ''),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider(create: (BuildContext context) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (BuildContext context) => Orders('', '', []),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              '/product_detail': (context) => ProductDetailScreen(),
              '/cart_screen': (context) => CartScreen(),
              '/orders_screen': (context) => OrdersScreen(),
              '/pruduct_item_screen': (context) => UserProductScreen(),
              '/edit_product_screen': (context) => EditProductScreen(),
            },
          ),
        ));
    //   extendBody: true,
    //   bottomNavigationBar: CurvedNavigationBar(
    //     //color: Colors.purpleAccent,
    //     //buttonBackgroundColor: Colors.blueAccent,
    //     //animationDuration: ,
    //     backgroundColor: Colors.transparent,
    //     items: const <Widget>[
    //       Icon(Icons.favorite, size: 30),
    //       Icon(Icons.search, size: 30),
    //       Icon(Icons.home, size: 30),
    //       Icon(Icons.settings, size: 30),
    //       Icon(Icons.person, size: 30)
    //     ],
    //     index: index,
    //     onTap: (index) {
    //       setState(() {
    //         _page = index;
    //       });
    //     },
    //   ),
    //   body: Container(
    //     color: Colors.greenAccent,
    //     child: Center(
    //         child: Column(
    //       children: [
    //         Text(_page.toString(), textScaleFactor: 10.0),
    //         // ElevatedButton(
    //         //   child: Text('Go To Page of index 1'),
    //         //   onPressed: () {
    //         //     //Page change using state does the same as clicking index 1 navigation button
    //         //     final CurvedNavigationBarState? navBarState =
    //         //         _bottomNavigationKey.currentState;
    //         //     navBarState?.setPage(1);
    //         //   },
    //         // )
    //       ],
    //     )),
    //   ),
    //   // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}
