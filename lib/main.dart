import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/utils/custom_route.dart';
import 'package:shop/views/auth_home.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/products_screen.dart';
import './utils/app_routes.dart';
import 'package:provider/provider.dart';
import './views/product_datail_screen.dart';
import './providers/products.dart';
import './providers/auth.dart';

import './views/orders_screen.dart';
import './views/product_form_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          update: (ctx, auth, previusProducts) => new Products(
            auth.token,
            auth.userId,
            previusProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => new Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (ctx, auth, previusOrders) => new Orders(
            auth.token,
            auth.userId,
            previusOrders.items,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionsBuilder(),
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            },
          ),
        ),
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => AuthOrHome(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
