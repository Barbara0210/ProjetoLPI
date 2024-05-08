import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/components/appointment_card.dart';
import 'package:flutter_app/components/doctor_card.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String,dynamic> user={};
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

  Future <void> getData() async{
    //get token from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

      if(token.isNotEmpty && token !=''){
        //get user data
        final response = await DioProvider().getUser(token);
        if(response != null){
          setState(() {
            //json decode
            user = json.decode(response);
            print(user);
          });
        }
      }
  }

  @override
  void initState(){
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Config().init(context);
   return Scaffold(
body:Padding(
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
              user['name'], //hard code o nome de utilizador
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
        Config.spaceMedium,
        //category listing
        const  Text(
              'Category', //hard code o nome de utilizador
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
      
            SizedBox(
              height: Config.heightSize *0.05,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                 List<Widget>.generate(medCat.length,(index){
                  return Card(
                    margin: const EdgeInsets.only(right:20),
                    color: Config.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment:
                           MainAxisAlignment.spaceAround,
                          children:<Widget>[
                            FaIcon(
                              medCat [index] ['icon'],
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              medCat [index] ['category'],
                              style: const TextStyle(
                                fontSize: 16,
                                color:Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  
                }),
            ),
            ),
      Config.spaceSmall,
       const  Text(
              'Appointment Today', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
      //display appointment card here 
          AppointmentCard(),
          Config.spaceSmall,
          const  Text(
              'Top Doctors', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            //list of top doctors
            Config.spaceSmall,
            Column(
              children: List.generate(10,(index){
                return const DoctorCard(
                  route: 'doc_details',
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