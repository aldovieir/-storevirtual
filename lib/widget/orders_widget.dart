import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart';
import 'package:intl/intl.dart';

class OrdersWidget extends StatefulWidget {
  final Order order;
  OrdersWidget(this.order);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeigth = (widget.order.products.length * 25.0) + 10;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? itemsHeigth + 92 : 92,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh.mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: _expanded ? itemsHeigth : 0,
              child: ListView(
                children: widget.order.products.map((products) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        products.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${products.quantity} x R\$ ${products.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
