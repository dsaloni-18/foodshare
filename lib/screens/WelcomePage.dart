import 'package:flutter/material.dart';
import 'package:foodshare/Reusable_widgets/reusable_widgets.dart';
//import 'package:foodshare/screens/loginpage.dart';
import 'package:foodshare/screens/sign_in.dart';
import 'package:foodshare/screens/sign_up.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Food Share",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/background.jpg'),fit:BoxFit.cover),
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.white54, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8.0),
              child: Column(

                      children: <Widget>[
                        const SizedBox(height: 350),
                        const Text("Welcome to FoodShare",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 20),
                        firebaseUIButton(context, 'Login', () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const SignIn()));
                        }),
                        const SizedBox(height: 20),
                        firebaseUIButton(context, 'Sign Up', () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const SignUp()));
                        }),
                      ],

              ),
            ),

        ),
      ),
    );
  }
}
