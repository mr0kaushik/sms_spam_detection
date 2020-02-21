import 'package:flutter/material.dart';
import 'package:sms_spam_detection/Models/user_model.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/widgets/animation.dart';

import '../screens/ChatScreen.dart';


abstract class ChatScreenItem{}


class DateItem implements ChatScreenItem{
  final String _date;

  DateItem(this._date);

}



class ChatItem extends StatelessWidget implements ChatScreenItem {
  final bool _isRead;

//  final Icon _avatar;
//  final String _image;
  final User _user;

//  final String _title;
  final String _time;
  final String _lastMessage;

  /*this._avatar, this._image,*/
  ChatItem(this._user, this._lastMessage, this._time, this._isRead);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(createRoute(ChatScreen(user: _user)));
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (BuildContext context) {
//            return ChatScreen(user: _user);
//          }),
//        );
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
              backgroundColor: Colors.grey,
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
                          _user.name,
                          style: TextStyle(
                              color: MatColor.primaryTextColor,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        _time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      _lastMessage,
                      style: TextStyle(
                        fontSize: 13,
                        color: MatColor.secondaryTextColor,
                        fontFamily: 'Lato',
                      ),
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
