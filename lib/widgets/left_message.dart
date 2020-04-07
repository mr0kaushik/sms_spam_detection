import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';

class LeftMessage extends StatefulWidget {
  final SmsMessage lMessage;
  final double radius;
  final Color backgroundColor;

  LeftMessage(this.lMessage,
      {this.radius = 2.5, this.backgroundColor = MatColor.primaryLightColor2});

  @override
  _LeftMessageState createState() => _LeftMessageState();
}

class _LeftMessageState extends State<LeftMessage> {
  String time;
  String body;
  double cWidth;

  @override
  void initState() {
    cWidth = MediaQuery.of(context).size.width * 0.2;
    body = widget.lMessage.body;
    time = DateFormat('hh:mm aa').format(widget.lMessage.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: cWidth),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: MatColor.primaryLightColor2,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  body,
                  softWrap: true,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  time,
                  softWrap: true,
                  style: TextStyle(fontSize: 10, color: Colors.black26),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
