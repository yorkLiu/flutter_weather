import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:io';
import '../modal/weather.dart';
import '../modal/geolocator_placemark.dart';
import '../data/weather_utils.dart';
import '../pages/weather_page.dart';
import '../data/utils.dart' show Utils;
import '../constants.dart' show Constants;

import 'package:amap_location/amap_location.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
//import 'dart:async';

Function listEquals = const ListEquality().equals;


class _WeatherData{
  _WeatherData({
    this.weather,
    this.geoPlaceMark}):
        assert(weather != null);

  final Weather weather;
  final GEOPlaceMark geoPlaceMark;
}

class _PageSelector extends StatelessWidget {
  _PageSelector({
    @required this.children,
    this.tabController
  });

  final List<Widget> children;

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
//    final _controller = DefaultTabController.of(context);
    return SafeArea(
      top: false,
      bottom: false,

      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: this.children,
            ),
          ),

          TabPageSelector(
              controller: tabController,
              indicatorSize: 4.0,
            color: Colors.black26,
            selectedColor: Colors.white,
          ),
        ],

      ),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> with TickerProviderStateMixin {

//  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
//  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static const _CURPOSITION = 'CURPOSITION';

  TabController _tabController;
  GEOPlaceMark _currenLocation = null;
  List<String> _cities = [_CURPOSITION];
  List<Widget> _tabs = [];

  @override
  void initState() {
    _initConnectivity().then((bool connected){
      if(connected){
        _initData();
        _buildPageFromPrefers();
      }
    });

    _initLocation();
//    _connectivitySubscription =
//        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//          setState(() => _connectionStatus = result.toString());
//        });


    super.initState();
  }

  _initLocation() async {
    String _api_key = Platform.isAndroid ? Constants.AMPA_LOCATION_KEY_ANDROID
        : Constants.AMPA_LOCATION_KEY_IOS;
    AMapLocationClient.setApiKey(_api_key);
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
  }

  void _initData() async{
    await WeatherUtils.loadCityData();
  }

  //平台消息是异步的，所以我们用异步方法初始化。
  Future<bool> _initConnectivity() async {
    String connectionStatus;
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

//    print("****connectionStatus:$connectionStatus");
//    if(connectionStatus == ConnectivityResult.wifi.toString()){
//      String wifiName = await _connectivity.getWifiName();
//      String wifiIP = await _connectivity.getWifiIP();
//      print("wifi name: $wifiName with IP: $wifiIP");
//    }

    // 如果在异步平台消息运行时从树中删除了该小部件，e
    // 那么我们希望放弃回复，而不是调用setstate来更新我们不存在的外观。
    if (!mounted || connectionStatus == ConnectivityResult.none.toString()) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context){
            return Theme(
              data: ThemeData.light().copyWith(
                dialogBackgroundColor: Colors.white,
                primaryColor: Colors.black
              ),
              child: AlertDialog(
                title: Text("无法访问网络"),
                content: Text('请检查您的网络, 如:打开"移动网络"或者连接可用的"WIFI"'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('退出'),
                    onPressed: (){
                      exit(0);
                    },
                  )
                ],
              ),
            );
      });
      return false;
    }

    return true;
  }

  /// build the weather pages from read the shared preference data
  /// [isInit] is used by initState method to call this method
  /// If back to "home" page from "search" page and call [_buildPageFromPrefers]
  /// using the [isInit] parameter with "false"
  _buildPageFromPrefers({bool isInit: true}){
    Utils.getPreferCities().then((List<String> _list){
      bool _initPage = isInit;
      if(isInit){
        if(_list != null){
          _cities.clear();
        } else if(_cities.length > 1){
          _cities.removeRange(1, -1);
        }
      } else {
        // if the _cities is equals the shared prefer data
        // then do not re-init the weather page.
        if(_list != null && !listEquals(_cities, _list)){
          _initPage = true;
          _cities.clear();
        }
      }

      if(_initPage){
        _tabs.clear();

        if(!_cities.contains(_CURPOSITION)){
          _cities.add(_CURPOSITION);
        }

        if(_list != null && _list.length > 1){
          _cities.addAll(_list.getRange(1, _list.length));
        }

        for (var city_id in _cities) {
          _addTab(city_id);
        }
      }
    });
  }

  @override
  void dispose() {
    AMapLocationClient.shutdown();
    super.dispose();
  }

  TabController _makeNewTabController() => TabController(
    vsync: this,
    length: _tabs.length,
    initialIndex: 0,
  );

  /// navigate to "search" page
  /// after back to "home" page
  /// reload the weather page if the shared prefer data changed
  _navigateToSearchPage() async{
    await Navigator.pushNamed(context, "/search");
    _buildPageFromPrefers(isInit: false);

  }

  void _addTab(city_id){
    Widget _builder = FutureBuilder(
        future: new Future(() async {
          GEOPlaceMark geoPlaceMark = null;

          if(city_id == 'CURPOSITION'){
            await WeatherUtils.loadCityData();
            try {
              AMapLocation _amapLocation = await AMapLocationClient.getLocation(true);
              if(_amapLocation != null && _amapLocation.province.isNotEmpty){
                geoPlaceMark = GEOPlaceMark(
                    country: _amapLocation.country,
                    latitude: _amapLocation.latitude,
                    longitude: _amapLocation.longitude,
                    province: _amapLocation.province,
                    city: _amapLocation.city,
                    district: _amapLocation.district,
                    address: _amapLocation.street,
                    postCode: _amapLocation.adcode
                );

                _currenLocation = geoPlaceMark;

                city_id = WeatherUtils.getCity(province: geoPlaceMark.province, cityname: geoPlaceMark.district);
              }
            }catch(exception){
              _currenLocation = null;
            } finally {
              AMapLocationClient.stopLocation();
            }

            if (_currenLocation == null) {
              var curPos = await WeatherUtils.getCurrentGeoLocale();
              city_id = curPos['city_code'];
              geoPlaceMark = new GEOPlaceMark(
                  latitude: curPos['lat'],
                  longitude: curPos['lng'],
                  country: curPos['country'],
                  province: curPos['province'],
                  city: curPos['city'],
                  district: curPos['district'],
                  postCode: "${curPos['postCode']}"
              );
            }

            // add current
            Utils.addCityToPrefer(city_id, insertToFirst: true);
          }

          Weather weather = await WeatherUtils.loadWeatherData(city_id);
          return _WeatherData(weather: weather, geoPlaceMark: geoPlaceMark);
        }),
        builder: (BuildContext context, AsyncSnapshot<_WeatherData> weatherState) {

          if (weatherState.data == null) {
            return new Center(child: new CircularProgressIndicator());
          }

          if (weatherState.data.weather != null) {
            return WeatherPage(
                data: weatherState.data.weather,
                geoPlaceMark: weatherState.data.geoPlaceMark,
                onNavigation: (){
                  _navigateToSearchPage();
                },
            );
          }
        });

    setState(() {
      _tabs.add(_builder);
      _tabController = _makeNewTabController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        resizeToAvoidBottomPadding: false, //false键盘弹起不重新布局 避免挤压布局
        body: DefaultTabController(
          length: _tabs.length,
          child: _PageSelector(
              tabController: _tabController,
              children: _tabs.map((w)=> w).toList()
          ),
        )
    );
  }
}


