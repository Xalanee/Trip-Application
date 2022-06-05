import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
}

var Trips = [];
Future gettrips() async {
  var api = "http://localhost:5000/users/trips";
  final response = await http.get(Uri.parse(api), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  return Trips = jsonDecode(response.body);
}

List<NavigationItem> getNavigationItemList() {
  return <NavigationItem>[
    NavigationItem(Icons.home),
    NavigationItem(Icons.notifications),
    NavigationItem(Icons.settings),
    NavigationItem(Icons.person),
  ];
}

class Place {
  String description;
  String country;
  double price;
  List<String> images;
  bool favorite;

  Place(this.description, this.country, this.price, this.images, this.favorite);
}

// class tripe {
//   String memo;
//   String country;
//   double price;
//   List<String> images;
//   bool favorite;

//   tripe(this.memo, this.country, this.price, this.images, this.favorite);
// }

List<Place> getPlaceList() {
  return <Place>[
    Place(
        "Magaalo Bilic iyo qurux ku dheehantahy",
        "Bosaso",
        250.9,
        [
          "assets/images/qnadalla.jpeg",
          "assets/images/image0.jpeg",
          "assets/images/image1.jpeg",
        ],
        true),
    Place(
        "Buurta ugu wayn buurhaha Somalia ku yaal ee loo dalxiiso",
        "Cerigabo",
        290,
        [
          "assets/images/buurta daalo.jpg",
          "assets/images/daalo.jpg",
          "assets/images/image14.jpeg",
          "assets/images/image15.jpeg",
        ],
        false),
    Place(
        "Degmada Eyl waxey ku taala nawaaxiga nugaal wana goob dalxiis",
        "Eyl",
        370.5,
        [
          "assets/images/eyl.jpg",
          "assets/images/image3.jpeg",
          "assets/images/image15.jpeg",
          "assets/images/image10.jpeg",
        ],
        false),
    Place(
        "Waa cirifka woqoyi wana magalo ku macan dalxiz",
        "Ras-CAsayr",
        220.5,
        [
          "assets/images/calula.jpeg",
          "assets/images/image17.jpeg",
          "assets/images/image13.jpeg",
          "assets/images/xeebta calula.jpeg",
        ],
        false),
    Place(
        "One of the largest district in east aftica",
        "Baargaal",
        390,
        [
          "assets/images/image4.jpeg",
          "assets/images/image5.jpeg",
          "assets/images/image7.jpeg",
          "assets/images/image9.jpeg",
          "assets/images/image8.jpeg",
        ],
        false),
    Place(
        "degmada calula wa mesha ugu kalumaysiga badan mamulka puntland",
        "Calula",
        205,
        [
          "assets/images/image10.jpeg",
          "assets/images/image11.jpeg",
          "assets/images/image12.jpeg",
          "assets/images/image13.jpeg",
        ],
        false),
    Place(
        "degmada calula wa mesha ugu kalumaysiga badan mamulka puntland",
        "Calula",
        205,
        [
          "assets/images/image10.jpeg",
          "assets/images/image11.jpeg",
          "assets/images/image12.jpeg",
          "assets/images/image13.jpeg",
        ],
        false),
  ];
}
