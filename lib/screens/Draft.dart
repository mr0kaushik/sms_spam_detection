import 'package:flutter/material.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:sms_spam_detection/widgets/Utils.dart';

class DraftScreen extends StatefulWidget {
  @override
  _DraftScreenState createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  List<SmsMessage> _messages;

  @override
  void initState() {
    SmsDatabaseProvider.db
        .getSmsMessagesByKind(kinds: [SmsMessageKind.Draft]).then((value) {
      if (mounted) {
        setState(() {
          _messages = value;
        });
      }
    });
    super.initState();
  }

  Widget getRequiredWidget() {
    if (_messages == null) {
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
    if (_messages.length == 0) {
      return Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.drafts),
            Text(
              'Nothing here... yet!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black26,
              ),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _messages != null ? _messages.length : 0,
      itemBuilder: (context, index) {
        final SmsMessage message = _messages[index];
        final String title = message.address;
        final String body = message.body;
        return ListTile(
          leading: Icon(Icons.person, size: 24),
          title: Text(title != null ? title : "No Subject"),
          subtitle: Text(body != null ? body : "No body"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBar("Draft"),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  color: Colors.white,
                  child: getRequiredWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
