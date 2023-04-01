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
    return SafeArea(
      child: weatherMap!=null? Scaffold(
        body: Container(
          padding: EdgeInsets.all(25),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Text("${Jiffy("${DateTime.now()}").format('MMM do yyyy')}, ${Jiffy("${DateTime.now()}").format('hh mm')}"),
                    Text("${weatherMap!["name"]}"),
                  ],
                ),
              ),
              Image.network("https://openweathermap.org/img/wn/${weatherMap!["weather"][0]["icon"]}@2x.png"),
              Text("${weatherMap!["main"]["temp"]}°"),


              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text("Feels Like ${weatherMap!["main"]["feels_like"]}"),
                    Text("${weatherMap!["weather"][0]["description"]}"),
                  ],
                ),
              ),

              Text("Humidity ${weatherMap!["main"]["humidity"]},Pressure ${weatherMap!["main"]["pressure"]}"),

              Text("Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("hh mm a")}, Sunset  ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("hh mm a")}")

              ,SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: forecastMap!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Text("${Jiffy("${forecastMap!["list"][index]["dt_txt"]}").format("EEE h mm")}")

                          ,Image.network("https://openweathermap.org/img/wn/${forecastMap!["list"][index]["weather"][0]["icon"]}@2x.png"),
                          Text("${forecastMap!["list"][index]["main"]["temp_min"]}"),
                          Text("${forecastMap!["list"][index]["weather"][0]["description"]}"),
                        ],
                      ),
                    );
                  },
                ),
              )


            ],
          ),
        ),
      ) :Center(child: CircularProgressIndicator()),
    );
  }
}
