import 'package:flutter/material.dart';
import '../constants.dart';
import '../modal/weather.dart' show Future40Days;
import 'weather_calendar.dart';

/// 15天 and 40天 天气
class _MoreWeathers extends StatefulWidget {
  _MoreWeathers(this.future40days);

  final List<Future40Days> future40days;

  @override
  _MoreWeathersState createState() => _MoreWeathersState();
}

// AutomaticKeepAliveClientMixin 可以将 tab keep住
class _MoreWeathersState extends State<_MoreWeathers>
    with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );

//    _tabController.addListener((){
//      print("current index: ${_tabController.index}");
//    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 15天 天气
  Widget _build15Days(){
    return ListView.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          Future40Days item = widget.future40days[index];
          return _FifteenDaysWeatherItem(data: item);
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TabBar(
        unselectedLabelColor: Colors.white,
        controller: _tabController,
          tabs: <Widget>[
              Container(height: Constants.MORE_WEATHER_TAB_HEIGHT, child: Tab(text: Labels.TAB_TEXT_15_DAYS,),),
              Container(height: Constants.MORE_WEATHER_TAB_HEIGHT, child: Tab(text: Labels.TAB_TEXT_40_DAYS,),),
          ]
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _build15Days(),
          WeatherCalendar(
            items: widget.future40days
          ),
        ],
      ),
    );
  }

//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;
}

// 未来15天 天气
class _FifteenDaysWeatherItem extends StatelessWidget {
  _FifteenDaysWeatherItem({this.data});

  Future40Days data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
          border: Border(
            bottom: AppStyles.borderStyle,
          )
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            width: 100,
            decoration: BoxDecoration(
                border: Border(
                  right: AppStyles.borderStyle,
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data.week),
                Text(data.formatDate),
                Text(Utils.getChineseDateInfo(
                    data.nl, nljq: data.nljq, isAppendNL: false, allowConvert: true),
                  style: TextStyle(fontSize: 10.0),)
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 5.0,
                childAspectRatio: 2.0,
                shrinkWrap: true,
                crossAxisCount: 5,
                children: <Widget>[
                  Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:  AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(
                        data.weather1, forceDay: true), size: 24.0),
                  ),

                  Text(data.getShortWeather1),
                  Container(
                    alignment: Alignment(-0.0, 0.0),
                    child: Text("${data.maxTemp}°"),
                  ),

                  Text("${data.winDirect1}"),
                  Text(data.winPower1),


                  Container(
                    alignment: Alignment(-1.0, 0.0),
                    child: AppIcons.getWeatherIcon(
                        Utils.getWeatherIconByWeatherCode(
                            data.weather2, forceNight: true), size: 24.0),
                  ),

                  Text(data.getShortWeather2),
                  Container(
                    alignment: Alignment(-0.0, 0.0),
                    child: Text("${data.minTemp}°"),
                  ),

                  Text("${data.winDirect2}"),
                  Text("${data.winPower2}")

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// 加载  15天 & 40天 的天气
///
typedef CollapseCallback = void Function();
class ShowMoreWeatherPage extends StatefulWidget {

  ShowMoreWeatherPage({
    @required this.future40days,
    this.height:300.0,
    this.collapseIconHeight: 30.0,
    this.onCollapse}):
      assert(future40days != null);

  double height;
  double collapseIconHeight;
  List<Future40Days> future40days;

  CollapseCallback onCollapse;

  @override
  _ShowMoreWeatherPageState createState() => _ShowMoreWeatherPageState();
}

class _ShowMoreWeatherPageState extends State<ShowMoreWeatherPage> with TickerProviderStateMixin<ShowMoreWeatherPage> {

  void _defaultOnCollapse(){
    setState(() {
      widget.height = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();

    if(widget.onCollapse == null){
      widget.onCollapse = _defaultOnCollapse;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: widget.height,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                height: widget.collapseIconHeight,
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: widget.onCollapse
                ),
              ),
              Container(
                height: widget.height - widget.collapseIconHeight,
                child: _MoreWeathers(widget.future40days),
              )
            ],
          )),
    );
  }
}

