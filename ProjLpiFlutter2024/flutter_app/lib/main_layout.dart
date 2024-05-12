import 'package:flutter/material.dart';
import 'package:flutter_app/screens/appointment_page.dart';
import 'package:flutter_app/screens/fav_page.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  //variable declaration
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value){
          setState(() {
            //update page index when tab pressed/ switch page
            currentPage = value;
          });
        }),
        children: <Widget> [
         const HomePage(),
          //add page here
          FavPage(),
        const  AppointmentPage(),
          ProfilePage(),
        ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (page){
            setState(() {
              currentPage = page;
              _page.animateToPage(
                page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem( 
                    icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
              label: 'Home',
            ),
                BottomNavigationBarItem( 
                    icon: FaIcon(FontAwesomeIcons.solidHeart),
              label: 'Favorite',
            ),
              BottomNavigationBarItem( 
                     icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
              label: 'Appointments',
            ),
                BottomNavigationBarItem( 
                    icon: FaIcon(FontAwesomeIcons.solidUser),
              label: 'Profile',
            ),
          ],
          ),
    );
  }
}