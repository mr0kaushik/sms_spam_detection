import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:sms_spam_detection/tenserflow/tensor_flow_helper.dart';
import 'package:sms_spam_detection/utils/SharedPrefrences.dart';

class ImportedScreen extends StatefulWidget {
  @override
  _ImportedScreenState createState() => _ImportedScreenState();
}

class _ImportedScreenState extends State<ImportedScreen> {
  List<SmsMessage> messages = new List();

  bool isImporting = false;
  bool isImported = false;

  int length = 0;
  double _completed = 0;
  bool showButton = true;
  String message = 'Importing Message';

  @override
  void initState() {
    SharedPref.isMessageImported().then((value) {
      if (mounted) {
        setState(() {
          isImported = value;
          if (isImported) {
            Navigator.of(context).pushReplacementNamed('/home');
            print('initState : Navigator Push!! HOME');
          }
        });
      }
    });
    super.initState();
  }

  void getItems() async {
    setState(() {
      isImporting = true;
    });
    SmsQuery query = new SmsQuery();
    final SmsDatabaseProvider databaseProvider = SmsDatabaseProvider.db;

    messages = await query.getAllSms;
    length = messages.length;
    for (int i = 0; i < length; i++) {
      SmsMessage message = messages[i];
      message.type = await TfLiteHelper(message.body).getAccuracyType();
      messages.add(message);
//      debugPrint("Message ${message.body} \n ${message.messageType}");
      await databaseProvider.addMessageToDatabase(message);
      if (mounted) {
        setState(() {
          _completed = i / length;
        });
      }
    }

    await databaseProvider.getAllThreads(types: [
      SmsMessageType.HAM,
      SmsMessageType.SPAM,
      SmsMessageType.UNDECIDABLE
    ]).then((value) {
      if (value != null) {
        for (SmsThread thread in value) {
          thread.color = RandomColor.getRandomColor().value;
          databaseProvider.addThreadToDataBase(thread);
        }
      }
    });

    await databaseProvider.getAllSmsMessages().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            isImported = true;
            message = 'Message Imported Successfully!!';
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 4;
    double percentage = _completed;
//    debugPrint("Percent Value : $percentage");
    if (_completed > 0.99) {
      message = 'Finishing!!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sms Spam Detection',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Center(
                child: Image.asset(
                  "assets/images/app_icon.png",
                  width: imageSize,
                  height: imageSize,
//                  fit: BoxFit.cover,
                ),
              ),
            ),
            (isImporting)
                ? CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 13.0,
                    animation: false,
                    percent: percentage,
                    center: GestureDetector(
                      onTap: (isImported)
                          ? () {
                              SharedPref.setAlreadyImported(true);
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            }
                          : null,
                      child: Container(
                        child: Text(
                          (isImported)
                              ? 'Next'
                              : (percentage * 99).round().toString() + "%",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    footer: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          message,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        (isImported)
                            ? Text(
                                'Tap on Next to Continue',
                                style: new TextStyle(
                                    color: Colors.black54, fontSize: 14.0),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: MatColor.primaryColor,
                  )
                : (!isImported)
                    ? RaisedButton(
                        child: Text('Import Messages'),
                        onPressed: () {
                          setState(() {
                            getItems();
                          });
                        },
                        color: MatColor.primaryColor,
                        textColor: Colors.white,
                      )
                    : SizedBox.shrink(),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}

void logSMSMessage(SmsMessage smsMessage) {
  print("--------------------------");
  print("Id :  ${smsMessage.id} ");
  print("body :  ${smsMessage.body} ");
  print("address :  ${smsMessage.address}");
  print("sender :  ${smsMessage.sender}");
  print("date:  ${smsMessage.date}");
  print("datesent :  ${smsMessage.dateSent}");
  print("threadID :  ${smsMessage.threadId}");
  print("isRead :  ${smsMessage.isRead}");
  print("hashCode :  ${smsMessage.hashCode}");
  print("kind :  ${smsMessage.kind}");
  print("state :  ${smsMessage.state}");
  print('type : ${smsMessage.messageType}');
}
