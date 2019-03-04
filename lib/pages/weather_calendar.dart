import 'package:flutter/material.dart';
import '../modal/weather.dart' show Future40Days;
import '../constants.dart';

class WeatherCalendar extends StatefulWidget {

  WeatherCalendar({
    @required this.items,
    this.height: 300.0
  }):
      assert(items != null),
      this.selectedItem = items[0];

  final List<Future40Days> items;
  final double height;

  // 默认 selectedItem 选择的是今天
  Future40Days selectedItem;

  Color selectedColor = AppColors.CALENDAR_TODAY_COLOR;
  bool isSelected = false;

  List<Future40Days> get dataItems{
    List<Future40Days> _dataItems = [];
    int _weekday = DateTime.now().weekday;
    if(_weekday < 7){
      List.generate(_weekday, (index){
        _dataItems.add(null);
     });
    }
    _dataItems.addAll(items);

    return _dataItems;
  }

  @override
  _WeatherCalendarState createState() => _WeatherCalendarState();
}

class _WeatherCalendarState extends State<WeatherCalendar> {

  double _headerHeight = 20.0;
  double _detailHeight = 40.0;

  /// Get the day only from $date (eg:20181210)
  /// 如果是下一个月的第一天, 则显示 月份
  /// eg: 当前是 12月, 20190101 则应该显示 为 1月
  /// Eg:
  ///   1. 20181210 ==> 10
  ///   2. 20190101 ==> 1月
  String _getDayOnly(String date){
    if(date == null || date.isEmpty){
      return null;
    }

    var month = int.parse(date.substring(4,6));
    var day = int.parse(date.substring(6,8));
    var current_month = DateTime.now().month;
    // 如果是下一个月的第一天, 则显示 月份
    // eg: 当前是 12月, 20190101 则应该显示 为 1月
    if(day == 1 && month != current_month){
      return "$month月";
    } else if(date == Utils.getDateYMD()){
      return "今";
    }
    return "$day";

  }

  bool isToday(String date){
    return date == Utils.getDateYMD();
  }

  void _selectDay(Future40Days item){
    setState(() {
      widget.selectedItem = item;
      widget.isSelected = !isToday(item.date);
    });
  }


  /// 显示 weather Icon
  /// 雨
  /// 雪
  /// weather icon
  Widget _buildWeatherIcon(Future40Days item){
    String _weather = item.getWeather1;
    String _shortWeather = Utils.getSpecialWeatherText(_weather);
    Widget _icon;
    if(_shortWeather != null){
      _icon = new CircleAvatar(
        radius: Constants.WEATHER_ICON_RADIUS,
        backgroundColor: AppColors.WEATHER_CALENDAR_SPECIAL_WEATHER_AVATAR_BG_COLOR,
        foregroundColor: AppColors.WEATHER_CALENDAR_SPECIAL_WEATHER_AVATAR_F_COLOR,
        child: new Text(_shortWeather, style: AppStyles.WEATHER_CALENDAR_SPECIAL_WEATHER_TEXT_STYLE),
      );
    } else {
      _icon = AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(item.weather1, forceDay: true), size: Constants.WEATHER_CALENDAR_ICON_SIZE);
    }

    return _icon;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: <Widget>[
          // calendar header
          Container(
            height: _headerHeight,
            decoration: BoxDecoration(
                border: Border(
                    bottom: AppStyles.borderStyle
                )
            ),
            child: Row(
              children: Labels.WEEKS.map((w){
                return Expanded(
                  child: Center(child: Text(w, style: Theme.of(context).textTheme.caption,)),
                );
              }).toList(),
            ),
          ),

          // the details container, show the selected date details
          Container(
            height: _detailHeight,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                Text(Utils.getChineseDateInfo(widget.selectedItem.nl, nljq: widget.selectedItem.nljq, allowConvert: true)),
                AppStyles.DIVIDER_WIDTH_10,

                AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(widget.selectedItem.weather1, forceDay: true), size: 24.0),
                widget.selectedItem.isSameWeather? SizedBox(width: 0.0,): AppStyles.DIVIDER_WIDTH_10,
                widget.selectedItem.isSameWeather? SizedBox(width: 0.0,): AppIcons.getWeatherIcon(Utils.getWeatherIconByWeatherCode(widget.selectedItem.weather2, forceNight: true), size: 24.0),
                AppStyles.DIVIDER_WIDTH_10,
                Text(widget.selectedItem.getWeather),
                AppStyles.DIVIDER_WIDTH_10,
                Text("${widget.selectedItem.maxTemp}°/${widget.selectedItem.minTemp}°")
              ],
            ),
          ),

          // calendar
          Flexible(
            fit: FlexFit.tight,
              child: Container(
//            height: widget.height - _headerHeight - _detailHeight,
            height: double.infinity,
            child: GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7
              ),
              itemBuilder: (BuildContext context, int index){
                var item = widget.dataItems[index];
                if(item == null){
                  return Container(child: SizedBox(width: 5.0,));
                } else {
                  bool _isToday = item!= null ? isToday(item.date): false;
                  bool _isSelectedDay = widget.selectedItem != null &&
                      widget.selectedItem.date == item.date;
                  return Center(
                    child: Container(
                      color: _isToday && !widget.isSelected ? (AppColors.CALENDAR_TODAY_COLOR)
                          : (widget.isSelected && _isSelectedDay ? widget.selectedColor : null),
                      child: FlatButton(
                          padding: EdgeInsets.only(top: 3.0, bottom: 10.0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: _isToday? AppColors.CALENDAR_TODAY_COLOR: AppColors.borderColor
                              )
                          ),
                          onPressed: () => _selectDay(item),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text(_getDayOnly(item.date),
                                            style: Theme.of(context).textTheme.button.copyWith(fontSize: 12.0),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Text(Utils.getChineseDateInfo(item.nl, allowConvert: true, onlyReturnDay: true),
                                          style: Theme.of(context).textTheme.button.copyWith(fontSize: 8.0),
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              AppStyles.DIVIDER_HEIGHT_10,
                              _buildWeatherIcon(item),
                              AppStyles.DIVIDER_HEIGHT_3,
                              Expanded(
                                child: Text("${item.maxTemp}°/${item.minTemp}°",
                                    style: Theme.of(context).textTheme.button.copyWith(fontSize: 10.0)),
                              )

                            ],
                          )
                      ),
                    ),
                  );
                }
              },
              itemCount: widget.dataItems.length,
            ),
          )
          ),

        ],
      ),
    );
  }
}
