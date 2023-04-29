import 'package:flutter/material.dart';
import 'package:foodshare/reusable_widgets/reusable_widgets.dart';
import 'package:foodshare/screens/Receiver/receiver.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final TextEditingController _textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Assign Employee",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
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

                reusableTextField("Employee Name", Icons.person_outline, false, _textEditingController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Contact Number", Icons.phone_outlined, true,_textEditingController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Email", Icons.email_outlined, true, _textEditingController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Location", Icons.location_on, true, _textEditingController),
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