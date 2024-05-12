import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      Expanded(
        flex: 4,
        child: Container(
          width: double.infinity,
          color: Config.primaryColor,
          child: Column(
            children: const <Widget>[
              SizedBox(
                height: 110,
              ),
              CircleAvatar(
                radius: 65.0,
                backgroundImage: AssetImage('assets/profile1.jpg'),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Amanda Tan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '23 years old | female',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
        ),
      ),

      Expanded(
        flex: 5,
        child: Container(
          color: Colors.grey[200],
            child:  Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                child: Container(
                  width: 300,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        const Text('Profile',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),),
                        Divider(color: Colors.grey[300],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blueAccent[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              onPressed: (){},
                             child: const Text(
                              "Profile",
                              style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                              ),
                             ),
                             ),
                          ],
                        ),
                    Config.spaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.yellowAccent[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              onPressed: (){},
                             child: const Text(
                              "History",
                              style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                              ),
                             ),
                             ),
                          ],
                        ),

                        Config.spaceSmall,

                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.lightGreen[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              onPressed: () async{
                                final SharedPreferences prefs = 
                                  await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? '';

                                if(token.isNotEmpty && token != ''){
                                  final response = await DioProvider().logout(token);

                                  if (response == 200){
                                    await prefs.remove('token');
                                    setState(() {
                                      MyApp.navigatorKey.currentState!.pushReplacementNamed('/');
                                    });
                                  }
                                }  
                              },
                             child: const Text(
                              "LogOut",
                              style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                              ),
                             ),
                             ),
                          ],
                        ),
                      ],
                    ),
                    ),

                ),
              ),
            ),
        ),
      ),
    ],

   );
  }
}