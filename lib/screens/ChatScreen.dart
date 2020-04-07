import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sms_spam_detection/presentation/styles.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sms_spam_detection/sqflite/SmsDatabase.dart';
import 'package:sms_spam_detection/widgets/ChatMessage.dart';
import 'package:sms_spam_detection/widgets/chat_input_widget.dart';

class ChatScreen extends StatefulWidget {
  final int smsThreadId;
  final String address;

  ChatScreen(this.address, this.smsThreadId);

  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//  final TextEditingController _textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  List<SmsMessage> smsMessages;

  SmsThread thread;
  SmsSender sender;

  String title, subtitle;
  Contact contact;

  @override
  void initState() {
    title = widget.address;
    sender = new SmsSender();
    super.initState();

    SmsDatabaseProvider.db
        .getSmsMessagesByThreadId(widget.smsThreadId)
        .then((value) {
      if (mounted) {
        setState(() {
          smsMessages = value;
          thread = SmsThread.fromMessages(smsMessages);
        });
      }

      setReadMessages();
    });

    ContactsService.getContactsForPhone(widget.address).then((value) {
      if (value != null && value.length > 0) {
        contact = value.toList()[0];
        title =
        (contact.givenName != null) ? contact.givenName : widget.address;
      } else {
        title = widget.address;
      }
      subtitle = widget.address;
      if (mounted) {
        setState(() {
          if (thread != null) {
            thread.contact = contact;
          } else {
            thread = new SmsThread(widget.smsThreadId);
            thread.contact = contact;
          }
        });
      }
    }, onError: (e) {
      print('ContactQuery : Contact not found error : ${e.toString()}');
    });
  }

  ChatMessage _buildChatThread(SmsMessage smsMessage) {
    final cm = ChatMessage(
      smsMessage,
      AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );
    return cm;
  }

  _handleSubmitted(String text, TextEditingController textEditingController) {
    textEditingController.clear();
    if (text != null && text.length > 0) {
      String address = widget.address;

      final SmsMessage smsMessage =
      new SmsMessage(address, text, threadId: widget.smsThreadId);
      final ChatMessage message = _buildChatThread(smsMessage);

      smsMessage.onStateChanged.listen((event) {
        switch (event) {
          case SmsMessageState.Sent:
            if (mounted) {
              setState(() {
                thread.addNewMessage(smsMessage);
                smsMessages.insert(0, smsMessage);
              });
            }
//            message.animationController.forward();
            SmsDatabaseProvider.db
                .setMessageState(smsMessage.id, SmsMessageState.Sent);
            showToast('Message Sent');
            break;

          case SmsMessageState.Sending:
            message.animationController.forward();
            print("Sending");
            SmsDatabaseProvider.db
                .setMessageState(smsMessage.id, SmsMessageState.Sending);
            break;
          case SmsMessageState.Delivered:
            showToast('Message Delivered');
            SmsDatabaseProvider.db
                .setMessageState(smsMessage.id, SmsMessageState.Delivered);
            break;

          case SmsMessageState.Fail:
            showToast('Failed to sent');
            SmsDatabaseProvider.db
                .setMessageState(smsMessage.id, SmsMessageState.Fail);
            break;

          case SmsMessageState.None:
            print("None");
            SmsDatabaseProvider.db
                .setMessageState(smsMessage.id, SmsMessageState.None);
            break;
        }
      }, onError: (error) {
        print("ChatScreen : smsMessage.onStateChanged : OnError ");
      }, onDone: () {
        print("ChatScreen : smsMessage.onStateChanged : onDone ");
      });

      if (sender == null) {
        sender = new SmsSender();
      }
      sender.sendSms(smsMessage);
      SmsDatabaseProvider.db.addMessageToDatabase(smsMessage);
      FocusScope.of(context).unfocus();
    }
  }

  Widget buildChats() {
    List<ChatScreenItem> chatScreenItems = getChatsByDate(smsMessages);

    return ListView.builder(
      padding: EdgeInsets.only(top: 15.0),
      reverse: true,
      itemCount: (chatScreenItems != null && chatScreenItems.isNotEmpty)
          ? chatScreenItems.length
          : 0,
      itemBuilder: (context, int index) {
        final ChatScreenItem item = chatScreenItems[index];
        if (item is DateItem) {
          return item;
        } else {
          return item as ChatMessage;
        }
      },
    );
  }

