import 'package:dio/dio.dart';
import 'dart:convert';
import 'config.dart';
import '../modal/weather.dart';
import '../exceptions/networkexception.dart';

class WeatherUtils {

  static List<dynamic> _cityData = null;

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

  /**
   * Get the network IP
   * With visit the http://www.ip.cn url
   */
  static Future<String> _getIP() async{
    var ipRegexp = RegExp(
        r'((?:(?:25[0-5]|2[0-4]\d|(?:1\d{2}|[1-9]?\d))\.){3}(?:25[0-5]|2[0-4]\d|(?:1\d{2}|[1-9]?\d)))');
    var url = "http://www.ip.cn";
    var ip = "Unknow";
    Response r = await new Dio().get(url);

    if(r.statusCode == 200){
      r.data.split("\n").forEach((line) {
        ipRegexp.allMatches(line).forEach((match) {
          ip = match.group(0);
        });
      });
    }

    return ip;
  }

  /**
   * Params:
   * [ac] city code
   * [n] city 中文名称
   * [p] city 全拼
   * [tc] city 电话区号
   * [pc] city 邮编
   * [fl] city 拼音简写 (i.e: beijing ==> BJ, chengdu ==> CD)
   * [pv] 省份 (四川，福建 ..)
   *
   * return List
   */
  static Future<List<dynamic>> loadCityData() async{
    if(_cityData != null){
      return _cityData;
    }

    var url = "http://i.tq121.com.cn/j/wap2016/news/city_search_data.js";
    Response r = await new Dio().get(url);
    var regex = r'(\[.*\])';
    var results = new RegExp(regex).firstMatch(r.data);
    var result = results[0];
    result = result.replaceAll('ac:','"ac":')
        .replaceAll('n:','"n":')
        .replaceAll('p:','"p":')
        .replaceAll('tc:','"tc":')
        .replaceAll('pc:','"pc":')
        .replaceAll('fl:','"fl":')
        .replaceAll('pv:','"pv":');
    _cityData = jsonDecode(result);
    return _cityData;
  }

  /**
   * Search city like [keyWords]
   *
   * [keyWords] search key words (城市/拼音/电话区号)
   * [province] search by province 中文名称
   * [cityname] search by city 文名称
   * [strictMatchCityCode] search by city code (strict match) (i.e: 成都 "101270101", 龙泉驿: "101270102")
   *
   *
   * IF [province] && [cityname] 则只返回一个结果
   * IF [province] OR [cityname] 则返回所有的查询结果
   *
   * For Example:
   *
   * searchCity('028') ==> [{ac: 101270101, n: 成都, pv: 四川}, {ac: 101270102, n: 龙泉驿, pv: 四川}...]
   * searchCity(null, province: '四川') ==> [{ac: 101270101, n: 成都, pv: 四川}, {ac: 101270102, n: 龙泉驿, pv: 四川}...]
   * searchCity(null, cityname: '成都') == > [{ac: 101270101, n: 成都, pv: 四川}, {ac: 10127010106A, n: 成都大熊猫繁育研究基地, pv: 四川省景点},...]
   * searchCity(null, province: '四川', cityname: '成都') ==> [{ac: 101270101, n: 成都, pv: 四川}]
   * searchCity(null, strictMatchCityCode: '101270101') ==> [{ac: 101270101, n: 成都, pv: 四川}]
   *
   *
   */
  static List searchCity(String keyWords, {String province: null, String cityname: null, String strictMatchCityCode:null}) {

    var resultDatas = [];
    if ((keyWords == null || keyWords.isEmpty)
    && (cityname == null || cityname.isEmpty)
    && (province == null || province.isEmpty)) {
      return resultDatas;
    }

    for (var i = 0; i < _cityData.length; i++) {
      var data = {};
      var city = _cityData[i];

      var city_ac=city['ac'].toString();
      var city_name=city['n'].toString();
      var city_pv = city['pv'].toString();
      var city_p = city['p'].toString();
      var city_tc = city['tc'].toString();
      var city_pc = city['pc'].toString();
      var city_fl = city['fl'].toString();

      // only search for province and city
      if((cityname != null && cityname.isNotEmpty)
       || (province != null && province.isNotEmpty)){
        bool aFind = false;
        bool onlyFindOne = (cityname != null && cityname.isNotEmpty) && (province != null && province.isNotEmpty);

        // province
        if(province != null && province.isNotEmpty){
          aFind = province.indexOf(city_pv)==0 || city_pv.indexOf(province)==0 || city_pv == province;
        }

        // city
        if (cityname != null && cityname.isNotEmpty) {
          aFind = cityname.indexOf(city_name) == 0 ||
              city_name.indexOf(cityname) == 0 || city_name == cityname;
        }

        if(aFind){
          data['ac'] = city_ac;
          data['n'] = city_name;
          data['pv'] = city_pv;
          resultDatas.add(data);
          if(onlyFindOne){
            break;
          } else {
            continue;
          }

        } else {
          continue;
        }
      }

      // search by the city code (strict match)
      if(strictMatchCityCode != null && strictMatchCityCode.isNotEmpty){
        if(city_ac == strictMatchCityCode){
          data['ac'] = city_ac;
          data['n'] = city_name;
          data['pv'] = city_pv;
          resultDatas.add(data);
          break;
        } else {
          continue;
        }
      }


      if (city_name.indexOf(keyWords) == 0 || city_name == keyWords) {
        data['ac'] = city_ac;
        data['n'] =
            city_name.substring(0, keyWords.length) + city_name.substring(keyWords.length);
        data['pv'] = city_pv;
        resultDatas.add(data);
        continue;
      }
      var bFind = false;

      if (city_p.toLowerCase().indexOf(keyWords.toLowerCase()) == 0 ||
          city_p.toLowerCase() == keyWords.toLowerCase()) {
        bFind = true;
      }

      if (!bFind && city_tc.isNotEmpty  && city_tc.indexOf(keyWords) == 0 ||
          (keyWords.substring(0, 1) == '0' &&
              ("0" + city_tc).indexOf(keyWords) == 0)) {
        bFind = true;
      }

      if (!bFind && ((city_pc.isNotEmpty && city_pc.indexOf(keyWords) == 0) ||
          (city_fl.isNotEmpty && city_fl.toLowerCase().indexOf(keyWords.toLowerCase()) == 0))) {
        bFind = true;
      }



      if (!bFind) {
        continue;
      }
      data['ac'] = city_ac;
      data['n'] = city_name;
      data['pv'] = city_pv;
      resultDatas.add(data);
    }
    return resultDatas;
  }

