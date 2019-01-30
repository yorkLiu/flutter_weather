import 'package:flutter/material.dart';
import '../modal/weather.dart';
import '../modal/geolocator_placemark.dart';
import '../data/weather_utils.dart';
import '../pages/weather_page.dart';




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
    initData();
    super.initState();

  }

  void initData(){
    WeatherUtils.loadCityData();
  }

  @override
  Widget build(BuildContext context) {

    return _PageSelectors();

  }
}


