import 'package:flutter/material.dart';

class AppIcons{
  static const _asset_base_path = "assets/images/weather_icons";

  static IconData location1 = newIconData(0xe61f); // 定位图标
  static IconData location2 = newIconData(0xe638); // 定位图标
  static IconData rain = newIconData(0xe81e); // 降水量
  static IconData wind = newIconData(0xe6b5); // 风力,风向
  static IconData humidity = newIconData(0xe61e); //相对湿度
  static IconData visibility = newIconData(0xe832); // 能见度



  // create a IconData by codePoint (unicode)
  static IconData newIconData(int codePoint, {String fontFamily: Constants.AppIconFontFamily}){
    return IconData(codePoint, fontFamily: Constants.AppIconFontFamily);
  }

  // get the weather image from assets folder
  // Note weather code 00, 01, 03, 13 分为 日间与夜间
  // 日间为: d00, d01, d01, d13
  // 夜间为: n00, n01, n01, n13
  static Image getWeatherIcon(String weatherCode, {double size: 50.0}){
    weatherCode = weatherCode == '0' ? "00": weatherCode;
    return Image.asset("$_asset_base_path/$weatherCode.png",
      width: size,
      height: size,
    );
  }

}


class AppColors {

  static const borderColor = Color.fromRGBO(255, 255, 255, 0.1);

  // 优
  static const AQI_LEVEL_1 = Color(0xff44cf12);
  // 良
  static const AQI_LEVEL_2 = Color(0xffeec500);
  // 轻度污染
  static const AQI_LEVEL_3 = Color(0xffff9900);
//  static const AQI_LEVEL_3 = Color.fromRGBO(255, 153, 0, 1.0);
  // 中度污染
  static const AQI_LEVEL_4 = Color(0xfffa5535);
  // 重度污染
  static const AQI_LEVEL_5 = Color(0xffe31b40);
  // 严重污染
  static const AQI_LEVEL_6 = Color(0xff8e0636);

}

class AppStyles {


  static const dataFromTextStyle=TextStyle(
    fontSize: 10.0
  );
  static const updateTimeTextStyle=TextStyle(
    fontSize: 8.0
  );

  static const borderStyle = BorderSide(
      color: AppColors.borderColor,
      width: 1.0
  );

  static const todayWeatherTextStyle= TextStyle(fontSize: 12.0);

  static const DIVIDER_HEIGHT_6 = SizedBox(height: 6.0);
  static const DIVIDER_HEIGHT_15 = SizedBox(height: 15.0);

  static const mainTemperatureTextStyle = TextStyle(
      fontSize: 60.0,
      fontWeight: FontWeight.bold);

  static TextStyle getAQITextStyle(int aqi){
    // 优/AQI: 0 - 50
    // 良/AQI: 51 - 100
    // 轻度污染/AQI: 101－150
    // 中度污染/ AQI: 151－200
    // 重度污染/ AQI: 201－300
    // 严重污染/ AQI: 大于300

    Color _color;
    String _flag_text;

    if(aqi <= 50){
      _color = AppColors.AQI_LEVEL_1;
      _flag_text = "优";
    } else if(aqi > 50 && aqi <=100){
      _color = AppColors.AQI_LEVEL_2;
      _flag_text = "良";
    } else if(aqi > 100 && aqi <=150){
      _color = AppColors.AQI_LEVEL_3;
      _flag_text = "轻度污染";
    } else if(aqi > 150 && aqi <=200){
      _color = AppColors.AQI_LEVEL_4;
      _flag_text = "中度污染";
    } else if(aqi > 200 && aqi <=300){
      _color = AppColors.AQI_LEVEL_5;
      _flag_text = "重度污染";
    } else if(aqi > 300){
      _color = AppColors.AQI_LEVEL_6;
      _flag_text = "严重污染";
    }

    return TextStyle(
      fontSize: 14.0,
      color: _color,
      fontWeight: FontWeight.bold,
    );
  }

}

class Labels {
  static const DATA_FROM_TEXT = "中国天气网";
  static const AQI_TEXT = "空气质量";
  static const RAIN_TEXT = "降水量";
  static const WIND_TEXT = "风向 风力";
  static const HUMIDITY_TEXT = "相对湿度";
  static const VISIBILITY_TEXT = "能见度";
  static const TODAY_TEXT = "今天";
}


class Utils{

  static List<String> _specialWeatherCode = ['00', '01', '03', '13'];

  /// get AQI label
  /// 优/AQI: 0 - 50
  /// 良/AQI: 51 - 100
  /// 轻度污染/AQI: 101－150
  /// 中度污染/ AQI: 151－200
  /// 重度污染/ AQI: 201－300
  /// 严重污染/ AQI: 大于300
  static String getAqiDisplayText(String aqi_str) {
    int aqi = int.parse(aqi_str);
    String _aqi_label;

    if (aqi <= 50) {
      _aqi_label = "优";
    } else if (aqi > 50 && aqi <= 100) {
      _aqi_label = "良";
    } else if (aqi > 100 && aqi <= 150) {
      _aqi_label = "轻度污染";
    } else if (aqi > 150 && aqi <= 200) {
      _aqi_label = "中度污染";
    } else if (aqi > 200 && aqi <= 300) {
      _aqi_label = "重度污染";
    } else if (aqi > 300) {
      _aqi_label = "严重污染";
    }

    return "$aqi_str $_aqi_label";
  }

  /// Get weather icon by weather code
  /// If weather code in ['00', '01', '03', '13'] 分为 日间 与夜间
  /// d: 表示 日间
  /// n: 表示 夜间
  /// 20 ~ 次日凌晨的 5点 为夜间
  /// 06 ~ 19点为 日间
  static String getWeatherIconByWeatherCode(String weathercode, {int hour: null}){
    String _weatherCode = weathercode;
    if(_specialWeatherCode.contains(weathercode)){
      int currentHour = DateTime.now().hour;
      int minusHour = hour != null ? (24-hour) : (24-currentHour);
      // 20 ~ 次日凌晨的 5点 为夜间
      // 06 ~ 19点为 日间
      bool isNight = minusHour < 5 || minusHour > 18;

      if(isNight){
        _weatherCode = "n$weathercode";
      } else {
        _weatherCode = "d$weathercode";
      }
    }

    return _weatherCode;
  }

  /// Get short week
  /// Replace "星期" to "周"
  /// "星期一" -> "周一"
  static String getShortWeek(String week, {String date: null}){
    if(date !=null && date.isNotEmpty){
      DateTime today = DateTime.now();
      String todayYMD = "${today.year.toString()}${today.month.toString().padLeft(2,'0')}${today.day.toString().padLeft(2,'0')}";
      if(date.trim().compareTo(todayYMD) == 0){
        return "今天";
      }
    }

    if(week.contains("星期")){
      return week.replaceAll("星期", "周");
    }
    return week;
  }
}

class Constants {
  static const AppIconFontFamily ="Weather_IconFont";
}