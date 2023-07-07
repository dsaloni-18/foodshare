import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'yourorder.dart';

// ignore: must_be_immutable
class MainDrawer1 extends StatelessWidget {
  int value = 0;

  MainDrawer1({super.key});
  // final receiverName;
  //MainDrawer(this.receiverName);

  Widget buildListTile(String title, VoidCallback tapHandler, Icon symbol) {
    return ListTile(
      leading: symbol,
      title: Text(title),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
      
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.only(top: 120, left: 10),
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               Row(children: const [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Hello Donor !',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ]),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
         Container(
            color: Colors.blue[200],
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: const Icon(
                Icons.history,
                color: Colors.black,
                size: 26,
              ),
              title: const Text('Your Orders',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyOrders.routeName);
              },
            ),
          ),
          const Divider(color: Colors.white),
           Container(
            color: Colors.blue[300],
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 26,
              ),
              title: const Text('Logout',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                value = 1;
                if (value == 1) {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                }
              },
            ),
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }
}
