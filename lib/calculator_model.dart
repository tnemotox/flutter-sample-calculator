import 'package:flutter/material.dart';

class CalculatorModel extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  void setValue(String newValue) {
    _value = newValue;
    notifyListeners();
  }
}
