import 'package:flutter/material.dart';
import 'package:sms_spam_detection/screens/InboxScreen.dart';
import 'package:sms_spam_detection/screens/SpamScreen.dart';
import 'package:sms_spam_detection/screens/UndecidableScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  _getAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: TabBar(
        isScrollable: true,
        labelStyle: TextStyle(
            fontSize: 18, fontFamily: 'Lato', fontWeight: FontWeight.w500),
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: <Widget>[
          Tab(text: 'Inbox'),
          Tab(text: 'Undecidable'),
          Tab(text: 'Spam'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: _getAppBar(context),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: TabBarView(
              children: <Widget>[
                InboxScreen(),
                UndecidableScreen(),
                SpamScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
