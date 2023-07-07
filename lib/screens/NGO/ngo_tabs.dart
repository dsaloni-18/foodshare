import 'package:flutter/material.dart';
import 'package:foodshare/screens/NGO/ngo_ongoing_order.dart';
import 'package:foodshare/screens/NGO/ngo_past_orders.dart';


class NGOTabs extends StatefulWidget {
  static const routeName='ngo-tabs';

  const NGOTabs({super.key});
  @override
  _NGOTabsState createState() => _NGOTabsState();
}

class _NGOTabsState extends State<NGOTabs> {
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
            NgoPastOrdersScreen(),NgoOngoingOrders(),
        
          ]),
        ));
  }
}