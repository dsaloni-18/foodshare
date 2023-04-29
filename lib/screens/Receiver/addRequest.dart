import 'package:flutter/material.dart';
import 'package:foodshare/reusable_widgets/reusable_widgets.dart';
import 'package:foodshare/screens/Receiver/myrequest.dart';
import 'package:foodshare/screens/Receiver/receiver.dart';

class AddRequest extends StatefulWidget {
  const AddRequest({Key? key}) : super(key: key);

  @override
  State<AddRequest> createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  final TextEditingController _foodtype = TextEditingController();
  final TextEditingController _targetage = TextEditingController();
  final TextEditingController _feedcount = TextEditingController();
  final TextEditingController _location = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Add Food Request",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blueAccent
                  , Colors.white54, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[

                reusableTextField("Food Type", Icons.restaurant_menu, false, _foodtype),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Target Age Group", Icons.group, true,_targetage),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Feed Count", Icons.confirmation_number, true, _feedcount),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Location", Icons.location_on, true, _location),
                const SizedBox(
                  height: 5,
                ),
                firebaseUIButton(context, "Submit", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NGO()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}