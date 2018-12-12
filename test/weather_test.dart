import 'dart:convert';

import 'package:flutter_weather/data/weather_utils.dart';
import 'package:flutter_weather/modal/weather.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){


  test("Test Weather json data to weather object", (){
    String city_id = '101270101';
    Future<Weather> future = WeatherUtils.loadWeatherData(city_id);
    future.then((weather){
      print(weather.today);
      print(weather.fc1h_24);
      print(weather.fc40);
    });
  });

}