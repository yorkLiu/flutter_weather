import 'package:flutter/material.dart';
import 'dart:async';
import '../modal/weather.dart';
import '../constants.dart';
import '../data/weather_utils.dart' show WeatherUtils;
import 'more_days_weather.dart';
import '../modal/geolocator_placemark.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({Key key,
    this.data,
    this.geoPlaceMark
  }): super(key: key);

  final Weather data;
  final GEOPlaceMark geoPlaceMark;

  ////// global config [start] ///////////
  double mainContainerHeight = 200.0;
  ////// global config [end] ////////////


  Today today;
  List<Future40Days> future40days;
  Future40Days todayExtraInfo;
  List<Future24Hours> future24hours;

  DateTime updateTime;

  // 判断 bottomsheet 是否已经打开
  bool isBottomSheetDisplayed = false;

  // 判读 手势 是否 从下往上滑动
  // 从下往上滑动 则加载 15 & 40天的天气
  bool allowShowMore = false;

  bool isShowMoreWeather = false;

  String getUpdateTime(){
    updateTime = updateTime??DateTime.now();
    return '${updateTime.hour.toString().padLeft(2,"0")}:${updateTime.minute.toString().padLeft(2,"0")}';
  }

  get getLocation {
    if(geoPlaceMark != null && geoPlaceMark.getMainAddress != null && geoPlaceMark.getMainAddress.toString().isNotEmpty){
      return geoPlaceMark.getMainAddress;
    } else {
      return today.cityName;
    }
  }

  get getSubLocation {
    if(geoPlaceMark != null){
      return geoPlaceMark.getSubAddress;
    }
    return "";
  }

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _TodayWeatherItem extends StatelessWidget {
  _TodayWeatherItem({
    this.today,
    this.todayExtraInfo,
    this.height
  });

  final Today today;
  final Future40Days todayExtraInfo;

  double height = 150.0;

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


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: BoxConstraints(minHeight: 150.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(today.weatherCode)),
                Text(today.weather, style: AppStyles.todayWeatherTextStyle)
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(getDateInfo()),
                  Text(Utils.getChineseDateInfo(todayExtraInfo.nl, nljq: todayExtraInfo.nljq)),
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
                AppStyles.DIVIDER_HEIGHT_10,
                new CircleAvatar(
                  radius: Constants.AQI_RADIUS,
                  backgroundColor: Utils.getQqiColor(todayExtraInfo.aqi),
                  foregroundColor: Colors.white,
                  child: new Text(todayExtraInfo.aqi, style: AppStyles.fontSize_14_TextStyle),
                ),
                AppStyles.DIVIDER_HEIGHT_10,
                Text(Utils.getAqiDisplayText(todayExtraInfo.aqi),
                    style: AppStyles.getAQITextStyle(todayExtraInfo.aqi)),
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

  Today today;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Constants.SUB_CONTAINER_HEIGHT,
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
//                          vertical: Constants.SUB_DETAIL_VERTICAL,
                          horizontal: Constants.SUB_DETAIL_HORIZONTAL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              AppIcons.rain,
                              size: Constants.SUB_DETAIL_ICON_SIZE),
                          SizedBox(width: Constants.SUB_DETAIL_DEVIDER_WIDTH),
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
//                          vertical: Constants.SUB_DETAIL_VERTICAL,
                          horizontal: Constants.SUB_DETAIL_HORIZONTAL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(AppIcons.wind,
                              size: Constants.SUB_DETAIL_ICON_SIZE),
                          SizedBox(width: Constants.SUB_DETAIL_DEVIDER_WIDTH),
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
//                            vertical: Constants.SUB_DETAIL_VERTICAL,
                            horizontal: Constants.SUB_DETAIL_HORIZONTAL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                                AppIcons.humidity,
                                size: Constants.SUB_DETAIL_ICON_SIZE),
                            SizedBox(width: Constants.SUB_DETAIL_DEVIDER_WIDTH),
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
//                            vertical: Constants.SUB_DETAIL_VERTICAL,
                            horizontal: Constants.SUB_DETAIL_HORIZONTAL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                                AppIcons.visibility,
                                size: Constants.SUB_DETAIL_ICON_SIZE),
                            SizedBox(width: Constants.SUB_DETAIL_DEVIDER_WIDTH),
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
    this.weatherCode,
    this.aqi});
  final String date; // 日期 (i.e: 20180921)
  final String week; // 周几 (i.e: 星期五)
  final String maxTemp; // 最高温度
  final String minTemp; // 最低湿度
  final String weather;
  final String weatherCode;
  final String aqi;

  String get shortWeek{
    return Utils.getShortWeek(week, date: date);
  }

  @override
  Widget build(BuildContext context) {
    Widget _aqiAvatar = null;
    // AQI avatar define
    if(aqi != null && aqi.isNotEmpty){
      _aqiAvatar = new Container(
        width: Constants.DAY_WEATHER_AQI_WIDTH,
        height: Constants.DAY_WEATHER_AQI_HEIGHT,
        alignment: Alignment(0.0, 0.0), // Alignment(0.0, 0.0) 表示居中对齐
        decoration: BoxDecoration(
          borderRadius: AppStyles.DAY_WEATHER_AQI_BORDER_STYLE,
          color: Utils.getQqiColor(aqi)
        ),
        child: Text(
            Utils.getAqiDisplayText(aqi, isReturnShort: true),
          style: AppStyles.DAY_WEATHER_AQI_TEXT_STYLE,
        ),
      );
    }

    return Container(
      width: Constants.DAY_WEATHER_PER_CONTAINER_WIDTH,
      height: Constants.DAY_WEATHER_CONTAINER_HEIGHT,
      margin: EdgeInsets.symmetric(vertical: Constants.VERTICAL_SIZE_10),
      decoration: BoxDecoration(
          border: Border(
              right: AppStyles.borderStyle
          )
      ),
      child: Column(
        children: <Widget>[
          Text(shortWeek),
          Text(weather),
          AppStyles.DIVIDER_HEIGHT_10,
          AppIcons.getWeatherIcon(
              Utils.getWeatherIconByWeatherCode(weatherCode,
                  isDistDayNight: (shortWeek == Labels.TODAY_TEXT)),
              size: Constants.SMALL_WEATHER_ICON_SIZE),
          AppStyles.DIVIDER_HEIGHT_3,
          Text("$minTemp°/$maxTemp°"),
          AppStyles.DIVIDER_HEIGHT_6,
          _aqiAvatar!= null? _aqiAvatar : SizedBox(height: Constants.DAY_WEATHER_AQI_HEIGHT)
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
      width: Constants.HOURS_24_PER_CONTAINER_WIDTH,
      height: Constants.HOURS_24_CONTAINER_HEIGHT,
      margin: EdgeInsets.symmetric(vertical: Constants.VERTICAL_SIZE_10),
      child: Column(
        children: <Widget>[
          Text(time),
//          Text(weather),
          AppStyles.DIVIDER_HEIGHT_10,
          AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(weatherCode, hour: hour), size: 24.0),
          AppStyles.DIVIDER_HEIGHT_3,
          Text("$temp°")
        ],
      ),
    );
  }
}

