// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../screens/ongoing_orders.dart';
class Tabs extends StatefulWidget {
  static const routeName='tabs';

  const Tabs({super.key});
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,//selects the default tab when the app opens
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text('Your Orders',style: TextStyle(color: Colors.white),),
            bottom: const TabBar(tabs: [
         
              Tab(
                icon: Icon(Icons.done_all),
                text: 'Past',
              )
            ]),
          ),
          body: TabBarView(children: [
      
          OngoingOrders(),
          ]),
        ));
  }
}