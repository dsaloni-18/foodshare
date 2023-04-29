import 'package:flutter/material.dart';
import 'package:foodshare/Reusable_widgets/reusable_widgets.dart';
import 'package:foodshare/screens/Donor/Donor.dart';

class DonateForm extends StatefulWidget {
  const DonateForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DonateFormState createState() => _DonateFormState();
}

class _DonateFormState extends State<DonateForm> {
  final _food=TextEditingController();
  final _count=TextEditingController();
  final _location=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Donate Food",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
             gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.white54, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[

                reusableTextField("Food Description", Icons.restaurant_menu, false, _food),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Feed Count", Icons.confirmation_number, true, _count),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Location", Icons.location_on, true, _location),
                const SizedBox(
                  height: 5,
                ),
                firebaseUIButton(context, "Submit", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Donor()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
