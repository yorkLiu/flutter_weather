// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
      today: json['today'] == null
          ? null
          : Today.fromJson(json['today'] as Map<String, dynamic>),
      fc40: (json['fc40'] as List)
          ?.map((e) => e == null
              ? null
              : Future40Days.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      fc1h_24: (json['fc1h_24'] as List)
          ?.map((e) => e == null
              ? null
              : Future24Hours.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'today': instance.today,
      'fc40': instance.fc40,
      'fc1h_24': instance.fc1h_24
    };

Today _$TodayFromJson(Map<String, dynamic> json) {
  return Today(
      date: json['date'] as String,
      time: json['time'] as String,
      cityName: json['cityName'] as String,
      cityCode: json['cityCode'] as String,
      temp: json['temp'] as String,
      weather: json['weather'] as String,
      weatherCode: json['weatherCode'] as String,
      winDirect: json['winDirect'] as String,
      winPower: json['winPower'] as String,
      winSpeed: WeatherConverter.escapeHtml(json['winSpeed'].toString()) as String,
      humidity: json['humidity'] as String,
      visibility: json['visibility'] as String,
      atmospheric: json['atmospheric'] as String,
      aqi: json['aqi'] as String,
      rain: json['rain'] as String,
      rain24h: json['rain24h'] as String);
}

Map<String, dynamic> _$TodayToJson(Today instance) => <String, dynamic>{
      'date': instance.date,
      'time': instance.time,
      'cityName': instance.cityName,
      'cityCode': instance.cityCode,
      'temp': instance.temp,
      'weather': instance.weather,
      'weatherCode': instance.weatherCode,
      'winDirect': instance.winDirect,
      'winPower': instance.winPower,
      'winSpeed': instance.winSpeed,
      'humidity': instance.humidity,
      'visibility': instance.visibility,
      'atmospheric': instance.atmospheric,
      'aqi': instance.aqi,
      'rain': instance.rain,
      'rain24h': instance.rain24h
    };

Future40Days _$Future40DaysFromJson(Map<String, dynamic> json) {
  return Future40Days(
      date: json['date'] as String,
      nl: json['nl'] as String,
      nljq: json['nljq'] as String,
      week: json['week'] as String,
      maxTemp: json['maxTemp'] as String,
      minTemp: json['minTemp'] as String,
      holiday: json['holiday'] as String,
      weather1: WeatherConverter.convertWeatherCode(json['weather1']) as String,
      weather2: WeatherConverter.convertWeatherCode(json['weather2']) as String,
      winDirect1: WeatherConverter.convertWinDirect(json['winDirect1']) as String,
      winDirect2: WeatherConverter.convertWinDirect(json['winDirect2']) as String,
      winPower1: WeatherConverter.convertWinPower(json['winPower1']) as String,
      winPower2: WeatherConverter.convertWinPower(json['winPower2']) as String,
      aqi: json['aqi'] as String,
      aqi_label: json['aqi_label'] as String);
}

Map<String, dynamic> _$Future40DaysToJson(Future40Days instance) =>
    <String, dynamic>{
      'date': instance.date,
      'nl': instance.nl,
      'nljq': instance.nljq,
      'week': instance.week,
      'maxTemp': instance.maxTemp,
      'minTemp': instance.minTemp,
      'holiday': instance.holiday,
      'weather1': instance.weather1,
      'weather2': instance.weather2,
      'winDirect1': instance.winDirect1,
      'winDirect2': instance.winDirect2,
      'winPower1': instance.winPower1,
      'winPower2': instance.winPower2,
      'aqi': instance.aqi,
      'aqi_label': instance.aqi_label
    };

Future24Hours _$Future24HoursFromJson(Map<String, dynamic> json) {
  return Future24Hours(
      datetime: json['datetime'] as String,
      weather:  WeatherConverter.convertWeatherCode(json['weather']) as String,
      temp: json['temp'] as String,
//      winDirect:json['winDirect'] as String,
//      winPower: json['winPower'] as String);
      winDirect: WeatherConverter.convertWinDirect(json['winDirect']) as String,
      winPower: WeatherConverter.convertWinPower(json['winPower']) as String);
}

Map<String, dynamic> _$Future24HoursToJson(Future24Hours instance) =>
    <String, dynamic>{
      'datetime': instance.datetime,
      'weather': instance.weather,
      'temp': instance.temp,
      'winDirect': instance.winDirect,
      'winPower': instance.winPower
    };