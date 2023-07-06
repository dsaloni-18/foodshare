import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDistributor {
  final List<String> ngos = ['NGO1', 'NGO2', 'NGO3']; // list of NGOs
  Future<void> distributeOrders() async {

    final orders = await getPendingOrders(); // retrieve pending orders
    int lastNgoIndex = 0; // index of last assigned NGO
    for (final order in orders) {
      // assign order to next NGO in the list
      final ngo = ngos[lastNgoIndex % ngos.length];
      await assignOrder(order, ngo);
      lastNgoIndex++;
    }
  }

  Future<List<DocumentSnapshot>> getPendingOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: false)
        .get();
    return snapshot.docs;
  }

  Future<void> assignOrder(DocumentSnapshot order, String ngo) async {
    // update order status with assigned NGO
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(order.id)
        .update({'ngo': ngo});
  }
}