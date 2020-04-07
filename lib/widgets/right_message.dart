import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';

class RightMessage extends StatefulWidget {
  final SmsMessage rMessage;
  final double radius;
  final Color backgroundColor;

  RightMessage(this.rMessage,
      {this.radius = 2.5, this.backgroundColor = MatColor.primaryLightColor2});

  @override
  _RightMessageState createState() => _RightMessageState();
}

class _RightMessageState extends State<RightMessage> {
  String time;
  String body;
  double cWidth;

  @override
  void initState() {
    cWidth = MediaQuery.of(context).size.width * 0.2;
    body = widget.rMessage.body;
    time = time = DateFormat('hh:mm aa').format(widget.rMessage.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: cWidth, right: 0.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: MatColor.primaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  body,
                  softWrap: true,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      time,
                      softWrap: true,
                      style: TextStyle(fontSize: 10, color: Colors.black26),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
