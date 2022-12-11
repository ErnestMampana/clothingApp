import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NavigationBarCurved extends StatefulWidget {
  const NavigationBarCurved({Key? key}) : super(key: key);

  @override
  State<NavigationBarCurved> createState() => _NavigationBarCurvedState();
}

class _NavigationBarCurvedState extends State<NavigationBarCurved> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //int _page = 2;
  int index = 2;
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      // extendBody: true,
      color: Colors.purpleAccent,
      buttonBackgroundColor: Colors.blueAccent,
      //animationDuration: ,
      backgroundColor: Colors.transparent,
      items: const <Widget>[
        Icon(Icons.settings, size: 30),
        Icon(Icons.favorite, size: 30),
        Icon(Icons.home, size: 30),
        Icon(Icons.search, size: 30),
        Icon(Icons.shopping_cart, size: 30)
      ],
      index: index,
      onTap: (index) {
        setState(() {
          if (index == 4) {
            Navigator.of(context).pushNamed('/cart_screen');
          }
          //_page = index;
        });
      },
    );
  }
}
