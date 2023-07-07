//import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/orders.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersList extends StatefulWidget {
  final List<Orders> ord;
  const OrdersList(this.ord, {super.key});
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.white]),
      ),
      height: MediaQuery.of(context).size.height*0.78,
      child: FutureBuilder(
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
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text("nothing there",
                          style: TextStyle(color: Colors.white)),
                    );
                  }
                  final documents = snapshot.data?.docs;              
                  return snapshot.data!.docs.isEmpty
                      ? const Center(
                    child: Text('No donations available!',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                  )
                      : ListView.builder(
                        scrollDirection: Axis.vertical,
                      itemCount: documents?.length,
                      itemBuilder: (ctx, i) {
                        DateTime date = documents?[i]['time'].toDate();
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[                           
                              Card(                             
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(18),
                                      side: const BorderSide(
                                          color: Colors.black, width: 0.0)),
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
                                              ' ${documents?[i]['range']}',
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
                                              ' ${documents?[i]['veg'] ? 'Veg' : 'NonVeg'}',
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
                                          contentPadding: const EdgeInsets.all(0),
                                          leading: const Text(
                                            'Description:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          title: Text(
                                            ' ${documents?[i]['description']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),                                 
                                        ),
                                        const Divider(color: Colors.black),
                                        ListTile(
                                          contentPadding: const EdgeInsets.all(0),
                                          leading: const Text(
                                            'Order Confirmed by:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          title: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.35,
                                            child: Text(
                                              ' ${documents?[i]['orderconfirmed']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 5)
                            ],
                          ),
                        );
                      });
                });
          }),
    );
    //);
  }
}
