import 'package:flutter/cupertino.dart';
import 'package:shopping_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double amount) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          amount: amount,
          dateTime: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }
}
