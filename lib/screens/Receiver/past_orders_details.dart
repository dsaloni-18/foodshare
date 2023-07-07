// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'receiver_home_screen.dart';

//import './confirm_order_screen.dart';
class PastOrderDetailScreen extends StatefulWidget {
  static const routeName = 'pastorders-detail-screen';

  const PastOrderDetailScreen({super.key});

  @override
  _PastOrderDetailScreenState createState() => _PastOrderDetailScreenState();
}

class _PastOrderDetailScreenState extends State<PastOrderDetailScreen> {
  Map userData = {};
  bool isLoading = false;
  var hasTimerStopped = false;

  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context)?.settings.arguments as Map;
    final rangeNumber = userData['range'].toString();
    DateTime time1 = userData['date'].toDate();
   var date1=DateTime(time1.year, time1.month, time1.day,time1.hour, time1.minute);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blueAccent,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                color: Colors.red,
                child: TextButton(
                    onPressed: () async {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            content: const Text('Are you sure?'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      final user = await FirebaseAuth
                                          .instance
                                          .currentUser;
                                      await FirebaseFirestore.instance
                                          .collection('donors')
                                          .doc(userData['userId'])
                                          .collection('orders')
                                          .doc(userData['id'])
                                          .update({
                                        'status': false,
                                        'orderconfirmed':
                                            "Not yet Confirmed",
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('receiver')
                                          .doc(user?.uid)
                                          .collection('past orders')
                                          .doc(userData['id'])
                                          .delete();
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(userData['id'])
                                          .update({
                                        'status': false,
                                      });
                                      Navigator.of(context).popAndPushNamed(
                                          ReceiverHomeScreen.routeName);
                                    } on PlatformException catch (err) {
                                      var message =
                                          'An error occurred, pelase check your credentials!';

                                      if (err.message != null) {
                                        message = err.message!;
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                                title: const Text(
                                                    "Oops something went wrong"),
                                                content: FittedBox(
                                                    child: Column(
                                                        children: <Widget>[
                                                      Text(err.message ==
                                                              null
                                                          ? "sorry for incovinience"
                                                          : message),
                                                      IconButton(
                                                          icon: const Icon(Icons
                                                              .arrow_back),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          })
                                                    ])));
                                          });

                                      print(err.message);
                                    } catch (err) {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                                title: const Text(
                                                    "Oops something went wrong"),
                                                content: FittedBox(
                                                    child: Column(
                                                        children: <Widget>[
                                                      const Text(
                                                          "Sorry for the inconvinience"),
                                                      IconButton(
                                                          icon: const Icon(Icons
                                                              .arrow_back),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          })
                                                    ])));
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
                                child: const Text('No',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ));
                },
                    child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                )
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                color: Colors.green,
                child: TextButton(
                    onPressed: () async {
                      try {
                        final user = await FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection('receiver')
                            .doc(user?.uid)
                            .collection('past orders')
                            .doc(userData['id'])
                            .update({
                          'finished': true,
                          'date': DateTime.now(),
                        });
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text('Thank You!'),
                                content: FittedBox(
                                  child: Column(
                                    children: <Widget>[
                                      const Text("Thank you for helping us!"),
                                      IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: () {

                                            Navigator.of(context)
                                                .popAndPushNamed(
                                                ReceiverHomeScreen.routeName);
                                          })
                                    ],
                                  ),
                                ),
                              );
                            });
                      } on PlatformException catch (err) {
                        var message =
                            'An error occurred, please check your credentials!';

                        if (err.message != null) {
                          message = err.message!;
                        }
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                  title: const Text("Oops something went wrong"),
                                  content: FittedBox(
                                      child: Column(children: <Widget>[
                                        Text(err.message == null
                                            ? "sorry for incovinience"
                                            : message),
                                        IconButton(
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            })
                                      ])));
                            });

                        print(err.message);
                      } catch (err) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                  title: const Text("Oops something went wrong"),
                                  content: FittedBox(
                                      child: Column(children: <Widget>[
                                        const Text("Sorry for the inconvinience"),
                                        IconButton(
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            })
                                      ])));
                            });
                      }
                    },
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const  <Widget>[
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          'RECEIVED',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
             ListTile(
              title: const Text('Donor: ',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['donorName'],
                  style: const TextStyle(fontSize: 20)),
            ), const Divider(thickness: 5,),
          ListTile(
              title: const Text('Email:',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['email'],
                  style: const TextStyle(fontSize: 20)),
            ), const Divider(thickness: 5,),
            ListTile(
              title: const Text('Contact',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['contact'].toString(),
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(thickness: 5,),
            ListTile(
              title: const Text(
                'Type:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                userData['isVeg'] ? 'Vegetarian' : 'Non-Vegetarian',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              title: const Text('Range:',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text('Serves nearly $rangeNumber ',
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              title: const Text('Food Description:',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['foodDescription'],
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              title: const Text('Address:',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle:
              Text(userData['address'], style: const TextStyle(fontSize: 20)),
            ),
            const Divider(
              thickness: 4,
            ),
              ListTile(
            title: const Text('Expired on:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            subtitle: Text(
            '$date1',
              style: TextStyle(fontSize: 20),
            ),)
          ],
        ));
  }
}
