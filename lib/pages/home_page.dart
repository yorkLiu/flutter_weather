import 'package:flutter/material.dart';
import '../modal/weather.dart';
import '../modal/geolocator_placemark.dart';
import '../data/weather_utils.dart';
import '../pages/weather_page.dart';

import 'package:amap_location/amap_location.dart';




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
    @required this.children
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final _controller = DefaultTabController.of(context);
    return SafeArea(
      top: false,
      bottom: false,

      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              children: this.children,
            ),
          ),

          TabPageSelector(
              controller: _controller,
              indicatorSize: 4.0,
            color: Colors.black26,
            selectedColor: Colors.white,
          ),
        ],

      ),
    );
  }
}

class _PageSelectors extends StatelessWidget {
  GEOPlaceMark currenLocation = null;
  var cities = ['CURPOSITION', '101270102'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: DefaultTabController(
            length: cities.length,
            child: _PageSelector(
              children: cities.map((city_id) {
                return FutureBuilder(
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

                            currenLocation = geoPlaceMark;

                            city_id = WeatherUtils.getCity(province: geoPlaceMark.province, cityname: geoPlaceMark.district);
                            print("City ID: $city_id");
                          }
                        }catch(e){
                          print("Exception....>>>>>>");
                          print(e);

                          currenLocation = null;

                        } finally {
                          AMapLocationClient.stopLocation();
                        }

                        print("currenLocation is null: ${currenLocation == null}");

                        if (currenLocation == null) {
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
                      }

                      Weather weather = await WeatherUtils.loadWeatherData(city_id);

                      print(geoPlaceMark);
                      return _WeatherData(weather: weather, geoPlaceMark: geoPlaceMark);
                    }),
                    builder: (BuildContext context, AsyncSnapshot<_WeatherData> weatherState) {

                      if (weatherState.data == null) {
                        return new Center(child: new CircularProgressIndicator());
                      }

                      if (weatherState.data.weather != null) {
                        return WeatherPage(
                            data: weatherState.data.weather,
                            geoPlaceMark: weatherState.data.geoPlaceMark
                        );
                      }
                    });
              }).toList(),
            )
        )
    );
  }
}


class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {


  @override
  void initState() {

    super.initState();
    initData();
    initLocation();

  }

  initLocation() async{

    AMapLocationClient.setApiKey("92db4c9f65225920347c5e5e51fd4cc2");
    await AMapLocationClient.startup(new AMapLocationOption( desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters ));

  }

  void initData() async{
    await WeatherUtils.loadCityData();
  }

  @override
  void dispose() {
    AMapLocationClient.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return _PageSelectors();

  }
}


