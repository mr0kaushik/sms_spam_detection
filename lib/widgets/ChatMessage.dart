import 'package:flutter/material.dart';
import 'package:sms_spam_detection/Models/Thread.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';

class ChatMessage extends StatelessWidget {
  final Thread thread;
  final AnimationController animationController;

  ChatMessage(this.thread, this.animationController);

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: thread.fromSelf ? _RightThread(thread) : _LeftThread(thread),
    );
//  return thread.fromSelf ? _RightThread(thread) : _LeftThread(thread);
  }
}

class _RightThread extends StatelessWidget {
  final Thread thread;
  final Color backgroundColor;
  final double r;

  _RightThread(this.thread,
      {this.r = 2.5, this.backgroundColor = MatColor.primaryLightColor2});

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: c_width, right: 0.0),
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
              children: <Widget>[
                Text(
                  thread.message,
                  softWrap: true,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  thread.time,
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

class _LeftThread extends StatelessWidget {
  final Thread thread;
  final Color backgroundColor;
  final double radius;

  _LeftThread(this.thread,
      {this.radius = 2.5, this.backgroundColor = MatColor.primaryLightColor3});

  @override
  Widget build(BuildContext context) {
    final double c_width = MediaQuery.of(context).size.width * 0.2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: c_width),
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
                  thread.message,
                  softWrap: true,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  thread.time,
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
