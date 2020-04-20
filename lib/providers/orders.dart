import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> meals;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.meals,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<List<OrderItem>> fetchAndSetOrder() async {
    final url =
        'https://canteen-app-9667c.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return null;
    }

    extractedData.forEach((orderId, orderedData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderedData['amount'],
        meals: (orderedData['meals'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                  imageUrl: item['imageUrl'],
                ))
            .toList(),
        dateTime: DateTime.parse(orderedData['dateTime']),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    return orders;
    
  }

  Future<void> addOrder(List<CartItem> cartMeals, double total) async {
    final url =
        'https://canteen-app-9667c.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'meals': cartMeals
              .map((cartMeal) => {
                    'id': cartMeal.id,
                    'title': cartMeal.title,
                    'quantity': cartMeal.quantity,
                    'price': cartMeal.price,
                    'imageUrl': cartMeal.imageUrl,
                  })
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          meals: cartMeals,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
