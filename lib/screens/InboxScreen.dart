import 'package:flutter/material.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:sms_spam_detection/widgets/ChatItem.dart';

//
//class InboxScreen extends StatefulWidget {
//
//  @override
//  _InboxScreenState createState() => _InboxScreenState();
//}

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();

  InboxScreen();
}

class _InboxScreenState extends State<InboxScreen> {
  List<SmsThread> _threads;

  bool isImported = false;

  @override
  void initState() {
    SmsDatabaseProvider.db
        .getAllThreads(types: [SmsMessageType.HAM]).then((value) {
      _threads = value;
      if (mounted) {
        setState(() {
          isImported = true;
          _threads = value;
        });
      }
    });
    super.initState();
  }

  Widget getRequiredWidget() {
    if (_threads == null) {
      return Center(
        child: Text(
          'Importing Messages!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black26,
          ),
        ),
      );
    }

    if (_threads.length == 0) {
      return Center(
        child: Text(
          'Nothing here yet!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black26,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _threads.length,
      itemBuilder: (context, index) {
        final SmsThread thread = _threads[index];
        return ChatItem(thread);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: Container(
        color: Colors.white,
        child: getRequiredWidget(),
      ),
    );
  }
}
