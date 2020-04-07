import 'package:flutter/material.dart';
import 'package:sms_spam_detection/screens/ChatScreen.dart';
import 'package:sms_spam_detection/sms/contacts.dart';

class ContactItem extends StatefulWidget {
  final Contact contact;

  ContactItem(this.contact);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  String title, address;
  List<String> addresses = [];
  bool showItem = true;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      title = (widget.contact.displayName != null)
          ? widget.contact.displayName
          : '';
      if (widget.contact.getPhonesString == null) {
        address = '';
        return;
      }

      String str = widget.contact.getPhonesString();
      if (str.length > 0) {
        address = str.split(RegExp(','))[0];
      }
    }
  }

  getSubTitle(List<String> addresses) {
    String s = addresses[0];
    if (showItem && addresses.length > 1) {
      for (int i = 1; i < addresses.length; i++) {
        if (addresses[i] != null) {
          s = s + ' ' + addresses[i];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
//    subTitle += (phones.length > 1) ? ", + ${phones.length - 1}" : "";
//    String subTitle = address;
//    if (showItem && addresses.length > 1) {
//      for (int i = 1; i < addresses.length; i++) {
//        if (addresses[i] != null) {
//          subTitle = subTitle + ' ' + addresses[i];
//        }
//      }
//    }
    String subTitle = widget.contact.getPhonesString();

    return ListTile(
      leading: CircleAvatar(
        child:
            (widget.contact.avatar != null && widget.contact.avatar.length > 0)
                ? ClipOval(child: Image.memory(widget.contact.avatar))
                : Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
      ),
      title: Text(title != null ? title : 'Deepak'),
      subtitle: Text((subTitle != null) ? subTitle : '14729822'),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChatScreen(address, 1001);
        }));
      },
    );
  }
}
