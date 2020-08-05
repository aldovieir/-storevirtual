import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/app_routes.dart';
import '../widget/badge.dart';
import 'package:shop/widget/product_grid.dart';
import '../providers/products.dart';
import '../widget/app_drawer.dart';

enum FilterOpitions {
  All,
  Favorite,
}

class ProductOverviewSreen extends StatefulWidget {
  @override
  _ProductOverviewSreenState createState() => _ProductOverviewSreenState();
}

class _ProductOverviewSreenState extends State<ProductOverviewSreen> {
  bool _isLoanding = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoanding = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOpitions selectedvalue) {
              if (selectedvalue == FilterOpitions.Favorite) {
                products.showFavoriteOnly();
              } else {
                products.showAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos!'),
                value: FilterOpitions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOpitions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: _isLoanding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(),
      drawer: AppDrawer(),
    );
  }
}
