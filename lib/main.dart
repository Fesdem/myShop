import 'package:flutter/material.dart';
import 'package:flutter_complete_guide_shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import '../screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import 'screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './providers/orders.dart';
import 'screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products('', '', []),
              update: (ctx, auth, previousProducts) =>
                  Products(auth.token, auth.userId, previousProducts!.items)),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('', '', []),
              update: (ctx, auth, previousOrders) =>
                  Orders(auth.token, auth.userId, previousOrders!.orders)),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              title: 'MyShop',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.orange[600],
                primarySwatch: Colors.purple,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }),
              ),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                OrdersScreen.routeName: (context) => const OrdersScreen(),
                UserProductScreen.routeName: (context) => UserProductScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            );
          },
        ));
  }
}
