import 'user_model.dart';

class Message {
  User sender;
  String time;
  String text;
  bool isSent = false;
  bool isRead = false;

  Message({this.sender, this.time, this.text, this.isRead, this.isSent});
}
