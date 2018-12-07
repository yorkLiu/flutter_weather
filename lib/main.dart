import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(MaterialApp(
  title: "天气预报",
  theme: ThemeData.light().copyWith(
      primaryColor: Colors.black54,
//      cardColor: Color(AppColors.AppBarColor)
  ),
  home: HomePage(),

));
