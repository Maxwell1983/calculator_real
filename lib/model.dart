import 'package:flutter/material.dart';

class CalculatorModel extends ChangeNotifier {
  String _input = '';
  String _result = '0';
  String _conversionInput = '';
  String _conversionResult = '';

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

  void calculateResult() {
    try {
      final expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
      _result = _evaluateExpression(expression).toString();
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
  }

  double _evaluateExpression(String expression) {
    try {
      // Split the input for simple operations
      final sanitized = expression.replaceAll(' ', '');
      final regExp = RegExp(r'(\d+\.?\d*)([-+*/])(\d+\.?\d*)');
      final match = regExp.firstMatch(sanitized);

      if (match == null) return double.nan; // Invalid input
      final num1 = double.parse(match.group(1)!);
      final operator = match.group(2)!;
      final num2 = double.parse(match.group(3)!);

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
          throw Exception('Unknown operator');
      }
    } catch (e) {
      return double.nan; // Error during evaluation
    }
  }

  // Conversion Logic for "Separate Screen"
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
      _conversionResult = (kilometers * 0.621371192).toStringAsFixed(2); // Convert to miles
    } catch (e) {
      _conversionResult = 'Error';
    }
    notifyListeners();
  }
}
