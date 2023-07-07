
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'add_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_list.dart';
import '../../models/orders.dart';
import 'drawer2.dart';

class DonorMain extends StatefulWidget {
  static const routeName = '/donor-main';

  const DonorMain({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DonorMainState createState() => _DonorMainState();
}

class _DonorMainState extends State<DonorMain> {
  int value = 0;
  late UserCredential authResult;
  final List<Orders> _loadedOrders = [
    Orders(
      range: 2,
      isVeg: true,
      description: 'Roti', date: DateFormat(),
    )
  ];

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'FoodShare',
          style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        // ),
      ),
      drawer: MainDrawer1(),
     
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 10,),
            Container(
              color: Colors.cyan[50],
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    ' Your Donations: ',
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.black),
            OrdersList(_loadedOrders),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
            color: Colors.blueAccent,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddOrder.routeName);
                },
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const  <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      'Donate Now',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ))),
      ),
    );
  }
}
