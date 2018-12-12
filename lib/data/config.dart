
import 'dart:math';

var URLS = {
  '40D_Weather_API': 'http://d1.weather.com.cn/wap_40d/{city_id}.html',
  'Today_Weather_API': 'http://d1.weather.com.cn/sk_2d/{city_id}.html',
  'Alarm': 'http://d1.weather.com.cn/dingzhi/{city_id}.html?_=1536053479436'
};

var APIS = {
  'today': {
    'url': URLS['Today_Weather_API'],
    'extra_headers': {
      'Host': 'd1.weather.com.cn',
      'Referer': 'http://m.weather.com.cn/mweather1d'
    }
  },
  '40D': {
    'url': URLS['40D_Weather_API'],
    'extra_headers': {
      'Host': 'd1.weather.com.cn',
      'Referer': 'http://m.weather.com.cn/mweather40d'
    }
  }
};

var API_REGEX = {
  // 解析 today API 返回数据的 regex
  'today': r'var\s*dataSK\s*=\s*(.*)\s*',
  // 解析 40 天 API 返回数据的 regex
  'fc40': r'var\s*fc40\s*=\s*(\[\s*.*\])\s*;',
  // 解析 24小时 API 返回数据的 regex
  'fc1h_24': r'var\s*fc1h_24\s*=\{"jh":\s*(\[.*\])\};'
};

var API_COLUMNS_MAPPING = {
  //40天API (APIS['today'] --> dataSK = {...})返回数据对应的 columns mapping
  'today': {
    'date': 'date', //日期(09月10日(星期一))
    'time': 'time', //更新时间
    'cityname': 'cityName', //城市名
    'city': 'cityCode', //城市编号
    'temp': 'temp', //温度
    'weather': 'weather', //天气
    'weathercode': 'weatherCode', //天气 编码
    'WD': 'winDirect', //风向
    'WS': 'winPower', //风力
    'wse': 'winSpeed', //风速
    'SD': 'humidity', //相对湿度
    'njd': 'visibility', //能见度
    'qy': 'atmospheric', //气压
    'aqi': 'aqi', //空气质量 分数
    'rain': 'rain', //降雨量
    'rain24h': 'rain24h' //24小时降雨量
  },
  //40天API (APIS['40D_New'] --> fc40 = [{...}, {...}])返回数据对应的 columns mapping
  'fc40': {
    '009': 'date',
    '010': 'nl', //农历
    '018': 'nljq', //农历节气 (清明,白露,中秋...)
    '016': 'week', //周几
    '003': 'maxTemp', //最高温度
    '004': 'minTemp', //最低温度
    '017': 'holiday', //阳历节日
    '001': 'weather1', //气像1 (refer Config.QXBM)
    '002': 'weather2', //气像2 (if weather1 == weather2 then echo weather2 else if weather1 == '' then echo weather2 else echo weather1 转 weather2)
    //if winPower1 == winPower2 and winDirect1 == winDirect2 then echo winDirect1 + " " + winPower1
    //else echo winDirect1 + " " + winPower1 + 转 winDirect2 + " " + winPower2
    '005': 'winPower1', //风力1
    '006': 'winPower2', //风力2
    '007': 'winDirect1', //风向1
    '008': 'winDirect2', //风向2
    '011': 'aqi', //空气质量 分数
    '012': 'aqi_label' //空气质量 等级 (优, 良, 轻度污染, 中度污染, 重度污染, 严重污染)
  },

  //24小时 API (APIS['40D_New']--> fc1h_24 = [{...}, {...}])返回数据对应的 columns mapping
  'fc1h_24': {
    'jf': 'datetime', //日期时间 (201809061700, 表示: 2018年09月06日 17:00)
    'ja': 'weather', //气像 (refer Config.QXBM)
    'jb': 'temp', //温度
    'jd': 'winDirect', //风向
    'jc': 'winPower', //风力
  }
};


//天气 dictionary
var QXBM = {
  "00": "晴",
  "01": "多云",
  "02": "阴",
  "03": "阵雨",
  "04": "雷阵雨",
  "05": "雷阵雨伴有冰雹",
  "06": "雨夹雪",
  "07": "小雨",
  "08": "中雨",
  "09": "大雨",
  "10": "暴雨",
  "11": "大暴雨",
  "12": "特大暴雨",
  "13": "阵雪",
  "14": "小雪",
  "15": "中雪",
  "16": "大雪",
  "17": "暴雪",
  "18": "雾",
  "19": "冻雨",
  "20": "沙尘暴",
  "21": "小到中雨",
  "22": "中到大雨",
  "23": "大到暴雨",
  "24": "暴雨到大暴雨",
  "25": "大暴雨到特大暴雨",
  "26": "小到中雪",
  "27": "中到大雪",
  "28": "大到暴雪",
  "29": "浮尘",
  "30": "扬沙",
  "31": "强沙尘暴",
  "53": "霾",
  "99": "无",
  "32": "浓雾",
  "49": "强浓雾",
  "54": "中度霾",
  "55": "重度霾",
  "56": "严重霾",
  "57": "大雾",
  "58": "特强浓雾",
  "301": "雨",
  "302": "雪"
};