  String _getPrettyDate(DateTime iDate) {
    DateTime cNow = DateTime.now();
    Duration duration = cNow.difference(iDate);

    if (duration
        .abs()
        .inDays == 0) {
      if (iDate.day == cNow.day) {
        return "Today";
      }
      return "Yesterday";
    }

    if (duration
        .abs()
        .inDays == 1) {
      return "Yesterday";
    }

    return DateFormat("dd-MM-yyyy").format(iDate);
  }

  List<ChatScreenItem> getChatsByDate(List<SmsMessage> smsMessages) {
    List<ChatScreenItem> items = [];

    smsMessages.sort();

    if (smsMessages != null && smsMessages.isNotEmpty) {
      int i = 0,
          j = 0;
      for (i = 0; i < smsMessages.length;) {
        SmsMessage iMessage = smsMessages[i];
        DateTime iDate = iMessage.dateSent;

        if (iMessage.kind == SmsMessageKind.Sent) {
          iDate = iMessage.date;
        }

        ChatMessage iChat = _buildChatThread(iMessage);
        items.add(iChat);
        _messages.add(iChat);

        String iDateStr = _getPrettyDate(iDate);
        DateItem date = new DateItem(iDateStr);

        for (j = i + 1; j < smsMessages.length; j++) {
          SmsMessage jMessage = smsMessages[j];
          DateTime jDate = jMessage.dateSent;

          if (jMessage.kind == SmsMessageKind.Sent) {
            jDate = jMessage.date;
          }

          ChatMessage jChat = _buildChatThread(jMessage);

          Duration duration = iDate.difference(jDate);
          if (duration
              .abs()
              .inDays == 0 && iDate.day == jDate.day) {
            items.add(jChat);
            _messages.add(jChat);
          } else
            break;
        }
        items.add(date);
        i = j;
      }
    }

    return items;
  }

  @override
  void dispose() {
    if (_messages != null && _messages.isNotEmpty) {
      for (ChatMessage message in _messages) {
        message.animationController.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatScreenItem> chatScreenItems = [];
    if (smsMessages != null && smsMessages.isNotEmpty) {
      chatScreenItems.addAll(getChatsByDate(smsMessages));
    }

    return Scaffold(
      appBar: getChatScreenAppBar(context, title, subtitle),
      body: Container(
          color: Theme
              .of(context)
              .primaryColor,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
//                              child: (smsMessages != null)
//                                  ? Center(child: CircularProgressIndicator())
                              child: (smsMessages != null)
                                  ? (smsMessages.isEmpty)
                                  ? Center(
                                child: Text('No messages yet'),
                              )
                                  : ListView.builder(
                                padding: EdgeInsets.only(top: 15.0),
                                reverse: true,
                                itemCount: (chatScreenItems != null &&
                                    chatScreenItems.isNotEmpty)
                                    ? chatScreenItems.length
                                    : 0,
                                itemBuilder: (context, int index) {
                                  final ChatScreenItem item =
                                  chatScreenItems[index];
                                  if (item is DateItem) {
                                    return item;
                                  } else {
                                    return item as ChatMessage;
                                  }
                                },
                              )
                                  : Center(child: Text('Importing Messages')),
                            ),
                          ),
                        ), //LIST VIEW
                        ChatInputWidget(
                          active:
                          !widget.address.contains(RegExp(r"([a-zA-Z])")),
                          onSubmitted: (message, controller) {
                            _handleSubmitted(message, controller);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  AppBar getChatScreenAppBar(BuildContext context, String name,
      String address) {
    return AppBar(
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: chatScreenTitleStyle,
          ),
          (address != null && address.length > 0 && address != name)
              ? Text(
            address,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: chatScreenSubtitleStyle,
          )
              : SizedBox.shrink(),
        ],
      ),
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (context) =>
          [
            PopupMenuItem(
              child: Text("Info"),
              value: "Info",
            )
          ],
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
      elevation: 0.0,
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
    );
  }

  void setReadMessages() {
    SmsDatabaseProvider.db.setThreadRead(thread.threadId);
  }
}
