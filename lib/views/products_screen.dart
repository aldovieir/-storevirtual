import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../providers/products.dart';
import '../widget/products_item.dart';
import '../utils/app_routes.dart';

class ProductsScreen extends StatelessWidget {
  Future<void> _refreshproducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Gerenciador de Prrodutos'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshproducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[
                ProductsItem(products[i]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