//风向 dictionary
var FXBM = {
  "0": "微风",
  "1": "东北风",
  "2": "东风",
  "3": "东南风",
  "4": "南风",
  "5": "西南风",
  "6": "西风",
  "7": "西北风",
  "8": "北风",
  "9": "旋转风"
};

//风力 dictionary
var FLBM = {
  "0": "<3级",
  "1": "3-4级",
  "2": "4-5级",
  "3": "5-6级",
  "4": "6-7级",
  "5": "7-8级",
  "6": "8-9级",
  "7": "9-10级",
  "8": "10-11级",
  "9": "11-12级"
};

var USER_AGENTS = [
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; AcooBrowser; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
  "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.0.04506)",
  "Mozilla/4.0 (compatible; MSIE 7.0; AOL 9.5; AOLBuild 4337.35; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
  "Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)",
  "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 2.0.50727; Media Center PC 6.0)",
  "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.0.3705; .NET CLR 1.1.4322)",
  "Mozilla/4.0 (compatible; MSIE 7.0b; Windows NT 5.2; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.2; .NET CLR 3.0.04506.30)",
  "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN) AppleWebKit/523.15 (KHTML, like Gecko, Safari/419.3) Arora/0.3 (Change: 287 c9dfb30)",
  "Mozilla/5.0 (X11; U; Linux; en-US) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.6",
  "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2pre) Gecko/20070215 K-Ninja/2.1.1",
  "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9) Gecko/20080705 Firefox/3.0 Kapiko/3.0",
  "Mozilla/5.0 (X11; Linux i686; U;) Gecko/20070322 Kazehakase/0.4.5",
  "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko Fedora/1.9.0.8-1.fc10 Kazehakase/0.5.6",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.20 (KHTML, like Gecko) Chrome/19.0.1036.7 Safari/535.20",
  "Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; fr) Presto/2.9.168 Version/11.52",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.11 TaoBrowser/2.0 Safari/536.11",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.71 Safari/537.1 LBBROWSER",
  "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; LBBROWSER)",
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; QQDownload 732; .NET4.0C; .NET4.0E; LBBROWSER)",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.84 Safari/535.11 LBBROWSER",
  "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)",
  "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; QQBrowser/7.0.3698.400)",
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; QQDownload 732; .NET4.0C; .NET4.0E)",
  "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; SV1; QQDownload 732; .NET4.0C; .NET4.0E; 360SE)",
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; QQDownload 732; .NET4.0C; .NET4.0E)",
  "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)",
  "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1",
  "Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; zh-cn) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5",
  "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:2.0b13pre) Gecko/20110307 Firefox/4.0b13pre",
  "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11",
  "Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.10) Gecko/20100922 Ubuntu/10.10 (maverick) Firefox/3.6.10"
];

Map<String, String> getHeaders(){
  return {
    'User-Agent': USER_AGENTS[new Random().nextInt(USER_AGENTS.length)],
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Connection': 'keep-alive',
    'Accept-Encoding': 'gzip, deflate',
  };
}

Map<String, String> get_headers(Map<String, String> extra_headers) {
  var headers = getHeaders();

  headers.addAll(extra_headers);
  return headers;
}

class WeatherConverter{

  static Map<dynamic, String> HTML_ESCAPE = {
    '&lt;': '<',
    '&tl;': '>',
    '&nbsp;': ' '
  };

  /// 天气代码 converter
  static String convertWeatherCode(String _weatherCode){
    return _weatherCode != null && _weatherCode.isNotEmpty? QXBM[_weatherCode]: "";
  }

  /// 风向 converter
  static String convertWinDirect(String _windDirect){
    return _windDirect != null && _windDirect.isNotEmpty? FXBM[_windDirect]: "";
  }

  /// 风力 converter
  static String convertWinPower(String _windPowder){
    return _windPowder != null && _windPowder.isNotEmpty? FLBM[_windPowder]: "";
  }

  /// escape the html flags
  static String escapeHtml(String str){
    String r = str;
    HTML_ESCAPE.forEach((key, val) {
      if(str.contains(key)){
        r = r.replaceAll(key, val);
      }
    });
    return r;
  }
}


void main(){
//  DateTime today = new DateTime.now();
//  String dateSlug ="${today.year.toString()}${today.month.toString().padLeft(2,'0')}${today.day.toString().padLeft(2,'0')}";
//  print(dateSlug);

  DateTime updateTime;

  updateTime = updateTime??DateTime.now();

  print(updateTime);

}

