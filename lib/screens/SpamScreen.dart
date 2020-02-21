import 'package:flutter/material.dart';
import 'package:sms_spam_detection/Models/ChatItem.dart';
import 'package:sms_spam_detection/Models/message_model.dart';
import 'package:sms_spam_detection/Models/user_model.dart';

class SpamScreen extends StatelessWidget {
  final List<Message> chats = [
    new Message(
      isRead: true,
      sender: new User(
          id: 0, name: 'Deepak', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "Thanks buddy, see you soon",
      isSent: true,
    ),
    new Message(
      isRead: true,
      sender: new User(
          id: 1, name: 'Harshit', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "Thanks buddy, see you soon",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender:
          new User(id: 3, name: 'Akash', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "Thanks buddy, see you soon",
      isSent: true,
    ),
    new Message(
      isRead: true,
      sender:
          new User(id: 4, name: 'Vansh', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "Thanks buddy, Thanks buddy, Thanks buddy, see you soon",
      isSent: true,
    ),
    new Message(
      isRead: true,
      sender:
          new User(id: 5, name: 'Ansh', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text:
          "Thanks buddy, see you soonThanks buddy, Thanks buddy, Thanks buddy, Thanks buddy, ",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender:
          new User(id: 6, name: 'Mahi', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "Thanks buddy, see you soon Thanks buddy, Thanks buddy, ",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender: new User(
          id: 7, name: 'Anjali', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "Thanks buddy, see you soonsee you soon see you soon see you soon",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender:
          new User(id: 8, name: 'Nitin', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "you soon",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender:
          new User(id: 8, name: 'Nitin', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "you soon",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender:
          new User(id: 8, name: 'Nitin', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "you soon",
      isSent: true,
    ),
    new Message(
      isRead: false,
      sender:
          new User(id: 8, name: 'Nitin', imageUrl: 'asset/images/deadpool.jpg'),
      time: "12:20 pm",
      text: "you soon",
      isSent: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final Message chat = chats[index];
            return ChatItem(
              chat.sender,
              chat.text,
              chat.time,
              chat.isRead,
            );
          },
        ),
      ),
    );
  }
}