  /**
   * Get the current GEO locale
   * return {
   *  lat:
   *  lng:
   *  country:
   *  province:
   *  city:
   *  district:
   *  adcode:
   * }
   */
  static Future<dynamic> getCurrentGeoLocale() async{
    var _ip = await _getIP();
    var url = "https://apis.map.qq.com/ws/location/v1/ip?callback=locale&ip=$_ip&key=TKUBZ-D24AF-GJ4JY-JDVM2-IBYKK-KEBCU&output=jsonp&t=${_getTimestamp()}";
    var regex_pattens = r'"result":(\{.*\})\s*\}\)';

    Dio dio = new Dio();
    Response r = await dio.get(url);

    var d = r.data.toString().replaceAll("\n", "").replaceAll(" ", "");
    var results = new RegExp(regex_pattens).firstMatch(d);
    var result = results[1];
//    result = result.replaceAll(new RegExp(',"adcode":[0-9]{6,}'), "");
    Map map  = jsonDecode(result);

    var province = map['ad_info']['province'];
    var district = map['ad_info']['district'];
    var postCode = map['ad_info']['adcode'];
    var cities = searchCity(null, province: province, cityname: district);
    var city_code = cities[0]['ac'];

    return {
      'lat': map['location']['lat'],
      'lng': map['location']['lng'],
      'country': map['ad_info']['nation'],
      'province': province,
      'city': map['ad_info']['city'],
      'district': district,
      'postCode': postCode,
      'city_code': city_code
    };
  }

}



main() {
  String city_id = '101270102';
  WeatherUtils._get_weather_info(city_id).then((data){
    print(data);
    Weather weather = Weather.fromJson(json.decode(data));
    print(weather.today);
    print(weather.fc1h_24);
    print(weather.fc40);
  });


//    Future<Weather> future = WeatherUtils.loadWeatherData(city_id);
//    future.then((weather){
//      print(weather);
//      print(weather.today);
//      print(weather.fc1h_24);
//      print(weather.fc40);
//    });

//  WeatherUtils.getLocale();
//  WeatherUtils.loadCityData().then((a){
//    var s = WeatherUtils.searchCity("0818", strictMatchCityCode: '101270102');
//    print(s);
//
////    WeatherUtils.getCurrentGeoLocale().then((a){
////      print(a);
////    });
//  });





}

