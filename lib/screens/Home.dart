import 'package:flutter/material.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/screens/ChatScreen.dart';
import 'package:sms_spam_detection/screens/InboxScreen.dart';
import 'package:sms_spam_detection/screens/SpamScreen.dart';
import 'package:sms_spam_detection/screens/UndecidableScreen.dart';

class Home extends StatelessWidget {
  AppBar _getAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {},
      ),
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
      bottom: TabBar(
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
        backgroundColor: Theme.of(context).primaryColor,
        appBar: _getAppBar(context),
        body: Container(
          decoration: BoxDecoration(
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
        floatingActionButton: _buildFloatingActionButton(
          context,
        ),
      ),
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return SelectContact();
        }));
      },
      child: Icon(
        Icons.message,
        color: MatColor.textColor,
      ),
    );
  }
}

class SelectContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('contact $index'),
            subtitle: Text('contact $index\'s status...'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChatScreen();
              }));
            },
          );
        },
      ),
    );
  }
}
