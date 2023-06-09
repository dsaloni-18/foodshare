import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'past_orders_details.dart';

class PastOrdersScreen extends StatefulWidget {
  static const routeName = 'past-orders-screen';
  @override
  _PastOrdersScreenState createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  bool isConfirm = true;
  Widget getDonorTile(int i, final documents) {
    final rangenumber = documents[i]['range'];

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PastOrderDetailScreen.routeName, arguments: {
          'isConfirm': isConfirm,
          'username': documents[i]['username'],
          'address': documents[i]['address'],
          'typeofdonor': documents[i]['typeofdonor'],
          'isVeg': documents[i]['isVeg'],
          'range': documents[i]['range'],
          'foodDescription': documents[i]['foodDescription'],
          'donorName': documents[i]['donorName'],
          'contact': documents[i]['contact'],
          'email': documents[i]['email'],
          'date': documents[i]['date'],
          'id': documents[i]['id'],
          'userId': documents[i]['userId']
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
                      width: 7,
                    ),
                    Text(documents[i]['foodDescription'],
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20)),
                  ],
                ),
                 const SizedBox(
                    height: 10,
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
              ],
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

                  return streamSnapshot.data!.docs.isEmpty
                      ? const Center(
                          child: Text(
                          "No Orders yet !",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ))
                      : ListView.builder(
                          itemBuilder: (ctx, i) {
                            DateTime timer;
                            if (documents[i]['date'] != null) {
                              timer = documents[i]['date'].toDate();
                            
                            if (timer.isBefore(DateTime.now())) {
                              FirebaseFirestore.instance
                                  .collection('receiver')
                                  .doc(future1.data?.uid)
                                  .collection('past orders')
                                  .doc(documents[i]['id'])
                                  .update({'finished': true});
                            }
                            if (documents[i]['finished'] == true) {
                              return const SizedBox(height: 0, width: 0);
                            }
                            return getDonorTile(i, documents);
                          }
                            return null;},
                          itemCount: documents.length);
                },
              );
            }));
  }
}
