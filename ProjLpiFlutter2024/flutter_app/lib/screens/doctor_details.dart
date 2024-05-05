import 'package:flutter/material.dart';
import 'package:flutter_app/components/button.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  //for favorite button
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(onPressed:  (){ 
            setState(() {
              isFav = !isFav;
            });
          },
           icon: FaIcon(isFav ? Icons.favorite_rounded : Icons.favorite_outline,
           color: Colors.red,
            ),
           )
        ],
      ) , 
      //create a custom app bar widget
      body: SafeArea(
      child: Column(
        children: <Widget>[
          //build doctor avatar and intro here
      AboutDoctor(),
      DetailBody(),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(10),  
        child: Button(
        width: double.infinity,
         title: 'Book appointment',
          onPressed: (){
            //navigate to booking page
            Navigator.of(context).pushNamed('booking_page');
          },
           disable: false) ,
        ),

        ],
      ),
      )
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return  Container(
      width: double.infinity,
      child: Column(children: <Widget>[
        const CircleAvatar(
          radius: 65.0,
          backgroundImage: AssetImage('assets/doctor_2.jpg'),
          backgroundColor: Colors.white,
        ),
        Config.spaceMedium,
        const Text(
          'Dr Richard Tan',
          style: TextStyle(
            color:Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
    Config.spaceSmall,
    SizedBox(
      width: Config.widthSize * 0.75, 
      child: const Text(
        'MBBS (International Medical University, Malaysia) MRCP (Royal College of Physicians)',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    ),
    Config.spaceSmall,
SizedBox(
      width: Config.widthSize * 0.75, 
      child: const Text(
        'Sarawak General Hospital',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    ),

      ],),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key});

  @override
  Widget build(BuildContext context) {
  Config().init(context);
    return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget> [
    
        const DoctorInfo(),
        Config.spaceSmall,
        const Text(
          'About Doctor',
          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),
        ),
      
        Text('Dr. Richard Tan is an experience Dentist at Sarawak. He is graduated since 2008, and complete his training at Sungai Buloh General Hospital',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        softWrap: true,
        textAlign: TextAlign.justify,
        ),

        //doctor exp and ratinf
      ],
    ),


    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Row(
      children: const <Widget>[
        InfoCard(label: 'Patients', value: '109'),
        SizedBox(width: 15,),
         InfoCard(label: 'Experiences', value: '10 years'),
          SizedBox(width: 15,),
          InfoCard(label: 'Rating', value: '4.0'),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({ Key? key, required this.label, required this.value }) : super(key: key);

final String label;
final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Config.primaryColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15,
            ),
            child: Column(
              children:  <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10,),
                   Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
  }
}