class _WeatherPageState extends State<WeatherPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = new ScrollController();


  Widget _buildAppBar() {
    return Container(
      height: Constants.APP_BAR_HEIGHT,
      padding: EdgeInsets.symmetric(
          horizontal: Constants.HORIZONTAL_SIZE_5, vertical: Constants.VERTICAL_SIZE_8),
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
                      Text(widget.getLocation),
                    ],
                  ),
                  Text(
                    widget.getSubLocation,
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
    return _TodayWeatherItem(today: widget.today, todayExtraInfo: widget.todayExtraInfo, height: widget.mainContainerHeight,);
  }

  //
  // 降水量， 风向，风力
  // 相对光湿度, 能见度
  Widget _buildSubDetails(BuildContext context) {
      return _TodayWeatherShortDetailItem(today: widget.today,);
  }

  Widget _buildDailyContainer(BuildContext context){

    return Container(
      height: Constants.DAY_WEATHER_MAIN_CONTAINER_HEIGHT,
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
                weather: item.getWeather1Only,
                aqi: item.aqi,
            );

          }),
    );
  }

  Widget _build24HoursContainer(BuildContext context) {
    return Container(
      height: Constants.HOURS_24_MAIN_CONTAINER_HEIGHT,
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    // end init the data
  }

  Future<Null> _refreshData(BuildContext context){
    _hideBottomSheet(context);
     return WeatherUtils.loadWeatherData(widget.data.cityCode).then((data) {
      if(data.errorCode == null){
        setState(() {
          widget.updateTime = DateTime.now();
          widget.today = data.today;
          widget.future40days = data.fc40;
          widget.future24hours = data.fc1h_24;
          widget.todayExtraInfo = widget.future40days[0];
        });
      }

//      _scaffoldKey.currentState?.showSnackBar(SnackBar(
//            content: Row(
//              children: <Widget>[
//                data.errorCode != null? AppIcons.erroInfoIcon: AppIcons.infoIcon,
//                AppStyles.DIVIDER_WIDTH_5,
//                Text(data.errorCode != null? Labels.DATA_LOAD_FAILED : Labels.DATA_LOADED)
//              ],
//            ),
//            backgroundColor: Colors.black54,
//        ));
    });
  }

  /// show bottom sheet
  void _showBottomSheet(){
    PersistentBottomSheetController _bottomSheet = _scaffoldKey.currentState.showBottomSheet<void>((
        BuildContext context) {
      return _buildMoreWeatherPage(context);
    });

    if(_bottomSheet != null){
      setState(() {
        Future.value(_bottomSheet.closed).then((v) => widget.isBottomSheetDisplayed = false);
        widget.isBottomSheetDisplayed = true;
      });
    }
  }

  /// hide bottom sheet
  void _hideBottomSheet(BuildContext context){
    if(widget.isBottomSheetDisplayed){
      Navigator.of(context).pop();
      setState(() {
        widget.isBottomSheetDisplayed = false;
      });
    }
  }


  /// 15 days and 40 days
  Widget _showMoreWeathers(BuildContext context) {
    return Container(
      height: Constants.SHOW_MORE_ICON_CONTAINER_HEIGHT,
      alignment: Alignment(0.0, 0.0),
      child: IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          onPressed: () =>  _showBottomSheet()
      ),
    );
  }

  Widget _buildMoreWeatherPage(BuildContext context) {
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    var _height = screenHeight -
        (widget.mainContainerHeight + Constants.APP_BAR_HEIGHT +
            Constants.VERTICAL_SIZE_8);
    return ShowMoreWeatherPage(
      height: _height,
      future40days: widget.future40days,
      onCollapse: ()=> _hideBottomSheet(context),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if(notification.metrics.axisDirection == AxisDirection.down){
      if(notification is ScrollStartNotification){
        if(notification.dragDetails == null){
          setState(() {
            widget.allowShowMore = false;
          });
        }
      }
      else if(notification is ScrollEndNotification
         && widget.allowShowMore) {
        _showBottomSheet();
        setState(() {
          widget.allowShowMore = false;
        });
      } else if(notification is ScrollUpdateNotification){
        print('update....${notification.dragDetails.delta.dy}');
      }
      else if(notification is OverscrollNotification){
        if(notification.dragDetails.delta.dy < 0.0){
          setState(() {
            widget.allowShowMore = true;
          });
        } else {
          setState(() {
            widget.allowShowMore = false;
          });
        }
      }
    }
    return false;
  }


  Widget _buildMore(BuildContext context){

    return Container(
      height: Constants.SHOW_MORE_ICON_CONTAINER_HEIGHT,
      alignment: Alignment(0.0, 0.0),
      child: IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          onPressed: (){
            print('...clicked...');
            setState(() {
              widget.isShowMoreWeather = true;
            });
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double aHeight = Constants.APP_BAR_HEIGHT + Constants.VERTICAL_SIZE_8
    +Constants.SUB_CONTAINER_HEIGHT + Constants.SUB_DETAIL_VERTICAL
    +Constants.DAY_WEATHER_MAIN_CONTAINER_HEIGHT + Constants.VERTICAL_SIZE_10
    + Constants.HOURS_24_MAIN_CONTAINER_HEIGHT +  Constants.VERTICAL_SIZE_10
    + Constants.SHOW_MORE_ICON_CONTAINER_HEIGHT;

    widget.mainContainerHeight = MediaQuery.of(context).size.height - aHeight+ 5;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      key: _scaffoldKey,
      body: SafeArea(
          child: RefreshIndicator(
              displacement: 10.0,
              onRefresh: () => _refreshData(context),
              key: _refreshIndicatorKey,
              child: GestureDetector(
                /// 透明也响应处理
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _hideBottomSheet(context),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScrollNotification,
                      child: Stack(
                        children: <Widget>[
                          ListView(
                              controller: _scrollController,
                              // 这句是在list里面的内容不足一屏时，list可能会滑不动，加上就一直都可以滑动
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: <Widget>[
                                _buildAppBar(),
                                _buildMainRegion(),
                                _buildSubDetails(context),
                                _buildDailyContainer(context),
                                _build24HoursContainer(context),

                              ]
                          ),

                          Positioned(
                            bottom: 3.0,
                            left: 0.0,
                            right: 0.0,
                            child:  _showMoreWeathers(context),
                          )

                        ],
                      )
                  ),
                  )
              )
          )
      );

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      key: _scaffoldKey,
      body: SafeArea(
          child: RefreshIndicator(
              displacement: 10.0,
              onRefresh: () => _refreshData(context),
              key: _refreshIndicatorKey,
              child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScrollNotification,
                    child: Stack(
                      children: <Widget>[
                        ListView(
                          controller: _scrollController,
                          // 这句是在list里面的内容不足一屏时，list可能会滑不动，加上就一直都可以滑动
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            _buildAppBar(),
                            _buildMainRegion(),
                            _buildSubDetails(context),
                            _buildDailyContainer(context),
                            _build24HoursContainer(context),
                            _buildMore(context),
                          ],
                        ),
                          Positioned(
                            bottom: 15.0,
                            left: 0.0,
                            right: 0.0,
                            child: Offstage(
                              offstage: !widget.isShowMoreWeather,
                              child: Container(
                                height: 300.0,
                                color: Colors.blue,
                              ),
                            ),
                          )
                      ],
                    )
                  )
          )
      ),
    );


