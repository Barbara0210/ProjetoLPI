// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../utils/config.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key});

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:Config.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget> [
              Row(
                children: [  CircleAvatar(
          backgroundImage: AssetImage("assets/doctor_2.jpg"),
         ),
         SizedBox(width: 10,),
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Dr Richard",
              style: TextStyle(color:Colors.white),

              ),
              SizedBox(
                height: 2,
              ),
          Text(
              "Dental",
              style: TextStyle(color:Colors.white),

              ),
          ],
         ),],
              ),
        Config.spaceSmall,
        //schedule info here
        ScheduleCard(),
        Config.spaceSmall,
        //action button

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: (){},
              ),
              ),
              
            const SizedBox(
              width: 20,
            ),

              Expanded(
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: (){},
              ),
              ),
          ],
        )
            ],)
        )
        
      )
    );
  }
}

class ScheduleCard extends StatefulWidget {
  const ScheduleCard({super.key});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
width: double.infinity,
padding: const EdgeInsets.all(20),
child: Row(
  crossAxisAlignment:CrossAxisAlignment.center ,
  children: const <Widget>[
    Icon(
      Icons.calendar_today,
      color:Colors.white,
      size:15,
    ),
    SizedBox(
      width: 5,
    ),
    Text(
      'Monday, 28/11/2022',
      style: TextStyle(color: Colors.white),
    ),
    SizedBox(
      width: 20,
    ),
   Icon(
      Icons.access_alarm,
      color:Colors.white,
      size:17,
    ),
    const SizedBox(width: 5,),
    Flexible(child: Text('2:00',style: TextStyle(color: Colors.white),))
  ],
),
    );
  }
}

