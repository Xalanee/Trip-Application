import 'dart:convert';

import 'package:dalxiz/screens/home_screen.dart';
import 'package:dalxiz/screens/spash_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class Nofication extends StatefulWidget {
  const Nofication({
    Key? key,
    String? payload,
  }) : super(key: key);

  @override
  State<Nofication> createState() => _NoficationState();
}

class _NoficationState extends State<Nofication> {
  // late String title;
  // late String payload;
  // late String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromARGB(255, 112, 190, 112),
          title: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text(
              'Bookings',
              style: TextStyle(fontSize: 30),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SplashScreen()));
            },
          ),
        ),
        body: Container(child: buildTripCard(context)));
  }

  Widget buildTripCard(context) {
    Future GetTrips() async {
      var api = "http://localhost:5000/users/trip";
      final response = await http.get(Uri.parse(api), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      return jsonDecode(response.body);
    }

    Future Delete(Id) async {
      var api = "http://localhost:5000/users/trip/${Id}";
      final response =
          await http.delete(Uri.parse(api), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      return jsonDecode(response.body);
    }

    return Center(
        child: Container(
            child: FutureBuilder(
                future: GetTrips(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("No data Available."),
                    );
                  }
                  // print(snapshot.data['data']['data']);

                  var data = snapshot.data['data']['data'];

                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      data[index]['title'],
                                      style: new TextStyle(
                                        fontSize: 30.0,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        Delete(data[index]['id']);
                                        setState(() {});
                                      },
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 30.0),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        data[index]['body'],
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    )
                                    // Spacer(),
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: .0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        r"$ " +
                                            data[index]['payload'].toString(),
                                        style: new TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent),
                                      ),
                                      Spacer(),
                                      Icon(Icons.directions_car),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                })));
  }
}
