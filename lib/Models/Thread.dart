import 'package:flutter/material.dart';

class Thread {
  final bool fromSelf;
  final String message;
  final String time;

  Thread({@required bool fromSelf, @required String message, @required String time})
      : this.fromSelf = fromSelf ?? true,
        this.message = message ?? '',
        this.time = time ?? '';
}
