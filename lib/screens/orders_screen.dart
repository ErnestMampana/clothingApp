import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothingapp/providers/auth.dart';
import 'package:clothingapp/providers/orders.dart' show Orders;
import 'package:clothingapp/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetMethod();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      //appBar: AppBar(title: Text('Your Orders')),
      //drawer: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          // : ListWheelScrollView(itemExtent: 250, children: OrderItem(orderData.orders[index]))
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (cont, index) => OrderItem(orderData.orders[index])),
    );
  }
}
