import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import '../providers/product.dart';
import '../utils/app_routes.dart';
import '../exception/http_exception.dart';

class ProductsItem extends StatelessWidget {
  final Product product;
  ProductsItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir produto'),
                    content: Text('Tem Certeza!'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                    ],
                  ),
                ).then(
                  (value) async {
                    if (value) {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(product.id);
                      } on HttpException catch (erro) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(erro.toString()),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
