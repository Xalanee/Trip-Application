import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_acount.dart';
import 'login_screen.dart';

class OpeningView extends StatefulWidget {
  const OpeningView({Key? key}) : super(key: key);

  @override
  OpeningViewState createState() => OpeningViewState();
}

class OpeningViewState extends State<OpeningView> {
  OpeningViewState();

  String displayName = "";

  @override
  void initState() {
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // final logo = Image.asset(
    //   "assets/images/logo.jpg",
    //   height: mq.size.height / 6,
    // );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          "Sign In",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        },
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateAccount()));
        },
      ),
    );

    final buttons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        loginButton,
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
          child: registerButton,
        ),
      ],
    );

    display() {
      if (displayName != null)
        return Text(
          "Welcome  $displayName!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
          ),
        );
      else
        return Text(
          "Welcome!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        );
    }

    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 70),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                  radius: 60,
                )),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 100),
              child: display(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100, bottom: 0),
              child: buttons,
            )
          ],
        ),
      ),
    );
  }
}
