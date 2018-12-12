import 'package:flutter/material.dart';
import 'dart:async';
import '../modal/weather.dart';
import '../constants.dart';
import '../data/weather_utils.dart' show WeatherUtils;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.data}): super(key: key);

  final Weather data;

  Today today;
  List<Future40Days> future40days;
  Future40Days todayExtraInfo;
  List<Future24Hours> future24hours;

  DateTime updateTime;

  String getUpdateTime(){
    updateTime = updateTime??DateTime.now();
    return '${updateTime.hour.toString().padLeft(2,"0")}:${updateTime.minute.toString().padLeft(2,"0")}';
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _TodayWeatherItem extends StatelessWidget {
  _TodayWeatherItem({
    this.today,
    this.todayExtraInfo
  });

  final Today today;
  final Future40Days todayExtraInfo;

  static const double HORIZONTAL_SIZE = 5.0;
  static const double VERTICAL_SIZE = 8.0;

  /// get the date info
  /// if holiday is not empty
  /// return date (holiday)
  String getDateInfo(){
    if(todayExtraInfo.holiday != null && todayExtraInfo.holiday.isNotEmpty){
      return "${today.getDateOnly}(${todayExtraInfo.holiday})";
    }
    return today.getDateOnly;
  }

  /// 获取 农历
  /// If 农历节气
  /// return 农历(农历节气)
  String getChineseDateInfo(){
    if(todayExtraInfo.nljq != null && todayExtraInfo.nljq.isNotEmpty){
      return "农历 ${todayExtraInfo.nl}(${todayExtraInfo.nljq})";
    }
    return "农历 ${todayExtraInfo.nl}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      constraints: BoxConstraints(minHeight: 150.0, maxHeight: 250.0),
      margin: EdgeInsets.symmetric(
          horizontal: HORIZONTAL_SIZE, vertical: VERTICAL_SIZE),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppIcons.getWeatherIcon(today.weatherCode),
                Text(today.weather, style: AppStyles.todayWeatherTextStyle)
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(getDateInfo()),
                  Text(getChineseDateInfo()),
                  Text(todayExtraInfo.week),
                  AppStyles.DIVIDER_HEIGHT_6,
                  Text("${today.temp}℃",
                    style: AppStyles.mainTemperatureTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            margin: EdgeInsets.only(right: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(Labels.AQI_TEXT),
                AppStyles.DIVIDER_HEIGHT_15,
                Text(Utils.getAqiDisplayText(todayExtraInfo.aqi),
                    style: AppStyles.getAQITextStyle(int.parse(todayExtraInfo.aqi)))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TodayWeatherShortDetailItem extends StatelessWidget {

  _TodayWeatherShortDetailItem({this.today});

  double SUB_DETAIL_ICON_SIZE = 30.0;
  double SUB_DETAIL_HORIZONTAL = 10.0;
  double SUB_DETAIL_VERTICAL = 5.0;
  double SUB_DETAIL_DEVIDER_WIDTH = 20.0;

  final Today today;


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 113.0,
        decoration: BoxDecoration(
            border: Border(
              top: AppStyles.borderStyle,
              bottom: AppStyles.borderStyle,
            )),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                    bottom: AppStyles.borderStyle,
                  )),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            right: AppStyles.borderStyle,
                          )),
                      padding: EdgeInsets.symmetric(
                          vertical: SUB_DETAIL_VERTICAL,
                          horizontal: SUB_DETAIL_HORIZONTAL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              AppIcons.rain,
                              size: SUB_DETAIL_ICON_SIZE),
                          SizedBox(width: SUB_DETAIL_DEVIDER_WIDTH),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[Text(Labels.RAIN_TEXT), Text('${today.rain}mm')],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SUB_DETAIL_VERTICAL,
                          horizontal: SUB_DETAIL_HORIZONTAL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(AppIcons.wind,
                              size: SUB_DETAIL_ICON_SIZE),
                          SizedBox(width: SUB_DETAIL_DEVIDER_WIDTH),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(Labels.WIND_TEXT),
                              Text("${today.winDirect} ${today.winPower}")],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                              right: AppStyles.borderStyle,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: SUB_DETAIL_VERTICAL,
                            horizontal: SUB_DETAIL_HORIZONTAL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                                AppIcons.humidity,
                                size: SUB_DETAIL_ICON_SIZE),
                            SizedBox(width: SUB_DETAIL_DEVIDER_WIDTH),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[Text(Labels.HUMIDITY_TEXT), Text("${today.humidity}")],
                            )
                          ],
                        ),
                      )),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SUB_DETAIL_VERTICAL,
                            horizontal: SUB_DETAIL_HORIZONTAL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                                AppIcons.visibility,
                                size: SUB_DETAIL_ICON_SIZE),
                            SizedBox(width: SUB_DETAIL_DEVIDER_WIDTH),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[Text(Labels.VISIBILITY_TEXT), Text("${today.visibility}")],
                            )
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}


