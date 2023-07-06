
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodshare/screens/donation_detail_screen.dart';
import 'package:foodshare/screens/history.dart';
import 'package:foodshare/screens/ngo_home_screen.dart';
//import 'package:foodshare/screens/notification.dart';
import 'package:foodshare/screens/past_orders_details.dart';
import 'package:foodshare/screens/pastorders.dart';
import 'package:foodshare/screens/yourorder.dart';
import 'package:foodshare/sign_in.dart';
import 'package:foodshare/spash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/add_order.dart';
import './screens/donor_main.dart';
import './screens/tick.dart';
import './screens/receiver_home_screen.dart';
import './screens/confirm_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './widgets/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
//
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDonor;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodShare',
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: Future<User>.value(FirebaseAuth.instance.currentUser),
                builder: (ctx, futuresnapshot) {
                  if (futuresnapshot.connectionState == ConnectionState.done) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(futuresnapshot.data?.uid)
                            .get(),
                        builder: (ctx, future1) {
                          if (future1.connectionState == ConnectionState.done) {
                            if (future1.data?['Donor']) {
                              return const DonorMain();
                            } else {
                              return ReceiverHomeScreen();
                            }
                          }
                          if (future1.connectionState ==
                              ConnectionState.waiting) {
                            return const SplashScreen();
                          }
                          return Container();
                        });
                  }
                  if (futuresnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SplashScreen();
                  }
                  return Container();
                },
              );
            }
            return const SignIn();
          }),
      routes: {
        SplashScreen.routeName: (ctx) => const SplashScreen(),
        DonationDetailScreen.routeName: (ctx) => DonationDetailScreen(),
        SignIn.routeName: (ctx) => const SignIn(),
        AddOrder.routeName: (ctx) => const AddOrder(),
        DonorMain.routeName: (ctx) => const DonorMain(),
        TickPage.routeName: (ctx) => TickPage(),
        ConfirmOrderScreen.routeName: (ctx) => const ConfirmOrderScreen(),
        ReceiverHomeScreen.routeName: (ctx) => ReceiverHomeScreen(),
        MyOrders.routeName: (ctx) => MyOrders(),
        Tabs.routeName: (ctx) =>  Tabs(),
        OngoingOrders.routeName: (ctx) => OngoingOrders(),
        PastOrderDetailScreen.routeName: (ctx) => const PastOrderDetailScreen(),
        PastOrdersScreen.routeName: (ctx) => PastOrdersScreen(),
        NGOhomeScreen.routeName:(ctx)=>NGOhomeScreen(),
      },
    );
  }
}
