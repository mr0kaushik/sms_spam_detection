import 'package:flutter/material.dart';
import 'package:sms_spam_detection/sms/contacts.dart';
import 'package:sms_spam_detection/widgets/contact_item.dart';

class SelectContact extends StatefulWidget {
  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  TextEditingController controller = TextEditingController();

  List<Contact> contacts = new List();
  List<Contact> filteredContacts = new List();

  bool showProgress;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    showProgress = true;
    ContactsService.getContacts(orderByGivenName: true).then((value) {
      if (mounted) {
        setState(() {
          contacts = value;
          filteredContacts = contacts;
          showProgress = false;
        });
      }
    });
  }

  _getSearchedContacts(String s) {
    ContactsService.getContacts(query: s, orderByGivenName: true).then((value) {
      if (mounted) {
        setState(() {
          filteredContacts = value.toList();
        });
      }
    });
  }

  _getAppBar() {
    return AppBar(
      title: (!isTyping)
          ? Text('Select Contact')
          : TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  border: InputBorder.none,
                  hintText: "Search here"),
              style: TextStyle(fontSize: 18.0, color: Colors.white60),
              onChanged: (query) {
                if (query == null || query.length == 0) {
                  if (mounted) {
                    setState(() {
                      filteredContacts = contacts;
                    });
                  }
                  return;
                }

                if (query.length > 0) {
                  filteredContacts.clear();
                  _getSearchedContacts(query);
                }
              },
            ),
      actions: <Widget>[
        IconButton(
          icon: Icon((isTyping) ? Icons.clear : Icons.search),
          onPressed: () {
            if (mounted) {
              setState(() {
                if (isTyping) {
                  isTyping = false;
                  controller.text = '';
                  if (mounted) {
                    setState(() {
                      filteredContacts = contacts;
                    });
                  }
                } else {
                  isTyping = true;
                }
              });
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isTyping && contacts.isNotEmpty) {
      filteredContacts = contacts;
    }

    return Scaffold(
      appBar: _getAppBar(),
      body: (showProgress)
          ? Center(child: CircularProgressIndicator())
          : (filteredContacts != null && filteredContacts.isNotEmpty)
              ? ListView.builder(
                  itemCount: (filteredContacts.isNotEmpty)
                      ? filteredContacts.length
                      : 0,
                  itemBuilder: (context, index) {
                    return ContactItem(filteredContacts[index]);
                  },
                )
              : Center(
                  child: Text('No contacts available'),
                ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}
