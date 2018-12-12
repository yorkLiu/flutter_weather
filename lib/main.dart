import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'modal/weather.dart';
import 'data/weather_utils.dart';

void main() => runApp(MaterialApp(
//  title: "天气预报",
  theme: ThemeData.dark().copyWith(
//      primaryColor: Colors.da,
//      cardColor: Color(AppColors.AppBarColor)
  ),
//  home: HomePage(),
home: FutureBuilder(
  future: new Future(() async{
    String city_id = '101270101';
    return await WeatherUtils.loadWeatherData(city_id);
  }),
  builder: (BuildContext context, AsyncSnapshot<Weather> weatherState){
    if(weatherState.data == null){
      return new Center(child: new CircularProgressIndicator());
    }
    if(weatherState.data != null){
//      print(weatherState.data);
//      print(weatherState.requireData.today);
      return HomePage(data: weatherState.data);
    }
  }
),


));
