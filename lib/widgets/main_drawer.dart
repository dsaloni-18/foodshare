import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/tabs.dart';

class MainDrawer extends StatelessWidget {
  int value = 0;

  MainDrawer({super.key});
  Widget buildListTile(String title, Function tapHandler, Icon symbol) {
    return ListTile(
      leading: symbol,
      title: Text(title),
      onTap: () {},
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
                    'Hello Reciever',
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
            color: Colors.black38,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: const Icon(
                Icons.history,
                color: Colors.white,
                size: 26,
              ),
              title: const Text('Your Orders',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Tabs.routeName);
              },
            ),
          ),
          const Divider(color: Colors.black),
          Container(
            color: Colors.black87,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 26,
              ),
              title: const Text('Logout',
                  style: TextStyle(
                      color: Colors.white,
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
