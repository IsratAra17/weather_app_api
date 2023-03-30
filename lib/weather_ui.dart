import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class Weather_UI extends StatefulWidget {
  const Weather_UI({Key? key}) : super(key: key);

  @override
  State<Weather_UI> createState() => _Weather_UIState();
}

class _Weather_UIState extends State<Weather_UI> {

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position= await Geolocator.getCurrentPosition();
    getWeatherData();
    print("This  is my latitude is ${position!.latitude}  longitute is ${position!.longitude}");
  }


  Position ?position;

  //Map<String,dynamic>? weatherMap;
 // Map<String,dynamic>? forecastMap;




  getWeatherData(){}




  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
