import 'package:flutter/material.dart';
import '../screens/history.dart';
import '../screens/pastorders.dart';

class Tabs extends StatefulWidget {
  static const routeName='tabs';
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
                icon: Icon(Icons.donut_large),
                text: 'Pending',
              ),
              Tab(
                icon: Icon(Icons.done_all),
                text: 'Confirmed',
              )
            ]),
          ),
          body: TabBarView(children: [
         PastOrdersScreen(), OngoingOrders(),
          ]),
        ));
  }
}