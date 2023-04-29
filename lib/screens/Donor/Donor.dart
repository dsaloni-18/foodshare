// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodshare/screens/Donor/myDonations.dart';
import 'package:foodshare/screens/Donor/viewrequest.dart';
class Donor extends StatefulWidget {
  const Donor({Key? key}) : super(key: key);

  @override
  _DonorState createState() => _DonorState();
}

class _DonorState extends State<Donor>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Donor",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
       
        bottom: TabBar(
          unselectedLabelColor: Colors.black,
          controller: _controller,
          tabs: const [Tab(text: "View Request"),Tab(text: "My Donations")],),
      ),
      body: TabBarView(
        
        controller: _controller,
        children: const [
          ViewRequest(),
          MyDonations(),
        ],),
    );
  }
}