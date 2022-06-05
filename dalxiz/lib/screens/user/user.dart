import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../login_screen.dart';

class ProfileUI2 extends StatefulWidget {
  @override
  State<ProfileUI2> createState() => _ProfileUI2State();
}

class _ProfileUI2State extends State<ProfileUI2> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phone = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromARGB(255, 112, 190, 112),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        body: Stack(alignment: Alignment.topCenter, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/profile.jpg'),
                  ),
                ),
              ),
            ],
          ),
          displayUserInformation(context),
        ]));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color.fromARGB(255, 112, 190, 112);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget displayUserInformation(context) {
  TextEditingController _usernameController = TextEditingController();

  Future userProfile(email) async {
    var api = "http://localhost:5000/users/user-Profile/${email}";
    final response = await http.get(Uri.parse(api), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    return jsonDecode(response.body);
  }

  return Center(
      child: Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 20,
              spreadRadius: 10,
              offset: const Offset(0, 10))
        ]),
    child: FutureBuilder(
        future: userProfile('email'),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No data Available."),
            );
          }
          var data = snapshot.data['data'];

          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Divider(
              thickness: 0.5,
              height: 10,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  hintText: data['username'],
                  hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Divider(
              thickness: 0.5,
              height: 10,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.green,
                  ),
                  hintText: data['email'],
                  hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Divider(
              thickness: 0.5,
              height: 10,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.phone_android_outlined,
                    color: Colors.green,
                  ),
                  hintText: data['phone'].toString(),
                  hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ]);
        }),
  ));
}
