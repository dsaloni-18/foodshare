// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrders extends StatelessWidget {
  static const routeName = 'past-orders-screen1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent, title: const Text('My Donations')),
      body: Container(
     
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blueAccent,Colors.white,Colors.black],begin: Alignment.topCenter,end: Alignment.bottomCenter)
        ),
       padding:const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<User>(
            future: Future.value(FirebaseAuth.instance.currentUser),
            builder: (ctx, snapshot1) {
              if (snapshot1.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                );
              }
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('donors')
                      .doc(snapshot1.data?.uid)
                      .collection('orders')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return snapshot.data!.docs.isEmpty
                        ? const Center(
                      child: Text('No donations available!',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                    )
                        : ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (ctx, i) {
                          DateTime date = docs[i]['time'].toDate();
                          return Column(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Dismissible(
                                      key: ValueKey(docs[i]['id']),
                                      background: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(18),
                                          color: Theme.of(context).errorColor,
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 4,
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) {
                                        return showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text(
                                              'Do you want to remove the item from the cart?',
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(false);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(
                                                      docs[i]['id'])
                                                      .delete();
                                                  FirebaseFirestore.instance
                                                      .collection('donors')
                                                      .doc(
                                                      snapshot1.data?.uid)
                                                      .collection('orders')
                                                      .doc(
                                                      docs[i]['id'])
                                                      .delete();
                                                  Navigator.of(ctx).pop(true);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onDismissed: (direction) {},
                                      child: Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(18),
                                              side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 0.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    const Text(
                                                      'Date: ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' ${DateFormat('yMMMd').format(date)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    const Text(
                                                      'Serves: ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' ${docs[i]['range']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    const Text(
                                                      'Category: ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' ${docs[i]['veg'] ? 'Veg' : 'NonVeg'}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                                ListTile(
                                                  contentPadding:
                                                  const EdgeInsets.all(0),
                                                  leading: const Text(
                                                    'Description:',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  title: Text(
                                                    ' ${docs[i]['description']}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const Divider(color: Colors.black),
                                                ListTile(
                                                  contentPadding:
                                                  const EdgeInsets.all(0),
                                                  leading: const Text(
                                                    'Order Confirmed by:',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  title: Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.35,
                                                    child: Text(
                                                      ' ${docs[i]['orderconfirmed']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Text(
                                                  'Range: ${docs[i]['range']}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  'Category: ${docs[i]['veg']?'Veg':'NonVeg'} ',
                                                  style: const TextStyle(fontSize: 20),
                                                ),
                                                Text(
                                                  'Description: ${docs[i]['description']}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  'OrderConfirmeby:${docs[i]['orderconfirmed']}',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(height: 5)
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                  });
            }),
      ),
    );
  }
}