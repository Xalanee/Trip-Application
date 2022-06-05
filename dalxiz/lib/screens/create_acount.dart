import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'spash_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  Future register() async {
    var api = "http://localhost:5000/users/register";

    Map body = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phone.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: [
                Colors.green.shade900,
                Colors.green.shade700,
                Colors.green.shade500,
              ])),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        // #signup_text
                        Text(
                          "Sign Up",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white, fontSize: 32.5),
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        // #welcome
                        Text(
                          "Welcome",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),

                      // #text_field
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: MediaQuery.of(context).size.height * 0.3,
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: _usernameController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Please Enter your email";
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    hintText: "Fullname",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                              Divider(
                                thickness: 0.5,
                                height: 10,
                              ),
                              TextField(
                                controller: _emailController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Please Enter your email";
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                              Divider(
                                thickness: 0.5,
                                height: 10,
                              ),
                              TextField(
                                controller: _phone,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Please Enter your email";
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    hintText: "Phone",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                              Divider(
                                thickness: 0.5,
                                height: 10,
                              ),
                              TextField(
                                controller: _passwordController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Please Enter your email";
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),

                      // #signup_button
                      MaterialButton(
                        onPressed: () async {
                          if (_usernameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _phone.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              register().then((body) {
                                print(body);
                                if (body != null) {
                                  print("Account Created Sucessfull");
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SplashScreen()));
                                  // print(user);

                                } else {
                                  print("Login Failed");
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });
                            } else {
                              print("Please enter Fields");
                            }
                          }
                          setState(() {
                            isLoading = true;
                          });
                          await Future.delayed(const Duration(seconds: 5));
                          setState(() {
                            isLoading = false;
                          });
                        },
                        height: 45,
                        minWidth: 240,
                        shape: const StadiumBorder(),
                        color: Colors.green.shade700,
                        child: (isLoading)
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1.5,
                                ))
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      // #text
                      const Text(
                        "Login with SNS",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      // #buttons(facebook & github)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.blue,
                            shape: const StadiumBorder(),
                            height: 45,
                            minWidth: MediaQuery.of(context).size.width * 0.28,
                            child: const Text(
                              "Facebook",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.red,
                            shape: const StadiumBorder(),
                            height: 45,
                            minWidth: MediaQuery.of(context).size.width * 0.28,
                            child: const Text(
                              "Google",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.black,
                            shape: const StadiumBorder(),
                            height: 45,
                            minWidth: MediaQuery.of(context).size.width * 0.28,
                            child: const Text(
                              "Apple",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
