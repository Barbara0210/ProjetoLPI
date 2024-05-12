import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/doctor_details.dart';
import 'package:flutter_app/utils/config.dart';


//
class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key,required this.doctor,required this.isFav}) : super(key: key);


final Map<String,dynamic>doctor;//receive doctor details
final bool isFav;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            height: 150,
            child: GestureDetector(
              child: Card(
                elevation: 5,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: Config.widthSize * 0.33,
                      child: Image.asset(
                        'assets/doctor_2.jpg',
                      ),
                      //Image.network("http://10.0.2.2:8000${doctor['doctor_profile']}",
                    //  fit: BoxFit.fill,
                      ),
                    
                    Flexible(
                      child: Padding(
                      padding: 
                      const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text(
                            'Dr ${doctor['doctor_name']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                           Text(
                           " ${doctor['category']}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const <Widget> [
                              Icon(Icons.star_border,color: Colors.yellow,size: 16,),
                              Spacer(flex: 1,),
                              Text('4.5'),
                              Spacer(flex: 1,),
                              Text('Reviews'),
                              Spacer(flex: 1,),
                              Text('(20)'),
                              Spacer(flex: 7,),
                            ],

                          )
                        ],
                      ),
                      ),)
                  ],

                ),
              ),
              onTap: (){
                //redirect to doctors details page
                //Navigator.of(context).pushNamed(route,arguments: doctor);
                MyApp.navigatorKey.currentState!
                .push(MaterialPageRoute(builder: (_)  => DoctorDetails(
                  doctor: doctor,
                  isFav: isFav,
                )));
              }, // redirect to doctor details
            ),
    );
  }
}