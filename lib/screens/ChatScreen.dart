import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms_spam_detection/Models/Thread.dart';
import 'package:sms_spam_detection/Models/user_model.dart';
import 'package:sms_spam_detection/presentation/MatIcons.dart';
import 'package:sms_spam_detection/presentation/StringConst.dart';
import 'package:sms_spam_detection/widgets/ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  bool _isComposing = false;

  ChatMessage _buildChatThread(Thread thread) {
    final cm = ChatMessage(
      thread,
      AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );

    return cm;
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text != null && text.length > 0) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/mm/yyyy HH:mm:ss').format(now);
      final Thread thread =
          new Thread(fromSelf: true, message: text, time: formattedDate);

      ChatMessage message = _buildChatThread(thread);

      setState(() {
        _messages.insert(0, message);
        _isComposing = false;
      });
      message.animationController.forward();
    }
  }

  @override
  void initState() {
    final threads = [
      Thread(
          fromSelf: false, message: 'Hey Buddy !', time: '04/12/2019 12:23:23'),
      Thread(
          fromSelf: false, message: 'How are you', time: '04/12/2019 12:25:23'),
      Thread(
          fromSelf: true,
          message: 'Absouletly well, How about you',
          time: '04/12/2019 12:26:23'),
      Thread(
          fromSelf: false,
          message: 'I m also fine, what are you doing these days',
          time: '04/12/2019 12:29:23'),
      Thread(
          fromSelf: true,
          message: 'Woring on android project',
          time: '04/12/2019 12:30:23'),
      Thread(
          fromSelf: false, message: 'Hey Buddy !', time: '04/12/2019 12:23:23'),
      Thread(
          fromSelf: false, message: 'How are you', time: '04/12/2019 12:25:23'),
      Thread(
          fromSelf: true,
          message: 'Absouletly well, How about you',
          time: '04/12/2019 12:26:23'),
      Thread(
          fromSelf: false,
          message: 'I m also fine, what are you doing these days',
          time: '04/12/2019 12:29:23'),
      Thread(
          fromSelf: true,
          message: 'Woring on android project',
          time: '04/12/2019 12:30:23'),
      Thread(
          fromSelf: false, message: 'Hey Buddy !', time: '04/12/2019 12:23:23'),
      Thread(
          fromSelf: false, message: 'How are you', time: '04/12/2019 12:25:23'),
      Thread(
          fromSelf: true,
          message: 'Absouletly well, How about you',
          time: '04/12/2019 12:26:23'),
      Thread(
          fromSelf: false,
          message: 'I m also fine, what are you doing these days',
          time: '04/12/2019 12:29:23'),
      Thread(
          fromSelf: true,
          message: 'Woring on android project',
          time: '04/12/2019 12:30:23'),
    ];

    threads.forEach((thread) {
      final cm = _buildChatThread(thread);
      _messages.add(cm);
      cm.animationController.forward();
    });

    super.initState();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFe7e7e7),
                border: Border.all(color: Color(0xFFdbdbdb)),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  if (text != null) {
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  }
                },
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  hintText: StringConst.sendMessage,
                ),
                maxLines: 4,
                minLines: 1,
                style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
              ),
            ),
          ),
          new IconButton(
            icon: new Icon(
              MatIcons.up,
              color: Color(0xFFbdbdbd),
            ),
            onPressed: _isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: getChatScreenAppBar(context, widget.user.name, '9999784555'),
      body: GestureDetector(
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
                    Expanded(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          child: new ListView.builder(
                            padding: EdgeInsets.only(top: 15.0),
                            reverse: true,
                            itemCount: _messages.length,
                            itemBuilder: (context, int index) {
                              final ChatMessage message = _messages[index];
                              return message;
                            },
                          ),
                        ),
                      ),
                    ), //LIST VIEW
                    _buildTextComposer(), //SEND MESSAGE BAR
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar getChatScreenAppBar(BuildContext context, String name, String number) {
  return AppBar(
    centerTitle: true,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          number,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.more_vert),
        padding: EdgeInsets.only(right: 5.0),
        onPressed: () {},
      ),
    ],
    elevation: 0.0,
  );
}
