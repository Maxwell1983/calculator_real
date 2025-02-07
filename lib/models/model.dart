import 'package:flutter/material.dart';
import '../models/calculation_log.dart';
import '../controller/persistence/sqlite.dart';

class CalculatorModel extends ChangeNotifier {
  String _input = '';
  String _result = '0';
  String _conversionInput = '';
  String _conversionResult = '';

  final SqlLiteController _db = SqlLiteController();

  CalculatorModel() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _db.init();
  }

  Future<List<CalculationLog>> get history async {
    await _db.init();
    return _db.getAllData();
  }

  String get input => _input;
  String get result => _result;
  String get conversionInput => _conversionInput;
  String get conversionResult => _conversionResult;

  void addInput(String value) {
    _input += value;
    notifyListeners();
  }

  void clearInput() {
    _input = '';
    _result = '0';
    notifyListeners();
  }

  Future<void> calculateResult() async {
    try {
      print("calculateResult() called");  // Debug print

      final expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
      _result = _evaluateExpression(expression).toString();

      await _db.init();

      // Check the latest saved entry to avoid auto-duplication
      final latestRecord = await _db.getLastEntry();
      if (latestRecord != null &&
          latestRecord.expression == _input &&
          latestRecord.result == _result) {
        print("Skipping duplicate entry");
        return; // Prevents duplicate storage for the same operation
      }

      final log = CalculationLog(_input, _result);
      await _db.saveData(log);
      print("Saved calculation to history: $_input = $_result");

    } catch (e) {
      print("Error in calculateResult: $e");
      _result = 'Error';
    }
    notifyListeners();
  }




  Future<void> clearHistory() async {
    await _db.init();
    await _db.clearData();
    notifyListeners();
  }

  double _evaluateExpression(String expression) {
    try {
      final sanitized = expression.replaceAll(' ', '');
      final regExp = RegExp(r'(\d+\.?\d*)([-+*/])(\d+\.?\d*)');
      final match = regExp.firstMatch(sanitized);

      if (match == null) {
        print("Invalid Expression: $expression");
        return double.nan;
      }

      final num1 = double.tryParse(match.group(1)!) ?? double.nan;
      final operator = match.group(2)!;
      final num2 = double.tryParse(match.group(3)!) ?? double.nan;

      print("Parsed Expression -> num1: $num1, operator: $operator, num2: $num2");

      if (num1.isNaN || num2.isNaN) {
        print("Parsing Error: $expression");
        return double.nan;
      }

      switch (operator) {
        case '+':
          return num1 + num2;
        case '-':
          return num1 - num2;
        case '*':
          return num1 * num2;
        case '/':
          if (num2 == 0) throw Exception('Division by zero');
          return num1 / num2;
        default:
          print("Unknown operator: $operator");
          throw Exception('Unknown operator');
      }
    } catch (e) {
      print("Error in _evaluateExpression: $e");
      return double.nan;
    }
  }


  void updateConversionInput(String value) {
    _conversionInput += value;
    notifyListeners();
  }

  void clearConversionInput() {
    _conversionInput = '';
    _conversionResult = '';
    notifyListeners();
  }

  void performConversion() {
    try {
      final kilometers = double.parse(_conversionInput);
      _conversionResult = (kilometers * 0.621371192).toStringAsFixed(2);
    } catch (e) {
      _conversionResult = 'Error';
    }
    notifyListeners();
  }
}
