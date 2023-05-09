// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = 'feedback-screen';

  const FeedbackScreen({super.key});
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Give Feedback'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text(
                  'Rate our Donor:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                RatingBarIndicator(
                  itemBuilder: (context, _) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                  rating: 1,
                  //allowHalfRating: true,
                  direction: Axis.horizontal,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemCount: 5,
                  //initialRating: 2,
                  //onRatingUpdate: (rating) {
                  //print(rating);
                  //},
                  //),
                  //SizedBox(height: 10,),
                ),
                const Text(
                  'Let the donor know if you have some suggestions',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                        labelText: 'Give Feedback',
                        labelStyle: TextStyle(
                            color: Colors.black45, letterSpacing: 12)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  //color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
