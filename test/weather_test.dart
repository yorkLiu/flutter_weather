import 'dart:convert';

import 'package:flutter_weather/data/weather_utils.dart';
import 'package:flutter_weather/modal/weather.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){

  test("Test Weather json data to weather object", (){
    String city_id = '101270101';
    WeatherUtils.get_weather_info(city_id).then((data){
      Weather weather = Weather.fromJson(json.decode(data));
      assert(weather.today != null);
      assert(weather.fc1h_24 != null);
      assert(weather.fc40 != null);
      print(weather.today);
      print(weather.fc1h_24);
      print(weather.fc40);
    });
  });

}