import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_app/main_layout.dart';
import 'package:flutter_app/models/auth_model.dart';
import 'package:flutter_app/screens/MedicacaoScreen.dart';
import 'package:flutter_app/screens/auth_page.dart';
import 'package:flutter_app/screens/booking_page.dart';
import 'package:flutter_app/screens/doctor_details.dart';
import 'package:flutter_app/screens/success_booked.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//this is for push navigator
static final navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey ,
        title: 'Flutter Doctor App',
        theme: ThemeData(
       //pre-define input decoration
            inputDecorationTheme: const InputDecorationTheme(
              focusColor: Config.primaryColor,
              border: Config.outlinedBorder,
              focusedBorder: Config.focusBorder,
              errorBorder: Config.errorBorder,
              enabledBorder: Config.outlinedBorder,
              floatingLabelStyle: TextStyle(color: Config.primaryColor),
              prefixIconColor: Colors.black38,
         ),
       
         scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Config.primaryColor,
              selectedItemColor: Colors.white,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.grey.shade700,
              elevation: 10,
              type: BottomNavigationBarType.fixed,
            ),
       ),
      initialRoute: '/',
      routes: {
        '/':(context) => const AuthPage(),
      'main': (context) => MainLayout(),
      //'doc_details' : (context) => const DoctorDetails(),
      'booking_page' : (context) => BookingPage(),
      'success_booking':(context) => const AppointmentBooked(),
       'medication': (context) =>  MedicacaoScreen(),
      },
      ),
    );
  }
}
