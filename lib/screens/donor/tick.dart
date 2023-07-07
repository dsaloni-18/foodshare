import 'package:flutter/material.dart';
import 'donor_main.dart';

class TickPage extends StatelessWidget {
  static const routeName = '/tick-page';

  const TickPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).popAndPushNamed(DonorMain.routeName);
          },
        ),
        title: const Text('Thank you for donating!',style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20,),
            Container(
              height: 300,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('images/auth.jpg'),fit:BoxFit.cover),
              ),
            ),
               const SizedBox(height: 60,),
            Column(
              children: const <Widget>[
                Text(
                  'Your donation is successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  'Receiver will contact you shortly',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}