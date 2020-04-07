import 'package:flutter/material.dart';
import 'package:sms_spam_detection/presentation/StringConst.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String message, TextEditingController controller) onSubmitted;
  bool active = true;
  String hint;
  String deActivatedHint;

  ChatInputWidget(
      {@required this.onSubmitted,
      this.active,
      this.hint = StringConst.SEND_MESSAGE,
      this.deActivatedHint = StringConst.CANT_SEND_MESSAGE});

  @override
  State<StatefulWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    editingController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String hintText = (widget.active) ? widget.hint : widget.deActivatedHint;
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Color(0xff3b5998).withOpacity(0.06),
              borderRadius: BorderRadius.circular(32.0),
            ),
            margin: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Color(0xff3b5998),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Expanded(
                    child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: new InputDecoration.collapsed(
                    hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: Colors.black38),
                    hintText: hintText,
                  ),
                  focusNode: focusNode,
                  textInputAction: TextInputAction.send,
                  controller: editingController,
                  onSubmitted: sendMessage,
                  maxLines: 5,
                  minLines: 1,
                  enabled: widget.active,
                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                )),
                /*Expanded(child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type a message ...",
                  ),
                  focusNode: focusNode,
                  textInputAction: TextInputAction.send,
                  controller: editingController,
                  onSubmitted: sendMessage,
                )),*/
                IconButton(
                  icon: Icon((!widget.active)
                      ? Icons.mic_off
                      : (isTexting) ? Icons.send : Icons.keyboard_voice),
                  onPressed: () {
                    sendMessage(editingController.text);
                  },
                  color: Color(0xff3b5998),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool get isTexting => editingController.text.length != 0;

  void sendMessage(String message) {
    if (!isTexting) {
      return;
    }
    widget.onSubmitted(message, editingController);
    editingController.text = '';
    focusNode.unfocus();
  }
}
