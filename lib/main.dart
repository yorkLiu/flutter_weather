import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main(){

  runApp(MaterialApp(
//  title: "天气预报",
    theme: ThemeData.dark().copyWith(
//      primaryColor: Colors.da,
//      cardColor: Color(AppColors.AppBarColor)
    ),
    home: WeatherHomePage(),
  ));
}

