import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/screens/About.dart';
import 'package:sms_spam_detection/screens/ChatScreen.dart';
import 'package:sms_spam_detection/screens/Dashboard.dart';
import 'package:sms_spam_detection/screens/Draft.dart';
import 'package:sms_spam_detection/screens/Report.dart';
import 'package:sms_spam_detection/screens/Setting.dart';
import 'package:sms_spam_detection/screens/Test.dart';
import 'package:sms_spam_detection/screens/select_contacts.dart';
import 'package:sms_spam_detection/sms/contacts.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/widgets/DrawerItem.dart';

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Draft", Icons.drafts),
    new DrawerItem("Test", Icons.content_paste),
//    new DrawerItem("Setting", Icons.settings),
//    new DrawerItem("About", Icons.info_outline),
//    new DrawerItem("Report", Icons.report)
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;
  bool isVisible = true;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        isVisible = true;
        return new DashboardScreen();
      case 1:
        isVisible = true;
        return new DraftScreen();
      case 2:
        isVisible = false;
        return new TestScreen();
      case 3:
        isVisible = false;
        return new SettingScreen();
      case 4:
        isVisible = false;
        return new AboutScreen();
      case 5:
        isVisible = false;
        return new ReportScreen();
      default:
        isVisible = true;
        return new DashboardScreen();
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  SmsReceiver _smsReceiver;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future _showNotificationWithDefaultSound(SmsMessage m) async {
    SmsMessage message = m;
    int threadId = message.threadId;
    String head = message.sender;
    String body = message.body;
    String payload = jsonEncode(message.toMap);

    await ContactsService.getContactsForPhone(message.address).then((value) {
      if (value != null && value.length > 0) {
        Contact contact = value.toList()[0];
        head = contact.givenName;
      }
    });

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        threadId.toString(), 'sms_spam', channelDescription: 'Spam Sms detection',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      threadId,
      head,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  @override
  void initState() {
    super.initState();

    if (_smsReceiver == null) {
      _smsReceiver = new SmsReceiver();
      _smsReceiver.onSmsReceived.listen((event) {
        _showNotificationWithDefaultSound(event);
      });
    }

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onNotificationSelected);
  }

  Future<void> onNotificationSelected(String payload) async {
    Map<String, dynamic> messageMap = jsonDecode(payload);
    String address;
    int threadId = -1;
    if (messageMap.containsKey("address")) {
      address = messageMap["address"];
    }
    if (messageMap.containsKey("thread_id")) {
      threadId = messageMap["thread_id"];
    }

    if (address != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(address, threadId)));
    }
  }

  _getAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Sms Spam Detection',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
      elevation: 0.0,
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return SelectContact();
          }));
        },
        child: Icon(
          Icons.message,
          color: MatColor.textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: _getAppBar(context),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                currentAccountPicture: Image.asset('assets/images/app_icon.png'),
                accountName: new Text("SMS Spam Detection"),
                accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      floatingActionButton: _buildFloatingActionButton(
        context,
      ),
    );
  }
}
