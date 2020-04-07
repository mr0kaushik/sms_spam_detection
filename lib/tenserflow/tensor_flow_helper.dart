import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';

class TfLiteHelper {
  static const String KEY_ACCURACY = "accuracy";
  static const String KEY_INDEX = "index";
  static const String KEY_LABEL = "label";

  static const platform = const MethodChannel('spam_sms_tf_lite/model');

  String _message;
  double accuracy = -1;
  int index = -1;

  TfLiteHelper(this._message) {
    predict();
  }

  /// get prediction accuracy for the message
  Future<Map<String, dynamic>> predict() async {
    Map<String, dynamic> map = new HashMap();
    try {
      final String str = await platform.invokeMethod('predictMessage', {
        "args": [_message]
      });
      this.accuracy = double.parse(str);
//      debugPrint("Accuracy : " + str);
//      this.accuracy = accuracy;
      if (accuracy >= 0.7) {
        index = SmsMessageType.SPAM.index;
      } else if (accuracy <= 0.4) {
        index = SmsMessageType.HAM.index;
      } else {
        index = SmsMessageType.UNDECIDABLE.index;
      }
      map[KEY_ACCURACY] = this.accuracy;
      map[KEY_LABEL] = getLabel(this.accuracy);
      map[KEY_INDEX] = this.index;
    } on PlatformException catch (e) {
      debugPrint("Failed to predict message : '${e.message}'.");
    }

    return map;
  }

//  get accuracy => this.accuracy;

  /// get SmsMessageType after prediction
  /// SmsMessageType.HAM if accuracy < 0.4
  /// SmsMessageType.SPAM if accuracy > 0.7
  /// SmsMessageType.UNDECIDABLE otherwise
  Future<SmsMessageType> getAccuracyType() async {
    if (index == -1) {
      await predict();
    }
    return SmsMessageType.values[index];
  }

  /// get AccuracyLabel after prediction
  /// HAM if accuracy < 0.4
  /// SPAM if accuracy > 0.7
  /// UNDECIDABLE otherwise
  Future<String> getAccuracyLabel() async {
    if (index == -1) {
      await predict();
    }
    return getLabel(accuracy);
  }

  String getLabel(double accuracy) {
    if (accuracy <= 0.4) {
      return "HAM";
    }
    if (accuracy >= 0.7) {
      return "SPAM";
    }
    return "UNDECIDABLE";
  }
}
