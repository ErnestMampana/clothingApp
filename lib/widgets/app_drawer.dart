import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Drawer'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed('/orders_screen');
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed('/pruduct_item_screen');
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.power_settings_new_outlined),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushNamed('/pruduct_item_screen');
              //Provider.of<Auth>(context, listen: false).logout();
            })
      ]),
    );
  }
}