//    return Scaffold(
//      backgroundColor: Colors.blueGrey,
//      key: _scaffoldKey,
//      body: SafeArea(
//          child: RefreshIndicator(
//              displacement: 10.0,
//              onRefresh: () => _refreshData(context),
//              key: _refreshIndicatorKey,
//              child: BottomExpandView(
//                height: 330.0,
//                  children: <Widget>[
//                    _buildAppBar(),
//                    _buildMainRegion(),
//                    _buildSubDetails(context),
//                    _buildDailyContainer(context),
//                    _build24HoursContainer(context),
//                  ],
//                  expandChild: ShowMoreWeatherPage(
//                    height: 300.0,
//                    future40days: widget.future40days
//                  )
//
//              )
//          )
//      ),
//    );


//    return Scaffold(
//      backgroundColor: Colors.blueGrey,
//      key: _scaffoldKey,
//      body: SafeArea(
//          child: EasyRefresh(
//            autoLoad: false,
//            key: _easyRefreshKey,
//            behavior: ScrollOverBehavior(
////              showLeading: true,
////              showTrailing: true,
//            ),
//            refreshHeader: MaterialHeader(
//              key: _headerKey,
//              displacement: 20.0,
//            ),
//            refreshFooter: MaterialFooter(
//                key: _footerKey,
//                displacement: 10.0,
//            ),
//
////              refreshHeader: ClassicsHeader(
////                  key: _headerKey,
////                  refreshText: '下拉刷新',
////                  refreshReadyText: '释放刷新',
////                  refreshingText: "正在刷新...",
////                  refreshedText: '刷新结束',
////                  moreInfo: '"更新于 %T',
////                  bgColor: Colors.orange
////              ),
////              refreshFooter: ClassicsFooter(
////                key: _footerKey,
////                loadText: '上拉加载',
////                loadReadyText: '释放加载',
////                loadingText: '正在加载',
////                loadedText: '加载结束',
////                noMoreText: '没有更多数据',
////                moreInfo: '更新于 %T',
////                bgColor: Colors.transparent,
////                textColor: Colors.black87,
////                moreInfoColor: Colors.black54,
////                showMore: true,
////              ),
//
//            onRefresh: () async {
//              await Future.delayed(const Duration(microseconds: 10), (){
//                WeatherUtils.loadWeatherData(widget.data.cityCode).then((data) {
//                  print("....loaded.....");
//                  if (data.errorCode == null) {
//                    setState(() {
//                      widget.updateTime = DateTime.now();
//                      widget.today = data.today;
//                      widget.future40days = data.fc40;
//                      widget.future24hours = data.fc1h_24;
//                      widget.todayExtraInfo = widget.future40days[0];
//                    });
//                  }
//                });
//              });
//
//            },
//
//              loadMore: (){
//                  print('....load more....');
//                  _showBottomSheet();
//              },
//            child: ListView(
//              children: <Widget>[
//                _buildAppBar(),
//                _buildMainRegion(),
//                _buildSubDetails(context),
//                _buildDailyContainer(context),
//                _build24HoursContainer(context),
//                _showMoreWeathers(context),
//
//              ],
//            )
//
//          ),
//      ),
//    );

  }
}
