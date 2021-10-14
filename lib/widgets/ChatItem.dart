import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/presentation/styles.dart';
import 'package:sms_spam_detection/screens/ChatScreen.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:sms_spam_detection/widgets/Utils.dart';

class ChatItem extends StatefulWidget {
  final SmsThread _thread;

  ChatItem(this._thread);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool _isRead = false;
  String _title;
  String _time;

  Contact contact;
  String _lastMessage;
  int color;

  @override
  void initState() {
    super.initState();
    SmsDatabaseProvider.db
        .getThreadColorById(widget._thread.threadId)
        .then((value) {
      color = value;
    });
    widget._thread.getContact.then((value) => {contact = value});
  }

  String _getPrettyDate(DateTime iDate) {
    DateTime cNow = DateTime.now();
    Duration duration = cNow.difference(iDate);

    if (duration.abs().inDays == 0 && iDate.day == cNow.day) {
      return DateFormat("hh:mm aa").format(iDate);
    }
    return DateFormat("dd-MM-yyyy").format(iDate);
  }

  Route createRoute(Widget next) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => next,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SmsMessage cMessage = widget._thread.messages[0];
    if (contact != null) {
      _title = contact.givenName != null
          ? contact.givenName
          : widget._thread.address;
    } else {
      if (widget._thread.address != null) {
        _title = widget._thread.address;
      } else {
        _title = '';
      }
    }
    _lastMessage = (cMessage.body != null) ? cMessage.body : '';
    _time = _getPrettyDate(cMessage.date);
    _isRead = widget._thread.isAnyMessageUnRead();

    return GestureDetector(
      onTap: () {
        if (contact != null) {
          String label = contact.displayName;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      label, widget._thread.threadId)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      widget._thread.address, widget._thread.threadId)));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 15.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: _isRead ? Colors.white : MatColor.primaryLightColor3,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              minRadius: 25.0,
              maxRadius: 30.0,
              child: getAvatar(_title),
              backgroundColor:
                  color != null ? Color(color) : MatColor.primaryColor,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _title.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: chatItemTitleStyle,
                        ),
                      ),
                      Text(
                        _time.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chatItemTimeStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      _lastMessage.trimRight(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: chatItemLastMessageStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
