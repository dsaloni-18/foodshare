import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../donor/donation_detail_screen.dart';

class OngoingOrders extends StatefulWidget {
  static const routeName = 'abc115';
  @override
  _OngoingOrdersState createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> {
  @override
  bool isConfirm = true;
  Widget getDonorTile(int i, final documents) {
    final rangenumber = documents[i]['range'];
    DateTime date = documents[i]['date'].toDate();
    var formattedDate = DateFormat.MMMd().format(date);
    var formattedDate1 = DateFormat.Hm().format(date);
    return SizedBox(
      child: InkWell(
         onTap:(){
               Navigator.of(context)
              .pushNamed(DonationDetailScreen.routeName, arguments: {
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(3),
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Text(
                          documents[i]['username'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                        Icons.fastfood,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(documents[i]['foodDescription'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20)),
                    ],
                  ),
                  Row(children: [
                    const Icon(
                      Icons.supervised_user_circle,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Serves $rangenumber',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.5),
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
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.calendar_today,
                      size: 25,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Received on:$formattedDate,$formattedDate1',
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              ),
                        ),

                      
                      ],
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        body: FutureBuilder(
            future: Future.value(FirebaseAuth.instance.currentUser),
            builder: (ctx, future1) {
              if (future1.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                );
              }
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('receiver')
                    .doc(future1.data?.uid)
                    .collection('past orders')
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
                  if (documents!.isEmpty) {
                    return const Center(
                        child: Text(
                      "No Orders yet !",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ));
                  }
                  if (streamSnapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      "No Orders yet !",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ));
                  } else {
                    return ListView.builder(
                        itemBuilder: (ctx, i) {
                          if (streamSnapshot.data!.docs[i]['finished'] ==
                              false) {
                            return const SizedBox(height: 0, width: 0);
                          }
                          return getDonorTile(i, streamSnapshot.data?.docs);
                        },
                        itemCount: streamSnapshot.data?.docs.length);
                  }
                },
              );
            }));
  }
}
