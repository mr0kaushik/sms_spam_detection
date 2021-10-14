import 'package:flutter/material.dart';
import 'package:sms_spam_detection/screens/ChatScreen.dart';
import 'package:sms_spam_detection/sms/contacts.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;

  ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    String title, address;
    if (contact != null) {
      title = (contact.displayName != null) ? contact.displayName : '';
      if (contact.getPhonesString == null) {
        address = '';
      }

      String str = contact.getPhonesString();
      if (str.length > 0) {
        address = str.split(RegExp(','))[0];
      }
    }

    String subTitle = contact.getPhonesString();

    return ListTile(
      leading: CircleAvatar(
        child: (contact.avatar != null && contact.avatar.length > 0)
            ? ClipOval(child: Image.memory(contact.avatar))
            : Icon(
                Icons.person,
                color: Colors.white,
              ),
      ),
      title: Text(title != null ? title : '<>'),
      subtitle: Text((subTitle != null) ? subTitle : '<>'),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChatScreen(address, 1001);
        }));
      },
    );
  }
}