// 未来 7天 天气
class _DailyWeatherItem extends StatelessWidget {
  _DailyWeatherItem({this.date,
    this.week,
    this.minTemp,
    this.maxTemp,
    this.weather,
    this.weatherCode});
  final String date; // 日期 (i.e: 20180921)
  final String week; // 周几 (i.e: 星期五)
  final String maxTemp; // 最高温度
  final String minTemp; // 最低湿度
  final String weather;
  final String weatherCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(
              right: AppStyles.borderStyle
          )
      ),
      child: Column(
        children: <Widget>[
          Text(Utils.getShortWeek(week, date: date)),
          Text(weather),
          SizedBox(height: 10.0,),
          AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(weatherCode), size: 24.0),
          SizedBox(height: 3.0,),
          Text("$minTemp°/$maxTemp°")
        ],
      ),
    );
  }
}

// 未来 24小时 天气
class _TwentyFourHoursWeatherItem extends StatelessWidget {
  _TwentyFourHoursWeatherItem({
    this.time,
    this.hour,
    this.weatherCode,
    this.weather,
    this.temp
  });

  final String time;
  final int hour;
  final String weatherCode;
  final String weather;
  final String temp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51,
      height: 75,
      margin: EdgeInsets.symmetric(vertical: 10.0),
//      decoration: BoxDecoration(
//          border: Border(
//              right: AppStyles.borderStyle
//          )
//      ),
      child: Column(

        children: <Widget>[
          Text(time),
//          Text("小雨"),
          SizedBox(height: 10.0,),
          AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(weatherCode, hour: hour), size: 24.0),
          SizedBox(height: 3.0,),
          Text("$temp°")
        ],
      ),
    );
  }
}


class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  static const double HORIZONTAL_SIZE = 5.0;
  static const double VERTICAL_SIZE = 8.0;


//  Today _today;
//  List<Future40Days> _future40days;
//  Future40Days _todayExtraInfo;
//  List<Future24Hours> _future24hours;

  Widget _buildAppBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(
          horizontal: HORIZONTAL_SIZE, vertical: VERTICAL_SIZE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(AppIcons.location1, size: 16.0),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text('成都市 | 高新区'),
                    ],
                  ),
                  Text(
                    '天府软件园G5',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
          ),
          Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Text(
                        Labels.DATA_FROM_TEXT,
                        style: AppStyles.dataFromTextStyle,
                      ),
                      Text('${widget.getUpdateTime()} 更新', style: AppStyles.updateTimeTextStyle,)
                    ],
                  ),
                ),
              )
          ),
          Expanded(
              child: Container(
                alignment: Alignment.centerRight,
//              padding: EdgeInsets.only(top: 10.0),
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    print(">>>>>The Menu button was clicked.");
                    _refreshIndicatorKey.currentState.show();
                  },
                ),
              )
          ),

        ],
      ),
    );
  }

  Widget _buildMainRegion() {
    return _TodayWeatherItem(today: widget.today, todayExtraInfo: widget.todayExtraInfo);
  }

  //
  // 降水量， 风向，风力
  // 相对光湿度, 能见度
  Widget _buildSubDetails(BuildContext context) {
      return _TodayWeatherShortDetailItem(today: widget.today,);
  }


  Widget _buildDailyContainer(BuildContext context){

    return Container(
      height: 120.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: AppStyles.borderStyle
        )
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (BuildContext context, int index){
            Future40Days item = widget.future40days[index];
            return _DailyWeatherItem(
                date: item.date,
                week: item.week,
                minTemp: item.minTemp,
                maxTemp: item.maxTemp,
                weatherCode: item.weather1,
                weather: item.getWeather1Only
            );

          }),
    );
  }

  Widget _build24HoursContainer(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 24,
          itemBuilder: (BuildContext context, int index) {
            Future24Hours item = widget.future24hours[index];
            return _TwentyFourHoursWeatherItem(
                time: item.convertDateTime,
                hour: item.getHour,
                weatherCode: item.weather,
                weather: item.getWeather,
                temp: item.temp
            );
          }),
    );
  }


  @override
  void initState() {
    super.initState();

    // init the data
    var data = widget.data;
    widget.today = data.today;
    widget.future40days = data.fc40;
    widget.future24hours = data.fc1h_24;
    widget.todayExtraInfo = widget.future40days[0];

//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<Null> _refreshData(){
    return WeatherUtils.loadWeatherData(widget.data.cityCode).then((data) {
      print(data);
      setState(() {
        widget.updateTime = DateTime.now();
        widget.today = data.today;
        widget.future40days = data.fc40;
        widget.future24hours = data.fc1h_24;
        widget.todayExtraInfo = widget.future40days[0];

      });
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
            content: Row(
              children: <Widget>[
                Icon(Icons.info, color: Colors.green),
                AppStyles.DIVIDER_HEIGHT_15,
                Text('数据加载完成')
              ],
            ),
            backgroundColor: Colors.black54,
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      key: _scaffoldKey,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          key: _refreshIndicatorKey,
          child: ListView(
            children: <Widget>[
              _buildAppBar(),
              _buildMainRegion(),
              _buildSubDetails(context),
              _buildDailyContainer(context),
              _build24HoursContainer(context)
            ],
          ),
        )
      ),
    );
  }
}
