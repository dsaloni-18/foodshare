// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodshare/screens/NGO/ngo_donation_details.dart';
import 'package:foodshare/screens/NGO/ngo_confirm_order.dart';
//import 'package:foodshare/screens/notification.dart';
import 'drawer3.dart';
import 'package:flutter/material.dart';
//import '../widgets/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NGOHomeScreen extends StatefulWidget {
  static const routeName = 'ngo-home-screen';

  const NGOHomeScreen({super.key});
  @override
  _NGOHomeScreenState createState() => _NGOHomeScreenState();
}

class _NGOHomeScreenState extends State<NGOHomeScreen> {
  @override
  void initState() {
    count = 0;
    super.initState();
  }
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
        onTap: () {
          Navigator.of(context)
              .pushNamed(NGODonationDetailScreen.routeName, arguments: {
            'isConfirm': isConfirm,
            'username': documents[i]['username'],
            'address': documents[i]['address'],
            'typeofdonor': documents[i]['typeofdonor'],
            'isVeg': documents[i]['isVeg'],
            'range': documents[i]['range'],
            'foodDescription': documents[i]['description'],
            'donorName': documents[i]['donorName'],
            'contact': documents[i]['contact'],
            'email': documents[i]['email'],
            'status': documents[i]['status'],
            'id': documents[i]['id'],
            'userId': documents[i]['userId'],
            'date': documents[i]['date'],
            'time1': documents[i]['time1'],
          });
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue[50],
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Icon(
                            Icons.account_circle,
                            size: 60,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: Text(
                              documents[i]['username'],
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.fastfood,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(documents[i]['description'],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 24)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          const Icon(
                            Icons.supervised_user_circle,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            'Serves $rangenumber',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 24),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4),
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          const Icon(
                            Icons.watch,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            'Food Expired on \n$formattedDate,$formattedDate1',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 24),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton.icon(
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            //icon: Colors.green,
                            onPressed: () {
                              orderConfirm(context, documents, i);
                            },
                            label: const Text(
                              'Confirm Order',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 24),
                            )),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> orderConfirm(BuildContext context, var documents, var i) async {
  if (isLoading) {
    return;
  }

  try {
    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    final user11 = await FirebaseFirestore.instance
        .collection('ngo')
        .doc(user?.uid)
        .get();
    final String username1 = user11['username'];

    await FirebaseFirestore.instance
        .collection('ngo')
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
      'finished': false,
      'id': documents[i]['id'],
      'userId': documents[i]['userId'],
        'orderconfirmed': username1,
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
    });

    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushNamed(
      NGOConfirmOrder.routeName,
      arguments: {
        'status': documents[i]['status'],
        'id': documents[i]['id'],
        'userId': documents[i]['userId'],
        'NGOId': user?.uid,
      },
    );
  } catch (err) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Oops, something went wrong"),
          content: const Text("Sorry for the inconvenience"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer2(),
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.blueAccent,
          title: const Text('FoodShare'),
        
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .where('time1', isLessThan: DateTime.now())
                          
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

                        if (documents == null || documents.isEmpty) {
                          // No donations available
                          return const Center(
                            child: Text(
                              'No donations available!',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }

                        // Donations available, display them
                        return Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) {
                                    if (documents[i]['status'] == true) {
                                      return const SizedBox(
                                        height: 0,
                                        width: 0,
                                      );
                                    }
                                    return getDonorTile(i, documents);
                                  },
                                  itemCount: documents.length,
                                ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
