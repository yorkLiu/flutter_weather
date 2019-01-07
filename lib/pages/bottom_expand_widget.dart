import 'package:flutter/material.dart';


class BottomExpandView extends StatefulWidget {

  BottomExpandView({
    @required this.children,
    @required this.expandChild,
    this.height:300.0
  }):
        assert(children != null),
        assert(expandChild != null);

  // 主页面内容
  final List<Widget> children;
  // 要弹出的页面内容
  final Widget expandChild;
  // 要弹出的页面 高度
  final double height;

  bool isCollapsed = true;

  @override
  _BottomExpandStateView createState() => _BottomExpandStateView();
}


class _BottomExpandStateView extends State<BottomExpandView> {

  final double _ICON_HEIGHT=24.0;


  @override
  Widget build(BuildContext context) {

    if(widget.children != null && widget.children.length > 0){
      widget.children.add( Container(
        height: _ICON_HEIGHT,
        alignment: Alignment(0.0, 0.0),
        child: IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            onPressed: (){
              setState(() {
                widget.isCollapsed = false;
              });
            }
        ),
      ));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (Notification notification){

      },

      child: Stack(
        children: <Widget>[
          ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: widget.children,
          ),

          _buildBottomItem(),

        ],
      )

    );
  }


  Widget _buildBottomItem(){
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Offstage(
        offstage: widget.isCollapsed,
        child: Container(
          height: widget.height,
          child: Column(
            children: <Widget>[
              Container(
                height: _ICON_HEIGHT,
                alignment: Alignment(0.0, 0.0),
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: (){
                      setState(() {
                        widget.isCollapsed = true;
                      });
                    }
                ),
              ),
              widget.expandChild,
            ],
          ),
        ),
      )
    );
  }
}
