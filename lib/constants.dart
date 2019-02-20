import 'package:flutter/material.dart';

/// define the navigation call back function
typedef NavigationCallback = void Function();

class AppIcons{
  static const _asset_base_path = "assets/images/weather_icons";

  static IconData location1 = newIconData(0xe61f); // 定位图标
  static IconData location2 = newIconData(0xe638); // 定位图标
  static IconData rain = newIconData(0xe81e); // 降水量
  static IconData wind = newIconData(0xe6b5); // 风力,风向
  static IconData humidity = newIconData(0xe61e); //相对湿度
  static IconData visibility = newIconData(0xe832); // 能见度


  static Icon infoIcon = Icon(Icons.info, color: Colors.green);
  static Icon erroInfoIcon = Icon(Icons.info, color: Colors.red);



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

  // 中度污染
  static const AQI_LEVEL_4 = Color(0xfffa5535);
  // 重度污染
  static const AQI_LEVEL_5 = Color(0xffe31b40);
  // 严重污染
  static const AQI_LEVEL_6 = Color(0xff8e0636);

  static const CALENDAR_TODAY_COLOR= Color(0xff3dbfc3);

  static const WEATHER_CALENDAR_SPECIAL_WEATHER_AVATAR_BG_COLOR=Colors.blueGrey;
  static const WEATHER_CALENDAR_SPECIAL_WEATHER_AVATAR_F_COLOR=Colors.white;

  static const SEARCH_PAGE_COLOR = Color(0xff848d95);

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

  static const fontSize_14_TextStyle = TextStyle(fontSize: 14.0);

  static const DIVIDER_HEIGHT_3 = SizedBox(height: 3.0);
  static const DIVIDER_HEIGHT_6 = SizedBox(height: 6.0);
  static const DIVIDER_HEIGHT_10 = SizedBox(height: 10.0);
  static const DIVIDER_HEIGHT_15 = SizedBox(height: 15.0);
  static const DIVIDER_WIDTH_5 = SizedBox(width: 5.0);
  static const DIVIDER_WIDTH_10 = SizedBox(width: 10.0);

  static const mainTemperatureTextStyle = TextStyle(
      fontSize: 60.0,
      fontWeight: FontWeight.bold);

  static const WEATHER_CALENDAR_SPECIAL_WEATHER_TEXT_STYLE=TextStyle(
      fontSize: 12.0
  );

  static const DAY_WEATHER_AQI_BORDER_STYLE=BorderRadius.all(Radius.circular(10.0));
  static const DAY_WEATHER_AQI_TEXT_STYLE=TextStyle(color: Colors.white, fontSize: 10.0);

  static TextStyle getAQITextStyle(String aqi){
    // 优/AQI: 0 - 50
    // 良/AQI: 51 - 100
    // 轻度污染/AQI: 101－150
    // 中度污染/ AQI: 151－200
    // 重度污染/ AQI: 201－300
    // 严重污染/ AQI: 大于300

    Color _color = Utils.getQqiColor(aqi);

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

  static const DATA_LOADED = "数据更新成功";
  static const DATA_LOAD_FAILED = "网络超时";

  static const TAB_TEXT_15_DAYS = "15天";
  static const TAB_TEXT_40_DAYS = "40天";

  static const WEEKS = ["日", "一", "二", "三", "四", "五", "六"];
}


class Utils{

  static const _specialWeatherCode = ['00', '01', '03', '13'];
  static const _chineseMonth = {
    "一月": "正月",
    "十一月": "冬月",
    "十二月": "腊月",
  };

  /// 显示在 40 天 天气预报中
  /// 如果 weather1 + weather2 中包含以下文字，
  /// 则 在  40天的 icon 则会以文字显示
  /// 如: 小雨/暴雨 -> 雨, 雨夹雪 -> 雪, 浓雾/强浓雾 -> 雾 ...
  static const _specialWeatherTexts = ['雪', '雨', '霾', '雾'];

  /// get AQI label
  /// [aqi_str] aqi value
  /// [isReturnShort] if true will only return 2 text even the aqi_label length gretter than 2
  /// 优/AQI: 0 - 50
  /// 良/AQI: 51 - 100
  /// 轻度污染/AQI: 101－150
  /// 中度污染/ AQI: 151－200
  /// 重度污染/ AQI: 201－300
  /// 严重污染/ AQI: 大于300
  static String getAqiDisplayText(String aqi_str, {bool isReturnShort: false}) {
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

    if(isReturnShort && _aqi_label.length > 2){
      _aqi_label = _aqi_label.substring(0,2);
    }

    return "$_aqi_label";
  }

  static Color getQqiColor(String aqi_str){
    int aqi = int.parse(aqi_str);
    String _aqi_label;

    Color _color;
//    String _flag_text;

    if(aqi <= 50){
      _color = AppColors.AQI_LEVEL_1;
//      _flag_text = "优";
    } else if(aqi > 50 && aqi <=100){
      _color = AppColors.AQI_LEVEL_2;
//      _flag_text = "良";
    } else if(aqi > 100 && aqi <=150){
      _color = AppColors.AQI_LEVEL_3;
//      _flag_text = "轻度污染";
    } else if(aqi > 150 && aqi <=200){
      _color = AppColors.AQI_LEVEL_4;
//      _flag_text = "中度污染";
    } else if(aqi > 200 && aqi <=300){
      _color = AppColors.AQI_LEVEL_5;
//      _flag_text = "重度污染";
    } else if(aqi > 300){
      _color = AppColors.AQI_LEVEL_6;
//      _flag_text = "严重污染";
    }

    return _color;
  }

