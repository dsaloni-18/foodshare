import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'route11';

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
       decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/Splash_screen.jpg'),fit:BoxFit.cover),
              // gradient: LinearGradient(
              //     colors: [Colors.blueAccent, Colors.white54, Colors.black],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter)
                  ),
    );
  }
}
