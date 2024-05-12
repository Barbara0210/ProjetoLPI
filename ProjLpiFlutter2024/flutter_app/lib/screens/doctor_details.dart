import 'package:flutter/material.dart';
import 'package:flutter_app/components/button.dart';
import 'package:flutter_app/models/auth_model.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({Key? key,required this.doctor,required this.isFav}) : super (key : key );

final Map<String,dynamic> doctor;
final bool isFav;
  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {

  Map<String,dynamic> doctor = {};
  bool isFav = false;

  @override
  void initState(){
    doctor = widget.doctor;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //get arguments passed from doctor card
    //final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(onPressed:  () async{ 
             // press this button to add/remove favorite doctor
             final list = 
             Provider.of<AuthModel>(context,listen: false).getFav;

             if(list.contains(doctor['doc_id'])){
              list.removeWhere((id) => id == doctor['doc_id']);
             } else{
              list.add(doctor['doc_id']);
             }

             Provider.of<AuthModel>(context,listen:false).setFavList(list);

             final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if(token.isNotEmpty && token != ''){
                final response = 
                      await DioProvider().storeFavDoc(token, list);
              

              if(response == 200){
              setState(() {
              isFav = !isFav;
            });
              }
          }
           
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
          //pass doctor details here
      AboutDoctor(doctor:doctor),
      DetailBody(doctor: doctor,),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(10),  
        child: Button(
        width: double.infinity,
         title: 'Book appointment',
          onPressed: (){
            //navigate to booking page
            //pass doctor id for booking process
            Navigator.of(context).pushNamed('booking_page',arguments: {"doctor_id":doctor ['doc_id']});
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
  const AboutDoctor({Key? key, required this.doctor}) : super (key : key );

final Map<dynamic,dynamic>doctor;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return  Container(
      width: double.infinity,
      child: Column(children: <Widget>[
        const CircleAvatar(
          radius: 65.0, // tirar o const tbm se quiser tentar com o NetworkImage("")
          //backgroundImage: AssetImage('assets/doctor_2.jpg'),
          backgroundColor: Colors.white,
        ),
        Config.spaceMedium,
         Text(
          'Dr ${doctor['doctor_name']}',
          style: const TextStyle(
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
  const DetailBody({Key? key, required this.doctor}) : super (key : key );
final Map<dynamic,dynamic>doctor;
  @override
  Widget build(BuildContext context) {
  Config().init(context);
    return Container(
    padding: const EdgeInsets.all(10),
    //margin: const EdgeInsets.only(bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget> [
    
        DoctorInfo(
          patients: doctor['patients'],
          exp: doctor['experience'],
        ),
        Config.spaceSmall,
         Text(
          'About Doctor',
          style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18),
        ),
      
        Text('Dr ${doctor['doctor_name']} is an experience ${doctor['category']} Specialist at Sarawak. Graduated since 2008, and complete his training at Sungai Buloh General Hospital',
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
  const DoctorInfo({Key? key, required this.patients,required this.exp}) : super (key: key);

final int patients;
final int exp;

  @override
  Widget build(BuildContext context) {
  
    return Row(
      children:  <Widget>[
        InfoCard(label: 'Patients', value: '$patients'),
       const SizedBox(width: 15,),
         InfoCard(label: 'Experiences', value: '$exp years'),
         const SizedBox(width: 15,),
          const InfoCard(label: 'Rating', value: '4.0'),
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
              vertical: 15,
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