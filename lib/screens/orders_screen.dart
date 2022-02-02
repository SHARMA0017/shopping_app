// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/orderItem.dart' as oi;

class OrderScreen extends StatelessWidget {
  static const routeName = 'OrderScreen';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (context, i) {
            return oi.OrderItem(orders.orders[i]);
          },
          itemCount: orders.orders.length,
        ));
  }
}
