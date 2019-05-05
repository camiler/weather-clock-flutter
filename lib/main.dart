import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'setting_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '空气闹钟',
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(0, 107, 120, 1),
          title: new Text('AQI'),
          centerTitle: true,
          actions: <Widget>[
            new SettingButton()
          ],
        ), 
        body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/flutterbg.jpg'),
              fit: BoxFit.cover,
            )
          ),
          child: new Center(
            child: new WeatherDetail(),
          ),
        )
      ),
    );
  }
}

/*
 * 空气详细信息展示 
 */
class WeatherDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeatherDetailState();
  }
}
class WeatherDetailState extends State<WeatherDetail> {
  var _address = '定位中...';
  int _aqi;
  var _time = '更新于';
  var _detail;

  @override
  initState() {
    super.initState();
    _getLocationAqi();
  }

  _getLocationAqi() async {
    Position position;
    try {
      position = await  Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      var lat = position.latitude.toString();
      var lng = position.longitude.toString();
        
      if (lat is String) {
        var url = 'https://api.waqi.info/feed/geo:$lat;$lng/?token=a0921835e79a8010263dea8a071f14febbf595b9';
        var res = await http.get(url);
        
        if (res.statusCode == 200) {
          var body = json.decode(res.body);
          if (body['status'] == 'ok') {
            var data = body['data'];
            setState(() {
              _address = data['city']['name'];
              _aqi = data['aqi'];
              _time += data['time']['s'];
              _detail = data['iaqi'];
            });
          } else {
            res = null;
          }
        }
      }
    } on PlatformException {
      position = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    TextStyle tStyle = new TextStyle(fontSize: 20.0, fontWeight:FontWeight.w500, color: color);

    Column buildDetailItem(String title) {
      if (_detail[title.replaceAll('.', '')] is Map) {
        var num = _detail[title.replaceAll('.', '')];
        return new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(title, style: tStyle),
            new Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: new Text(num['v'].toString(), style: tStyle),
            )
          ],
        );
      }
      return new Column();
    }

    return new Container(
      child: new ListView(
        children: <Widget>[
          new Container(
            width: 500.0,
            padding: const EdgeInsets.only(top: 20.0, right: 20.0),
            child: new Text(_time, textAlign:TextAlign.right, style: new TextStyle(fontSize: 12.0, color: Colors.white)),
          ),
          new Container(
            width: 500.0,
            padding: const EdgeInsets.only(top: 80.0, left: 40.0, right: 40.0),
            child: new Center(child: new Text(_address, textAlign: TextAlign.center, style: tStyle))
          ),
          new Container(
            width: 500.0,
            padding: const EdgeInsets.only(top: 50.0, left: 40.0, right: 40.0, bottom: 50.0),
            child: new Center(child: new Text(_aqi.toString(), textAlign:TextAlign.center, style: new TextStyle(fontSize: 60.0, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildDetailItem('co'),
              buildDetailItem('no2'),
              buildDetailItem('o3'),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildDetailItem('pm10'),
                buildDetailItem('so2'),
                buildDetailItem('pm2.5')
              ],
            ),
          )
        ],
      )
    );
  }
}

/*
 * app bar上的设置按钮
 */
class SettingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new SettingPage()),
        );
      },
      // color: Colors.white, 这个是背景块的颜色
      child: new Text('闹钟设置', style: TextStyle(color: Colors.white)),
    );
  }
}
