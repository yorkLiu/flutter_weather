//import 'package:serializer/serializer.dart';
//
//@serializable
class Weather {
  Today today;
  List<Future40Days> fc40;
  List<Future24Hours> fc1h_24;
}

/**
 * Today real time weather info
 */
class Today{
  String date; // 日期 (i.e: 09月21日(星期五))
  String time; // 更新时间
  String cityName;
  String cityCode;
  String temp;
  String weather; // 天气 (i.e: 睛，多云，阴)
  String weatherCode; // 天气编码
  String winDirect; // 风向
  String winPower; // 风力
  String winSpeed; // 风速
  String humidity; // 相对湿度
  String visibility; // 能见度
  String atmospheric; // 大气压强
  String aqi; // 空气质量 score
  String rain; // 降雨量
  String rain24h; //未来24小是降雨量
}

/**
 * Future 40 days weather info include today
 */
class Future40Days{
  String data; // 日期 (i.e: 20180921)
  String nl; // 农历(i.e: 八月十二)
  String nljq; // 农历节气 (i.e: 春分，霜降)
  String week; // 周几 (i.e: 星期五)
  String maxTemp; // 最高温度
  String minTemp; // 最低湿度
  String holiday; // 节日 (i.e: 清明，劳动节，中秋节, 春节...)
  String weather1; // 天气1
  String weather2; // 天气2
  String winDirect1; // 风向1
  String winDirect2; // 风向2
  String winPower1; // 风力1
  String winPower2; // 风力2
  String aqi; // 空气质量 score
  String aqi_label; // 空气质量 (i.e: 优，良，轻度污染,...)
}

/**
 * Future 24 hours weather info
 */
class Future24Hours{
  String datetime; // date time (i.e: 201809211000, 表示: 2018/9/21 上午 11时)
  String weather; // 天气
  String temp; // 湿度
  String winDirect; // 风向
  String winPower; // 风力
}