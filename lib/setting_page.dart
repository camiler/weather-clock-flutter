import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = "/setting";

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('设置闹钟'),
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              margin: EdgeInsets.only(bottom: 30),
              color: Colors.white,
              child: new ClockStatusSwitch(),
            ),
            new Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: new BoxDecoration(border: new Border(bottom: BorderSide(width: 1.0, color: Color(0xEEEEEEEE))), color: Colors.white),
              child: new AqiSettingSlider(),
            ),
            new Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              color: Colors.white,
              child: new TimeSettingSelect(),
            ),
            new Container(
              padding: EdgeInsets.only(right: 50.0, left: 50.0, top: 30.0),
              child: new CupertinoButton(
                child: Text('确定'),
                color: Colors.blue,
                onPressed: () => {

                },
              ),
            )
          ],
        ),
      )
    );
  }
}

class ClockStatusSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ClockStatusSwitchState();
  }
}

class ClockStatusSwitchState extends State<ClockStatusSwitch> {
  var _clockStatus = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('开启/关闭'), 
      trailing: CupertinoSwitch(
        value: _clockStatus, 
        onChanged: (bool value) {
          setState(() {
            _clockStatus = value;
          });
        },
      ),
    );
  }
}

class AqiSettingSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AqiSettingSliderState();
  }
}

class AqiSettingSliderState extends State<AqiSettingSlider> {
  var _aqi = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('AQI大小'), 
      trailing: CupertinoSlider(
        value: _aqi, 
        onChanged: (double value) {
          setState(() {
            _aqi = value;
          });
        },
      ),
    );
  }
  
}

class TimeSettingSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TimeSettingSelectState();
  }
}

class TimeSettingSelectState extends State<TimeSettingSelect> {
  var _time = '';

  @override
  Widget build(BuildContext context) {
    _showPicker() async {
      var picker = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
      );
      setState(() {
        _time = picker.toString() != 'null' ? picker.toString() : TimeOfDay.now().toString();
      });
    }

    return ListTile(
      title: Text('时间'),
      trailing: FlatButton(color: Colors.white, onPressed: () => _showPicker(), child: Text(_time)),
    );
  }
  
}

