import 'dart:collection';
import 'package:intl/intl.dart';

class CalculationLog {
  String expression;
  String result;
  String timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  CalculationLog(this.expression, this.result);

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp,
    };
  }

  CalculationLog.fromJson(Map<dynamic, dynamic> json)
      : expression = json['expression'],
        result = json['result'],
        timestamp = json['timestamp'];
}
