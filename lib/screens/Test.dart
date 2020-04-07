import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/tenserflow/tensor_flow_helper.dart';
import 'package:sms_spam_detection/widgets/Utils.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool isResultAvailable = false;
  final textController = TextEditingController();
  String result = "Ham";
  double percentage = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBar("Test"),
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                key: Key("textField"),
                                controller: textController,
                                decoration: new InputDecoration(
                                  hintText: "Enter Text",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.length == 0) {
                                    return "Text field must contain characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (text) {
                                  if (mounted) {
                                    setState(() {
                                      isResultAvailable = false;
                                    });
                                  }
                                },
                                minLines: 5,
                                maxLines: 8,
                                textAlignVertical: TextAlignVertical.top,
                                textAlign: TextAlign.justify,
                                keyboardType: TextInputType.text,
                                style: new TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            (isResultAvailable)
                                ? Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          result,
                                          key: Key("result"),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColorDark),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          percentage.toString() + "%",
                                          key: Key("accuracy"),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 10,
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Wrap(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: MatColor.accentColor,
            child: GestureDetector(
              onTap: () => getPrediction(textController.text),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Check',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPrediction(String txt) async {
    if (txt.isNotEmpty) {
      TfLiteHelper(txt).predict().then((map) {
        if (map.containsKey(TfLiteHelper.KEY_ACCURACY)) {
          this.percentage = map[TfLiteHelper.KEY_ACCURACY] * 100;
        }

        if (map.containsKey(TfLiteHelper.KEY_LABEL)) {
          this.result = map[TfLiteHelper.KEY_LABEL];
        }
      });

      if (mounted) {
        setState(() {
          isResultAvailable = true;
        });
      }
    } else {
      showToast('Please insert text');
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
    );
  }
}
