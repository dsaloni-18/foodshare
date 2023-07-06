// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './confirm_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationDetailScreen extends StatefulWidget {
  static const routeName = 'donation-detail-screen';

  @override
  _DonationDetailScreenState createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  Map userData = {};
  bool isLoading = false;
  var hasTimerStopped = false;

  Future orderConfirm(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: const Text('Are you sure?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      try {
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
                            .doc(userData['id'])
                            .set({
                          'username': userData['username'],
                          'address': userData['address'],
                          'typeofdonor': userData['typeofdonor'],
                          'isVeg': userData['isVeg'],
                          'range': userData['range'],
                          'foodDescription': userData['foodDescription'],
                          'donorName': userData['donorName'],
                          'contact': userData['contact'],
                          'email': userData['email'],
                          'date': userData['date'],
                          'time': DateTime.now(),
                          'finished': false,
                          'id': userData['id'],
                          'userId': userData['userId']
                        });
                        Navigator.of(context).pushNamed(
                            ConfirmOrderScreen.routeName,
                            arguments: {
                              'status': userData['status'],
                              'id': userData['id'],
                              'userId': userData['userId'],
                              'receiverId': user?.uid
                            });
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(userData['id'])
                            .update({
                          'status': true,
                          'orderconfirmed': username1,
                        }).then((_) {
                          setState(() {
                            isLoading = false;
                          });
                        });
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
                                  title:
                                      const Text("Oops something went wrong"),
                                  content: FittedBox(
                                      child: Column(children: <Widget>[
                                    Text(err.message == null
                                        ? "sorry for inconvinience"
                                        : message),
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
                      } catch (err) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                  title:
                                      const Text("Oops something went wrong"),
                                  content: FittedBox(
                                      child: Column(children: <Widget>[
                                    const Text("sorry for inconvinience"),
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

  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context)?.settings.arguments as Map;
    final rangeNumber = userData['range'].toString();
    DateTime time1 = userData['date'].toDate();
    var date1=DateTime(time1.year, time1.month, time1.day,time1.hour, time1.minute);
    
    //final String date1 = userData['date'].toString();


    return Scaffold(
        appBar: AppBar(
          title: const Text('Order',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          backgroundColor: Colors.blueAccent,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: Container(
              color: userData['isConfirm'] ? Colors.grey : Colors.green,
              child: TextButton(
                  onPressed: () {
                    if (userData['isConfirm']) {
                      return;
                    }
                    orderConfirm(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        'CONFIRM',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ],
                  ))),
        ),
        body: ListView(
          children: <Widget>[
          const  Divider(thickness: 4,),
            Container(
              color: Colors.white,
              child: ListTile(
                title: const Text('Donor: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
                subtitle: Text(userData['donorName'],
                    style: const TextStyle(
                        
                        fontSize: 20,
                        )),
              ),
            ),
            const Divider(thickness: 4,),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
              title: const Text('Email:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['email'],
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(thickness: 4,),
              ListTile(
              title: const Text('Contact:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['contact'].toString(),
                  style: const TextStyle(fontSize: 20)),
            ),
                  
                ],
              ),
            ),
            const Divider(thickness: 4,),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text('Serves nearly $rangeNumber ',
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              title: const Text('Food Description:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['foodDescription'],
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              title: const Text('Address:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(userData['address'],
                  style: const TextStyle(fontSize: 20)),
            ),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              title: const Text('Available till',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text(
              '$date1',
                style: const TextStyle(fontSize: 20),
              ),
            //  subtitle: Align(
            //     alignment: Alignment.bottomLeft,
            //     child: CountDownTimer(
            //       key: UniqueKey(),
            //       countDownFormatter: (duration) async {
            //         return '${duration.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
            //       },
            //       countDownTimerStyle: const TextStyle(
            //           color: Colors.green,
            //           fontSize: 150.0,
            //           height: 100
            //       ),
            //       secondsRemaining: date2,
            //       whenTimeExpires: () {
            //         setState(() {
            //           hasTimerStopped = true;
            //         });
            //       },
            //       countDownStyle: const TextStyle(
            //           color: Colors.green, fontSize: 150.0, height: 100),
            //     ), 
              // ),
            )
          ],
        ));
  }
}
