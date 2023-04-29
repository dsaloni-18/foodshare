import 'package:flutter/material.dart';
import 'package:foodshare/screens/Receiver/donationAvailable.dart';
import 'package:foodshare/screens/Receiver/myrequest.dart';

class NGO extends StatefulWidget {
  const NGO({Key? key}) : super(key: key);

  @override
  _NGOState createState() => _NGOState();
}

class _NGOState extends State<NGO> with SingleTickerProviderStateMixin {
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
          "Receiver",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.black,
          controller: _controller,
          tabs: const [
            Tab(text: "My Request"),
            Tab(text: "Donations Available")
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          MyRequest(),
          DonationAvailable(),
        ],
      ),
    );
  }
}
