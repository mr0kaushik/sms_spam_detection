import 'package:flutter/material.dart';
// import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class ChatScreenItem {}

class DateItem extends StatelessWidget implements ChatScreenItem {
  final String _date;

  DateItem(this._date);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Text(
          _date,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChatMessage extends StatefulWidget implements ChatScreenItem {
  final SmsMessage smsMessage;
  final AnimationController animationController;

  ChatMessage(this.smsMessage, this.animationController);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  double cWidth;

  @override
  Widget build(BuildContext context) {
    cWidth = MediaQuery
        .of(context)
        .size
        .width * 0.2;

    return widget.smsMessage.kind == SmsMessageKind.Received
        ? _leftThread(widget.smsMessage)
        : _rightThread(widget.smsMessage);
  }

  String _getDate(DateTime mTime) {
    return DateFormat('hh:mm aa').format(mTime);
  }

  _rightThread(SmsMessage rMessage,
      {radius = 2.5, backgroundColor = MatColor.primaryLightColor2}) {
    String body = rMessage.body;
    String time = _getDate(rMessage.date);

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

  _leftThread(SmsMessage lMessage,
      {radius = 2.5, backgroundColor = MatColor.primaryLightColor2}) {
    return VisibilityDetector(
      key: Key('lMessageDetector'),
      onVisibilityChanged: (info) {
        print('${lMessage.id} Set Read : ${lMessage.isRead}');
        if (!lMessage.isRead) {
          SmsDatabaseProvider.db.setMessageRead(lMessage.id).then((value) {
            print('${lMessage.id} value : $value');
            lMessage.read = true;
          });
        }
      },
      child: Row(
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
                    lMessage.body,
                    softWrap: true,
                    style: TextStyle(),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    _getDate(lMessage.dateSent),
                    softWrap: true,
                    style: TextStyle(fontSize: 10, color: Colors.black26),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

