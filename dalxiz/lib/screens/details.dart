import 'dart:html';

import 'package:dalxiz/screens/user/Notification.dart';
import 'package:dalxiz/screens/user/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'data.dart';
import 'dart:convert';

class Detail extends StatefulWidget {
  final Place place;

  Detail({required this.place});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String body;
  late String payload;

  Future Trips() async {
    var api = "http://localhost:5000/users/trips";

    Map body = {
      'title': widget.place.country,
      'body': widget.place.description,
      'payload': widget.place.price.toStringAsFixed(2)
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

  int _currentImage = 0;
  @override
  void initState() {
    super.initState();

    NotificatioApi.init();
    listenNotification();
  }

  void listenNotification() =>
      NotificatioApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Nofication(payload: payload),
      ));
  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < widget.place.images.length; i++) {
      list.add(buildIndicator(i == _currentImage));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      height: 4.0,
      width: isActive ? 24.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive ? kPrimaryColor : Colors.grey[400],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Stack(
            children: <Widget>[
              Hero(
                tag: widget.place.images[0],
                child: PageView(
                  onPageChanged: (int page) {
                    setState(() {
                      _currentImage = page;
                    });
                  },
                  children: widget.place.images.map((image) {
                    return ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.darken),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.place.favorite = !widget.place.favorite;
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          widget.place.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: kPrimaryColor,
                          size: 36,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        widget.place.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.place.country,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        widget.place.images.length > 1
                            ? Row(
                                children: buildPageIndicator(),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Starting from",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          r"$ " + widget.place.price.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          title = widget.place.country;
                          body = widget.place.description;
                          payload = widget.place.price.toStringAsFixed(2);
                          setState(() {
                            isLoading = true;
                          });
                          if (body == body) {
                            _showDialog(context);
                            Trips().then((body) {
                              print(body);
                              if (body != null) {
                                print("Trip Created Sucessfull");
                                setState(() {
                                  isLoading = true;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Nofication()));
                                // print(user);

                              } else {
                                print("Login Failed");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          }
                          await Future.delayed(const Duration(seconds: 5));
                          setState(() {
                            isLoading = false;
                          });
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
                                'Book Now',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                        textColor: Colors.white,
                        color: Colors.green.shade700,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert!!"),
          content: new Text("Are you sure you Book!"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nofication()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
