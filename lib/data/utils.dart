import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{

  static const CITY_ID_KEY="cityId";
  static const SPLITER_FLAG="#";

  /// Get the cities id from shared preference
  /// will return city ids list
  static Future<List<String>> getPreferCities() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> cities = pref.getStringList(CITY_ID_KEY);

    return cities;
  }

  /// Add city id to shared preference
  /// if there exists city id in shared preference
  /// [cityId] the city id such as "101270101"
  /// [insertToFirst] is insert this city to first index, by default is false
  static addCityToPrefer(String cityId, {bool insertToFirst: false}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> cities = pref.getStringList(CITY_ID_KEY);

    if(cities == null){
      cities = new List<String>();
    }

    // 第一个位置我们是用来放 current location 的位置
    // 所以如果是 [insertToFirst] 位置，但当前的 cityId 与 shard Preference 中的第一个
    // 值不一致，则先将 shard Preference 第一个 删除
    // 以确保第一个永远都是能过定位获取的 current location city id.
    if(insertToFirst && cities.length>0 && cities[0] != cityId){
      cities.removeAt(0);
    }

    // if the city list was contains the [cityId]
    // and need insert this [cityId] to first index
    // then remove from the city list first
    // at last to insert it into first index.
    if(cities.contains(cityId) && insertToFirst){
      cities.remove(cityId);
    }

    if(!cities.contains(cityId)){
      if(insertToFirst){
        cities.insert(0, cityId);
      } else {
        cities.add(cityId);
      }
    }

    await pref.setStringList(CITY_ID_KEY, cities);
  }

  /// Remove the city from Share prefer
  static Future<List<String>> removeCityFromPrefer(String cityId) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> cities = pref.getStringList(CITY_ID_KEY);

    if(cities != null && cities.length > 0){
      if(cities.contains(cityId)){
        cities.remove(cityId);

        // re-set the share prefer
        await pref.setStringList(CITY_ID_KEY, cities);
      }
    }

    return cities;
  }
}



