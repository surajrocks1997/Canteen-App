import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('INR ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 800),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: min(widget.order.meals.length * 80.0, 240),
              child: ListView(
                children: widget.order.meals
                    .map((meal) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(meal.imageUrl),
                            radius: 40,
                          ),
                          title: Text(meal.title),
                          subtitle: Text('${meal.quantity}x'),
                          trailing: Text('INR ' + ((meal.price)*(meal.quantity)).toString()),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
