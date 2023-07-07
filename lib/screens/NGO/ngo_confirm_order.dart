

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodshare/screens/NGO/ngo_home_screen.dart';


class NGOConfirmOrder extends StatefulWidget {
  static const routeName = 'ngo-confirm-order-screen';

  const NGOConfirmOrder({super.key});

  @override
  _NGOConfirmOrderState createState() => _NGOConfirmOrderState();
}

class _NGOConfirmOrderState extends State<NGOConfirmOrder> {
  Map userData = {};
   Map orderData = {}; 

   @override
  void initState() {
    super.initState();
    fetchOrderData(); // Fetch the order details when the screen is initialized
  }
  Future<void> fetchOrderData() async {
    final orderId = userData['id'];
    final snapshot = await FirebaseFirestore.instance
        .collection('ngo')
        .doc(userData['NGOId'])
        .collection('past orders')
        .doc(orderId)
        .get();
    setState(() {
      orderData = snapshot.data() as Map;
    });
  }
  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Donation claimed successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const Center(
                child: Icon(Icons.check_circle_outline,
                    size: 150, color: Colors.green)),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 1000,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(NGOHomeScreen.routeName);
                  },
                  child: const Text(
                    'Continue Recieving',
                    style: TextStyle(fontSize: 15),
                  )),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              width: 1000,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('donors')
                        .doc(userData['userId'])
                        .collection('orders')
                        .doc(userData['id'])
                        .update({
                      'status': false,
                      'orderconfirmed': "Not yet Confirmed",
                    });
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(userData['id'])
                        .update({
                      'status': false,
                    });
                    await FirebaseFirestore.instance
                        .collection('ngo')
                        .doc(userData['NGOId'])
                        .collection('past orders')
                        .doc(userData['id'])
                        .delete();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .popAndPushNamed(NGOHomeScreen.routeName);
                  },
                  child: const Text(
                    'Cancel Donation',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
