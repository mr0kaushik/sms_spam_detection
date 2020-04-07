import 'package:flutter/material.dart';
import 'package:sms_spam_detection/widgets/Utils.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBar("Setting"),
          Container(
            color: Theme.of(context).primaryColor,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text("Will Add later!!"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
