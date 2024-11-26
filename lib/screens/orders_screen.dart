import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders';

  // We did not make use of an int state or a didChangeDependencies because we can use a 
  // FutureBuilder, which is way better for handling the future property and the server
  // request.

  // var _isInit = true;
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.error.toString() == 'type \'Null\' is not a subtype of type \'Map<String, dynamic>\' in type cast') {
                return const Center(
                  child: Text('Your Order\'s list is empty.'),
                );
              } 
              else {
                if (snapshot.error != null) {
                  print(snapshot.error);
                  // throw HttpException('Something went wrong. Try again');
                  return const Center(
                    child: Text('An error occured'),
                  );
                  
                } else {
                  return Consumer<Orders>(builder: (ctx, orderData, child) =>  ListView.builder(
                      itemBuilder: (ctx, index) =>
                          OrderItem(orderData.orders[index]),
                      itemCount: orderData.orders.length,),
                    );
                }
              }
            }));
  }
}
