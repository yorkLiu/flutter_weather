import 'package:json_annotation/json_annotation.dart';
import '../data/config.dart' show WeatherConverter;

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  Weather({this.today, this.fc40, this.fc1h_24});

  Today today;
  List<Future40Days> fc40;
  List<Future24Hours> fc1h_24;

  // 反序列化 json => dart object
  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  // 序列化 dart object => json
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

/**
 * Today real time weather info
 */

@JsonSerializable()
class Today{
  Today({
    this.date,
    this.time,
    this.cityName,
    this.cityCode,
    this.temp,
    this.weather,
    this.weatherCode,
    this.winDirect,
    this.winPower,
    this.winSpeed,
    this.humidity,
    this.visibility,
    this.atmospheric,
    this.aqi,
    this.rain,
    this.rain24h
  });

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

  factory Today.fromJson(Map<String, dynamic> json) => _$TodayFromJson(json);
  Map<String, dynamic> toJson() => _$TodayToJson(this);


  @override
  String toString() {
    return 'Today{date: $date, time: $time, cityName: $cityName, cityCode: $cityCode, temp: $temp, weather: $weather, weatherCode: $weatherCode, winDirect: $winDirect, winPower: $winPower, winSpeed: $winSpeed, humidity: $humidity, visibility: $visibility, atmospheric: $atmospheric, aqi: $aqi, rain: $rain, rain24h: $rain24h}';
  }


}

/**
 * Future 40 days weather info include today
 */

@JsonSerializable()
class Future40Days{
  Future40Days({
    this.date,
    this.nl,
    this.nljq,
    this.week,
    this.maxTemp,
    this.minTemp,
    this.holiday,
    this.weather1,
    this.weather2,
    this.winDirect1,
    this.winDirect2,
    this.winPower1,
    this.winPower2,
    this.aqi,
    this.aqi_label
  });
  String date; // 日期 (i.e: 20180921)
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

  factory Future40Days.fromJson(Map<String, dynamic> json) => _$Future40DaysFromJson(json);
  Map<String, dynamic> toJson() => _$Future40DaysToJson(this);

  @override
  String toString() {
    return '{date: $date, nl: $nl, nljq: $nljq, week: $week, maxTemp: $maxTemp, minTemp: $minTemp, holiday: $holiday, weather1: $weather1, weather2: $weather2, winDirect1: $winDirect1, winDirect2: $winDirect2, winPower1: $winPower1, winPower2: $winPower2, aqi: $aqi, aqi_label: $aqi_label}';
  }


}

/**
 * Future 24 hours weather info
 */

@JsonSerializable()
class Future24Hours{
  Future24Hours({
    this.datetime,
    this.weather,
    this.temp,
    this.winDirect,
    this.winPower
  });
  String datetime; // date time (i.e: 201809211000, 表示: 2018/9/21 上午 11时)
  String weather; // 天气
  String temp; // 湿度
  String winDirect; // 风向
  String winPower; // 风力

  factory Future24Hours.fromJson(Map<String, dynamic> json) => _$Future24HoursFromJson(json);
  Map<String, dynamic> toJson() => _$Future24HoursToJson(this);

  @override
  String toString() {
    return '{datetime: $datetime, weather: $weather, temp: $temp, winDirect: $winDirect, winPower: $winPower}';
  }


}