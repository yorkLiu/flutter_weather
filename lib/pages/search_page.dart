import 'package:flutter/material.dart';
import '../data/weather_utils.dart' show WeatherUtils;
import '../data/utils.dart' show Utils;
import '../constants.dart' show AppIcons;


class SearchCity extends StatefulWidget {
  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {

  static const EMPTY_TEXT='';
  static RegExp CHARACTER_NUMBER_REGEX= new RegExp("[0-9]|[a-zA-Z]");
  final TextEditingController _filter = new TextEditingController();
  String _searchText = EMPTY_TEXT;

  List _searchResults = [];
  List _prefers = [];


  _SearchCityState(){
    _filter.addListener((){
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = EMPTY_TEXT;
        });

      } else {
        setState(() {
          _searchText = _filter.text;
        });

        bool isSearch = _isCharacterOrNumber(_searchText)? (_searchText.length>2) : true;
        if(isSearch){
          _searchCity();
        }
      }
    });
  }

  bool _isCharacterOrNumber(text){
    return CHARACTER_NUMBER_REGEX.hasMatch(text);
  }

  @override
  void initState() {
    // load the added cities
    _loadPreference();
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> _children = [
      // Search bar
      Container(
        height: 50.0,
        child: _buildSearchBar(context),
      ),
      // 已添加的 城市
      Container(
        height: 20.0,
        margin: EdgeInsets.symmetric(vertical: 70.0),
        child: Center(
          child: Text('管理城市列表:', style: TextStyle(fontSize: 16.0),),
        ),
      ),

      Container(
        height: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 90.0),
        child: ListView.builder(
            itemCount: _prefers.length,
            itemBuilder: (context, index){
              var prefer = _prefers[index];
              return ListTile(
                leading: index == 0? Icon(AppIcons.location2, size: 16.0) : Icon(Icons.location_city, size: 16.0,),
                title: index ==0? Text('当前位置 ( ${prefer['n']} )') : Text('${prefer['n']} - ${prefer['pv']}'),
                trailing: index == 0 ? SizedBox(width: 10.0,) : IconButton(icon: Icon(Icons.delete),
                    onPressed: (){
                      Utils.removeCityFromPrefer(prefer['ac']).then((items){
                        setState(() {
                          _prefers.remove(prefer);
                        });
                      });
                    }
                ),
              );
            }
        ),
      ),
    ];

    if(_searchResults.length > 0){
      _children.add(Positioned(
          top: 50.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: _buildSearchResult(context)
      ));
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      resizeToAvoidBottomPadding: false, //false键盘弹起不重新布局 避免挤压布局
      body: SafeArea(
          child: Stack(
            children: _children
          )
      ),
    );
  }

  /// Search Bar widget
  ///
  Widget _buildSearchBar(BuildContext context){
    return new TextField(
      controller: _filter,
      maxLines: 1,
      style: TextStyle(fontSize: 15.0, color: Colors.white),
      //输入文本的样式
      decoration: InputDecoration(
          hintText: '搜索城市 (城市名/拼音/电话区号)',
          prefixIcon: new Icon(Icons.search, color: Colors.white),
          suffixIcon: _searchText.isEmpty
              ? SizedBox(width: 10)
              : new IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _filter.clear();
                setState(() {
                  _searchText = EMPTY_TEXT;
                  _searchResults.clear();
                });
              })
      ),
      onChanged: (text) {
        bool update = false;
        if(text.isNotEmpty && _isCharacterOrNumber(text) && text.length>2){
          update = true;
        }

        if(update || text.isEmpty){
          setState(() {
            _searchText = text;
          });
        }

        if(text.isEmpty){
          _filter.clear();
          _searchResults.clear();
        }
      },
    );
  }

  /// Search Result List View
  ///
  Widget _buildSearchResult(BuildContext context){
    Iterable<Widget> listTiles =  _searchResults.map((item){
      return MergeSemantics(
        child: ListTile(
          title: Text('${item['n']}'),
          trailing: Text('${item['pv']}'),
          onTap: (){
            setState(() {
              _prefers.add(item);
            });

            Utils.addCityToPrefer(item['ac']);
            _filter.clear();
            _searchResults.clear();
          },
        ),
      );
    });

    listTiles = ListTile.divideTiles(tiles: listTiles, context: context, color: Colors.white70);
    
    return Container(
      color: Colors.blueGrey,
      child: ListView(
        children: listTiles.toList(),
      ),
    );
  }

  /// search city by _searchText
  void _searchCity(){
    _searchResults.clear();
    if(_searchText.isNotEmpty){
      setState(() {
        _searchResults.addAll(WeatherUtils.searchCity(_searchText));
      });
    }
  }

  /// load shared preference data
  _loadPreference() async{
    List _list = await Utils.getPreferCities();
    List _cities = [];

    for (var _r in _list) {
      List a = WeatherUtils.searchCity(_r, strictMatchCityCode: _r);
      _cities.addAll(a);
    }

    if(_cities.length > 0){
      setState(() {
        _prefers = _cities;
      });
    }
  }

}
