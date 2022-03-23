/*
import 'package:http/http.dart' as http;
import 'dart:convert';

// OpenWeather.com api key = efb52228910f94f7a93a69174c6b8130
// api call for 7-day daily weather forecast. 
// https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04
// &exclude=current,minutely,hourly,alerts&appid=47dced083ea25cf48cf2d5a4c6d50e4c

var tempt;
var clouds;
var uvi;
var sunrise;
var sunset; 

Future getWeather () async {
  http.Response response = await http.get('https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=current,minutely,hourly,alerts&appid=47dced083ea25cf48cf2d5a4c6d50e4c');
  var result = jsonDecode(response.body);
  setState((){
    this.clouds = ["daily"][0]['clouds'];
    this.uvi = ["daily"][0]['uvi']
    this.sunrise = ["daily"][0]['sunrise']
    this.sunset = ["daily"][0]['sunset']
    this.temp =  ["daily"][0]['temp']['day']
  });
}

@override
void initState(){
  super.initState();
  this.getWeather();
}
*/