import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/components/appointment_card.dart';
import 'package:flutter_app/components/doctor_card.dart';
import 'package:flutter_app/models/auth_model.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   Map<String,dynamic> user={};
   Map<String,dynamic> doctor={};
   List<dynamic> favList = [];
   
   List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category":"General",
    },
     {
      "icon": FontAwesomeIcons.heartPulse,
      "category":"Cardiology",
    },
     {
      "icon": FontAwesomeIcons.lungs,
      "category":"Respirations",
    },
     {
      "icon": FontAwesomeIcons.hand,
      "category":"Dermatology",
    },
     {
      "icon": FontAwesomeIcons.personPregnant,
      "category":"Gynecology",
    },
     {
      "icon": FontAwesomeIcons.teeth,
      "category":"Dental",
    },
  ];




  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context,listen : false).getUser;
    doctor = Provider.of<AuthModel>(context,listen : false).getAppointment;
    favList = Provider.of<AuthModel>(context,listen : false).getFav;

   
   return Scaffold(
body: user.isEmpty
//if user is empty then returns progress indicator
    ? const Center(child: CircularProgressIndicator(),
    )
: Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 15,
  ),
  child: SafeArea(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  <Widget>[
           
            Text(
             user['name'], 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
           const SizedBox(
              child: CircleAvatar(
                radius:30,
                backgroundImage:
             AssetImage('assets/profile1.jpg')
              ),
            )
          ],
        ),
        Config.spaceSmall,
        //category listing
        const  Text(
              'Bem vindo ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
      
          const  Text(
              'Utentes da Unidade', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            //list of top doctors
            Config.spaceSmall,
            Column(
              children: List.generate(user['doctor'].length,(index){
                return DoctorCard(
                 // route: 'doc_details',
                  doctor:user['doctor'][index],
                  isFav: favList.contains(user['doctor'][index]['doc_id'])
                  ? true 
                  : false,
                );
              }),
            )
        ],
      ),
    ),
  ),
),
   );
  }
}