  /// Get weather icon by weather code
  /// If weather code in ['00', '01', '03', '13'] 分为 日间 与夜间
  /// d: 表示 日间
  /// n: 表示 夜间
  /// 20 ~ 次日凌晨的 5点 为夜间
  /// 06 ~ 19点为 日间
  static String getWeatherIconByWeatherCode(String weathercode,
      {isDistDayNight: true, forceDay: false, forceNight: false, int hour: null}) {
    String _weatherCode = weathercode.startsWith(new RegExp("d|n"))
        ? weathercode.replaceAll(RegExp("d|n"), '')
        : weathercode;
    if (_specialWeatherCode.contains(_weatherCode)) {
      int currentHour = DateTime
          .now()
          .hour;
      int minusHour = hour != null ? (24 - hour) : (24 - currentHour);
      // 20 ~ 次日凌晨的 5点 为夜间
      // 06 ~ 19点为 日间
      bool isNight = minusHour < 5 || minusHour > 18;

      if(forceDay){
        // if is forceDay, return d00, d$weatherCode
        _weatherCode = "d$_weatherCode";
      } else if (forceNight) {
        // if is forceNight, return n00, n$weatherCode
        _weatherCode = "n$_weatherCode";
      } else if (isDistDayNight && isNight) {
        _weatherCode = "n$_weatherCode";
      } else {
        _weatherCode = "d$_weatherCode";
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
        return Labels.TODAY_TEXT;
      }
    }

    if(week.contains("星期")){
      return week.replaceAll("星期", "周");
    }
    return week;
  }

  /// Get Date YYYYMMDD
  /// return YYYYMMDDD (eg: 20181222)
  static String getDateYMD({DateTime date: null}){
    DateTime _date = date != null ? date: DateTime.now();
    return "${_date.year.toString()}${_date.month.toString().padLeft(2,'0')}${_date.day.toString().padLeft(2,'0')}";
  }

  /// 获取 农历
  /// If 农历节气
  /// {isAppendNL: true} 是否追加 "农历"
  /// {allowConvert: false} 是否转换成 农历月 (十一月 > 冬月, 十二月 > 腊月)
  /// {onlyReturnDay: false} 是否只返回 农历的 日而不返回月 (十一月二十, return 二十)
  /// return 农历(农历节气)
  static String getChineseDateInfo(String nl, {String nljq: null,
    isAppendNL: true, allowConvert: false, onlyReturnDay: false}){
    String _nlText = isAppendNL? "农历" : "";
    String _nl = nl;
    // allowConvert
    // 是否转换成 农历月 (十一月 > 冬月, 十二月 > 腊月)
    if(allowConvert){
      _chineseMonth.forEach((key, value){
        if(nl.contains(key)){
          _nl = nl.replaceAll(key, value);
        }
      });
    }

    if(onlyReturnDay){
      return nl.split("月")[1];
    }

    if(nljq != null && nljq.isNotEmpty){
      return "${_nlText}${_nl}(${nljq})";
    }
    return "${_nlText}${_nl}";
  }

  /// Get Special Weather Text
  /// If the [weatherText] contains one of [_specialWeatherTexts]
  /// return one of item [_specialWeatherTexts]
  static String getSpecialWeatherText(String weatherText){
    for (var i = 0; i < _specialWeatherTexts.length; ++i) {
      var _s = _specialWeatherTexts[i];
      if(weatherText.contains(_s)){
        return _s;
      }
    }
    return null;
  }


}

class Constants {
  static const AppIconFontFamily ="Weather_IconFont";

  // 高德地图 API Key [start]
  static const AMPA_LOCATION_KEY_ANDROID='92db4c9f65225920347c5e5e51fd4cc2';
  // IOS 现在不可用，如果要用IOS, 则需要重新申请 IOS 版本的 API Key
  static const AMPA_LOCATION_KEY_IOS='92db4c9f65225920347c5e5e51fd4cc2';
  // 高德地图 API Key [end]

  static const AQI_RADIUS = 15.0;
  static const WEATHER_ICON_RADIUS = 10.0;

  static const SMALL_WEATHER_ICON_SIZE=24.0;
  static const WEATHER_CALENDAR_ICON_SIZE=20.0;


  static const APP_BAR_HEIGHT = 60.0;

  static const  HORIZONTAL_SIZE_5 = 5.0;
  static const  VERTICAL_SIZE_8 = 8.0;
  static const  VERTICAL_SIZE_10 = 10.0;

  static const SUB_CONTAINER_HEIGHT = 90.0;
  static const SUB_DETAIL_ICON_SIZE = 30.0;
  static const SUB_DETAIL_HORIZONTAL = 10.0;
  static const SUB_DETAIL_VERTICAL = 5.0;
  static const SUB_DETAIL_DEVIDER_WIDTH = 20.0;


  static const DAY_WEATHER_MAIN_CONTAINER_HEIGHT = 140.0;
  static const DAY_WEATHER_CONTAINER_HEIGHT = 130.0;
  static const DAY_WEATHER_PER_CONTAINER_WIDTH = 72.0;
  static const DAY_WEATHER_AQI_HEIGHT=16.0;
  static const DAY_WEATHER_AQI_WIDTH=30.0;


  static const HOURS_24_MAIN_CONTAINER_HEIGHT=100.0;
  static const HOURS_24_CONTAINER_HEIGHT=75.0;
  static const HOURS_24_PER_CONTAINER_WIDTH=51.0;

  static const SHOW_MORE_ICON_CONTAINER_HEIGHT=24.0;

  static const MORE_WEATHER_TAB_HEIGHT=18.0;



}