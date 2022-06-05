// import 'package:dalxiz/screens/create_acount.dart';
import 'dart:convert';

import 'package:dalxiz/screens/spash_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'create_acount.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences s_prefs;
  String temp = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  _saveToShared_Preferences() async {
    s_prefs = await SharedPreferences.getInstance();
    s_prefs.setString("email", _emailController.text.toString());
  }

  Future loginUser(String text, String number) async {
    var api = "http://localhost:5000/users/login";

    Map body = {
      'email': _emailController.text,
      'password': _passwordController.text
    };
    final response = await http.post(
      Uri.parse(api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    var res = jsonDecode(response.body);
    if (res['message'] == "Success") {
      return response.body;
    }
    return null;
  }

  void fireToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void fireToast2(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade900,
              Colors.green,
              Colors.green.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            /// Login & Welcome back
            Container(
              height: 210,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  /// LOGIN TEXT
                  Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 32.5)),
                  SizedBox(height: 7.5),

                  /// WELCOME
                  Text('Welcome Back',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(height: 60),

                    /// Text Fields
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 10,
                                offset: const Offset(0, 10)),
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            /// EMAIL
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter your email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.green,
                                ),
                                hintText: 'Email',
                                // isCollapsed: true,
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),

                            Divider(color: Colors.black54, height: 1),

                            /// PASSWORD
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter your Password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  isCollapsed: true,
                                  prefixIcon: Icon(
                                    Icons.lock_open,
                                    color: Colors.green,
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    /// LOGIN BUTTON
                    MaterialButton(
                      onPressed: () async {
                        isLoading = true;
                        if (_formKey.currentState!.validate()) {
                          loginUser(_emailController.text,
                                  _passwordController.text)
                              .then((body) async {
                            print(body);
                            if (body != null) {
                              print(
                                "Login Sucessfully",
                              );
                              setState(() {
                                isLoading = false;
                              });
                              _saveToShared_Preferences();
                              //save user email on local storage
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SplashScreen()));
                            } else {
                              print("Login Failed");
                              setState(() {
                                isLoading = false;
                              });
                            }
                          });

                          setState(() {
                            isLoading = true;
                          });
                          await Future.delayed(const Duration(seconds: 5));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      height: 45,
                      minWidth: 240,
                      child: (isLoading)
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ))
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                      textColor: Colors.white,
                      color: Colors.green.shade700,
                      shape: const StadiumBorder(),
                    ),
                    const SizedBox(height: 25),

                    /// TEXT
                    const Text(
                      'Login with SNS',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),

                    /// FACEBOOK/GITHUB
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CreateAccount()));
                          },
                          height: 45,
                          minWidth: 140,
                          child: const Text(
                            'Facebook',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                          color: Colors.blue,
                          shape: const StadiumBorder(),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          height: 45,
                          minWidth: 140,
                          child: const Text(
                            'Github',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                          color: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    /// Rich Text & Toast
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, right: 30, left: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By logging in you are agree with our',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Terms & Conditions ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.cyan),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Hash tag #tag');
                                    fireToast2("Terms & Conditions Hash Tag");
                                  }),
                            const TextSpan(text: ' and '),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.cyan),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Hash tag #tag');
                                    fireToast2("Privacy Policy Hash Tag");
                                  }),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveMail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    final String? userId = prefs.getString('email');
  }
}
