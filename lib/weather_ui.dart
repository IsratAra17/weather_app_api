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
// Server theke data anar por Map er madhome Data dekhano
  Map<String,dynamic>? weatherMap;
  Map<String,dynamic>? forecastMap;




  getWeatherData()async{
    var weather=await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=cc93193086a048993d938d8583ede38a&units=metric"));
    print("Weather data: ${weather.body}");
    var forecast=await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?lat=${position!.latitude}&lon=${position!.longitude}&appid=cc93193086a048993d938d8583ede38a&units=metric"));

    var weatherData=jsonDecode(weather.body);
    var forecastData=jsonDecode(forecast.body);

    setState(() {
      weatherMap=Map<String,dynamic>.from(weatherData);
      forecastMap=Map<String,dynamic>.from(forecastData);
    });

  }

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
