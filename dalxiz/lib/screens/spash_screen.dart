// ignore_for_file: unnecessary_new

import 'package:dalxiz/screens/user/user.dart';
import 'package:dalxiz/screens/user/users.dart';
import 'package:dalxiz/screens/user/status.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int selectedIndex = 0;

  //list of widgets to call ontap
  final widgetOptions = [
    const HomeScreen(),
    new Nofication(),
    new SettingsPage(),
    new ProfileUI2(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: widgetOptions.elementAt(selectedIndex),
        ),
        bottomNavigationBar: Container(
          height: 60,
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
          width: 50,
          child: BottomNavigationBar(
            elevation: 60.0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.white10,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border_outlined),
                label: 'Booking',
                backgroundColor: Colors.white10,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
                backgroundColor: Colors.white10,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.white10,
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.green,
            onTap: onItemTapped,
          ),
        ));
  }
}
