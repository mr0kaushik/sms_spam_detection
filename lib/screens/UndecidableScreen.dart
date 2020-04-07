import 'package:flutter/material.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:sms_spam_detection/widgets/ChatItem.dart';

class UndecidableScreen extends StatefulWidget {

  @override
  _UndecidableScreenState createState() => _UndecidableScreenState();
}

class _UndecidableScreenState extends State<UndecidableScreen> {
  List<SmsThread> _threads = [];

  @override
  void initState() {
    SmsDatabaseProvider.db.getAllThreads(types: [SmsMessageType.UNDECIDABLE])
        .then((value) {
      _threads = value;
      if (mounted) {
        setState(() {
          _threads = value;
        });
      }
    });
    super.initState();
  }


  Widget getRequiredWidget() {
    if (_threads.length > 0) {
      return ListView.builder(
        itemCount: _threads != null ? _threads.length : 0,
        itemBuilder: (context, index) {
          final SmsThread thread = _threads[index];
          return ChatItem(thread);
        },
      );
    }
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