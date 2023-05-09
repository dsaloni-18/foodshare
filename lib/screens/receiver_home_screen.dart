// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import './confirm_order_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReceiverHomeScreen extends StatefulWidget {
  static const routeName = 'receiver-home-screen';
  @override
  _ReceiverHomeScreenState createState() => _ReceiverHomeScreenState();
}

enum problems { badqualityfood, badservice, latedeliveries }

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  void initState() {
    count = 0;
    super.initState();
  }

  problems selectedButton = problems.badqualityfood;
  List<String> filterKeys = [];
  List<int> rangeKeys = [];
  bool isRange0 = false;
  bool isRange1 = false;
  bool isRange2 = false;
  bool isRange3 = false;
  bool isLoading = false;
  bool vegIsChecked = false;
  bool status = false;
  bool isConfirm = false;
  late int count;

  Widget getDonorTile(int i, final documents) {
    final rangenumber = documents[i]['range'];
    DateTime date = documents[i]['date'].toDate();
    var formattedDate = DateFormat.MMMd().format(date);
    var formattedDate1 = DateFormat.Hm().format(date);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        
        child: Column(
          children: <Widget>[
            Container(
              child: Card(
                elevation: 2.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(3),
                color: Colors.white,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Icon(
                            Icons.account_circle,
                            size: 60,
                            color: Colors.grey,
                          ),
                          Container(
                            // width:MediaQuery.of(context).size.width*0.26,
                            child: Expanded(
                              child: Text(
                                documents[i]['username'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.verified_user,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(documents[i]['typeofdonor'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.fastfood,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(documents[i]['description'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                      Row(children: [
                        const Icon(
                          Icons.supervised_user_circle,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Serves $rangenumber',
                          style: const TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6),
                        documents[i]['isVeg']
                            ? CircleAvatar(
                                backgroundColor: Colors.green[900],
                                radius: 8,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 8,
                              )
                      ]),
                      Row(children: [
                        const Icon(
                          Icons.watch,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Available for pickup uptil $formattedDate,$formattedDate1',
                          style: const TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton.icon(
                            icon: const Icon(
                              Icons.check,
                              color: Colors.black,
                            ),
                            //icon: Colors.green,
                            onPressed: () {
                              orderConfirm(context, documents, i);
                            },
                            label: const Text(
                              'Confirm Order',
                              style: TextStyle(color: Colors.green),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.020)
          ],
        ),
      ),
    );
  }

  Future? orderConfirm(BuildContext context, var documents, var i) {
    if (isLoading) {
      return null;
    } else {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: const Text('Are you sure?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          final user = FirebaseAuth.instance.currentUser;
                          var user11 = await FirebaseFirestore.instance
                              .collection('receiver')
                              .doc(user?.uid)
                              .get();
                          String username1 = user11['username'];
                          await FirebaseFirestore.instance
                              .collection('receiver')
                              .doc(user?.uid)
                              .collection('past orders')
                              .doc(documents[i]['id'])
                              .set({
                            'username': documents[i]['username'],
                            'address': documents[i]['address'],
                            'typeofdonor': documents[i]['typeofdonor'],
                            'isVeg': documents[i]['isVeg'],
                            'range': documents[i]['range'],
                            'foodDescription': documents[i]['description'],
                            'donorName': documents[i]['donorName'],
                            'contact': documents[i]['contact'],
                            'email': documents[i]['email'],
                            'date': documents[i]['date'],
                            'time': DateTime.now(),
                            'finished': true,
                            'id': documents[i]['id'],
                            'userId': documents[i]['userId']
                          });

                          Navigator.of(context).pushNamed(
                              ConfirmOrderScreen.routeName,
                              arguments: {
                                'status': documents[i]['status'],
                                'id': documents[i]['id'],
                                'userId': documents[i]['userId'],
                                'receiverId': user?.uid
                              });
                          await FirebaseFirestore.instance
                              .collection('donors')
                              .doc(documents[i]['userId'])
                              .collection('orders')
                              .doc(documents[i]['id'])
                              .update({
                            'status': true,
                            'orderconfirmed': username1,
                          });
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(documents[i]['id'])
                              .update({
                            'status': true,
                          }).then((_) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        } on PlatformException catch (err) {
                          String? message =
                              'An error occurred, pelase check your credentials!';

                          if (err.message != null) {
                            message = err.message;
                          }
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                    title:
                                        const Text("Oops something went wrong"),
                                    content: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.129,
                                        child: Column(children: <Widget>[
                                          Text(
                                            err.message ??
                                                "sorry for incovinience",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          IconButton(
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              })
                                        ])));
                              });

                          setState(() {
                            isLoading = false;
                          });
                          print(err.message);
                        } catch (err) {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                    title:
                                        const Text("Oops something went wrong"),
                                    content: FittedBox(
                                        child: Column(children: <Widget>[
                                      const Text("sorry for incovinience"),
                                      IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          })
                                    ])));
                              });

                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text('No', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.blueAccent,
          title: const Text('FoodShare'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width * 0.64,
                  child: SizedBox(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.25,
                      width: double.infinity,
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    const Positioned(
                        top: 50,
                        left: 60,
                        child: Center(
                          child: Text('No donations available!',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.58,
                      width: double.infinity,
                      child: (filterKeys.isEmpty &&
                              (rangeKeys.isEmpty || rangeKeys.contains(0)))
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder: (ctx, streamSnapshot) {
                                if (streamSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                                final documents = streamSnapshot.data?.docs;

                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                                backgroundColor: Colors.black),
                                          )
                                        : Container(
                                            child: ListView.builder(

                                                //shrinkWrap: true,
                                                itemBuilder: (ctx, i) {
                                                  DateTime date2 = documents?[i]
                                                          ['date']
                                                      .toDate();

                                                  if (date2.isBefore(
                                                      DateTime.now())) {
                                                    FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .doc(
                                                            documents?[i]['id'])
                                                        .delete();
                                                  }
                                                  if (documents?[i]['status'] ==
                                                      true) {
                                                    return const SizedBox(
                                                        height: 0, width: 0);
                                                  }

                                                  return getDonorTile(
                                                      i, documents);
                                                },
                                                itemCount: documents?.length),
                                          ),
                                  ),
                                );
                              },
                            )
                          : const SizedBox(height: 0,), 
                        
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
