
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodshare/screens/NGO/ngo_donation_details.dart';
import 'package:foodshare/screens/NGO/ngo_ongoing_order.dart';
import 'package:foodshare/screens/NGO/ngo_past_order_details.dart';
import 'package:foodshare/screens/donor/donation_detail_screen.dart';
import 'package:foodshare/screens/Receiver/history.dart';
import 'package:foodshare/screens/NGO/ngo_confirm_order.dart';
import 'package:foodshare/screens/NGO/ngo_home_screen.dart';
import 'package:foodshare/screens/Receiver/past_orders_details.dart';
import 'package:foodshare/screens/Receiver/pastorders.dart';
import 'package:foodshare/screens/donor/yourorder.dart';
import 'package:foodshare/sign_in.dart';
import 'package:foodshare/spash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodshare/screens/NGO/ngo_tabs.dart';
import 'screens/donor/add_order.dart';
import 'screens/donor/donor_main.dart';
import 'screens/donor/tick.dart';
import 'screens/Receiver/receiver_home_screen.dart';
import 'screens/Receiver/confirm_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/Receiver/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDonor;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodShare',
      debugShowCheckedModeBanner: false,
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
                            } 
                            else if(future1.data?['NGO']) {
                              return const NGOHomeScreen();
                            }
                            else{
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
        DonationDetailScreen.routeName: (ctx) => const DonationDetailScreen(),
        SignIn.routeName: (ctx) => const SignIn(),
        AddOrder.routeName: (ctx) => const AddOrder(),
        DonorMain.routeName: (ctx) => const DonorMain(),
        TickPage.routeName: (ctx) => const TickPage(),
        ConfirmOrderScreen.routeName: (ctx) => const ConfirmOrderScreen(),
        NGOHomeScreen.routeName :(ctx)=> const NGOConfirmOrder(),
        ReceiverHomeScreen.routeName: (ctx) => ReceiverHomeScreen(),
        MyOrders.routeName: (ctx) => const MyOrders(),
        Tabs.routeName: (ctx) =>  Tabs(),
        OngoingOrders.routeName: (ctx) => OngoingOrders(),
        PastOrderDetailScreen.routeName: (ctx) => const PastOrderDetailScreen(),
        PastOrdersScreen.routeName: (ctx) => PastOrdersScreen(),
        // ignore: equal_keys_in_map
        NGOHomeScreen.routeName:(ctx)=> const NGOHomeScreen(),
        NGOTabs.routeName:(ctx) => const NGOTabs(), 
        NgoOngoingOrders.routeName:(ctx)=> const NgoOngoingOrders(),
        NgoPastOrderDetailScreen.routeName:(ctx)=> const NgoPastOrderDetailScreen(),
        NGOConfirmOrder.routeName: (ctx) => const NGOConfirmOrder(),
        NGODonationDetailScreen.routeName:(context) => NGODonationDetailScreen(),

      },
    );
  }
}
