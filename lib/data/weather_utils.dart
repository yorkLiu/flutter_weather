import 'package:dio/dio.dart';
import 'dart:convert';
import 'config.dart';
import '../modal/weather.dart';
import '../exceptions/networkexception.dart';

class WeatherUtils {

  static int _getTimestamp() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static _parseToJson(strContent){
    var data = [];

    if(strContent == null){
      return json.decode("{'msg': 'content is null'}");
    }

    var eval = json.decode(strContent);
    if(eval is List){
      data.addAll(eval);
    } else {
      data.add(eval);
    }
    return data;
  }

  static _get_request(url, headers, {params = null, regex_pattens = null, columns = null}) async {
    var data ={};
    Options options = Options(
        headers: headers,
        connectTimeout: 10000,
        receiveTimeout: 20000);
    Dio dio = new Dio(options);
    Response r;
    for (var i = 0; i < 3; i++) {
      try{
        r = await dio.get(url, data: params, options: options);
        break;
      }catch(e){
        print("Request URL ERROR....wither headers: ${headers.toString()}");
        continue;
      }
    }

    if(r == null){
      throw NetworkException("Please check the network");
    }


    if (r.statusCode == 200) {
      var response = r.data;

      for (var key in regex_pattens.keys) {
        var array = [];
        var regex = regex_pattens[key];
        Match match = new RegExp(regex).firstMatch(response);
        String result = match != null ? match.group(1): null;
        var json_array = _parseToJson(result);
        var cols = columns[key];

        if (cols != null){
          for(var d in json_array){
            var item = {};
            for (var c in cols.keys){
              if(d.keys.contains(c)){
                item[cols[c]] =d[c];
              }
            }
            array.add(item);

            if(array.length > 1){
              data[key] = array;
            } else{
              data[key] = array[0];
            }
          }
        }
      }

      return data;
    } else{
      throw new Exception("Could not request Url '$url'");
    }
  }

  /**
   * Get 40 days weather info
   * Contains 40days and future 24 hours weather info
   */
  static _get_40_days_24hours_weather(city_id) async{
    var days_40_API = APIS['40D'];
    var headers = get_headers(days_40_API['extra_headers']);
    var url = days_40_API['url'].toString().replaceAll("{city_id}", city_id);

    var regex_pattens = {
      'fc40': API_REGEX['fc40'],
      'fc1h_24': API_REGEX['fc1h_24']
    };

    var columns = {
      'fc40': API_COLUMNS_MAPPING['fc40'],
      'fc1h_24': API_COLUMNS_MAPPING['fc1h_24']
    };

    var data = await _get_request(url, headers,
        params: {'_': _getTimestamp()},
        regex_pattens: regex_pattens,
        columns: columns);

    return data;
  }

  static _get_today_weather(city_id) async {
    var today_API = APIS['today'];
    var headers = get_headers(today_API['extra_headers']);

    String url = today_API['url'].toString().replaceAll("{city_id}", city_id);

    var regex_pattens = {'today': API_REGEX['today']};

    var columns = {'today': API_COLUMNS_MAPPING['today']};

    var data = await _get_request(url, headers,
        params: {'_': _getTimestamp()},
        regex_pattens: regex_pattens,
        columns: columns);

    return data;
  }

  /**
   * Get weather info (contains, today real time weather, 40 days weather and 24 hours weather info)
   *   @Visit: https://www.jianshu.com/p/ca37900a25e6
   *   :param city_id:
   *   :return: {
   *   'success': true,
   *   'today': {...}, # today weather
   *   'fc1h_24': [{...}, {...}], # today future 24 hours weather
   *   'fc40': [{...}, {...}] # 40 days weather
   *   }
   */
  static _get_weather_info(city_id) async{
      if(city_id == null || city_id == ''){
        return {
          'success': false,
          'msg': 'Missing City ID'
        };
      }
      var weather = {};
      var data1 = await _get_today_weather(city_id);
      var data2 = await _get_40_days_24hours_weather(city_id);

      weather.addAll(data1);
      weather.addAll(data2);

      return json.encode(weather);
  }

  static Future<Weather> loadWeatherData(city_id) async{
    try {
      var data = await _get_weather_info(city_id);
      Weather _weather = Weather.fromJson(json.decode(data));
      _weather.setCityCode(city_id);
      return _weather;
    } catch(e){
      print(">ERRR>>>>>>>>>>");
      Weather _error = Weather();
      if(e.toString().startsWith("NetworkException")){
        _error.errorCode = "NetWorkError";
      } else {
        _error.errorCode = "ERROR";
      }
      return _error;
    }
  }
}

main() {
  String city_id = '101270101';
//  WeatherUtils._get_weather_info(city_id).then((data){
//    print(data);
//    Weather weather = Weather.fromJson(json.decode(data));
//    print(weather.today);
//    print(weather.fc1h_24);
//    print(weather.fc40);
//  });


    Future<Weather> future = WeatherUtils.loadWeatherData(city_id);
    future.then((weather){
      print(weather);
      print(weather.today);
      print(weather.fc1h_24);
      print(weather.fc40);
    });


}

